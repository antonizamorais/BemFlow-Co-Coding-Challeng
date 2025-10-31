//
//  RelatorioProfissionalPreviewView.swift
//  flow_v2
//
//  Created by user on 29/10/25.
//

import SwiftUI

// Arquivo: RelatorioProfissionalPreviewView.swift

struct RelatorioProfissionalPreviewView: View {
    
    let relatorio: RelatorioProfissionalData
    
    @State private var isSharingPDF = false
    @State private var pdfData: Data? = nil
    
    // MARK: - CONTEÚDO QUE SERÁ EXPORTADO PARA PDF
    /// Esta propriedade computada contém apenas o layout do relatório, excluindo botões.
    var relatorioContent: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            // Título Principal
            HStack {
                //Image(systemName: "doc.text.magnifyingglass")
                    //.foregroundColor(.blue)
                Text("Relatório Profissional Detalhado")
                    .font(.title).bold() // Título um pouco maior para o PDF
            }
            .padding(.bottom, 10)
            
            // MARK: - SEÇÃO 1: RESUMO GERAL
            VStack(alignment: .leading, spacing: 10) {
                Text("Resumo Geral").font(.headline).foregroundColor(.primary)
                
                // Cards de Resumo (Reutilizando a lógica dos cards amigáveis/resumidos)
                RelatorioResumoCards(relatorio: relatorio.relatorioResumo)
            }
            
            // MARK: - SEÇÃO 2: GRÁFICOS (Detalhe Adicional)
            VStack(alignment: .leading, spacing: 10) {
                Text("Análise Gráfica (Placeholder)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Lista de gráficos (placeholders visuais)
                ForEach(relatorio.graficos, id: \.self) { grafico in
                    VStack(alignment: .leading) {
                        Text(grafico)
                            .font(.subheadline).bold()
                        // Placeholder visual para um gráfico no PDF
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 150)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(40) // Margens
            .background(Color.white)
                
            // Apenas garantimos que o VSTACK interno pode se expandir,
            // mas sem limitar o tamanho total do conteúdo
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - SEÇÃO 3: REGISTROS DETALHADOS
            VStack(alignment: .leading, spacing: 15) {
                Text("Registros Selecionados (\(relatorio.registros.count))")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Exibe os Registros Detalhados
                ForEach(relatorio.registros) { registro in
                    // **IMPORTANTE**: Você precisa ter a RegistroCardView do histórico implementada.
                    RegistroCardView(registro: registro)
                }
            }
            
        }
        .padding(30) // Padding maior para margens do PDF
        // Largura A4 padrão. Essencial para que o renderizador de PDF saiba o tamanho.
        //.frame(width: 595.2)
        //.background(Color.white) // Fundo branco para garantir a cor no PDF
    }
    
    // MARK: - BODY PRINCIPAL DA VIEW
    var body: some View {
        ScrollView {
            
            // Exibe o conteúdo do relatório
            relatorioContent
                .padding(.vertical) // Adiciona um padding vertical na visualização da tela
            
            // MARK: - OPÇÕES DE COMPARTILHAMENTO (APARECEM APENAS NA TELA, NÃO NO PDF)
            VStack(spacing: 15) {
                
                Button(action: { print("Gerar PDF para \(relatorioContent)") }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text("Gerar PDF Detalhado")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // Botão "Gerar PDF Detalhado"
                /*Button(action: {
                    // Cria o PDF usando Core Graphics
                    let pdfCreator = RelatorioPDFCreator(relatorio: relatorio)
                    
                    if let pdf = pdfCreator.createRelatorioPDF() {
                        self.pdfData = pdf
                        self.isSharingPDF = true
                    } else {
                        print("Falha ao gerar PDF.")
                    }
                }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text("Gerar PDF Detalhado")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } */
                
                // Botão "Enviar por Email"
                Button(action: { /* Implementação de envio de Email */ }) {
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
            .padding(.horizontal)
            .padding(.bottom, 20)
            
        }
        .navigationTitle("Pré-visualização do Relatório")
        
        // Exibe a Folha de Compartilhamento do iOS
        .sheet(isPresented: $isSharingPDF) {
            if let data = pdfData {
                ActivityViewController(activityItems: [data])
            }
        }
    }
}


// Componente auxiliar para exibir os cards de resumo de forma consistente
struct RelatorioResumoCards: View {
    let relatorio: RelatorioData
    
    var body: some View {
        VStack(spacing: 10) {
            // CARD 1: PERÍODO E REGISTROS
            VStack(alignment: .leading) {
                Text("Período: \(relatorio.periodo)").font(.subheadline).foregroundColor(.purple)
                Text("\(relatorio.totalRegistros) registros").font(.title3).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding().background(Color(red: 0.95, green: 0.90, blue: 1.0)).cornerRadius(10)
            
            // CARD 2: HUMOR MÉDIO
            VStack(alignment: .leading) {
                Text("Humor médio").font(.subheadline).foregroundColor(.green)
                Text(relatorio.humorMedio).font(.title3).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding().background(Color(red: 0.9, green: 1.0, blue: 0.9)).cornerRadius(10)
        }
    }
}


