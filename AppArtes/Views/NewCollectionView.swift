//
//  Sheet.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI

struct NewCollectionView: View {
    @Environment(\.dismiss) var dismiss
    var formItems = ["Título", "Descrição"]
    @State private var formData: [String: String] = [:]
    
    @State var taApertado = false
    var body: some View {
        NavigationStack{
            VStack{
                Button{
                    //open gallery// 3D scanner
                }
                label:{
                    Image("newCollection")
                        .resizable()
                        .frame(width: 217, height: 129)
                        .foregroundStyle(.gray)
                }
                Form {
                    ForEach(formItems, id: \.self) { item in
                        TextField(item, text: Binding(
                            get: { formData[item, default: ""] },
                            set: { formData[item] = $0 }
                        ))
                    }
                    Toggle("Tornar coleção público", isOn: $isEnabled)
                }
                .scrollContentBackground(.hidden) 
                
            }
            .navigationTitle("Nova coleção")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        //Create new item
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
        }
    }
}


#Preview {
    NewCollectionView()
}
