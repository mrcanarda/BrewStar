import SwiftUI

@main
struct BrewStarApp: App {
    @StateObject private var viewModel = AppViewModel()
    
    // @AppStorage: ilk açılış mı diye kontrol eder, telefonda kalıcı saklanır
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                HomeView()
                    .environmentObject(viewModel)
            } else {
                OnboardingView()
            }
        }
    }
}
