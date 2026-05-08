//
//  Sheet.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI
import UIKit

struct NewItem: View {
    @Environment(\.dismiss) var dismiss
    var formItems = ["Título", "Descrição", "Artista", "Data de criação"]
    @State private var formData: [String: String] = [:]
    
    @State private var selectedImage: UIImage?
    @State private var showDialog = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    
    var body: some View {
        NavigationStack{
            VStack{
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            showDialog = true
                        }
                } else {
            
                    Button(action: {
                        showDialog = true
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                        }
                        .frame(width: 200, height: 200)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                Form {
                    ForEach(formItems, id: \.self) { item in
                        TextField(item, text: Binding(
                            get: { formData[item, default: ""] },
                            set: { formData[item] = $0 }
                        ))
                    }
                }
                .scrollContentBackground(.hidden) 
                
            }
            .navigationTitle("Novo item")
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
                        
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .confirmationDialog("Escolha uma opção", isPresented: $showDialog, titleVisibility: .visible) {
                Button("Câmera") {
                    sourceType = .camera
                    showImagePicker = true
                }
                Button("Galeria") {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("Cancelar", role: .cancel) {}
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                    .ignoresSafeArea()
            }
        }
    }
}



#Preview {
    NewItem()
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
