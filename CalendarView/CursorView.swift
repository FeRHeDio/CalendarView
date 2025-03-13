import SwiftUI

// Extension to apply the button styles to the calendar view
extension View {
    func applyActionButtonStyle(
        backgroundColor: Color = .white,
        foregroundColor: Color = .black,
        shadowRadius: CGFloat = 4,
        shadowOpacity: Double = 0.1,
        cornerRadius: CGFloat = 8,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    ) -> some View {
        self.buttonStyle(ActionButtonStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shadowRadius: shadowRadius,
            shadowOpacity: shadowOpacity,
            cornerRadius: cornerRadius,
            padding: padding
        ))
    }
    
    func applyIconButtonStyle(
        backgroundColor: Color = .white,
        foregroundColor: Color = .black,
        shadowRadius: CGFloat = 4,
        shadowOpacity: Double = 0.1,
        cornerRadius: CGFloat = 8,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    ) -> some View {
        self.buttonStyle(IconButtonStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shadowRadius: shadowRadius,
            shadowOpacity: shadowOpacity,
            cornerRadius: cornerRadius,
            padding: padding
        ))
    }
    
    func applyNavigationButtonStyle(
        backgroundColor: Color = .white,
        foregroundColor: Color = .black,
        shadowRadius: CGFloat = 4,
        shadowOpacity: Double = 0.1,
        cornerRadius: CGFloat = 8,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
        isGrouped: Bool = false,
        position: NavigationButtonStyle.GroupPosition = .single
    ) -> some View {
        self.buttonStyle(NavigationButtonStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shadowRadius: shadowRadius,
            shadowOpacity: shadowOpacity,
            cornerRadius: cornerRadius,
            padding: padding,
            isGrouped: isGrouped,
            position: position
        ))
    }
} 
