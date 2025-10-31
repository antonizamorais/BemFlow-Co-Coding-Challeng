//
//  AnalisesGraficosView.swift
//  flow_v2
//
//  Created by user on 23/10/25.
//
import SwiftUI
import Charts
// Arquivo: AnalisesGraficosView.swift

struct AnalisesGraficosView: View {
    // Para acesso aos dados do usuário logado
    // @Query private var registros: [RegistroDiario]
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 1. Variação do Humor (Gráfico Placeholder)
            CardAnalise(titulo: "Variação do Humor", icon: "chart.line.uptrend.xyaxis") {
                // Seu componente Chart() real iria aqui.
                Text("Gráfico de Humor do Mês (Placeholder)")
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.vertical, 5)
            }
            
            // 2. Estatísticas do Mês (4 itens)
            EstatisticasMesView()
            
            // 3. Impacto dos Hábitos (Blocos de Tags)
            ImpactoHabitosView()
            
            Spacer()
        }
    }
}

// MARK: - Componentes Auxiliares (Placeholders)

// Componente para criar os cards de Análise (Fundo branco com título)
struct CardAnalise<Content: View>: View {
    let titulo: String
    let icon: String
    let content: Content
    
    init(titulo: String, icon: String, @ViewBuilder content: () -> Content) {
        self.titulo = titulo
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                Text(titulo)
                    .font(.headline).bold()
            }
            .foregroundColor(.primary)
            
            content // O conteúdo (Gráfico, Estatísticas, etc.)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2, x: 0, y: 1)
    }
}

// Placeholder para Estatísticas do Mês
struct EstatisticasMesView: View {
    // Usaria dados reais aqui
    var body: some View {
        CardAnalise(titulo: "Estatísticas do Mês", icon: "list.bullet.clipboard") {
            VStack(spacing: 15) {
                // Placeholder para os 4 blocos de estatísticas
                EstatisticaBloco(label: "Registros este mês", value: "0", color: .blue)
                EstatisticaBloco(label: "Emoção mais frequente", value: "Nenhuma", color: .orange)
                EstatisticaBloco(label: "Tag mais usada", value: "#Nenhuma", color: .yellow)
                EstatisticaBloco(label: "Sequência atual", value: "0 Dias", color: .purple)
            }
        }
    }
}

// Bloco individual de Estatística
struct EstatisticaBloco: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(color)
            Text(value)
                .font(.title3).bold()
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}


// Placeholder para Impacto dos Hábitos (Tags/Cards)
struct ImpactoHabitosView: View {
    var body: some View {
        CardAnalise(titulo: "Impacto dos Hábitos no Seu Bem-estar", icon: "lightbulb") {
            // Usando um ScrollView Horizontal para imitar o anexo
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    // Cartões de exemplo
                    HabitoCard(tag: "#exercício", humor: "5.0/5", impacto: "Impacto positivo", cor: .green)
                    HabitoCard(tag: "#trabalho", humor: "3.5/5", impacto: "Impacto neutro", cor: .yellow)
                    HabitoCard(tag: "#estudo", humor: "2.0/5", impacto: "Impacto negativo", cor: .red)
                }
            }
        }
    }
}

struct HabitoCard: View {
    let tag: String
    let humor: String
    let impacto: String
    let cor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(tag)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(cor)
            }
            Text("Humor médio: \(humor)")
                .font(.caption)
            Text("1 registros")
                .font(.caption)
            
            Text(impacto)
                .font(.caption).bold()
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background(cor.opacity(0.2))
                .foregroundColor(cor.opacity(0.9))
                .cornerRadius(5)
        }
        .padding()
        .frame(width: 150, height: 150, alignment: .topLeading)
        .background(cor.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    AnalisesGraficosView()
}
