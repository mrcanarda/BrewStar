//
//  DrinkCard.swift
//  BrewStar
//
//  Created by Can Arda on 24.02.26.
//

import SwiftUI

struct DrinkCard: View {
    let drink: Drink
    let onAddToCart: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: - Drink Image Area
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color("BrewGreen").opacity(0.15), Color("BrewGreen").opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                    .overlay {
                        AsyncImage(url: URL(string: drink.imageName)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .clipped()
                            default:
                                Image(systemName: drink.sfSymbol)
                                    .font(.system(size: 50))
                                    .foregroundColor(Color("BrewGreen").opacity(0.6))
                            }
                        }
                    }
                
                // Yıldız badge — sağ üstte
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                    Text("+\(drink.starPoints)")
                        .font(.system(size: 11, weight: .bold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color("BrewGold"))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(10)
            }
            
            // MARK: - Info Area
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(drink.description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            
            // MARK: - Price + Add Button
            HStack {
                Text(drink.formattedPrice)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation { isPressed = false }
                    }
                    onAddToCart()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color("BrewGreen"))
                        .clipShape(Circle())
                        .scaleEffect(isPressed ? 0.85 : 1.0)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            
          
            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .font(.system(size: 9))
                    .foregroundColor(Color("BrewGold"))
                Text("\(drink.starPoints * 10) stars to redeem")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color("BrewGold"))
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }
}

#Preview {
    DrinkCard(drink: Drink.sampleDrinks[0]) {}
        .frame(width: 200)
        .padding()
}
