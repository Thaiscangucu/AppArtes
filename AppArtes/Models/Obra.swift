//
//  Obra.swift
//  AppArtes
//
//  Created by Thais Cangucu on 10/04/26.
//

import Foundation

@MainActor
class Obra {
    var id: UUID
    var nome: String
    var descricao: String
    var preco: Double
    var dataCriacao: Date
    var tema: String
    
    init(
        id: UUID = UUID(),
        nome: String,
        descricao: String,
        preco: Double,
        dataCriacao: Date,
        tema: String
    ) {
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.preco = preco
        self.dataCriacao = dataCriacao
        self.tema = tema
    }
}
