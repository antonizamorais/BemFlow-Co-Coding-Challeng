//
//  CompartilhamentoView.swift
//  flow_v2
//
//  Created by user on 23/10/25.
//

// Arquivo: CompartilhamentoView.swift

import SwiftUI

// MARK: - ESTRUTURAS AUXILIARES

/// Define as opções que o usuário pode controlar no relatório.
struct ConfiguracoesRelatorio: Codable {
    var incluirTextosDetalhes: Bool = true
    var mostrarTagsEspecificas: Bool = true // Incluir tags como #trabalho, #familia
    var periodoSelecionado: String = "Últimos 3 meses" // Ex: Últimos 7 dias, Último mês, etc.
}

/// Define os dados de um Relatório (que será visualizado e compartilhado)
struct RelatorioData {
    let periodo: String
    let totalRegistros: Int
    let humorMedio: String // Ex: 3.5/5.0
    let emocaoPrincipal: String // Ex: Cansado
    // Aqui viriam a lista detalhada de emoções/tags/contextos...
}

// MARK: - DADOS MOCK (Exemplo de Relatório - baseado em image_4a4db8.png)
let relatorioDeExemplo = RelatorioData(
    periodo: "90 dias",
    totalRegistros: 4,
    humorMedio: "3.5/5.0",
    emocaoPrincipal: "Cansado"
)

// MARK: - ESTRUTURA PARA RELATÓRIO PROFISSIONAL DETALHADO
struct RelatorioProfissionalData {
    let relatorioResumo: RelatorioData // Dados resumidos (período, humor médio, etc.)
    let registros: [Registro] // Lista de registros detalhados (baseado nas configurações de privacidade)
    let graficos: [String] // Referências para gráficos (placeholders)
}

// MARK: - DADOS MOCK PARA RELATÓRIO PROFISSIONAL
let relatorioProfissionalDeExemplo = RelatorioProfissionalData(
    relatorioResumo: relatorioDeExemplo, // Usa o resumo já existente
    registros: registrosDeExemplo, // Lista completa dos registros de exemplo
    graficos: [
        "Variação do Humor (Últimos 3 meses)",
        "Frequência de Emoções",
        "Análise de Contextos (Tags)"
    ]
)

struct CompartilhamentoView: View {
    
    // Simula as configurações salvas pelo usuário
    @State private var configuracoesAtuais = ConfiguracoesRelatorio()

    var body: some View {
        // Envolve em uma NavigationView para permitir a navegação para a pré-visualização
        //NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // MARK: - LINK PARA CONFIGURAÇÕES DE PRIVACIDADE
                    NavigationLink(destination: ConfiguracoesPrivacidadeView(configuracoes: configuracoesAtuais)) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                            Text("Ajustar Configurações de Privacidade")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    
                    // MARK: - MODO PROFISSIONAL (Botão Azul/Roxo)
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "person.wave.2.fill") // Ícone de Terapeuta/Profissional
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        
                        Text("Compartilhar com Terapeuta")
                            .font(.title2).bold()
                        
                        Text("Gere um relatório detalhado para compartilhar com seu profissional de saúde mental.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Botão que leva à pré-visualização (sua sugestão implementada!)
                        NavigationLink(destination: RelatorioProfissionalPreviewView(relatorio: relatorioProfissionalDeExemplo)) {
                            Text("Gerar Relatório Profissional")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.9, green: 0.9, blue: 1.0)) // Fundo lilás claro
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                    
                    // MARK: - MODO AMIGÁVEL (Botão Verde)
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "person.3.fill") // Ícone de Amigo/Família
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.purple)

                        Text("Compartilhar com Amigo/Família")
                            .font(.title2).bold()
                        
                        Text("Crie um resumo amigável para compartilhar com pessoas próximas.")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        // Botão que leva à pré-visualização
                        NavigationLink(destination: RelatorioPreviewView(relatorio: relatorioDeExemplo, tipoRelatorio: "Amigável")) {
                            Text("Criar Resumo Amigável")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.9, green: 1.0, blue: 0.9)) // Fundo verde claro
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                }
                .padding(.vertical)
            }
            .navigationBarHidden(true) // Oculta o nav bar para ter um design clean
        //}
    }
}

#Preview {
    CompartilhamentoView()
}
