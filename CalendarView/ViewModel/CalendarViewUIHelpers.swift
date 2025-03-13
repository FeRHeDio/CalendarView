import SwiftUI

// MARK: - UI Helper methods for CalendarView
extension CalendarViewModel {
    // MARK: - Button Action Handlers
    
    /// Handles the Today button action
    func handleTodayButtonTap() {
        // Implementation for Today button action
        // For example, reset to current day/week
        currentWeek = 0
    }
    
    // MARK: - UI Configuration Helpers
    
    /// Returns the configuration for week picker dropdown options
    func getWeekPickerOptions() -> [(label: String, isSelected: Bool)] {
        return [
            ("Mar 15 - Mar 21", currentWeek == 0),
            ("Mar 22 - Mar 28", currentWeek == 1)
        ]
    }
    
    /// Returns the configuration for the occupancy row
    func getOccupancyRowConfiguration(for roomIndex: Int, isStandardRoom: Bool) -> [StayConfiguration] {
        let stayRanges = getStayRanges(for: roomIndex, isStandardRoom: isStandardRoom)
        
        return stayRanges.map { stay in
            let stayWidth = CGFloat(stay.endIndex - stay.startIndex + 1) * getDayColumnWidth()
            let stayOffset = CGFloat(stay.startIndex) * getDayColumnWidth()
            
            return StayConfiguration(
                guest: stay.guest,
                width: stayWidth - 32, // Padding
                offset: stayOffset + stayWidth/2, // Center in the cell
                color: stay.guest.color,
                textColor: darkenColor(stay.guest.color)
            )
        }
    }
}

// MARK: - Supporting Types
extension CalendarViewModel {
    /// Configuration for a guest stay display
    struct StayConfiguration {
        let guest: Guest
        let width: CGFloat
        let offset: CGFloat
        let color: Color
        let textColor: Color
    }
} 