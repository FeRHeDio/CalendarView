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
    
    @State private var currentWeek = 0 // 0 = week1, 1 = week2
    @State private var isWeekPickerVisible = false
    @State private var isLandscape = false
    @State private var isSuperiorRoomsCollapsed = false
    @State private var isStandardRoomsCollapsed = false
    
    // MARK: Static data
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let week1Dates = ["15", "16", "17", "18", "19", "20", "21"]
    private let week1OccupancyPercentages = ["85%", "90%", "75%", "80%", "95%", "70%", "65%"]
    private let week1AverageIncomes = ["$120", "$150", "$110", "$130", "$160", "$140", "$125"]
    private let week2Dates = ["22", "23", "24", "25", "26", "27", "28"]
    private let week2OccupancyPercentages = ["70%", "75%", "85%", "90%", "80%", "65%", "60%"]
    private let week2AverageIncomes = ["$110", "$130", "$145", "$170", "$150", "$120", "$105"]
    private let rooms = ["SUPQA101", "SUPQA102", "SUPQA103", "SUPQA104"]
    private let standardRooms = ["STDQA101", "STDQA102", "STDQA103"]
    
    
    // MARK: Computed Properties
    private var dates: [String] {
        currentWeek == 0 ? week1Dates : week2Dates
    }
    
    private var occupancyPercentages: [String] {
        currentWeek == 0 ? week1OccupancyPercentages : week2OccupancyPercentages
    }
    
    private var averageIncomes: [String] {
        currentWeek == 0 ? week1AverageIncomes : week2AverageIncomes
    }
    
    private var selectedDateRange: String {
        currentWeek == 0 ? "Mar 15 - Mar 21" : "Mar 22 - Mar 28"
    }
    
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
                    if isLandscape {
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
                if !isLandscape {
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
                                        .frame(width: getFixedColumnWidth(gridGeometry), height: 70)
                                    
                                        // Superior Room summary placeholder
                                    Text("Superior Room")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black.opacity(0.8))
                                        .frame(width: getFixedColumnWidth(gridGeometry), height: 60)
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
                                                isSuperiorRoomsCollapsed.toggle()
                                            }
                                        }) {
                                            Image(systemName: isSuperiorRoomsCollapsed ? "chevron.down" : "chevron.right")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black.opacity(0.8))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .frame(width: getFixedColumnWidth(gridGeometry), height: 60)
                                    .background(Color.white)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                    )
                                    
                                        // Superior room name cells
                                    if !isSuperiorRoomsCollapsed {
                                        ForEach(0..<rooms.count, id: \.self) { roomIndex in
                                            Text(rooms[roomIndex])
                                                .font(.subheadline)
                                                .frame(width: getFixedColumnWidth(gridGeometry), height: 60)
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
                                        .frame(width: getFixedColumnWidth(gridGeometry), height: 60)
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
                                                isStandardRoomsCollapsed.toggle()
                                            }
                                        }) {
                                            Image(systemName: isStandardRoomsCollapsed ? "chevron.down" : "chevron.right")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black.opacity(0.8))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .frame(width: getFixedColumnWidth(gridGeometry), height: 60)
                                    .background(Color.white)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                    )
                                    
                                        // Standard room name cells
                                    if !isStandardRoomsCollapsed {
                                        ForEach(0..<standardRooms.count, id: \.self) { roomIndex in
                                            Text(standardRooms[roomIndex])
                                                .font(.subheadline)
                                                .frame(width: getFixedColumnWidth(gridGeometry), height: 60)
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
                                                        Text(daysOfWeek[index])
                                                            .font(.subheadline)
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.gray.opacity(0.8))
                                                        
                                                        Text(dates[index])
                                                            .font(.subheadline)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.gray.opacity(0.8))
                                                    }
                                                    .padding(.top, 12)
                                                    
                                                    Spacer()
                                                    
                                                    Text(occupancyPercentages[index])
                                                        .font(.caption)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.gray.opacity(0.8))
                                                        .padding(.bottom, 12)
                                                }
                                                .frame(width: getDayColumnWidth(), height: 70)
                                                .overlay(
                                                    Rectangle()
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                                )
                                            }
                                        }
                                        
                                            // Summary row for Superior Rooms
                                        HStack(spacing: 0) {
                                            ForEach(0..<7, id: \.self) { index in
                                                Text(averageIncomes[index])
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black.opacity(0.8))
                                                    .frame(width: getDayColumnWidth(), height: 60)
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
                                                    .frame(width: getDayColumnWidth(), height: 60)
                                                    .overlay(
                                                        Rectangle()
                                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                                    )
                                            }
                                        }
                                        
                                            // Superior Room occupancy rows
                                        if !isSuperiorRoomsCollapsed {
                                            ForEach(0..<rooms.count, id: \.self) { roomIndex in
                                                occupancyRow(for: roomIndex, isStandardRoom: false, geometry: gridGeometry)
                                            }
                                        }
                                        
                                            // Summary row for Standard Rooms
                                        HStack(spacing: 0) {
                                            ForEach(0..<7, id: \.self) { index in
                                                Text(averageIncomes[index])
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black.opacity(0.8))
                                                    .frame(width: getDayColumnWidth(), height: 60)
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
                                                    .frame(width: getDayColumnWidth(), height: 60)
                                                    .overlay(
                                                        Rectangle()
                                                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                                    )
                                            }
                                        }
                                        
                                            // Standard Room occupancy rows
                                        if !isStandardRoomsCollapsed {
                                            ForEach(0..<standardRooms.count, id: \.self) { roomIndex in
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
                        .frame(height: getCalendarHeight())
                    }
                }
            }
            .onAppear {
                    // Set initial orientation
                checkOrientation(size: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                    // Update orientation when size changes
                checkOrientation(size: newSize)
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(isLandscape ? .horizontal : [])
        .onTapGesture {
            if isWeekPickerVisible {
                withAnimation {
                    isWeekPickerVisible = false
                }
            }
        }
    }
}

