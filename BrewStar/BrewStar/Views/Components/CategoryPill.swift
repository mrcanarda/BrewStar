import SwiftUI

struct CategoryPill: View {
    let category: DrinkCategory
    let isSelected: Bool
    let action: () -> Void
    
    // Renk teması: seçili/seçili değil durumu
    private var backgroundColor: Color {
        isSelected ? Color("BrewGreen") : Color(.systemGray6)
    }
    
    private var foregroundColor: Color {
        isSelected ? .white : .primary
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12, weight: .semibold))
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
            // Seçilince hafif shadow ekle
            .shadow(color: isSelected ? Color("BrewGreen").opacity(0.4) : .clear, radius: 8, y: 4)
        }
        // Animasyon: seçim değişince smooth geçiş
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    HStack {
        CategoryPill(category: .hotCoffee, isSelected: true) {}
        CategoryPill(category: .coldBrew, isSelected: false) {}
    }
    .padding()
}
