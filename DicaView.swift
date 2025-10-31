//
//  DicaView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import SwiftUI
import SwiftData

// --- DICIONÁRIO DE EMOJIS E CORES PADRÃO (REPETIDO AQUI PARA FACILITAR) ---
// Idealmente, isso estaria em um arquivo de constantes ou extensão
let emocaoMapDica: [String: (emoji: String, color: Color)] = [
    "Ansiedade": ("😬", Color(red: 0.4, green: 0.7, blue: 1.0)),
    "Tristeza": ("😔", Color(red: 0.6, green: 0.7, blue: 0.9)),
    "Cansaço": ("😴", Color(red: 0.8, green: 0.6, blue: 0.4)),
    "Felicidade": ("😄", Color(red: 0.3, green: 0.7, blue: 0.3)),
    "Inspiração": ("✨", Color(red: 0.7, green: 0.4, blue: 0.7)),
    "Produtivo": ("💪", Color(red: 0.9, green: 0.8, blue: 0.1)),
    "Default": ("❓", .gray)
]

// Função auxiliar para buscar o emoji
func emojiParaEmocao(_ emocao: String?) -> String {
    guard let emocao = emocao else { return "" }
    return emocaoMapDica[emocao]?.emoji ?? emocaoMapDica["Default"]!.emoji
}

struct DicaView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var emocaoSelecionada: String? = nil
    @State private var conteudoDica: String = ""
    
    // Lista de emoções (Corrigida para usar as chaves do dicionário)
    let listaEmocoes = emocaoMapDica.keys.filter { $0 != "Default" }.sorted()
    
    private var isFormValid: Bool {
        emocaoSelecionada != nil && !conteudoDica.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - FUNÇÃO DE SALVAMENTO
    private func salvarDica() {
        // ... (A lógica de salvamento permanece a mesma) ...
        guard let emocao = emocaoSelecionada, isFormValid else { return }
        
        let novaDica = Dica(
            conteudo: conteudoDica.trimmingCharacters(in: .whitespacesAndNewlines),
            emocao: emocao,
            likes: 0,
            data: Date()
        )
        
        modelContext.insert(novaDica)
        
        do {
            try modelContext.save()
            print("Dica compartilhada com sucesso!")
            dismiss()
        } catch {
            print("Erro ao salvar a dica no SwiftData: \(error.localizedDescription)")
        }
    }
    
    // MARK: - BODY (LAYOUT VERTICAL COM EMOJI)
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // --- TÍTULO ---
                    HStack {
                        //Image(systemName: "sparkles")
                        Text("Compartilhe Suas Dicas")
                            .font(.title2).bold()
                    }
                    .foregroundColor(Color.primary)
                    
                    // MARK: - CAMPO DE SELEÇÃO DE EMOÇÃO (COM EMOJI)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Para qual emoção?")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Picker("Selecione uma emoção...", selection: $emocaoSelecionada) {
                            Text("Selecione uma emoção...").tag(nil as String?)
                            
                            ForEach(listaEmocoes, id: \.self) { emocao in
                                // >>> AQUI ESTÁ A MUDANÇA: Adiciona o emoji antes do nome da emoção
                                Text("\(emojiParaEmocao(emocao)) \(emocao)").tag(emocao as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    }

                    // MARK: - CAMPO DA DICA
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sua dica")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextEditor(text: $conteudoDica)
                            .frame(minHeight: 120, maxHeight: 250)
                            .overlay(alignment: .topLeading) {
                                if conteudoDica.isEmpty {
                                    Text("Ex: Respiração 4-7-8, caminhada de 10min...")
                                        .foregroundColor(Color(uiColor: .placeholderText))
                                        .padding(.horizontal, 4)
                                        .padding(.top, 8)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                    
                    Spacer()
                    
                    // MARK: - BOTÃO COMPARTILHAR
                    Button(action: salvarDica) {
                        Text("Compartilhar Dica")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.green : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                    
                }
                .padding()
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
