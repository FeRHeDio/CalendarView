import SwiftUI
import Observation

/// Preview for the RoomSectionLabels component
struct RoomSectionPreview: View {
    @State private var viewModel = CalendarViewModel()
    @State private var isCollapsed = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("Room Section Preview")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                // Preview with collapsed state
                VStack(alignment: .leading, spacing: 4) {
                    Text("Collapsed State")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    RoomSectionLabels(
                        viewModel: viewModel,
                        geometry: geometry,
                        roomTypeTitle: "Superior Room with Queen bed",
                        isCollapsed: true,
                        rooms: viewModel.rooms,
                        toggleAction: { isCollapsed.toggle() }
                    )
                    .frame(width: geometry.size.width * 0.8)
                }
                
                // Preview with expanded state
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expanded State")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    RoomSectionLabels(
                        viewModel: viewModel,
                        geometry: geometry,
                        roomTypeTitle: "Standard Room",
                        isCollapsed: false,
                        rooms: viewModel.standardRooms,
                        toggleAction: { isCollapsed.toggle() }
                    )
                    .frame(width: geometry.size.width * 0.8)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    RoomSectionPreview()
} 