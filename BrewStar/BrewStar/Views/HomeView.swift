//
//  HomeView.swift
//  BrewStar
//
//  Created by Can Arda on 24.02.26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    // Sepet sheet'ini kontrol eder
    @State private var showCart = false
    @State private var selectedDrink: Drink? = nil
    @State private var showToast = false
    @State private var toastDrinkName = ""
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    
                    starsBanner
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    searchBar
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    categorySection
                        .padding(.top, 20)
                    
                    drinksGrid
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                }
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            // Sepet sheet'i — CartView'ı modal olarak açar
            .sheet(isPresented: $showCart) {
                CartView()
                    .environmentObject(viewModel)
            }
            .sheet(item: $selectedDrink) { drink in
                DrinkDetailView(drink: drink)
                    .environmentObject(viewModel)
                
            }
            
            .overlay(alignment: .bottom) {
                if showToast {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("\(toastDrinkName) added to bag!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color("BrewGreen"))
                    .clipShape(Capsule())
                    .padding(.bottom, 32)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4), value: showToast)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color("BrewGreen"), Color("BrewGreen").opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Good Evening ☕")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Text("Can!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Cart button — showCart'ı true yapar
                    ZStack(alignment: .topTrailing) {
                        Button {
                            showCart = true
                        } label: {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        if viewModel.cartItemCount > 0 {
                            Text("\(viewModel.cartItemCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(Color("BrewGold"))
                                .clipShape(Circle())
                                .offset(x: 4, y: -4)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(.spring(), value: viewModel.cartItemCount)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 24)
            }
        }
        .clipShape(
            .rect(
                bottomLeadingRadius: 28,
                bottomTrailingRadius: 28
            )
        )
        .ignoresSafeArea(edges: .top)
    }
    
    // MARK: - Stars Banner
    private var starsBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .font(.system(size: 24))
                .foregroundColor(Color("BrewGold"))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(viewModel.totalStars) Stars")
                    .font(.system(size: 18, weight: .bold))
                Text(viewModel.totalStars >= 465 ? "🎉 Reward unlocked!" : "\(465 - viewModel.totalStars) stars until next reward!")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.userLevel)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color("BrewGold"))
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color("BrewGold"), Color("BrewGold").opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * min(Double(viewModel.totalStars) / 465.0, 1.0), height: 6)
                    }
                }
                .frame(width: 90, height: 8)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search drinks...", text: $viewModel.searchText)
                .font(.system(size: 15))
                .autocorrectionDisabled()
                 .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
        .animation(.easeInOut(duration: 0.2), value: viewModel.searchText.isEmpty)
    }
    
    // MARK: - Category Pills
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(DrinkCategory.allCases) { category in
                    CategoryPill(
                        category: category,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Drinks Grid
    private var drinksGrid: some View {
        Group {
            if viewModel.filteredDrinks.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "cup.and.saucer")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No drinks found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredDrinks) { drink in
                        DrinkCard(drink: drink) {
                            viewModel.addToCart(drink)
                            toastDrinkName = drink.name
                            withAnimation { showToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation { showToast = false }
                            }
                        }

                        .onTapGesture {
                            selectedDrink = drink
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppViewModel())
}
