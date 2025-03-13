//
//  CalendarViewModel.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 12/03/2025.
//

import SwiftUI

@Observable
class CalendarViewModel {
    // MARK: - Properties
    var currentWeek = 0 // 0 = week1, 1 = week2
    var isWeekPickerVisible = false
    var isLandscape = false
    var isSuperiorRoomsCollapsed = false
    var isStandardRoomsCollapsed = false
    
    // MARK: - Static data
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let week1Dates = ["15", "16", "17", "18", "19", "20", "21"]
    let week1OccupancyPercentages = ["85%", "90%", "75%", "80%", "95%", "70%", "65%"]
    let week1AverageIncomes = ["$120", "$150", "$110", "$130", "$160", "$140", "$125"]
    let week2Dates = ["22", "23", "24", "25", "26", "27", "28"]
    let week2OccupancyPercentages = ["70%", "75%", "85%", "90%", "80%", "65%", "60%"]
    let week2AverageIncomes = ["$110", "$130", "$145", "$170", "$150", "$120", "$105"]
    let rooms = ["SUPQA101", "SUPQA102", "SUPQA103", "SUPQA104"]
    let standardRooms = ["STDQA101", "STDQA102", "STDQA103"]
    
    // MARK: - Computed Properties
    var dates: [String] {
        currentWeek == 0 ? week1Dates : week2Dates
    }
    
    var occupancyPercentages: [String] {
        currentWeek == 0 ? week1OccupancyPercentages : week2OccupancyPercentages
    }
    
    var averageIncomes: [String] {
        currentWeek == 0 ? week1AverageIncomes : week2AverageIncomes
    }
    
    var selectedDateRange: String {
        currentWeek == 0 ? "Mar 15 - Mar 21" : "Mar 22 - Mar 28"
    }
    
    // MARK: - Methods
    func toggleWeekPickerVisibility() {
        isWeekPickerVisible.toggle()
    }
    
    func toggleSuperiorRoomsCollapsed() {
        isSuperiorRoomsCollapsed.toggle()
    }
    
    func toggleStandardRoomsCollapsed() {
        isStandardRoomsCollapsed.toggle()
    }
    
    func selectWeek(_ week: Int) {
        currentWeek = week
        isWeekPickerVisible = false
    }
    
    func navigateToPreviousWeek() {
        if currentWeek > 0 {
            currentWeek -= 1
        }
    }
    
    func navigateToNextWeek() {
        if currentWeek < 1 {
            currentWeek += 1
        }
    }
    
    func checkOrientation(size: CGSize) {
        isLandscape = size.width > size.height
    }
    
    func getFixedColumnWidth(_ geometry: GeometryProxy) -> CGFloat {
        let baseWidth = geometry.size.width * 0.35
        return isLandscape ? baseWidth * 0.7 : baseWidth // 30% narrower in landscape
    }
    
    func getDayColumnWidth() -> CGFloat {
        return 80 // Fixed width for day columns
    }
    
    func getCalendarHeight() -> CGFloat {
        let headerHeight: CGFloat = 70
        let sectionHeaderHeight: CGFloat = 60
        let summaryRowHeight: CGFloat = 60
        let roomCellHeight: CGFloat = 60
        
        var totalHeight = headerHeight // Days header row
        
        // Superior Room section
        totalHeight += summaryRowHeight // Superior Room summary row
        
        if !isSuperiorRoomsCollapsed {
            totalHeight += roomCellHeight * CGFloat(rooms.count) // Superior room cells
        }
        
        // Standard Room section
        totalHeight += summaryRowHeight // Standard Room summary row
        
        if !isStandardRoomsCollapsed {
            totalHeight += roomCellHeight * CGFloat(standardRooms.count) // Standard room cells
        }
        
        return totalHeight
    }
    
    func darkenColor(_ color: Color) -> Color {
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
    
    func getOccupancyColor(for room: Int, on day: Int) -> Color {
        let currentDate = Int(dates[day]) ?? 0
        if let guest = Guest.guests.first(where: { $0.room == room &&
            currentDate >= $0.startDate &&
            currentDate <= $0.endDate }) {
            return guest.color
        }
        return Color.clear
    }
    
    func getOccupyingGuest(_ room: Int, _ day: Int, _ isStandardRoom: Bool) -> Guest? {
        let currentDate = Int(dates[day]) ?? 0
        return Guest.guests.first(where: { $0.room == room &&
            $0.isStandardRoom == isStandardRoom &&
            $0.week == currentWeek &&
            currentDate >= $0.startDate &&
            currentDate <= $0.endDate })
    }
    
    func getStayRanges(for roomIndex: Int, isStandardRoom: Bool) -> [(guest: Guest, startIndex: Int, endIndex: Int)] {
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
        
        return stayRanges
    }
}
