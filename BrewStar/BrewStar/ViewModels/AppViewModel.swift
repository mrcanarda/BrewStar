import Foundation
import Combine

// @MainActor: Bu class'taki tüm UI güncellemeleri main thread'de çalışır
// ObservableObject: View'lar bu class'ı "izleyebilir", değişince otomatik güncellenir
@MainActor
class AppViewModel: ObservableObject {
    
    // @Published: Bu değişken değişince, bağlı tüm View'lar otomatik yenilenir
    @Published var drinks: [Drink] = Drink.sampleDrinks
    @Published var selectedCategory: DrinkCategory = .all
    @Published var cartItems: [CartItem] = []
    @Published var totalStars: Int = 340  // Başlangıç yıldızı
    @Published var searchText: String = ""
    
    // Computed property: reactive filtreleme
    // selectedCategory veya searchText değişince otomatik yeniden hesaplanır
    var filteredDrinks: [Drink] {
        let categoryFiltered = selectedCategory == .all
            ? drinks
            : drinks.filter { $0.drinkCategory == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // Sepet toplam fiyatı
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.drink.price * Double($1.quantity)) }
    }
    
    // Sepetteki toplam ürün sayısı (badge için)
    var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    // MARK: - Cart Actions
    func addToCart(_ drink: Drink) {
        // Zaten sepette varsa miktarını artır
        if let index = cartItems.firstIndex(where: { $0.drink.id == drink.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(drink: drink, quantity: 1))
        }
    }
    
    func decreaseQuantity(_ item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        if cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
        } else {
            cartItems.remove(at: index)
        }
    }

    var userLevel: String {
        switch totalStars {
        case 0..<150: return "Level Green"
        case 150..<300: return "Level Silver"
        case 300..<500: return "Level Gold"
        default: return "Level Diamond"
        }
    }

} 

// MARK: - CartItem
struct CartItem: Identifiable {
    let id: UUID = UUID()
    let drink: Drink
    var quantity: Int
}
