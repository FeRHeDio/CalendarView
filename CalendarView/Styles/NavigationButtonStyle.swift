//
//  NavigationButtonStyle.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 12/03/2025.
//

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
