//
//  PDFGenerator.swift
//  flow_v2
//
//  Created by user on 29/10/25.
//
import SwiftUI
import UIKit

// MARK: - FUNÇÃO PRINCIPAL DE GERAÇÃO DE PDF (Ajuste Final de Hierarquia)

/// Converte uma View SwiftUI em um objeto Data que representa o PDF.
/// - Parameter view: A View SwiftUI a ser renderizada.
/// - Returns: Dados brutos do PDF (Data) ou nil em caso de falha.
func generatePDF<Content: View>(view: Content) -> Data? {
    
    // 1. Configuração do Renderizador de UI
    let printPageRenderer = UIPrintPageRenderer()
    
    // Configura o tamanho da página (A4: 595.2 x 841.8)
    let paperRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    printPageRenderer.setValue(paperRect, forKey: "paperRect")
    printPageRenderer.setValue(paperRect, forKey: "printableRect")
    
    // 2. Criação e Configuração do Host/Controlador da SwiftUI
    let hostingController = UIHostingController(rootView: view)
    hostingController.view.frame = paperRect
    hostingController.view.backgroundColor = .clear

    // --- MANIPULAÇÃO CRÍTICA DA HIERARQUIA ---
    
    // Precisamos de um UIViewController raiz para anexar a View.
    // Usamos um controlador de visualização "pai" temporário (dummy) que não precisa ser visível.
    let rootVC = UIViewController()
    rootVC.view.frame = hostingController.view.bounds
    
    rootVC.addChild(hostingController)
    rootVC.view.addSubview(hostingController.view)
    hostingController.didMove(toParent: rootVC)

    // Força o ciclo de layout completo no controlador temporário.
    rootVC.view.setNeedsLayout()
    rootVC.view.layoutIfNeeded()
    
    // --- GERAÇÃO DO PDF ---
    
    // 3. Adiciona a View ao Renderizador
    printPageRenderer.addPrintFormatter(
        hostingController.view.viewPrintFormatter(),
        startingAtPageAt: 0
    )
    
    // 4. Renderização do PDF para Dados
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, printPageRenderer.paperRect, nil)
    
    for i in 0..<printPageRenderer.numberOfPages {
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
    }
    
    UIGraphicsEndPDFContext()
    
    // 5. Limpeza (Remove a View da hierarquia)
    hostingController.willMove(toParent: nil)
    hostingController.view.removeFromSuperview()
    hostingController.removeFromParent()
    
    return pdfData as Data
}
