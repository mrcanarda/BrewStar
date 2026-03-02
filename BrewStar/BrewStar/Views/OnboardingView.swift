import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
   
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Sayfa içeriği
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "cup.and.saucer.fill",
                        title: "Welcome to BrewStar",
                        description: "Your favorite coffee, ordered in seconds. Pick your drink, customize it, and we'll handle the rest.",
                        tag: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "star.fill",
                        title: "Earn Stars",
                        description: "Every order earns you stars. Collect enough and redeem them for free drinks. The more you order, the more you save!",
                        tag: 1
                    )
                    .tag(1)
                    OnboardingPage(
                        icon: "creditcard.fill",
                        title: "Easy Payment",
                        description: "Pay with your credit card, Apple Pay, or use your stars. Checkout is fast, secure, and always rewarding.",
                        tag: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Alt kısım — dots + buton
                VStack(spacing: 32) {
                    // Dots
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    // Buton
                    Button {
                        if currentPage < 2 {
                               currentPage += 1
                           } else {
                            withAnimation(.easeInOut) {
                                hasSeenOnboarding = true
                            }
                        }
                    } label: {
                        HStack {
                            Text(currentPage < 2 ? "Next" : "Get Started")
                                .font(.system(size: 17, weight: .semibold))
                            if currentPage < 2 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            } else {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .foregroundColor(buttonTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 32)
                    
                    // Skip butonu
                    if currentPage < 2 {
                        Button {
                            withAnimation(.easeInOut) {
                                hasSeenOnboarding = true
                            }
                        } label: {
                            Text("Skip")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    } else {
                        Color.clear.frame(height: 20)
                    }
                }
                .padding(.bottom, 48)
            }
        }
    }
    
    // Sayfaya göre arka plan rengi
    private var backgroundColor: Color {
        switch currentPage {
        case 0: return Color("BrewGreen")
        case 1: return Color("BrewGold")
        case 2: return Color("BrewGreenDark")
        default: return Color("BrewGreen")
        }
    }
    
    // Sayfaya göre buton yazı rengi
    private var buttonTextColor: Color {
        switch currentPage {
        case 1: return Color("BrewGold")
        default: return Color("BrewGreen")
        }
    }
}

// MARK: - OnboardingPage
struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let tag: Int
    
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // İkon
            ZStack {
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            .scaleEffect(appeared ? 1.0 : 0.5)
            .opacity(appeared ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: appeared)
            
            // Yazı
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            .offset(y: appeared ? 0 : 30)
            .opacity(appeared ? 1.0 : 0.0)
            .animation(.spring(response: 0.6).delay(0.2), value: appeared)
            
            Spacer()
            Spacer()
        }
        .tag(tag)
        .onAppear {
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                appeared = true
            }
        }
        .onDisappear { appeared = false }
    }
}

#Preview {
    OnboardingView()
}
