//
//  MapaComunidadeView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

// Arquivo: MapaComunidadeView.swift

import SwiftUI
import SwiftData
import Foundation

// --- DICIONÁRIO DE EMOJIS E CORES PADRÃO ---
let emocaoMap: [String: (emoji: String, color: Color)] = [
    "Ansioso": ("😬", Color(red: 0.4, green: 0.7, blue: 1.0)),
    "Feliz": ("😄", Color(red: 0.3, green: 0.7, blue: 0.3)),
    "Triste": ("😔", Color(red: 0.6, green: 0.7, blue: 0.9)),
    "Cansado": ("😴", Color(red: 0.8, green: 0.6, blue: 0.4)),
    "Produtivo": ("💪", Color(red: 0.9, green: 0.8, blue: 0.1)),
    "Inspirado": ("✨", Color(red: 0.7, green: 0.4, blue: 0.7)),
    "Default": ("❓", .gray)
]

struct MapaComunidadeView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    // Consulta todos os registros (para cálculo das emoções da comunidade)
    // RegistroDiario deve ser acessível neste contexto
    @Query private var todosOsRegistros: [RegistroDiario]
    
    // Consulta as Dicas (Top 5), ordenadas por likes decrescente
    @Query(sort: [SortDescriptor(\Dica.likes, order: .reverse), SortDescriptor(\Dica.data, order: .reverse)])
    private var todasAsDicas: [Dica]

    @State private var mostrandoSheetDicas = false
    
    // 1. Ponto de persistência da lista de IDs curtidos (String no AppStorage)
    @AppStorage("liked_dica_ids") private var likedDicaIDsString: String = ""
    
    // 2. Estado em memória para rastrear os IDs curtidos (Set de UUIDs)
    @State private var likedDicaIDsSet: Set<UUID> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // ... (seu header e navegação de abas) ...
                
                // --- EMOÇÕES DA COMUNIDADE ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("Como a comunidade está se sentindo hoje?")
                        .font(.headline)
                        .foregroundColor(.black)
                    emocoesComunidadeGrid
                }
                .padding(.horizontal)
                
                // --- COMPARTILHE SUAS DICAS (CTA) ---
                HStack {
                    Text("Compartilhe suas dicas")
                        .font(.title3).bold()
                        .foregroundColor(.black)
                    Spacer()
                    Button("Compartilhar") {
                        mostrandoSheetDicas = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.8, green: 0.9, blue: 1.0))
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                // --- TOP DICAS DA SEMANA ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Top 5 Dicas Mais Úteis da Semana")
                        .font(.title3).bold()
                        .foregroundColor(.black)
                    topDicasList
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Mapa Social")
        .sheet(isPresented: $mostrandoSheetDicas) {
            DicaView() // Sua tela de cadastro de sugestões
        }
        .onAppear {
            // Inicializa o Set de IDs na primeira aparição da View
            if likedDicaIDsSet.isEmpty && !likedDicaIDsString.isEmpty {
                let idStrings = likedDicaIDsString.split(separator: ",").map { String($0) }
                let uuids = idStrings.compactMap { UUID(uuidString: $0) }
                likedDicaIDsSet = Set(uuids)
            }
        }
    }
    
    // MARK: - LÓGICA DE CÁLCULO E LAYOUT DA EMOÇÕES
    
    private var emocoesComunidadeGrid: some View {
        
        let totalRegistros = todosOsRegistros.count
        
        // CORREÇÃO do WARNING: 'var' trocado por 'let'
        let contagemEmocoes = todosOsRegistros.reduce(into: [String: Int]()) { counts, registro in
            // registro.emocaoPrincipal deve ser String
            counts[registro.emocaoPrincipal, default: 0] += 1
        }
        
        var todasAsEmocoesComContagem: [String: Int] = [:]
        
        for emocao in emocaoMap.keys where emocao != "Default" {
            todasAsEmocoesComContagem[emocao] = contagemEmocoes[emocao] ?? 0
        }

        let emocoesOrdenadas = todasAsEmocoesComContagem.sorted { $0.value > $1.value }
        let listaParaExibir = emocoesOrdenadas.prefix(6)
        
        guard !listaParaExibir.isEmpty else {
            return AnyView(Text("Ainda não há registros para calcular o mapa de emoções.").foregroundColor(.gray))
        }

        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

        return AnyView(LazyVGrid(columns: columns, spacing: 12) {
            
            ForEach(listaParaExibir, id: \.key) { (emocao, contagem) in
                let percentual = totalRegistros > 0 ? (Double(contagem) / Double(totalRegistros)) * 100 : 0
                let map = emocaoMap[emocao] ?? emocaoMap["Default"]!
                
                // SugestoesComunidadeView deve ser acessível
                NavigationLink(destination: SugestoesComunidadeView(emocaoSelecionada: emocao)) {
                    // CORREÇÃO: Alinhamento alterado para .center
                    VStack(alignment: .center, spacing: 8) {
                        
                        Text(map.emoji)
                            .font(.largeTitle)
                        
                        Text(emocao)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text(String(format: "%.0f%%", percentual))
                            .font(.title3).bold()
                            .foregroundColor(map.color)
                        
                        Text("\(contagem) pessoas")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(red: 0.95, green: 0.98, blue: 1.0))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(map.color.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        })
    }
    
    // MARK: - FUNÇÃO DE CURTIR DICA
    
    private func likeDica(_ dica: Dica) {
        // CORREÇÃO: dica.id é um UUID (não opcional)
        let dicaID = dica.id
        
        if likedDicaIDsSet.contains(dicaID) {
            return
        }

        // 1. Atualiza o contador e salva no SwiftData
        dica.likes += 1
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar o like no SwiftData: \(error.localizedDescription)")
            dica.likes -= 1
            return
        }
        
        // 2. Atualiza o registro de likes NO ESTADO e persistência
        likedDicaIDsSet.insert(dicaID)
        // Salva TODOS os IDs curtidos na String do AppStorage
        likedDicaIDsString = likedDicaIDsSet.map { $0.uuidString }.joined(separator: ",")
    }

    // MARK: - LAYOUT DA LISTA DE DICAS
    
    private var topDicasList: some View {
        VStack(spacing: 10) {
            if todasAsDicas.isEmpty {
                Text("Nenhuma dica compartilhada ainda. Seja o primeiro!").foregroundColor(.gray)
            } else {
                // Iteramos sobre as 5 primeiras dicas
                ForEach(Array(todasAsDicas.prefix(5).enumerated()), id: \.element.id) { index, dica in
                    
                    // CORREÇÃO: isLiked é uma verificação direta no Set<UUID>
                    let isLiked = likedDicaIDsSet.contains(dica.id)
                    
                    HStack {
                        // Ícone da Posição
                        Text("\(index + 1)º")
                            .font(.caption).bold()
                            .padding(6)
                            .background(index < 3 ? .yellow.opacity(0.3) : .gray.opacity(0.3))
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading) {
                             Text(dica.conteudo)
                                .lineLimit(1)
                                .bold()
                                .foregroundColor(.black)
                            
                            // Metadados
                            Text("Para: \(dica.emocao) • Por Anônimo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // --- BOTÃO DE CURTIR INTERATIVO ---
                        Button {
                            withAnimation {
                                likeDica(dica)
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                                Text("\(dica.likes)")
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(isLiked)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
        }
    }
}

#Preview {
    MapaComunidadeView()
}
