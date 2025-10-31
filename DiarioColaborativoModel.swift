//
//  DiarioColaborativoModel.swift
//  flow_v2
//
//  Created by user on 30/10/25.
//

// Arquivo: DiarioColaborativoModel.swift
import Foundation
import SwiftData
import SwiftUI // Necessário para UIImage/Data (imagens)

// MARK: - 1. MODELO DE ENTRADA (REGISTRO DENTRO DO DIÁRIO)

@Model
final class EntradaDiario {
    var id = UUID()
    var autor: String = "Anônimo" // No app final, use o AppUser logado
    var data: Date
    var titulo: String // Ex: "Aniversário da Vovó"
    var texto: String  // Descrição ou pensamentos
    var emocao: String // Emoji/Humor
    var tags: [String] // Ex: ["#familia", "#celebracao"]
    var imageData: Data? // Para anexar imagens
    var curtidas: Int = 0 // Simples contador de likes
    
    // Propriedade para ligar a Entrada de volta ao seu Diário
    var diarioPai: DiarioColaborativo?
    
    init(autor: String, data: Date, titulo: String, texto: String, emocao: String, tags: [String] = [], imageData: Data? = nil) {
        self.autor = autor
        self.data = data
        self.titulo = titulo
        self.texto = texto
        self.emocao = emocao
        self.tags = tags
        self.imageData = imageData
    }
}


// MARK: - 2. MODELO DE DIÁRIO (O CONTAINER)

@Model
final class DiarioColaborativo {
    var id = UUID()
    var nome: String // Ex: "Família Silva - 2024"
    var descricao: String
    var tipoPrivacidade: String // Ex: "Privado"
    
    // Relações:
    // Lista de usuários participando (simulada por enquanto)
    var membros: [String] = ["Eu", "J"] // Simulação de membros
    
    // Entradas/Registros dentro deste diário
    @Relationship(deleteRule: .cascade, inverse: \EntradaDiario.diarioPai)
    var entradas: [EntradaDiario] = []
    

    init(nome: String, descricao: String, tipoPrivacidade: String) {
        self.nome = nome
        self.descricao = descricao
        self.tipoPrivacidade = tipoPrivacidade
    }
}
