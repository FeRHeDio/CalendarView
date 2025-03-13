//
//  CursorView.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 05/03/2025.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @State private var viewModel = CalendarViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                    // Header component
                headerView()
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                    // Calendar title and navigation (conditional based on orientation)
                HStack(alignment: .center) {
                    Text("Calendar")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                        // Only show navigation controls in the title row when in landscape
                    if viewModel.isLandscape {
                        HStack(spacing: 16) {
                            todayButton()
                            weekPickerView()
                            navigationButtonsView()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                    // Calendar navigation - only show in portrait mode
                if !viewModel.isLandscape {
                    HStack {
                        todayButton()
                        
                        Spacer()
                        
                        weekPickerView()
                        
                        Spacer()
                        
                        navigationButtonsView()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                
                    // Calendar grid
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        GeometryReader { gridGeometry in
                            HStack(spacing: 0) {
                                    // Fixed first column with room names
                                VStack(spacing: 0) {
                                        // Header placeholder (for days row)
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 70)
                                    
                                        // Superior Room summary placeholder
                                    Text("Superior Room")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black.opacity(0.8))
                                        .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 60)
                                        .background(Color.gray.opacity(0.02))
                                        .overlay(
                                            Rectangle()
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                        )
                                    
                                        // Superior Room section
                                    HStack(alignment: .center) {
                                        Text("Superior Room with Queen bed")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black.opacity(0.8))
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                viewModel.toggleSuperiorRoomsCollapsed()
                                            }
                                        }) {
                                            Image(systemName: viewModel.isSuperiorRoomsCollapsed ? "chevron.down" : "chevron.right")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black.opacity(0.8))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 60)
                                    .background(Color.white)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                    )
                                    
                                        // Superior room name cells
                                    if !viewModel.isSuperiorRoomsCollapsed {
                                        ForEach(0..<viewModel.rooms.count, id: \.self) { roomIndex in
                                            Text(viewModel.rooms[roomIndex])
                                                .font(.subheadline)
                                                .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 60)
                                                .background(Color.white)
                                                .overlay(
                                                    Rectangle()
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                                )
                                        }
                                    }
                                    
                                        // Standard Room summary placeholder
                                    Text("Standard Room")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black.opacity(0.8))
                                        .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 60)
                                        .background(Color.gray.opacity(0.02))
                                        .overlay(
                                            Rectangle()
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                        )
                                    
                                        // Standard Room section
                                    HStack(alignment: .center) {
                                        Text("Standard Room")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black.opacity(0.8))
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                viewModel.toggleStandardRoomsCollapsed()
                                            }
                                        }) {
                                            Image(systemName: viewModel.isStandardRoomsCollapsed ? "chevron.down" : "chevron.right")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black.opacity(0.8))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 60)
                                    .background(Color.white)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                    )
                                    
                                        // Standard room name cells
                                    if !viewModel.isStandardRoomsCollapsed {
                                        ForEach(0..<viewModel.standardRooms.count, id: \.self) { roomIndex in
                                            Text(viewModel.standardRooms[roomIndex])
                                                .font(.subheadline)
                                                .frame(width: viewModel.getFixedColumnWidth(gridGeometry), height: 60)
                                                .background(Color.white)
                                                .overlay(
                                                    Rectangle()
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                                )
                                        }
                                    }
                                }
                                
                                    // Scrollable content for all rows
                                ScrollView(.horizontal, showsIndicators: false) {
                                    VStack(spacing: 0) {
                                            // Days header row
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
                                        
                                            // Summary row for Superior Rooms
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
                                        
                                            // Empty row for Superior Room section header
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
                                        
                                            // Superior Room occupancy rows
                                        if !viewModel.isSuperiorRoomsCollapsed {
                                            ForEach(0..<viewModel.rooms.count, id: \.self) { roomIndex in
                                                occupancyRow(for: roomIndex, isStandardRoom: false, geometry: gridGeometry)
                                            }
                                        }
                                        
                                            // Summary row for Standard Rooms
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
                                        
                                            // Empty row for Standard Room section header
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
                                        
                                            // Standard Room occupancy rows
                                        if !viewModel.isStandardRoomsCollapsed {
                                            ForEach(0..<viewModel.standardRooms.count, id: \.self) { roomIndex in
                                                occupancyRow(for: roomIndex, isStandardRoom: true, geometry: gridGeometry)
                                            }
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                                .scrollTargetBehavior(.viewAligned)
                            }
                            .frame(minHeight: gridGeometry.size.height)
                        }
                        .frame(height: viewModel.getCalendarHeight())
                    }
                }
            }
            .onAppear {
                    // Set initial orientation
                viewModel.checkOrientation(size: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                    // Update orientation when size changes
                viewModel.checkOrientation(size: newSize)
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(viewModel.isLandscape ? .horizontal : [])
        .onTapGesture {
            if viewModel.isWeekPickerVisible {
                withAnimation {
                    viewModel.isWeekPickerVisible = false
                }
            }
        }
    }
}

