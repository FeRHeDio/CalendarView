//
//  CursorView.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 05/03/2025.
//

import SwiftUI

struct CursorView: View {
    // Sample data
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let dates = ["15", "16", "17", "18", "19", "20", "21"]
    private let occupancyPercentages = ["85%", "90%", "75%", "80%", "95%", "70%", "65%"]
    private let rooms = ["Room A", "Room B", "Room C", "Room D"]
    private let averageIncomes = ["$120", "$150", "$110", "$130", "$160", "$140", "$125"]
    
    @State private var selectedDateRange = "Mar 15 - Mar 21"
    
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
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12)
                    }
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1, height: 24)
                    
                    Button(action: {}) {
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
                            // Empty header cell
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: geometry.size.width * 0.45, height: 70)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                )
                            
                            // Summary cell
                            HStack {
                                Text("Superior Room with Queen bed")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray.opacity(0.8))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                            .padding(.horizontal, 12)
                            .frame(width: geometry.size.width * 0.45, height: 50)
                            .background(Color.gray.opacity(0.05))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                            )
                            
                            // Room name cells
                            ForEach(0..<rooms.count, id: \.self) { roomIndex in
                                Text(rooms[roomIndex])
                                    .font(.subheadline)
                                    .frame(width: geometry.size.width * 0.45, height: 60)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                    )
                            }
                        }
                        
                        // Scrollable content for all rows
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(spacing: 0) {
                                // Days header row
                                HStack(spacing: 0) {
                                    ForEach(0..<7, id: \.self) { index in
                                        VStack(spacing: 4) {
                                            Text(daysOfWeek[index])
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundColor(.gray)
                                            
                                            Text(dates[index])
                                                .font(.title3)
                                                .fontWeight(.bold)
                                            
                                            Text(occupancyPercentages[index])
                                                .font(.caption)
                                                .foregroundColor(Color.green)
                                        }
                                        .frame(width: 80, height: 70)
                                        .overlay(
                                            Rectangle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                        )
                                    }
                                }
                                
                                // Summary row
                                HStack(spacing: 0) {
                                    ForEach(0..<7, id: \.self) { index in
                                        Text(averageIncomes[index])
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray.opacity(0.8))
                                            .frame(width: 80, height: 50)
                                            .background(Color.gray.opacity(0.05))
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                            )
                                    }
                                }
                                
                                // Room occupancy rows
                                ForEach(0..<rooms.count, id: \.self) { roomIndex in
                                    HStack(spacing: 0) {
                                        ForEach(0..<7, id: \.self) { dayIndex in
                                            ZStack {
                                                Rectangle()
                                                    .fill(getOccupancyColor(for: roomIndex, on: dayIndex))
                                                    .frame(width: 80, height: 60)
                                                
                                                if isOccupied(roomIndex, dayIndex) {
                                                    Text("Guest Name")
                                                        .font(.caption)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                            )
                                        }
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
    
    // Helper function to determine occupancy color
    private func getOccupancyColor(for room: Int, on day: Int) -> Color {
        // Sample logic - in a real app this would be based on actual data
        let occupied = isOccupied(room, day)
        return occupied ? Color.blue : Color.clear
    }
    
    // Helper function to determine if a room is occupied
    private func isOccupied(_ room: Int, _ day: Int) -> Bool {
        // Sample logic - in a real app this would be based on actual data
        return (room + day) % 3 == 0
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
