//
//  AppArtesTests.swift
//  AppArtesTests
//
//  Created by Thais Cangucu on 10/04/26.
//

import Testing
import Foundation
@testable import AppArtes

@Suite("Testes da Classe Exposicao")

@MainActor
struct ExposicaoTests {
    
    let sut: Exposicao
    
    init() {
        self.sut = Exposicao(
            titulo: "Arte Moderna 2026",
            local: "Museu Digital",
            dataInicio: Date()
        )
    }

    @Test("Adicionar uma obra aumenta a contagem na lista")
    func adicionarObra() async throws {
        // Given
        let novaObra = Obra(
            id: UUID(),
            nome: "Escultura Digital",
            descricao: "3D Scan",
            preco: 1500.0,
            dataCriacao: Date(),
            tema: "Futurismo"
        )
        
        // When
        sut.adicionarObra(novaObra)
        
        // Then
        #expect(sut.listaDeObras.count == 1)
        #expect(sut.listaDeObras.first?.nome == "Escultura Digital")
    }
    
    @Test("Remover uma obra por ID limpa a lista corretamente")
    func removerObra() async throws {
        // Given
        let idObra = UUID()
        let obra = Obra(id: idObra, nome: "Pintura Virtual", descricao: "VR", preco: 500.0, dataCriacao: Date(), tema: "Abstrato")
        sut.adicionarObra(obra)
        
        // When
        sut.removerObra(idObra: idObra)
        
        // Then
        #expect(sut.listaDeObras.isEmpty)
    }
    
    @Test("Cálculo do valor total deve somar os preços das obras")
    func calcularValorTotal() async throws {
        // Given
        let obra1 = Obra(id: UUID(), nome: "Obra 1", descricao: "D1", preco: 100.0, dataCriacao: Date(), tema: "T1")
        let obra2 = Obra(id: UUID(), nome: "Obra 2", descricao: "D2", preco: 250.50, dataCriacao: Date(), tema: "T2")
        
        // When
        sut.adicionarObra(obra1)
        sut.adicionarObra(obra2)
        
        // Then
        let valorEsperado = 350.50
        #expect(sut.calcularValorTotal() == valorEsperado)
    }
}
