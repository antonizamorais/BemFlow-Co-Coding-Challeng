//
//  DataModels.swift
//  flow_v2
//
//  Created by user on 30/10/25.
//

// Arquivo: DataModels.swift
import Foundation
import SwiftUI

// MARK: - 1. ESTRUTURA BÁSICA DE RESUMO (Usada no RelatorioPreviewView)
// Esta é a estrutura simples que você usa na RelatorioPreviewView (resumo).
struct RelatorioData: Identifiable {
    let id = UUID()
    let periodo: String          // Ex: "Últimos 30 dias"
    let totalRegistros: Int
    let humorMedio: String       // Ex: "3.5/5.0"
    let emocaoPrincipal: String  // Ex: "Inspirado"
}

// MARK: - 2. ESTRUTURA DE REGISTRO INTERMEDIÁRIA (DTO)
// Este tipo é crucial para a lista de registros no relatório detalhado.
struct Registro: Identifiable {
    let id = UUID()
    
    // Os campos que o RelatorioPDFCreator e RegistroCardView esperam:
    let data: Date
    let humor: String               // Mapeia para RegistroDiario.emocaoPrincipal
    let descricao: String
    let tags: [String]
}

// MARK: - 3. ESTRUTURA COMPLETA DO RELATÓRIO PROFISSIONAL
// Usada no RelatorioProfissionalPreviewView
struct RelatorioProfissionalData: Identifiable {
    let id = UUID()
    // Reutiliza a estrutura de resumo
    let relatorioResumo: RelatorioData
    let graficos: [String]
    // Contém a lista que causou o erro original no PDF Creator
    let registros: [Registro]
}

// MARK: - 4. DADOS DE EXEMPLO (Para facilitar a visualização e teste)

let relatorioDeExemploSimples = RelatorioData(
    periodo: "Últimos 30 dias",
    totalRegistros: 15,
    humorMedio: "4.2/5.0",
    emocaoPrincipal: "Produtivo"
)

let relatorioProfissionalDeExemplo: RelatorioProfissionalData = {
    // ... (Definição dos dados de exemplo completos para o relatório profissional)
    // Usando a mesma lógica da resposta anterior
    let resumo = RelatorioData(
        periodo: "Últimos 30 dias",
        totalRegistros: 2,
        humorMedio: "4.0/5.0",
        emocaoPrincipal: "Produtivo"
    )
    let registrosDeExemplo: [Registro] = [
        Registro(data: Date(), humor: "Produtivo", descricao: "O projeto avançou muito hoje.", tags: ["#trabalho", "#foco"]),
    ]
    
    return RelatorioProfissionalData(
        relatorioResumo: resumo,
        graficos: ["Gráfico de Variação", "Gráfico de Impacto"],
        registros: registrosDeExemplo
    )
}()