// MARK: - Extension for helpers
extension CalendarView {
    // Helper function to get fixed column width based on orientation
    private func getFixedColumnWidth(_ geometry: GeometryProxy) -> CGFloat {
        let baseWidth = geometry.size.width * 0.35
        return isLandscape ? baseWidth * 0.7 : baseWidth // 30% narrower in landscape
    }
    
    // Helper function to get day column width
    private func getDayColumnWidth() -> CGFloat {
        return 80 // Fixed width for day columns
    }
    
    // Helper function to check orientation based on size
    private func checkOrientation(size: CGSize) {
        isLandscape = size.width > size.height
    }
    
    // Today button component
    private func todayButton() -> some View {
        Button(action: {}) {
            Text("Today")
        }
        .applyActionButtonStyle()
    }
    
    // Week picker component
    private func weekPickerView() -> some View {
        ZStack(alignment: .top) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isWeekPickerVisible.toggle()
                }
            }) {
                HStack {
                    Text(selectedDateRange)
                        .font(.subheadline)
                    
                    Image(systemName: isWeekPickerVisible ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
            }
            .applyActionButtonStyle()
            
            // Dropdown menu
            if isWeekPickerVisible {
                VStack(spacing: 0) {
                    // Spacer to push dropdown below the button
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 50)
                    
                    // Week options
                    VStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                currentWeek = 0
                                isWeekPickerVisible = false
                            }
                        }) {
                            HStack {
                                Text("Mar 15 - Mar 21")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Spacer()
                                if currentWeek == 0 {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(currentWeek == 0 ? Color.gray.opacity(0.1) : Color.white)
                            .contentShape(Rectangle())
                        }
                        
                        Divider()
                        
                        Button(action: {
                            withAnimation {
                                currentWeek = 1
                                isWeekPickerVisible = false
                            }
                        }) {
                            HStack {
                                Text("Mar 22 - Mar 28")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Spacer()
                                if currentWeek == 1 {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(currentWeek == 1 ? Color.gray.opacity(0.1) : Color.white)
                            .contentShape(Rectangle())
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .zIndex(1)
            }
        }
        .zIndex(isWeekPickerVisible ? 100 : 1)
    }
    
    // Navigation buttons component
    private func navigationButtonsView() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if currentWeek > 0 {
                        currentWeek -= 1
                    }
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
                    if currentWeek < 1 {
                        currentWeek += 1
                    }
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
            // First, identify continuous stays for this room
            var stayRanges: [(guest: Guest, startIndex: Int, endIndex: Int)] = []
            var currentGuest: Guest? = nil
            var startIndex = -1
            
            // Find all continuous stays in this row
            for dayIndex in 0..<7 {
                if let guest = getOccupyingGuest(roomIndex, dayIndex, isStandardRoom) {
                    if currentGuest == nil || currentGuest?.name != guest.name {
                        // Start of a new stay
                        if currentGuest != nil {
                            // End previous stay
                            stayRanges.append((guest: currentGuest!, startIndex: startIndex, endIndex: dayIndex - 1))
                        }
                        currentGuest = guest
                        startIndex = dayIndex
                    }
                    
                    // If we're at the last day, end the current stay
                    if dayIndex == 6 {
                        stayRanges.append((guest: guest, startIndex: startIndex, endIndex: dayIndex))
                    }
                } else if currentGuest != nil {
                    // End of a stay
                    stayRanges.append((guest: currentGuest!, startIndex: startIndex, endIndex: dayIndex - 1))
                    currentGuest = nil
                }
            }
            
            // Now render the cells with labels in the middle of stays
            return ZStack(alignment: .leading) {
                // Background cells - empty cells with borders
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { dayIndex in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: getDayColumnWidth(), height: 60)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                }
                
                // Shaped occupancy containers
                ForEach(stayRanges.indices, id: \.self) { index in
                    let stay = stayRanges[index]
                    let stayWidth = CGFloat(stay.endIndex - stay.startIndex + 1) * getDayColumnWidth()
                    let stayOffset = CGFloat(stay.startIndex) * getDayColumnWidth()
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(stay.guest.color)
                        .frame(width: stayWidth - 32, height: 44)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .overlay(
                            Text(stay.guest.name)
                                .font(.system(size: 11, weight: .medium, design: .default))
                                .foregroundColor(darkenColor(stay.guest.color))
                                .padding(.horizontal, 4)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        )
                        .position(x: stayOffset + stayWidth/2, y: 30) // Center in the cell
                }
            }
        }
    }
    
    // Helper function to create a darker version of a color for better text readability
    private func darkenColor(_ color: Color) -> Color {
        // Extract RGB components using UIColor
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Darken the color by reducing RGB values
        let darkeningFactor: CGFloat = 0.5
        return Color(
            red: max(red - darkeningFactor, 0),
            green: max(green - darkeningFactor, 0),
            blue: max(blue - darkeningFactor, 0)
        )
    }
    
    // Helper function to determine occupancy color
    private func getOccupancyColor(for room: Int, on day: Int) -> Color {
        let currentDate = Int(dates[day]) ?? 0
        if let guest = Guest.guests.first(where: { $0.room == room &&
            currentDate >= $0.startDate &&
            currentDate <= $0.endDate }) {
            return guest.color
        }
        return Color.clear
    }
    
    // Helper function to determine if a room is occupied and by whom
    private func getOccupyingGuest(_ room: Int, _ day: Int, _ isStandardRoom: Bool) -> Guest? {
        let currentDate = Int(dates[day]) ?? 0
        return Guest.guests.first(where: { $0.room == room &&
            $0.isStandardRoom == isStandardRoom &&
            $0.week == currentWeek &&
            currentDate >= $0.startDate && 
            currentDate <= $0.endDate })
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
    
    // Helper function to calculate calendar height based on collapsed state
    private func getCalendarHeight() -> CGFloat {
        let headerHeight: CGFloat = 70
        let sectionHeaderHeight: CGFloat = 60
        let summaryRowHeight: CGFloat = 60
        let roomCellHeight: CGFloat = 60
        
        var totalHeight = headerHeight // Days header row
        
        // Superior Room section
        totalHeight += summaryRowHeight // Superior Room summary placeholder
        totalHeight += sectionHeaderHeight // Superior Room section header
        
        if !isSuperiorRoomsCollapsed {
            totalHeight += roomCellHeight * CGFloat(rooms.count) // Superior room cells
        }
        
        // Standard Room section
        totalHeight += summaryRowHeight // Standard Room summary placeholder
        totalHeight += sectionHeaderHeight // Standard Room section header
        
        if !isStandardRoomsCollapsed {
            totalHeight += roomCellHeight * CGFloat(standardRooms.count) // Standard room cells
        }
        
        return totalHeight
    }
}

#Preview {
    CalendarView()
}

