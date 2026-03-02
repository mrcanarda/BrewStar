import SwiftUI

// MARK: - Size Option
enum DrinkSize: String, CaseIterable {
    case short = "Short"
    case tall = "Tall"
    case grande = "Grande"
    case venti = "Venti"
    
    var priceAdd: Double {
        switch self {
        case .short: return 0.0
        case .tall: return 0.5
        case .grande: return 1.0
        case .venti: return 1.5
        }
    }
    
    var oz: String {
        switch self {
        case .short: return "8oz"
        case .tall: return "12oz"
        case .grande: return "16oz"
        case .venti: return "20oz"
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .short: return 22
        case .tall: return 26
        case .grande: return 30
        case .venti: return 34
        }
    }
}

// MARK: - Milk Option
enum MilkOption: String, CaseIterable {
    case whole = "Whole"
    case oat = "Oat"
    case almond = "Almond"
    case soy = "Soy"
    case none = "None"
    
    var icon: String {
        switch self {
        case .whole: return "🥛"
        case .oat: return "🌾"
        case .almond: return "🌰"
        case .soy: return "🫘"
        case .none: return "🚫"
        }
    }
}

// MARK: - DrinkDetailView
struct DrinkDetailView: View {
    let drink: Drink
    
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedSize: DrinkSize = .grande
    @State private var selectedMilk: MilkOption = .whole
    @State private var quantity: Int = 1
    @State private var addedToCart: Bool = false
    
    private var totalPrice: Double {
        (drink.price + selectedSize.priceAdd) * Double(quantity)
    }
    
    private var totalStars: Int {
        drink.starPoints * quantity
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                
                VStack(spacing: 24) {
                    infoSection
                    Divider()
                    sizeSection
                    Divider()
                    milkSection
                    Divider()
                    quantitySection
                }
                .padding(24)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .offset(y: -28)
                
                Color.clear.frame(height: 100)
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) { addToCartButton }
        .overlay(alignment: .top) { closeButton }
    }
    
    // MARK: - Hero
    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color("BrewGreen").opacity(0.2), Color("BrewGreen").opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 320)
            
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: drink.imageName)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color("BrewGreen").opacity(0.3), radius: 20)
                    default:
                        Image(systemName: drink.sfSymbol)
                            .font(.system(size: 100))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("BrewGreen"), Color("BrewGreen").opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                    Text("+\(totalStars) stars")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color("BrewGold"))
                .clipShape(Capsule())
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Close Button
    private var closeButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(.leading, 20)
            .padding(.top, 56)
            Spacer()
        }
    }
    
    // MARK: - Info
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(drink.name)
                    .font(.system(size: 26, weight: .bold))
                Spacer()
                Text("\(drink.calories) cal")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color("BrewGreen"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("BrewGreen").opacity(0.1))
                    .clipShape(Capsule())
            }
            Text(drink.description)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Size
    private var sizeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Size")
                .font(.system(size: 17, weight: .bold))
            
            HStack(spacing: 10) {
                ForEach(DrinkSize.allCases, id: \.self) { size in
                    let isSelected = selectedSize == size
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedSize = size
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: size.iconSize))
                                .foregroundColor(isSelected ? Color("BrewGreen") : .secondary)
                            Text(size.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                            Text(size.oz)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            if size.priceAdd > 0 {
                                Text("+€\(String(format: "%.2f", size.priceAdd))")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color("BrewGreen"))
                            } else {
                                Text("Base")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isSelected ? Color("BrewGreen").opacity(0.1) : Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color("BrewGreen") : Color.clear, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(isSelected ? Color("BrewGreen") : .primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Milk
    private var milkSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Milk")
                .font(.system(size: 17, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(MilkOption.allCases, id: \.self) { milk in
                        let isSelected = selectedMilk == milk
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedMilk = milk
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(milk.icon)
                                    .font(.system(size: 16))
                                Text(milk.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(isSelected ? Color("BrewGreen").opacity(0.1) : Color(.systemGray6))
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? Color("BrewGreen") : Color.clear, lineWidth: 2)
                            )
                            .clipShape(Capsule())
                            .foregroundColor(isSelected ? Color("BrewGreen") : .primary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Quantity
    private var quantitySection: some View {
        HStack {
            Text("Quantity")
                .font(.system(size: 17, weight: .bold))
            Spacer()
            HStack(spacing: 16) {
                Button {
                    if quantity > 1 {
                        withAnimation(.spring(response: 0.3)) { quantity -= 1 }
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(quantity == 1 ? .secondary : Color("BrewGreen"))
                        .frame(width: 36, height: 36)
                        .background(quantity == 1 ? Color(.systemGray6) : Color("BrewGreen").opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(quantity == 1)
                
                Text("\(quantity)")
                    .font(.system(size: 20, weight: .bold))
                    .frame(minWidth: 30)
                
                Button {
                    withAnimation(.spring(response: 0.3)) { quantity += 1 }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color("BrewGreen"))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    // MARK: - Add To Cart Button
    private var addToCartButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 1)
            
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                for _ in 0..<quantity {
                    viewModel.addToCart(drink)
                }
                withAnimation(.spring()) { addedToCart = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    dismiss()
                }
            } label: {
                HStack {
                    if addedToCart {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                            Text("Added to Bag!")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        HStack {
                            Text("Add to Bag")
                                .font(.system(size: 17, weight: .semibold))
                            Spacer()
                            Text(String(format: "€%.2f", totalPrice))
                                .font(.system(size: 17, weight: .bold))
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    addedToCart
                        ? LinearGradient(colors: [Color.green, Color.green], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color("BrewGreen"), Color("BrewGreenDark")], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .animation(.spring(response: 0.4), value: addedToCart)
            }
            .disabled(addedToCart)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    DrinkDetailView(drink: Drink.sampleDrinks[0])
        .environmentObject(AppViewModel())
}
