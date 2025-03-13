import SwiftUI
import Observation

/// Main calendar grid component
struct CalendarGridView: View {
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                GeometryReader { gridGeometry in
                    HStack(spacing: 0) {
                        // Fixed first column with room names
                        RoomLabelsColumn(
                            viewModel: viewModel,
                            geometry: gridGeometry
                        )
                        
                        // Scrollable content for all rows
                        CalendarContentView(
                            viewModel: viewModel,
                            geometry: gridGeometry
                        )
                    }
                    .frame(minHeight: gridGeometry.size.height)
                }
                .frame(height: viewModel.getCalendarHeight())
            }
        }
    }
}

// MARK: - Room Labels Column

/// Fixed first column showing room labels
struct RoomLabelsColumn: View {
    @Bindable var viewModel: CalendarViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 0) {
            // Header placeholder (for days row)
            Rectangle()
                .fill(Color.clear)
                .frame(width: viewModel.getFixedColumnWidth(geometry), height: 70)
            
            // Summary row placeholder (for Superior Room price summary)
            Rectangle()
                .fill(Color.clear)
                .frame(width: viewModel.getFixedColumnWidth(geometry), height: 60)
            
            // Superior Room section
            RoomSectionLabels(
                viewModel: viewModel,
                geometry: geometry,
                roomTypeTitle: "Superior Room with Queen bed",
                isCollapsed: viewModel.isSuperiorRoomsCollapsed,
                rooms: viewModel.rooms,
                toggleAction: viewModel.toggleSuperiorRoomsCollapsed
            )
            
            // Standard Room section
            RoomSectionLabels(
                viewModel: viewModel,
                geometry: geometry,
                roomTypeTitle: "Standard Room",
                isCollapsed: viewModel.isStandardRoomsCollapsed,
                rooms: viewModel.standardRooms,
                toggleAction: viewModel.toggleStandardRoomsCollapsed
            )
            
            // Summary row placeholder (for Standard Room price summary)
            Rectangle()
                .fill(Color.clear)
                .frame(width: viewModel.getFixedColumnWidth(geometry), height: 60)
        }
    }
}

/// Labels for a room section (Superior or Standard)
/// This component displays the room type title with a toggle button and the room names when expanded
struct RoomSectionLabels: View {
    @Bindable var viewModel: CalendarViewModel
    let geometry: GeometryProxy
    let roomTypeTitle: String
    let isCollapsed: Bool
    let rooms: [String]
    let toggleAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Section header with toggle
            HStack(alignment: .center) {
                Text(roomTypeTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.8))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        toggleAction()
                    }
                }) {
                    Image(systemName: isCollapsed ? "chevron.down" : "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.8))
                }
            }
            .padding(.horizontal, 12)
            .frame(width: viewModel.getFixedColumnWidth(geometry), height: 60)
            .background(Color.gray.opacity(0.02))
            .overlay(
                Rectangle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
            )
            
            // Room name cells
            if !isCollapsed {
                ForEach(0..<rooms.count, id: \.self) { roomIndex in
                    Text(rooms[roomIndex])
                        .font(.subheadline)
                        .frame(width: viewModel.getFixedColumnWidth(geometry), height: 60)
                        .background(Color.white)
                        .overlay(
                            Rectangle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                        )
                }
            }
        }
    }
}

// MARK: - Calendar Content

/// Scrollable content area of the calendar
struct CalendarContentView: View {
    @Bindable var viewModel: CalendarViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 0) {
                // Days header row
                DaysHeaderRow(viewModel: viewModel)
                
                // Superior Rooms section
                RoomSectionContent(
                    viewModel: viewModel,
                    geometry: geometry,
                    isCollapsed: viewModel.isSuperiorRoomsCollapsed,
                    roomCount: viewModel.rooms.count,
                    isStandardRoom: false
                )
                
                // Standard Rooms section
                RoomSectionContent(
                    viewModel: viewModel,
                    geometry: geometry,
                    isCollapsed: viewModel.isStandardRoomsCollapsed,
                    roomCount: viewModel.standardRooms.count,
                    isStandardRoom: true
                )
            }
        }
        .scrollTargetLayout()
        .scrollTargetBehavior(.viewAligned)
    }
}

/// Header row showing days of the week
struct DaysHeaderRow: View {
    var viewModel: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        Text(viewModel.daysOfWeek[index])
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Text(viewModel.dates[index])
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    Text(viewModel.occupancyPercentages[index])
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.bottom, 12)
                }
                .frame(width: viewModel.getDayColumnWidth(), height: 70)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                )
            }
        }
    }
}

/// Content for a room section (Superior or Standard)
/// Displays a summary row at the top and occupancy rows for each room when not collapsed
struct RoomSectionContent: View {
    @Bindable var viewModel: CalendarViewModel
    let geometry: GeometryProxy
    let isCollapsed: Bool
    let roomCount: Int
    let isStandardRoom: Bool
    
    var body: some View {
        VStack(spacing: 0) { // Zero spacing to ensure no gaps between rows
            // Summary row
            SummaryRow(viewModel: viewModel)
            
            // Room occupancy rows
            if !isCollapsed {
                ForEach(0..<roomCount, id: \.self) { roomIndex in
                    OccupancyRow(
                        viewModel: viewModel,
                        roomIndex: roomIndex,
                        isStandardRoom: isStandardRoom,
                        geometry: geometry
                    )
                }
            }
        }
    }
}

/// Row showing average incomes
struct SummaryRow: View {
    var viewModel: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                Text(viewModel.averageIncomes[index])
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.8))
                    .frame(width: viewModel.getDayColumnWidth(), height: 60)
                    .background(Color.gray.opacity(0.02))
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
            }
        }
    }
}

/// Empty row for section headers
struct EmptyHeaderRow: View {
    var viewModel: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { _ in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: viewModel.getDayColumnWidth(), height: 60)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
            }
        }
    }
}

/// Row showing guest occupancy for a room
struct OccupancyRow: View {
    var viewModel: CalendarViewModel
    let roomIndex: Int
    let isStandardRoom: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        HStack(spacing: 0) {
            // Get stay configurations from the view model
            let stayConfigurations = viewModel.getOccupancyRowConfiguration(for: roomIndex, isStandardRoom: isStandardRoom)
            
            // Now render the cells with labels in the middle of stays
            ZStack(alignment: .leading) {
                // Background cells - empty cells with borders
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { dayIndex in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: viewModel.getDayColumnWidth(), height: 60)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                }
                
                // Shaped occupancy containers
                ForEach(stayConfigurations.indices, id: \.self) { index in
                    let config = stayConfigurations[index]
                    
                    GuestStayView(config: config)
                }
            }
        }
    }
}

/// View for a guest's stay
struct GuestStayView: View {
    let config: CalendarViewModel.StayConfiguration
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(config.color)
            .frame(width: config.width, height: 44)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .overlay(
                Text(config.guest.name)
                    .font(.system(size: 11, weight: .medium, design: .default))
                    .foregroundColor(config.textColor)
                    .padding(.horizontal, 4)
                    .lineLimit(1)
                    .truncationMode(.tail)
            )
            .position(x: config.offset, y: 30) // Center in the cell
    }
}

#Preview {
    VStack {
        Text("Calendar Grid Preview")
            .font(.headline)
            .padding(.bottom, 8)
        
        CalendarGridView(viewModel: CalendarViewModel())
            .frame(height: 600)
    }
    .padding()
} 
