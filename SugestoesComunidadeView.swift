//
//  SugestoesComunidadeView.swift
//  flow_v2
//
//  Created by user on 11/10/25.
//

import SwiftUI
import SwiftData

// --- DICIONÁRIO DE EMOJIS E CORES PADRÃO (REPETIDO AQUI PARA FACILITAR) ---
let emocaoMapSugestoes: [String: (emoji: String, color: Color)] = [
    "Ansioso": ("😬", Color(red: 0.4, green: 0.7, blue: 1.0)),
    "Feliz": ("😄", Color(red: 0.3, green: 0.7, blue: 0.3)),
    "Triste": ("😔", Color(red: 0.6, green: 0.7, blue: 0.9)),
    "Cansado": ("😴", Color(red: 0.8, green: 0.6, blue: 0.4)),
    "Produtivo": ("💪", Color(red: 0.9, green: 0.8, blue: 0.1)),
    "Inspirado": ("✨", Color(red: 0.7, green: 0.4, blue: 0.7)),
    "Default": ("❓", .gray)
]

// Assumindo a existência de RegistroDiario e Dica
// Assumindo a função 'emojiParaEmocao'

struct SugestoesComunidadeView: View {
    
    let emocaoSelecionada: String
    
    @Environment(\.modelContext) private var modelContext
    
    // Consulta para todos os registros (para calcular Contextos/Estatísticas)
    @Query private var todosOsRegistros: [RegistroDiario]
    
    // Consulta das Dicas (ordenadas por likes)
    @Query(sort: [SortDescriptor(\Dica.likes, order: .reverse), SortDescriptor(\Dica.data, order: .reverse)])
    private var todasAsDicas: [Dica]

    @State private var likedDicaIDsSet: Set<UUID> = []
    
    // MARK: - PROPRIEDADES COMPUTADAS
    
    private var corDaEmocao: Color {
        return emocaoMapSugestoes[emocaoSelecionada]?.color ?? .gray
    }
    
    private var emojiDaEmocao: String {
        return emocaoMapSugestoes[emocaoSelecionada]?.emoji ?? emocaoMapSugestoes["Default"]!.emoji
    }

    private var percentualEmocao: Double {
        let totalRegistros = todosOsRegistros.count
        guard totalRegistros > 0 else { return 0 }
        
        let contagem = todosOsRegistros.filter { $0.emocaoPrincipal == emocaoSelecionada }.count
        return (Double(contagem) / Double(totalRegistros)) * 100
    }
    
    private var topDicasFiltradas: [Dica] {
        return todasAsDicas
            .filter { $0.emocao == emocaoSelecionada }
            .prefix(5)
            .map { $0 }
    }
    
    // MARK: - FUNÇÃO DE INTERAÇÃO
    
    private func tryDica(_ dica: Dica) {
        let dicaID = dica.id
        if !likedDicaIDsSet.contains(dicaID) {
            likedDicaIDsSet.insert(dicaID)
        }
    }

    // MARK: - BODY
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // --- HEADER DE ESTATÍSTICA (NO TOPO) ---
                Text("\(emojiDaEmocao) \(emocaoSelecionada) - \(String(format: "%.0f%%", percentualEmocao)) da comunidade")
                    .font(.title2).bold()
                    .foregroundColor(corDaEmocao)
                    .padding(.top, 10)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("💡 Contextos Mais Comuns")
                        .font(.headline)
                        .foregroundColor(corDaEmocao)

                    // >>> CHAMADA DO SEU FLOWLAYOUT COM A TAG DE CONTEXTO
                    FlowLayout(items: ["trabalho", "prazo", "estudos", "família", "saúde", "exercício", "finanças"], itemSpacing: 8) { tag in
                        
                        Text("#\(tag)")
                            .font(.caption).bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            // A cor da tag de contexto na tela de sugestão é roxa (baseado no Anexo 2)
                            .background(Color.purple.opacity(0.2))
                            .foregroundColor(.purple)
                            .cornerRadius(15)
                            // ESSENCIAL: Impede que o texto dentro da tag quebre!
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    
                    if percentualEmocao == 0 {
                        Text("Ainda não há registros de tags para esta emoção.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                              
                
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading) // Garante a largura total
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                .shadow(radius: 2, x: 0, y: 1)

                
                // MARK: - 2. DICAS DA COMUNIDADE
                VStack(alignment: .leading, spacing: 15) {
                    Text("✨ Dicas da Comunidade")
                        .font(.headline)
                        .foregroundColor(corDaEmocao)
                    
                    dicasList // A sub-View com a lista de dicas
                    
                    if topDicasFiltradas.isEmpty {
                        Text("Nenhuma dica compartilhada para \(emocaoSelecionada) ainda.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading) // Garante a largura total
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                .shadow(radius: 2, x: 0, y: 1) // Sombra sutil
                
                Spacer()
            }
            .padding(.horizontal)
            .background(Color(red: 0.95, green: 0.98, blue: 1.0).edgesIgnoringSafeArea(.all)) // Fundo sutil

        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - SUB-VIEW LISTA DE DICAS
    private var dicasList: some View {
        VStack(spacing: 12) {
            ForEach(topDicasFiltradas, id: \.id) { dica in
                let isTried = likedDicaIDsSet.contains(dica.id)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(dica.conteudo)
                            .font(.subheadline).bold()
                            .foregroundColor(.black)
                        Text("Por Anônimo")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Likes
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(dica.likes)")
                            .font(.subheadline)
                    }
                    .padding(.trailing, 8)
                    
                    // Botão "Vou tentar"
                    Button(isTried ? "Tentada!" : "Vou tentar") {
                        tryDica(dica)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isTried ? corDaEmocao.opacity(0.8) : .green)
                    .disabled(isTried)
                }
                .padding()
                .background(corDaEmocao.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}


// MARK: - Placeholder para TagFlowLayoutView
// Substitua por sua implementação de FlowLayout
struct TagFlowLayoutView: View {
    let tags: [String]
    
    var body: some View {
        HStack { // Simulação de FlowLayout para este exemplo
            ForEach(tags.prefix(5), id: \.self) { tag in
                Text("#\(tag)")
                    .font(.caption).bold()
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

// Para usar no Preview:
/*
#Preview {
    // Você precisa passar uma emoção existente no seu mapa
    SugestoesComunidadeView(emocaoSelecionada: "Ansioso")
        .modelContainer(for: [Dica.self, RegistroDiario.self], inMemory: true)
}
*/