// MARK: - Extension for view components
extension CalendarView {
    // Today button component
    private func todayButton() -> some View {
        Button(action: {
            viewModel.handleTodayButtonTap()
        }) {
            Text("Today")
        }
        .applyActionButtonStyle()
    }
    
    // Week picker component
    private func weekPickerView() -> some View {
        ZStack(alignment: .top) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.toggleWeekPickerVisibility()
                }
            }) {
                HStack {
                    Text(viewModel.selectedDateRange)
                        .font(.subheadline)
                    
                    Image(systemName: viewModel.isWeekPickerVisible ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
            }
            .applyActionButtonStyle()
            
            // Dropdown menu
            if viewModel.isWeekPickerVisible {
                VStack(spacing: 0) {
                    // Spacer to push dropdown below the button
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 50)
                    
                    // Week options
                    VStack(spacing: 0) {
                        ForEach(viewModel.getWeekPickerOptions().indices, id: \.self) { index in
                            let option = viewModel.getWeekPickerOptions()[index]
                            
                            Button(action: {
                                withAnimation {
                                    viewModel.selectWeek(index)
                                }
                            }) {
                                HStack {
                                    Text(option.label)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                    Spacer()
                                    if option.isSelected {
                                        Image(systemName: "checkmark")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(option.isSelected ? Color.gray.opacity(0.1) : Color.white)
                                .contentShape(Rectangle())
                            }
                            
                            if index < viewModel.getWeekPickerOptions().count - 1 {
                                Divider()
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .zIndex(1)
            }
        }
        .zIndex(viewModel.isWeekPickerVisible ? 100 : 1)
    }
    
    // Navigation buttons component
    private func navigationButtonsView() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.navigateToPreviousWeek()
                }
            }) {
                Image(systemName: "chevron.left")
            }
            .applyNavigationButtonStyle(isGrouped: true, position: .leading)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 24)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.navigateToNextWeek()
                }
            }) {
                Image(systemName: "chevron.right")
            }
            .applyNavigationButtonStyle(isGrouped: true, position: .trailing)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // Extracted occupancy row view
    private func occupancyRow(for roomIndex: Int, isStandardRoom: Bool, geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            // Get stay configurations from the view model
            let stayConfigurations = viewModel.getOccupancyRowConfiguration(for: roomIndex, isStandardRoom: isStandardRoom)
            
            // Now render the cells with labels in the middle of stays
            return ZStack(alignment: .leading) {
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
        }
    }
    
    // Header component
    private func headerView() -> some View {
        HStack {
            // Logo and title
            HStack(spacing: 12) {
                // Circular logo
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("LP")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                // Title and subtitle
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Luxury Place")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Dashboard")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Right side buttons
            HStack(spacing: 16) {
                // Circular lens icon with shadow
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                // Plus button
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
