//
//  PaymentView.swift
//  BrewStar
//
//  Created by Can Arda on 25.02.26.
//

import SwiftUI

// MARK: - Payment Method
enum PaymentMethod: String, CaseIterable {
    case creditCard = "Credit Card"
    case applePay = "Apple Pay"
    case stars = "Pay with Stars"
    
    var icon: String {
        switch self {
        case .creditCard: return "creditcard.fill"
        case .applePay: return "apple.logo"
        case .stars: return "star.fill"
        }
    }
}

// MARK: - PaymentView
struct PaymentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPayment: PaymentMethod = .creditCard
    @State private var cardNumber: String = ""
    @State private var cardHolder: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    @State private var isProcessing: Bool = false
    @State private var orderPlaced: Bool = false
    @State private var orderNumber: String = ""
    @State private var earnedStarsCount: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                if orderPlaced {
                    orderSuccessView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            orderSummarySection
                            paymentMethodSection
                            if selectedPayment == .creditCard {
                                cardDetailsSection
                            }
                            if selectedPayment == .stars {
                                starsPaymentSection
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 120)
                    }
                    .scrollIndicators(.hidden)
                    
                    VStack {
                        Spacer()
                        placeOrderButton
                    }
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color("BrewGreen"))
                }
            }
        }
    }
    
    // MARK: - Order Summary
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.system(size: 17, weight: .bold))
            
            VStack(spacing: 10) {
                ForEach(viewModel.cartItems) { item in
                    HStack {
                        Text("\(item.quantity)x")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("BrewGreen"))
                            .frame(width: 28)
                        Text(item.drink.name)
                            .font(.system(size: 14))
                        Spacer()
                        Text(String(format: "€%.2f", item.drink.price * Double(item.quantity)))
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(String(format: "€%.2f", viewModel.cartTotal))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("BrewGreen"))
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color("BrewGold"))
                    Text("You'll earn \(viewModel.cartItems.reduce(0) { $0 + $1.drink.starPoints * $1.quantity }) stars")
                        .font(.system(size: 13))
                        .foregroundColor(Color("BrewGold"))
                    Spacer()
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        }
    }
    
    // MARK: - Payment Method
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.system(size: 17, weight: .bold))
            
            VStack(spacing: 10) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    let isSelected = selectedPayment == method
                    
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedPayment = method
                        }
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: method.icon)
                                .font(.system(size: 18))
                                .foregroundColor(isSelected ? Color("BrewGreen") : .secondary)
                                .frame(width: 28)
                            Text(method.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("BrewGreen"))
                                    .transition(.scale)
                            }
                        }
                        .padding(16)
                        .background(isSelected ? Color("BrewGreen").opacity(0.08) : Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isSelected ? Color("BrewGreen") : Color.clear, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
        }
    }
    
    // MARK: - Card Details
    private var cardDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Details")
                .font(.system(size: 17, weight: .bold))
            
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Card Number")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    TextField("1234 5678 9012 3456", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .font(.system(size: 16))
                        .onChange(of: cardNumber) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            let limited = String(filtered.prefix(16))
                            var formatted = ""
                            for (i, char) in limited.enumerated() {
                                if i > 0 && i % 4 == 0 { formatted += " " }
                                formatted += String(char)
                            }
                            cardNumber = formatted
                        }
                }
                .padding(14)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Card Holder")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    TextField("Can Arda", text: $cardHolder)
                        .font(.system(size: 16))
                }
                .padding(14)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Expiry Date")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        TextField("MM/YY", text: $expiryDate)
                            .keyboardType(.numberPad)
                            .font(.system(size: 16))
                            .onChange(of: expiryDate) { _, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                let limited = String(filtered.prefix(4))
                                if limited.count >= 3 {
                                    expiryDate = String(limited.prefix(2)) + "/" + String(limited.dropFirst(2))
                                } else {
                                    expiryDate = limited
                                }
                            }
                    }
                    .padding(14)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CVV")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        SecureField("•••", text: $cvv)
                            .keyboardType(.numberPad)
                            .font(.system(size: 16))
                            .onChange(of: cvv) { _, newValue in
                                cvv = String(newValue.filter { $0.isNumber }.prefix(3))
                            }
                    }
                    .padding(14)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                    .frame(width: 100)
                }
            }
        }
    }
    
    // MARK: - Stars Payment
    private var starsPaymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pay with Stars")
                .font(.system(size: 17, weight: .bold))
            
            HStack(spacing: 14) {
                Image(systemName: "star.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color("BrewGold"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.totalStars) Stars Available")
                        .font(.system(size: 16, weight: .bold))
                    
                    let requiredStars = Int(viewModel.cartTotal * 100)
                    let canPay = viewModel.totalStars >= requiredStars
                    
                    Text(canPay ? "✅ Enough stars!" : "❌ Need \(requiredStars - viewModel.totalStars) more stars")
                        .font(.system(size: 13))
                        .foregroundColor(canPay ? Color("BrewGreen") : .red)
                }
                Spacer()
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        }
    }
    
    // MARK: - Place Order Button
    private var placeOrderButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 1)
            
            Button {
                placeOrder()
            } label: {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.9)
                        Text("Processing...")
                            .font(.system(size: 17, weight: .semibold))
                    } else {
                        Text("Place Order")
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Text(String(format: "€%.2f", viewModel.cartTotal))
                            .font(.system(size: 17, weight: .bold))
                    }
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
                .animation(.easeInOut, value: isProcessing)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Order Success
    private var orderSuccessView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color("BrewGreen").opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(Color("BrewGreen"))
            }
            
            VStack(spacing: 8) {
                Text("Order Placed!")
                    .font(.system(size: 28, weight: .bold))
                Text("Your order is being prepared ☕")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            
            // Sıra numarası
            VStack(spacing: 6) {
                Text("Order Number")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Text("#\(orderNumber)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("BrewGreen"))
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color("BrewGreen").opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 40)
            
            Text("Hey Can, your order will be ready shortly!\nPlease show this number at the counter.")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(Color("BrewGold"))
                Text("+\(earnedStarsCount) stars earned!")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color("BrewGold"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color("BrewGold").opacity(0.1))
            .clipShape(Capsule())
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Back to Menu")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("BrewGreen"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Place Order Logic
    private func placeOrder() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        orderNumber = String(format: "%04d", Int.random(in: 1000...9999))
        earnedStarsCount = viewModel.cartItems.reduce(0) { $0 + $1.drink.starPoints * $1.quantity }
        
        withAnimation { isProcessing = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring()) {
                if selectedPayment == .stars {
                    let requiredStars = Int(viewModel.cartTotal * 100)
                    viewModel.totalStars -= requiredStars
                } else {
                    viewModel.totalStars += earnedStarsCount
                }
                viewModel.cartItems.removeAll()
                isProcessing = false
                orderPlaced = true
            }
        }
    }
}

#Preview {
    PaymentView()
        .environmentObject(AppViewModel())
}
