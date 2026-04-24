//
//  HomeView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            VStack{
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        EmptyView()
                    }
                    label:{
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .navigationTitle("Minha Coleção")
        }
    }
}

#Preview {
    HomeView()
}
