//
//  CartView.swift
//  BrewStar
//
//  Created by Can Arda on 25.02.26.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showPayment = false
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottom) {
                
                // MARK: - Ana içerik
                if viewModel.cartItems.isEmpty {
                    emptyCartView
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.cartItems) { item in
                                CartItemRow(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 140)
                    }
                }
                
                if !viewModel.cartItems.isEmpty {
                    checkoutButton
                }
            }
            .navigationTitle("My Order")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        withAnimation {
                            viewModel.cartItems.removeAll()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $showPayment, onDismiss: {
                if viewModel.cartItems.isEmpty {
                    dismiss()
                }
            }) {
                PaymentView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    // MARK: - Boş sepet
    private var emptyCartView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 64))
                .foregroundColor(Color("BrewGreen").opacity(0.4))
            Text("Your bag is empty")
                .font(.title2.bold())
            Text("Add some drinks to get started!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button {
                dismiss()
            } label: {
                Text("Browse Menu")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color("BrewGreen"))
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Checkout butonu
    private var checkoutButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 1)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.cartItemCount) item\(viewModel.cartItemCount > 1 ? "s" : "")")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Text(String(format: "€%.2f", viewModel.cartTotal))
                            .font(.system(size: 22, weight: .bold))
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color("BrewGold"))
                        Text("+\(viewModel.cartItems.reduce(0) { $0 + $1.drink.starPoints * $1.quantity }) stars")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color("BrewGold"))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("BrewGold").opacity(0.1))
                    .clipShape(Capsule())
                }
                
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    showPayment = true
                } label: {
                    HStack {
                        Text("Proceed to Checkout")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color("BrewGreen"), Color("BrewGreenDark")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - CartItemRow
struct CartItemRow: View {
    @EnvironmentObject var viewModel: AppViewModel
    let item: CartItem
    @State private var showDetail = false
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("BrewGreen").opacity(0.1))
                    .frame(width: 64, height: 64)
                AsyncImage(url: URL(string: item.drink.imageName)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    default:
                        Image(systemName: item.drink.sfSymbol)
                            .font(.system(size: 28))
                            .foregroundColor(Color("BrewGreen"))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.drink.name)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                Text(item.drink.formattedPrice)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundColor(Color("BrewGold"))
                    Text("+\(item.drink.starPoints) pts")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color("BrewGold"))
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.decreaseQuantity(item)
                    }
                } label: {
                    Image(systemName: item.quantity == 1 ? "trash" : "minus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(item.quantity == 1 ? .red : Color("BrewGreen"))
                        .frame(width: 28, height: 28)
                        .background(
                            item.quantity == 1
                                ? Color.red.opacity(0.1)
                                : Color("BrewGreen").opacity(0.1)
                        )
                        .clipShape(Circle())
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 16, weight: .bold))
                    .frame(minWidth: 20)
                
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.addToCart(item.drink)
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(Color("BrewGreen"))
                        .clipShape(Circle())
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            DrinkDetailView(drink: item.drink)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(AppViewModel())
}
