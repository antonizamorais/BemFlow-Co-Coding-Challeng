//
//  RelatorioPDFCreator.swift
//  flow_v2
//
//  Created by user on 30/10/25.
//

import UIKit
import Foundation
import SwiftUI // Necessário se você usar cores do SwiftUI

class RelatorioPDFCreator {
    
    let relatorio: RelatorioProfissionalData
    
    init(relatorio: RelatorioProfissionalData) {
        self.relatorio = relatorio
    }
    
    // Tamanho da página A4
    private let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // 72 DPI
    private let textMargin: CGFloat = 40
    private var cursorY: CGFloat = 40.0 // Posição atual do desenho vertical
    
    // MARK: - FUNÇÃO PRINCIPAL DE GERAÇÃO
    
    func createRelatorioPDF() -> Data? {
        let pdfData = NSMutableData()
        
        // Inicia o contexto de desenho do PDF
        UIGraphicsBeginPDFContextToData(pdfData, pageRect, nil)
        
        // Inicia a primeira página
        UIGraphicsBeginPDFPage()
        
        cursorY = textMargin // Reseta o cursor para o topo da página

        // 1. Desenha o Cabeçalho e Resumo
        drawHeader()
        
        // 2. Desenha a Seção de Gráficos (placeholders)
        drawSection(title: "Análise Gráfica (Placeholder)")
        drawGraphPlaceholders()
        
        // 3. Desenha a Seção de Registros Detalhados (que precisa de quebra de página)
        drawSection(title: "Registros Detalhados")
        drawDetailedRecords()
        
        // Finaliza o contexto
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }
    
    // MARK: - HELPERS DE DESENHO
    
    private func checkPageBreak(requiredHeight: CGFloat) {
        // Se a posição atual + a altura necessária ultrapassa o limite inferior (841.8 - margem)
        if cursorY + requiredHeight > pageRect.height - textMargin {
            UIGraphicsBeginPDFPage()
            cursorY = textMargin // Volta para o topo da nova página
        }
    }
    
    private func drawHeader() {
        // Título
        let titleText = "Relatório Profissional Detalhado"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.blue
        ]
        (titleText as NSString).draw(at: CGPoint(x: textMargin, y: cursorY), withAttributes: titleAttributes)
        cursorY += 40
        
        // Resumo (Período)
        let resumoText = "Período: \(relatorio.relatorioResumo.periodo) | Registros: \(relatorio.relatorioResumo.totalRegistros) | Humor Médio: \(relatorio.relatorioResumo.humorMedio)"
        let resumoAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        (resumoText as NSString).draw(at: CGPoint(x: textMargin, y: cursorY), withAttributes: resumoAttributes)
        cursorY += 30
    }
    
    private func drawSection(title: String) {
        checkPageBreak(requiredHeight: 30)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]
        (title as NSString).draw(at: CGPoint(x: textMargin, y: cursorY), withAttributes: attributes)
        cursorY += 25
    }
    
    private func drawGraphPlaceholders() {
        for graphName in relatorio.graficos {
            checkPageBreak(requiredHeight: 180)
            
            // Desenha o nome do gráfico
            (graphName as NSString).draw(at: CGPoint(x: textMargin, y: cursorY), withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
            cursorY += 20
            
            // Desenha um retângulo como placeholder do gráfico
            let rect = CGRect(x: textMargin, y: cursorY, width: pageRect.width - (2 * textMargin), height: 150)
            let path = UIBezierPath(rect: rect)
            UIColor(Color(.systemGray5)).setFill() // Usa a cor cinza do SwiftUI/UIKit
            path.fill()
            
            cursorY += 170
        }
    }
    
    private func drawDetailedRecords() {
        let maxLineWidth = pageRect.width - (2 * textMargin)
        
        for registro in relatorio.registros {
            // Calculo estimado da altura do registro (depende de RegistroCardView)
            // Aqui estamos apenas estimando o texto da descrição.
            let description = "Data: \(registro.data), Humor: \(registro.emocao), Tags: \(registro.tag)\nDescrição: \(registro.texto)"
            
            let estimatedHeight = description.height(withConstrainedWidth: maxLineWidth, font: UIFont.systemFont(ofSize: 12)) + 30
            
            checkPageBreak(requiredHeight: estimatedHeight)
            
            // Desenha a borda do "Card"
            let rect = CGRect(x: textMargin, y: cursorY, width: maxLineWidth, height: estimatedHeight)
            let path = UIBezierPath(rect: rect)
            UIColor(Color(.systemGray6)).setFill()
            path.fill()
            
            // Desenha o texto do registro dentro do "Card"
            (description as NSString).draw(in: rect.insetBy(dx: 10, dy: 10), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            
            cursorY += estimatedHeight + 10 // Adiciona um pequeno espaço entre os registros
        }
    }
}

// Extensão auxiliar para calcular a altura necessária do texto
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
