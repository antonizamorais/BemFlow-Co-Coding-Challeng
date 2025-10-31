//
//  ActivityViewController.swift
//  flow_v2
//
//  Created by user on 29/10/25.
//

import SwiftUI
import UIKit

// MARK: - WRAPPER DO UIKIT PARA SHARE SHEET

/// Uma View que empacota o UIActivityViewController (Folha de Compartilhamento nativa do iOS).
struct ActivityViewController: UIViewControllerRepresentable {
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nada a fazer aqui para este caso
    }
}
