//
//  CursorView.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 05/03/2025.
//

import SwiftUI
import Inject

struct CursorView: View {
    @ObserveInjection var redraw
    
    // Sample data
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    // Week 1 data (Mar 15-21)
    private let week1Dates = ["15", "16", "17", "18", "19", "20", "21"]
    private let week1OccupancyPercentages = ["85%", "90%", "75%", "80%", "95%", "70%", "65%"]
    private let week1AverageIncomes = ["$120", "$150", "$110", "$130", "$160", "$140", "$125"]
    
    // Week 2 data (Mar 22-28)
    private let week2Dates = ["22", "23", "24", "25", "26", "27", "28"]
    private let week2OccupancyPercentages = ["70%", "75%", "85%", "90%", "80%", "65%", "60%"]
    private let week2AverageIncomes = ["$110", "$130", "$145", "$170", "$150", "$120", "$105"]
    
    private let rooms = ["Room A", "Room B", "Room C", "Room D"]
    private let standardRooms = ["STDQA101", "STDQA102", "STDQA103"]
    
    // Current week selection
    @State private var currentWeek = 0 // 0 = week1, 1 = week2
    
    // Computed properties for current week data
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
    
    // Guest data
    private struct Guest {
        let name: String
        let color: Color
        let room: Int
        let startDate: Int
        let endDate: Int
        let isStandardRoom: Bool
        let week: Int // 0 = week1, 1 = week2
    }
    
    private let guests = [
        // Week 1 - Superior rooms
        Guest(name: "Bessie Cooper", color: Color(red: 0.7, green: 0.9, blue: 0.7), room: 0, startDate: 15, endDate: 20, isStandardRoom: false, week: 0),  // Pastel green
        Guest(name: "Kristin Watson", color: Color(red: 0.7, green: 0.8, blue: 0.9), room: 1, startDate: 16, endDate: 18, isStandardRoom: false, week: 0), // Pastel blue
        Guest(name: "Albert Flores", color: Color(red: 0.85, green: 0.8, blue: 0.9), room: 2, startDate: 15, endDate: 20, isStandardRoom: false, week: 0), // Pastel violet
        Guest(name: "Bessie Cooper", color: Color(red: 0.7, green: 0.9, blue: 0.7), room: 3, startDate: 20, endDate: 21, isStandardRoom: false, week: 0),   // Pastel green (same guest)
        
        // Week 1 - Standard rooms
        Guest(name: "John Smith", color: Color(red: 0.9, green: 0.8, blue: 0.7), room: 0, startDate: 15, endDate: 17, isStandardRoom: true, week: 0),  // Pastel orange
        Guest(name: "Emma Johnson", color: Color(red: 0.9, green: 0.7, blue: 0.8), room: 1, startDate: 18, endDate: 21, isStandardRoom: true, week: 0), // Pastel pink
        Guest(name: "Michael Brown", color: Color(red: 0.8, green: 0.9, blue: 0.8), room: 2, startDate: 16, endDate: 19, isStandardRoom: true, week: 0),  // Light green
        
        // Week 2 - Superior rooms
        Guest(name: "Robert Davis", color: Color(red: 0.8, green: 0.7, blue: 0.9), room: 0, startDate: 22, endDate: 25, isStandardRoom: false, week: 1),  // Pastel purple
        Guest(name: "Sarah Miller", color: Color(red: 0.9, green: 0.9, blue: 0.7), room: 1, startDate: 23, endDate: 28, isStandardRoom: false, week: 1), // Pastel yellow
        Guest(name: "James Wilson", color: Color(red: 0.7, green: 0.9, blue: 0.9), room: 2, startDate: 24, endDate: 27, isStandardRoom: false, week: 1), // Pastel cyan
        Guest(name: "Jennifer Lee", color: Color(red: 0.9, green: 0.8, blue: 0.8), room: 3, startDate: 22, endDate: 24, isStandardRoom: false, week: 1),  // Pastel pink
        
        // Week 2 - Standard rooms
        Guest(name: "David Taylor", color: Color(red: 0.8, green: 0.8, blue: 0.7), room: 0, startDate: 25, endDate: 28, isStandardRoom: true, week: 1),  // Pastel tan
        Guest(name: "Lisa Anderson", color: Color(red: 0.7, green: 0.8, blue: 0.7), room: 1, startDate: 22, endDate: 24, isStandardRoom: true, week: 1), // Pastel mint
        Guest(name: "Thomas White", color: Color(red: 0.9, green: 0.7, blue: 0.7), room: 2, startDate: 23, endDate: 26, isStandardRoom: true, week: 1)   // Pastel salmon
    ]
    
