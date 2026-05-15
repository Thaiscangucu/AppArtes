import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isShowingSheet = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                MarketplaceView()
                    .tabItem {
                        Image(systemName: "bag.fill")
                    }
                    .tag(1)
                CollectionsView()
                    .tabItem {
                        Image(systemName: "photo.artframe")
                    }
                    .tag(3) // Tag corrigida (antes tinha uma tag(2) duplicada aqui)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(4)
            }
        }
    }
}

// Preview simulando o contêiner 
#Preview {
    ContentView()
}
