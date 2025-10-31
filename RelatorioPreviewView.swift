//
//  RelatorioPreviewView.swift
//  flow_v2
//
//  Created by user on 23/10/25.
//

import SwiftUI

// Arquivo: RelatorioPreviewView.swift

struct RelatorioPreviewView: View {
    let relatorio: RelatorioData
    let tipoRelatorio: String // "Profissional" ou "Amigável"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Título e Ícone (Relatório do Mês)
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.purple)
                    Text("Relatório do Mês")
                        .font(.title2).bold()
                }
                .padding(.bottom, 10)
                
                // MARK: - CARD 1: PERÍODO E REGISTROS
                VStack(alignment: .leading) {
                    Text("Período: \(relatorio.periodo)")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                    Text("\(relatorio.totalRegistros) registros")
                        .font(.title).bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 0.95, green: 0.90, blue: 1.0)) // Roxo claro
                .cornerRadius(10)
                
                // MARK: - CARD 2: HUMOR MÉDIO
                VStack(alignment: .leading) {
                    Text("Humor médio")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text(relatorio.humorMedio)
                        .font(.title).bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 0.9, green: 1.0, blue: 0.9)) // Verde claro
                .cornerRadius(10)
                
                // MARK: - CARD 3: EMOÇÃO PRINCIPAL
                VStack(alignment: .leading) {
                    Text("Emoção principal")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    Text(relatorio.emocaoPrincipal)
                        .font(.title).bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 1.0, green: 0.95, blue: 0.8)) // Amarelo/Laranja claro
                .cornerRadius(10)

                // MARK: - OPÇÕES DE COMPARTILHAMENTO
                
                // Botão "Gerar PDF" (Vermelho/Laranja)
                Button(action: { print("Gerar PDF para \(tipoRelatorio)") }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text("Gerar PDF")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // Botão "Enviar por Email" (Azul)
                Button(action: { print("Enviar por Email para \(tipoRelatorio)") }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Enviar por Email")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Pré-visualização do Relatório")
    }
}

