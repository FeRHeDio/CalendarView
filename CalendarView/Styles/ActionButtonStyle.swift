//
//  ActionButtonStyle.swift
//  CalendarView
//
//  Created by Fernando Putallaz on 12/03/2025.
//

import SwiftUI

///// A button style that provides a consistent look for action buttons throughout the app
///// with customizable background color, text color, and shadow options.
struct ActionButtonStyle: ButtonStyle {
    var backgroundColor: Color = .white
    var foregroundColor: Color = .black
    var shadowRadius: CGFloat = 4
    var shadowOpacity: Double = 0.1
    var cornerRadius: CGFloat = 8
    var padding: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(foregroundColor)
            .padding(padding)
            .background(
                backgroundColor
                    .opacity(configuration.isPressed ? 0.9 : 1.0)
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            )
            .cornerRadius(cornerRadius)
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,
                y: 2
            )
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
