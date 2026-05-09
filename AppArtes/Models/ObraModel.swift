//
//  ObraModel.swift
//  AppArtes
//
//  Created by Thais Cangucu on 08/05/26.
//

import Foundation
import SwiftData

@Model
final class ObraDeArte {
    // A macro @Attribute(.unique) garante que não haverá duas obras com o mesmo ID
    @Attribute(.unique) var id: String
    var titulo: String
    var descricao: String
    var dataCriacao: Date
    
    // CORREÇÃO 1: Mudar de UIImage para Data e usar .externalStorage
    @Attribute(.externalStorage) var image: Data?
    
    var formatoArquivo: String
    
    init(
        id: String = UUID().uuidString,
        titulo: String,
        descricao: String,
        image: Data? = nil, // CORREÇÃO 2: Receber Data no inicializador
        dataCriacao: Date = .now,
        formatoArquivo: String = "usdz" // Valor padrão definido conforme o diagrama
    ) {
        self.id = id
        self.titulo = titulo
        self.descricao = descricao
        self.dataCriacao = dataCriacao
        self.image = image
        self.formatoArquivo = formatoArquivo
    }
    
    func publicar() {
        // Lógica de publicação da obra de arte
        print("Obra \(titulo) publicada!")
    }
}
