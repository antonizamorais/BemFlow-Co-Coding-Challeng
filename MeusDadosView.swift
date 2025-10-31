//
//  MeusDadosView.swift
//  flow_v2
//
//  Created by user on 23/10/25.
//

import SwiftUI
import Charts // Necessário para gráficos

enum TabSelecionada: String {
    case analises = "Análises & Gráficos"
    case historico = "Histórico Completo"
}

struct MeusDadosView: View {
    
    // Estado para controlar qual aba está visível
    @State private var tabAtual: TabSelecionada = .analises
    
    // Lista de todas as tags e emoções disponíveis (Para uso nos filtros)
    // Você deve buscar estas listas dinamicamente ou usar uma lista estática de seu Constants.
    let todasAsEmocoes = ["Feliz", "Ansioso", "Cansado", "Produtivo", "Triste", "Inspirado"]
    let todasAsTags = ["trabalho", "saúde", "estudo", "exercício", "família"]
    
    var body: some View {
        //NavigationView {
            VStack(spacing: 0) {
                
                // MARK: - CONTROLE SEGMENTADO/ABAS (Customizado para imitar o design)
                HStack(spacing: 0) {
                    // Botão 1: Análises & Gráficos
                    TabViewItem(tabAtual: $tabAtual, tab: .analises)
                    // Botão 2: Histórico Completo
                    TabViewItem(tabAtual: $tabAtual, tab: .historico)
                }
                .frame(height: 40)
                .background(Color.white) // Fundo da barra de abas
                
                // MARK: - CONTEÚDO DA ABA SELECIONADA
                ScrollView {
                    VStack {
                        // Exibe a View correspondente à aba selecionada
                        if tabAtual == .analises {
                            AnalisesGraficosView()
                        } else {
                            // Passa as listas de opções para a view de histórico/filtros
                            HistoricoCompletoView()
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                }
                .background(Color(.systemGray6).edgesIgnoringSafeArea(.all)) // Fundo cinza claro
            }
            //.navigationTitle("Meus Dados")
        //}
    }
}

// MARK: - TabViewItem (Botão customizado para a navegação por abas)
struct TabViewItem: View {
    @Binding var tabAtual: TabSelecionada
    let tab: TabSelecionada
    
    // Mapeamento de ícones para dar o visual do anexo
    private var iconName: String {
        switch tab {
        case .analises:
            return "chart.bar.xaxis" // Gráfico de barras
        case .historico:
            return "list.bullet.rectangle" // Lista/Histórico
        }
    }

    var body: some View {
        Button(action: {
            tabAtual = tab
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: iconName)
                        // Cor do ícone
                        .foregroundColor(tabAtual == tab ? .blue : .gray)
                    Text(tab.rawValue)
                        .font(.subheadline)
                        // Cor do texto
                        .foregroundColor(tabAtual == tab ? .blue : .gray)
                }
                // Linha indicadora azul na aba selecionada
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(tabAtual == tab ? .blue : .clear)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(tabAtual == tab ? Color.white : Color(.systemGray5).opacity(0.3)) // Fundo ligeiramente diferente
        }
        .buttonStyle(.plain)
    }
}



#Preview {
    MeusDadosView()
}
