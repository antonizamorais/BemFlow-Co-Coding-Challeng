//
//  ContentView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import SwiftUI

struct MainTabView: View {
    // Usamos um @State para rastrear qual aba está ativa (por índice)
    @State private var selectedTab: Int = 0
    
    // Altura do cabeçalho
    let headerHeight: CGFloat = 180
    
    // Propriedade Computada para retornar o título e subtítulo da tela atual
    private var currentHeaderInfo: (title: String, subtitle: String) {
        switch selectedTab {
        case 0:
            return ("MAPA DA COMUNIDADE", "Descubra como a comunidade está se sentindo") // Mapa Container
        case 1:
            return ("REGISTRO DIÁRIO", "Conte-nos como foi o seu dia e suas emoções") // RegistroView
        case 2:
            return ("MEUS DADOS", "Sua jornada emocional e progresso pessoal") // Meus Dados/Mapa Pessoal
        case 3:
            return ("COMPARTILHAR", "Compartilhe seus registros de forma segura") // Compartilhar
        case 4:
            return ("DIÁRIO COLABORATIVO", "Crie e compartilhe diários com amigos, família ou grupos especiais") // Diário colaborativo
        default:
            return ("APP DE EMOÇÕES", "Sua jornada de autoconhecimento")
        }
    }
    
    var body: some View {
        // ZStack para sobrepor o cabeçalho fixo sobre a TabView rolável
        ZStack(alignment: .top) {
            
            // 1. CONTEÚDO PRINCIPAL
            TabView(selection: $selectedTab) { // Linka a seleção com o @State
                
                // Aba 1: Mapa Social/Comunidade
                NavigationStack {
                    MapaContainerView()
                }
                .tag(0) // Tag para controle
                .tabItem {
                    Label("Mapa Social", systemImage: "map")
                }

                // Aba 2: Registrar
                NavigationStack {
                    RegistroView()
                }
                .tag(1)
                .tabItem {
                    Label("Registrar", systemImage: "square.and.pencil")
                }
                
                // Aba 3: Meus Dados (Mapa Pessoal)
                NavigationStack {
                    MeusDadosView()
                }
                .tag(2)
                .tabItem {
                    Label("Meus Dados", systemImage: "person.crop.circle")
                }
                
                // Aba 4: Compartilhar
                NavigationStack {
                    CompartilhamentoView()
                }
                .tag(3) // Tag para controle
                .tabItem {
                    Label("Compartilhar", systemImage: "arrow.up.circle")
                }
                
                // Aba 5: Diário Colaborativo
                NavigationStack {
                    DiarioColaborativoView()
                }
                .tag(4)
                .tabItem {
                    Label("Diário Colaborativo", systemImage: "doc.text.image")
                }
            }
            // Padding Superior: Empurra o conteúdo da TabView para baixo do cabeçalho fixo
            .padding(.top, headerHeight)
            
            // 2. O CABEÇALHO FIXO E DINÂMICO
            CustomHeaderView(
                title: currentHeaderInfo.title,
                subtitle: currentHeaderInfo.subtitle
            )
        }
    }
}

#Preview {
    MainTabView()
}
