//
//  CursorView.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 05/03/2025.
//

import SwiftUI
import Observation

/// Main calendar view that orchestrates all components
struct CalendarView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @State private var viewModel = CalendarViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header component
                HeaderView()
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                // Calendar title
                CalendarTitleView(viewModel: viewModel)
                
                // Calendar grid
                CalendarGridView(viewModel: viewModel)
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

/// Calendar title and controls section
struct CalendarTitleView: View {
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Title and navigation (conditional based on orientation)
            HStack(alignment: .center) {
                Text("Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Only show navigation controls in the title row when in landscape
                if viewModel.isLandscape {
                    CalendarControlsView(viewModel: viewModel, isLandscape: true)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Calendar navigation - only show in portrait mode
            if !viewModel.isLandscape {
                CalendarControlsView(viewModel: viewModel, isLandscape: false)
            }
        }
    }
}

#Preview {
    CalendarView()
}
