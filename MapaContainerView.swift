//
//  MapaContainerView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import SwiftUI

// Enum para controlar qual aba está selecionada
enum MapaTipo: String, CaseIterable {
    case comunidade = "Mapa da Comunidade"
    case pessoal = "Meu Mapa Pessoal"
}

struct MapaContainerView: View {
    
    // Estado para controle do segmented control interno
    @State private var tipoSelecionado: MapaTipo = .comunidade
    
    var body: some View {
        // VStack sem o ZStack ou CustomHeaderView, pois eles estão na MainTabView
        VStack(spacing: 0) {
            
            // 1. CONTROLE DE ABAS (Segmented Control Customizado)
            cabecalhoDeAbas
            
            // 2. CONTEÚDO DA ABA SELECIONADA
            Group {
                if tipoSelecionado == .comunidade {
                    MapaComunidadeView()
                } else {
                    MapaPessoalView()
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
    
    // MARK: - Componente do Controle de Abas
    private var cabecalhoDeAbas: some View {
        HStack(spacing: 0) {
            ForEach(MapaTipo.allCases, id: \.self) { tipo in
                Button(action: {
                    withAnimation(.easeInOut) {
                        tipoSelecionado = tipo
                    }
                }) {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: tipo == .comunidade ? "globe.americas.fill" : "person.fill")
                                .font(.subheadline)
                            Text(tipo.rawValue)
                                .font(.subheadline)
                        }
                        .foregroundColor(tipoSelecionado == tipo ? .black : .gray)
                        
                        // Linha de destaque (Sublinhado)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(tipoSelecionado == tipo ? Color(red: 0.1, green: 0.5, blue: 0.75) : .clear)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 10)
        .background(Color.white) // Fundo branco para o controle
        .padding(.horizontal)
    }
}
