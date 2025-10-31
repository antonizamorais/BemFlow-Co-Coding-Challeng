//
//  RegistroView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import SwiftUI
import SwiftData

struct RegistroView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    // Estados para o formulário
    @State private var emocaoSelecionada: String = ""
    @State private var descricaoDia: String = ""
    @State private var tagsSelecionadas: [String] = []
    @State private var novaTag: String = "" // Para o campo "Criar nova tag"
    
    // Mapeamento de emoções para emojis (conforme seu design)
    let emocoesComEmojis: [String: String] = [
        "Feliz": "😄",
        "Ansioso": "😟",
        "Cansado": "😴",
        "Produtivo": "💪",
        "Triste": "😔",
        "Inspirado": "✨"
    ]
    
    let tagsSugeridas = ["trabalho", "família", "saúde", "exercício", "estudo", "meditação"]
    
    var isFormValid: Bool {
        // O formulário é válido se uma emoção foi selecionada
        !emocaoSelecionada.isEmpty
    }

    var body: some View {
        //NavigationView {
            VStack(spacing: 0) { // VStack para empilhar ScrollView e Botão

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Título principal
                        Text("Como você está se sentindo hoje?")
                            .font(.title2).bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 10)
                        
                        // MARK: - SELEÇÃO DE EMOÇÃO (Cards com Emojis)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Escolha sua emoção principal:")
                                .font(.headline)
                            
                            // GRID DE EMOÇÕES (Cards com Emojis) - 3 colunas
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
                                ForEach(emocoesComEmojis.keys.sorted(), id: \.self) { emotion in // .sorted() para ordem consistente
                                    TagItemEmocao(
                                        emoji: emocoesComEmojis[emotion] ?? "❓", // Pega o emoji do dicionário
                                        text: emotion,
                                        isSelected: emocaoSelecionada == emotion
                                    ) {
                                        emocaoSelecionada = emotion
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // MARK: - DESCRIÇÃO DO DIA
                        VStack(alignment: .leading) {
                            Text("Conte-nos mais sobre seu dia:")
                                .font(.headline)
                            
                            TextEditor(text: $descricaoDia)
                                .frame(height: 150)
                                .overlay( // Usar overlay para o placeholder
                                    Group {
                                        if descricaoDia.isEmpty {
                                            Text("O que aconteceu hoje? Qual foi o ponto alto ou baixo do dia?")
                                                .foregroundColor(Color(.placeholderText))
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 8)
                                        }
                                    }
                                    .allowsHitTesting(false),
                                    alignment: .topLeading
                                )
                                .padding(5) // Padding interno para o TextEditor
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 20)
                        
                        // MARK: - SELEÇÃO DE TAGS
                        VStack(alignment: .leading) {
                            Text("Tags do dia:")
                                .font(.headline)
                            
                            // Tags Sugeridas
                            FlowLayout(items: tagsSugeridas, itemSpacing: 8) { tag in
                                TagItem(
                                    text: "#\(tag)", // Adiciona o '#' nas tags sugeridas
                                    isSelected: tagsSelecionadas.contains(tag),
                                    action: { toggleTag(tag) }
                                )
                                .disabled(!tagsSelecionadas.contains(tag) && tagsSelecionadas.count >= 3) // Limite de 3
                            }
                            
                            // Campo para criar nova tag e botão "Adicionar" (conforme design)
                            HStack {
                                TextField("Criar nova tag...", text: $novaTag)
                                    .textFieldStyle(.roundedBorder)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never) // Tags geralmente são minúsculas
                                
                                Button("Adicionar") {
                                    if !novaTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        let cleanTag = novaTag.lowercased().replacingOccurrences(of: " ", with: "")
                                        if !tagsSelecionadas.contains(cleanTag) && tagsSelecionadas.count < 3 {
                                            tagsSelecionadas.append(cleanTag)
                                            novaTag = "" // Limpa o campo após adicionar
                                        }
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple) // Cor roxa para o botão "Adicionar"
                                .disabled(novaTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || tagsSelecionadas.count >= 3)
                            }
                            .padding(.top, 10)

                            
                        }
                        .padding(.bottom, 20)
                        Spacer().frame(height: 120)
                    }
                    .padding()
                    
                }
                
                // MARK: - BOTÃO DE SALVAR REGISTRO (Corpo e Estilo Final)
                Button(action: salvarRegistro) {
                    Text("Salvar Registro") // Texto atualizado
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
                //.disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 20) // Espaço para a Safe Area inferior
            } // Fim do VStack principal
            .navigationTitle("") // Remove o título padrão
            .navigationBarTitleDisplayMode(.inline) // Para um controle mais preciso
            //.toolbar {
              //  ToolbarItem(placement: .navigationBarLeading) {
                //    Button("Cancelar") { dismiss() }
                  //      .foregroundColor(.blue) // Cor azul para o botão Cancelar
               // }
           // }
        //}
    }
    
    // MARK: - Funções Auxiliares
    
    private func toggleTag(_ tag: String) {
        if let index = tagsSelecionadas.firstIndex(of: tag) {
            tagsSelecionadas.remove(at: index)
        } else {
            if tagsSelecionadas.count < 3 {
                tagsSelecionadas.append(tag)
            } else {
                print("Limite de 3 tags atingido.")
            }
        }
    }
    
    private func salvarRegistro() {
        let novoRegistro = RegistroDiario(
            data: Date(),
            emocaoPrincipal: emocaoSelecionada,
            descricao: descricaoDia,
            tags: tagsSelecionadas
        )
        
        modelContext.insert(novoRegistro)
        
        do {
            try modelContext.save()
        } catch {
            print("ERRO ao salvar o registro diário: \(error.localizedDescription)")
            return
        }

        dismiss()
    }
}

// MARK: - ESTRUTURA AUXILIAR TagItemEmocao (Card de seleção de humor com Emoji)
// Mantida aqui por ser específica desta View
struct TagItemEmocao: View {
    let emoji: String // Novo campo para o emoji
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text(emoji) // O emoji
                    .font(.largeTitle)
                Text(text)  // O texto da emoção
                    .font(.caption).bold()
            }
            .frame(maxWidth: .infinity, minHeight: 80) // Ajuste de tamanho
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.white) // Fundo branco quando não selecionado
            .foregroundColor(isSelected ? .blue : .black)
            .cornerRadius(12) // Borda mais suave
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1), radius: 4, x: 0, y: 2) // Sombra
        }
        .buttonStyle(.plain) // Remove o estilo padrão do botão
    }
}
