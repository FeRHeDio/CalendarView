import SwiftUI
import Observation

/// Container for all calendar navigation controls
struct CalendarControlsView: View {
    @Bindable var viewModel: CalendarViewModel
    let isLandscape: Bool
    
    var body: some View {
        if isLandscape {
            // Horizontal layout for landscape
            HStack(spacing: 16) {
                TodayButton(viewModel: viewModel)
                WeekPickerView(viewModel: viewModel)
                NavigationButtonsView(viewModel: viewModel)
            }
        } else {
            // Distributed layout for portrait
            HStack {
                TodayButton(viewModel: viewModel)
                
                Spacer()
                
                WeekPickerView(viewModel: viewModel)
                
                Spacer()
                
                NavigationButtonsView(viewModel: viewModel)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Individual Controls

/// Button to navigate to today's date
struct TodayButton: View {
    var viewModel: CalendarViewModel
    
    var body: some View {
        Button(action: {
            viewModel.handleTodayButtonTap()
        }) {
            Text("Today")
        }
        .applyActionButtonStyle()
    }
}

/// Week picker dropdown component
struct WeekPickerView: View {
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            // Week picker button
            WeekPickerButton(viewModel: viewModel)
            
            // Dropdown menu
            if viewModel.isWeekPickerVisible {
                WeekPickerDropdown(viewModel: viewModel)
                    .zIndex(1)
            }
        }
        .zIndex(viewModel.isWeekPickerVisible ? 100 : 1)
    }
}

/// Week picker button that toggles the dropdown
private struct WeekPickerButton: View {
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
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
    }
}

/// Dropdown menu for week selection
private struct WeekPickerDropdown: View {
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Spacer to push dropdown below the button
            Rectangle()
                .fill(Color.clear)
                .frame(height: 50)
            
            // Week options
            VStack(spacing: 0) {
                ForEach(viewModel.getWeekPickerOptions().indices, id: \.self) { index in
                    let option = viewModel.getWeekPickerOptions()[index]
                    
                    WeekPickerOption(
                        label: option.label,
                        isSelected: option.isSelected,
                        action: {
                            withAnimation {
                                viewModel.selectWeek(index)
                            }
                        }
                    )
                    
                    if index < viewModel.getWeekPickerOptions().count - 1 {
                        Divider()
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}

/// Individual option in the week picker dropdown
private struct WeekPickerOption: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.gray.opacity(0.1) : Color.white)
            .contentShape(Rectangle())
        }
    }
}

/// Navigation buttons for moving between weeks
struct NavigationButtonsView: View {
    var viewModel: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            // Previous week button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.navigateToPreviousWeek()
                }
            }) {
                Image(systemName: "chevron.left")
            }
            .applyNavigationButtonStyle(isGrouped: true, position: .leading)
            
            // Divider between buttons
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 24)
            
            // Next week button
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
}

#Preview {
    VStack(spacing: 20) {
        CalendarControlsView(viewModel: CalendarViewModel(), isLandscape: true)
        CalendarControlsView(viewModel: CalendarViewModel(), isLandscape: false)
    }
    .padding()
    .previewLayout(.sizeThatFits)
} 