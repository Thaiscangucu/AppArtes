//
//  Exposicao.swift
//  AppArtes
//
//  Created by Thais Cangucu on 10/04/26.
//
// Isso é uma modificação

import Foundation

@MainActor
class Exposicao {
    var id: UUID
    var titulo: String
    var local: String
    var dataInicio: Date
    private(set) var listaDeObras: [Obra]
    
    init(id: UUID = UUID(), titulo: String, local: String, dataInicio: Date) {
        self.id = id
        self.titulo = titulo
        self.local = local
        self.dataInicio = dataInicio
        self.listaDeObras = []
    }
    
    /// Adiciona uma obra à exposição caso ela já não esteja presente.
    func adicionarObra(_ obra: Obra) {
        if !listaDeObras.contains(where: { $0.id == obra.id }) {
            listaDeObras.append(obra)
        }
    }
    
    /// Remove uma obra da exposição pelo ID.
    func removerObra(idObra: UUID) {
        listaDeObras.removeAll { $0.id == idObra }
    }
    
    /// Retorna o valor total das obras presentes na exposição.
    func calcularValorTotal() -> Double {
        return listaDeObras.reduce(0) { $0 + $1.preco }
    }
}