    @State private var isSuperiorRoomsCollapsed = false
    @State private var isStandardRoomsCollapsed = false

    
    var body: some View {
        VStack(spacing: 0) {
            // Header component
            headerView()
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 16)
            
            // Calendar title
            HStack {
                Text("Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Calendar navigation
            HStack {
                Button(action: {}) {
                    Text("Today")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Text(selectedDateRange)
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                // Navigation buttons group
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if currentWeek > 0 {
                                currentWeek -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12)
                    }
                    
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
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12)
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Calendar grid
            ScrollView {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        // Fixed first column with room names
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: geometry.size.width * 0.35, height: 70)
                            
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
                            .frame(width: geometry.size.width * 0.35, height: 60)
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
                                        .frame(width: geometry.size.width * 0.35, height: 60)
                                        .background(Color.white)
                                        .overlay(
                                            Rectangle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                        )
                                }
                            }
                            
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
                            .frame(width: geometry.size.width * 0.35, height: 60)
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
                                        .frame(width: geometry.size.width * 0.35, height: 60)
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
                                        VStack {
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
                                        .frame(width: 80, height: 70)
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
                                            .frame(width: 80, height: 60)
                                            .background(Color.gray.opacity(0.02))
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                            )
                                    }
                                }
                                
                                // Superior Room occupancy rows
                                if !isSuperiorRoomsCollapsed {
                                    ForEach(0..<rooms.count, id: \.self) { roomIndex in
                                        occupancyRow(for: roomIndex, isStandardRoom: false, geometry: geometry)
                                    }
                                }
                                
                                // Summary row for Standard Rooms
                                HStack(spacing: 0) {
                                    ForEach(0..<7, id: \.self) { index in
                                        Text(averageIncomes[index])
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black.opacity(0.8))
                                            .frame(width: 80, height: 60)
                                            .background(Color.gray.opacity(0.02))
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                            )
                                    }
                                }
                                
                                // Standard Room occupancy rows
                                if !isStandardRoomsCollapsed {
                                    ForEach(0..<standardRooms.count, id: \.self) { roomIndex in
                                        occupancyRow(for: roomIndex, isStandardRoom: true, geometry: geometry)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        
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
                            .frame(width: 80, height: 60)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                }
                
                // Shaped occupancy containers
                ForEach(stayRanges.indices, id: \.self) { index in
                    let stay = stayRanges[index]
                    let stayWidth = CGFloat(stay.endIndex - stay.startIndex + 1) * 80
                    let stayOffset = CGFloat(stay.startIndex) * 80
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(stay.guest.color)
                        .frame(width: stayWidth - 32, height: 44)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .overlay(
                            Text(stay.guest.name)
                                .font(.system(size: 11, weight: .medium, design: .default))
                                .foregroundColor(darkenColor(stay.guest.color))
                                .padding(.horizontal, 4)
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
        if let guest = guests.first(where: { $0.room == room && 
            currentDate >= $0.startDate && 
            currentDate <= $0.endDate }) {
            return guest.color
        }
        return Color.clear
    }
    
    // Helper function to determine if a room is occupied and by whom
    private func getOccupyingGuest(_ room: Int, _ day: Int, _ isStandardRoom: Bool) -> Guest? {
        let currentDate = Int(dates[day]) ?? 0
        return guests.first(where: { $0.room == room && 
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
}

#Preview {
    CursorView()
}

