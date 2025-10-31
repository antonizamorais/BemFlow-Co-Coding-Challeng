//
//  CustomHeaderView.swift
//  flow_v2
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct CustomHeaderView: View {
    // Propriedades para título e subtítulo dinâmicos
    let title: String
    let subtitle: String
    
    // Altura fixa para uso na MainTabView
    static let headerHeight: CGFloat = 180
    
    var body: some View {
        VStack(spacing: 8) {
            
            //Logo Fixa
            Image("logoapp")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60) // Ajuste o tamanho para ser visível no cabeçalho
                //.clipShape(Circle()) // Para dar um formato circular ao logo
                .shadow(radius: 5)
                .padding(.top, 40) // Espaço para a barra de status
            
            // Título Dinâmico
            Text(title)
                .font(.title).bold()
                .foregroundColor(.black)
            
            // Subtítulo Dinâmico
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.8))
                .padding(.bottom, 15)
        }
        .frame(maxWidth: .infinity)
        // Gradiente em tons de Azul/Turquesa
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.4, green: 0.7, blue: 0.95),  // Azul claro
                Color(red: 0.1, green: 0.5, blue: 0.75)   // Azul escuro (Turquesa)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .frame(height: CustomHeaderView.headerHeight)
    }
}
