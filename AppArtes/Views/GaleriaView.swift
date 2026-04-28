//
//  GaleriaView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 27/04/26.
//

import SwiftUI

struct GaleriaView: View {
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationStack{
            VStack{
                
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
                NewCollectionView()
            }
        }
    }
}

#Preview {
    GaleriaView()
}
