//
//  HomeView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI

struct CollectionView: View {
    @State private var selectedTab = 0
    @State private var isShowingSheet = false
    var items: [PostItem] = [PostItem(height: CGFloat.random(in: 150...300))]
    var body: some View {
        NavigationStack{
            ZStack{
                MasonryGrid(items: items, columns: 2, spacing: 12) { item in
                    RoundedRectangle(cornerRadius: 3)
                        .frame(height: item.height)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $isShowingSheet) {
                NewItem()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //setting button
                    }
                    label:{
                        Image(systemName: "ellipsis")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        // aumentar o tamanho da area de clique deste botao
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .background(Circle().fill(Color.clear))
                    }                }
            }
            .navigationTitle("Minha Coleção")
            
        }
    }
}

#Preview {
    CollectionView()
}
