//
//  Guest.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 12/03/2025.
//

import Foundation
import SwiftUI

struct Guest {
    let name: String
    let color: Color
    let room: Int
    let startDate: Int
    let endDate: Int
    let isStandardRoom: Bool
    let week: Int // 0 = week1, 1 = week2
    
    static let guests = [
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
}


