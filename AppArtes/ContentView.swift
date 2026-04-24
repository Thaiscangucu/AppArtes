import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isShowingSheet = false
    
    var body: some View {
        // O ZStack permite colocar o botão flutuante exatamente no centro da TabBar
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                
                Text("Loja View")
                    .tabItem {
                        Image(systemName: "bag.fill")
                    }
                    .tag(1)
                Text("")
                    .tabItem {
                    }
                    .tag(2)
                
                Text("Galeria View")
                    .tabItem {
                        Image(systemName: "photo.artframe")
                        
                    }
                    .tag(3)
                
                Text("Perfil View")
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(4)
            }
            
            Button {
                isShowingSheet.toggle()
            } label: {
                // aumentar o tamanho da area de clique deste botao
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .background(Circle().fill(Color.clear))
            }
            .offset(y: -10)

        }

        .sheet(isPresented: $isShowingSheet) {
            NewItem()
        }
    }
}

#Preview{
    ContentView()
}
