//
//  Sheet.swift
//  AppArtes
//
//  Created by Thais Cangucu.
//

import SwiftUI
import SwiftData
import UIKit
import AVFoundation
import Photos

struct NewItem: View {
    // 1. Recebe a coleção para a qual a obra está sendo adicionada
    var colecao: Colecao
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var formData: [String: String] = [:]
    
    @State private var selectedImage: UIImage?
    @State private var showDialog = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var title = ""
    @State var descricao = ""
    @State var data = Date.now
    @State var precoTexto = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                // Exibição da Imagem ou Botão de Adicionar
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            showDialog = true
                        }
                }
                else {
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
                
                // Formulário de dados
                Form {
                    TextField("Título", text: $title)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                    TextField("Descrição", text: $descricao)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                    DatePicker("Data de criação", selection: $data, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    TextField("Preço (R$)", text: $precoTexto)
                        .keyboardType(.decimalPad)
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
                        if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                            let preco = Double(precoTexto.replacingOccurrences(of: ",", with: "."))
                            let novaObra = ObraDeArte(
                                titulo: title,
                                descricao: descricao,
                                image: imageData,
                                dataCriacao: data,
                                preco: preco
                            )
                            
                            // 4. Salva a obra e CONECTA na coleção
                            context.insert(novaObra)
                            colecao.obras.append(novaObra)
                            
                            dismiss()
                        }
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    // Só permite salvar se tiver imagem e título
                    .disabled(title.isEmpty || selectedImage == nil)
                }
            }
            .confirmationDialog("Escolha uma opção", isPresented: $showDialog, titleVisibility: .visible) {
                
                Button("Câmera") {
                    checkCameraPermission()
                    sourceType = .camera
                    showImagePicker = true
                }
                Button("Galeria") {
                    checkPhotoPermission()
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
    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            // Primeira vez: o sistema pedirá permissão automaticamente
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { print("Acesso concedido") }
            }
        case .denied, .restricted:
            // Usuário já negou antes: você pode mostrar um alerta sugerindo ir às Configurações
            print("Acesso negado")
        case .authorized:
            print("Acesso já autorizado")
        @unknown default:
            break
        }
    }
    func checkPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized { print("Acesso concedido") }
            }
        }
    }

}


// MARK: - Componente Nativo de Câmera/Galeria
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
