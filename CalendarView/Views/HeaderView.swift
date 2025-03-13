import SwiftUI

/// Displays the app header with logo, title, and action buttons
struct HeaderView: View {
    var body: some View {
        HStack {
            // Logo and title
            HStack(spacing: 12) {
                // Circular logo
                LogoView()
                
                // Title and subtitle
                TitleView()
            }
            
            Spacer()
            
            // Right side buttons
            HStack(spacing: 16) {
                SearchButton()
                AddButton()
            }
        }
    }
}

// MARK: - Subcomponents

private struct LogoView: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 40, height: 40)
            .overlay(
                Text("LP")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
    }
}

private struct TitleView: View {
    var body: some View {
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
}

private struct SearchButton: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

private struct AddButton: View {
    var body: some View {
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

#Preview {
    HeaderView()
        .padding()
        .previewLayout(.sizeThatFits)
} 
