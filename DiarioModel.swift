//
//  DiarioModel.swift
//  flow_v2
//
//  Created by user on 30/10/25.
//

// Arquivo: DiarioModel.swift
import Foundation
import SwiftData

// MARK: - 1. MODELO DO DIÁRIO
@Model
final class DiarioColaborativo {
    var id = UUID()
    var nome: String             // Ex: "Família Silva - 2024"
    var descricao: String
    var tipoPrivacidade: String  // Ex: "Privado", "Público"
    var dataCriacao: Date
    
    // Relacionamento com o usuário criador (presumindo que AppUser existe)
    var criadorUsername: String?
    
    // Relacionamento com as Entradas (registros)
    @Relationship(deleteRule: .cascade)
    var entradas: [EntradaDiario]?
    
    // Relacionamento com membros (para futura implementação de convite)
    var membrosUsernames: [String] // Array de usernames dos membros
    
    init(nome: String, descricao: String, tipoPrivacidade: String, criadorUsername: String) {
        self.nome = nome
        self.descricao = descricao
        self.tipoPrivacidade = tipoPrivacidade
        self.dataCriacao = Date()
        self.criadorUsername = criadorUsername
        self.membrosUsernames = [criadorUsername] // O criador é sempre um membro
    }
}

// MARK: - 2. MODELO DA ENTRADA (O REGISTRO COM IMAGEM)
@Model
final class EntradaDiario {
    var id = UUID()
    var data: Date
    var autorUsername: String
    var emocao: String           // Ex: 😃, Alegria
    var texto: String            // Descrição ou Pensamento
    var tags: [String]           // Ex: ["#familia", "#celebração"]
    
    // Novo: Campo para armazenar a imagem como Data (binário)
    @Attribute(.allowsExternalStorage) // Sugere que a imagem seja armazenada fora do banco principal se for grande
    var imagemData: Data?
    
    // Relacionamento com o diário pai
    var diarioPai: DiarioColaborativo?
    
    init(data: Date, autorUsername: String, emocao: String, texto: String, tags: [String], imagemData: Data? = nil) {
        self.data = data
        self.autorUsername = autorUsername
        self.emocao = emocao
        self.texto = texto
        self.tags = tags
        self.imagemData = imagemData
    }
}
