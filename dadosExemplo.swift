//
//  dadosExemplo.swift
//  flow_v2
//
//  Created by user on 11/10/25.
//

import SwiftData
import Foundation

// Função para inserir dados de demonstração
func createSampleData(modelContext: ModelContext) {
    do {
        // Verifica se já existem dados
        let countRegistros = try modelContext.fetchCount(FetchDescriptor<RegistroDiario>())
        let countDicas = try modelContext.fetchCount(FetchDescriptor<Dica>())
        
        guard countRegistros == 0 && countDicas == 0 else {
            print("Dados de exemplo já existem. Pulando inserção.")
            return // Já existem dados, não insere novamente
        }
        
        print("Inserindo dados de exemplo...")

        // --- DADOS DE REGISTRO DIÁRIO ---
        let emocoes = ["Feliz", "Ansioso", "Cansado", "Produtivo", "Triste"]
        let tags = ["trabalho", "família", "saúde", "exercício", "estudo"]
        
        for i in 1...20 {
            let registro = RegistroDiario(
                data: Calendar.current.date(byAdding: .day, value: -i, to: Date())!,
                emocaoPrincipal: emocoes.randomElement()!,
                descricao: "Registro de demonstração do dia \(i).",
                tags: [tags.randomElement()!, tags.randomElement()!]
            )
            modelContext.insert(registro)
        }
        
        // --- DICAS COM LIKES DIFERENTES ---
        // [Conteúdo, Likes, Emoção]
        let dicas = [
            ("Técnica Pomodoro", 198, "Ansioso"),
            ("Compartilhar gratidão", 189, "Triste"),
            ("Conversar com alguém de confiança", 178, "Ansioso"),
            ("Cochilo de 20 minutos", 167, "Cansado"),
            ("Criar algo com as mãos", 167, "Produtivo"),
            ("Sair para caminhar", 150, "Feliz")
        ]
        
        for (conteudo, likes, emocao) in dicas {
            let dica = Dica(
                // 1. conteúdo (String)
                conteudo: conteudo,
                // 2. emocao (String)
                emocao: emocao,
                // 3. likes (Int)
                likes: likes,
                // 4. data (Date)
                data: Date()
            )
            modelContext.insert(dica)
        }
        
        // Salva os dados no banco
        try modelContext.save()
        print("Dados de exemplo inseridos com sucesso!")

    } catch {
        print("Erro ao inserir dados de exemplo: \(error)")
    }
}
