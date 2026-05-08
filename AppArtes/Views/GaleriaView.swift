//
//  GaleriaView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 27/04/26.
//

import SwiftUI

struct GaleriaView: View {
    @State private var isShowingSheet = false
    @State var collections: [String] = ["title"]
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(collections, id: \.self) { item in
                    NavigationLink{
                        CollectionView()
                    }
                    label:{
                        VStack(alignment: .leading){
                            Text(item)
                                .bold()
                                .foregroundColor(.black)
                            HStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 156, height: 142)
                                    .background(.white)
                                VStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 144, height: 68)
                                        .background(.white)
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 144, height: 68)
                                        .background(.white)
                                }
                            }
                        }
                        .background{
                            Rectangle()
                                .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .frame(width: 350, height: 190)
                        }
                        .frame(width: 350, height: 190)
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

