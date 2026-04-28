//
//  GaleriaView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 27/04/26.
//

import SwiftUI

struct GaleriaView: View {
    @State private var isShowingSheet = false
    @State var collections: [String] = []
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    var body: some View {
        NavigationStack{
            ScrollView {
                // fix grid
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(collections, id: \.self) { item in
                        Rectangle()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        isShowingSheet.toggle()
                    }
                    label:{
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Coleções")
            
            .sheet(isPresented: $isShowingSheet) {
                NewCollectionView(collections: $collections)
            }
        }
    }
}

#Preview {
    GaleriaView()
}
