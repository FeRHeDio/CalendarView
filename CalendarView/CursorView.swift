import SwiftUI

/// A button style for navigation controls that can be grouped together
struct NavigationButtonStyle: ButtonStyle {
    var backgroundColor: Color = .white
    var foregroundColor: Color = .black
    var shadowRadius: CGFloat = 4
    var shadowOpacity: Double = 0.1
    var cornerRadius: CGFloat = 8
    var padding: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    var isGrouped: Bool = false
    var position: GroupPosition = .single
    
    enum GroupPosition {
        case leading, middle, trailing, single
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(foregroundColor)
            .padding(padding)
            .background(backgroundColor.opacity(configuration.isPressed ? 0.9 : 1.0))
            .clipShape(getRoundedCornerShape())
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    
    private func getRoundedCornerShape() -> RoundedCornerShape {
        if !isGrouped {
            return RoundedCornerShape(
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                topTrailing: cornerRadius,
                bottomTrailing: cornerRadius
            )
        }
        
        switch position {
        case .leading:
            return RoundedCornerShape(
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                topTrailing: 0,
                bottomTrailing: 0
            )
        case .middle:
            return RoundedCornerShape(
                topLeading: 0,
                bottomLeading: 0,
                topTrailing: 0,
                bottomTrailing: 0
            )
        case .trailing:
            return RoundedCornerShape(
                topLeading: 0,
                bottomLeading: 0,
                topTrailing: cornerRadius,
                bottomTrailing: cornerRadius
            )
        case .single:
            return RoundedCornerShape(
                topLeading: cornerRadius,
                bottomLeading: cornerRadius,
                topTrailing: cornerRadius,
                bottomTrailing: cornerRadius
            )
        }
    }
}

// Helper shape for custom rounded corners
struct RoundedCornerShape: Shape {
    var topLeading: CGFloat = 0
    var bottomLeading: CGFloat = 0
    var topTrailing: CGFloat = 0
    var bottomTrailing: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        path.move(to: CGPoint(x: rect.minX + topLeading, y: rect.minY))
        
        // Top edge and top-right corner
        path.addLine(to: CGPoint(x: rect.maxX - topTrailing, y: rect.minY))
        if topTrailing > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - topTrailing, y: rect.minY + topTrailing),
                radius: topTrailing,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
        }
        
        // Right edge and bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomTrailing))
        if bottomTrailing > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - bottomTrailing, y: rect.maxY - bottomTrailing),
                radius: bottomTrailing,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
        }
        
        // Bottom edge and bottom-left corner
        path.addLine(to: CGPoint(x: rect.minX + bottomLeading, y: rect.maxY))
        if bottomLeading > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + bottomLeading, y: rect.maxY - bottomLeading),
                radius: bottomLeading,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
        }
        
        // Left edge and top-left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeading))
        if topLeading > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + topLeading, y: rect.minY + topLeading),
                radius: topLeading,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
        }
        
        path.closeSubpath()
        return path
    }
}

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
