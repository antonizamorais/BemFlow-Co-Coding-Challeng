//
//  MapaPessoalView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

// Arquivo: MapaPessoalView.swift

import SwiftUI
import SwiftData

struct MapaPessoalView: View {
    @Query private var meusRegistros: [RegistroDiario]
    
    // Propriedades computadas de estatísticas (Exemplo)
    private var totalRegistros: Int { meusRegistros.count }
    private var humorMedio: Double {
        // Lógica para calcular o humor médio (assumindo que o RegistroDiario tem um score)
        return 2.0
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // --- SUAS EMOÇÕES (Últimos 7 dias) ---
                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Suas Emoções (Últimos 7 dias)", systemImage: "heart.text.square.fill")
                            .font(.headline)
                            .foregroundColor(Color.purple)
                        
                        Text("Aqui virá o gráfico ou lista das emoções mais registradas.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // --- SEUS CONTEXTOS PRINCIPAIS ---
                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Seus Contextos Principais", systemImage: "tag.fill")
                            .font(.headline)
                            .foregroundColor(Color.orange)
                        
                        Text("#estudo (1)") // Exemplo de tag
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(6)
                    }
                }

                // --- SUA JORNADA EMOCIONAL (Estatísticas) ---
                VStack(alignment: .leading) {
                    Label("Sua Jornada Emocional", systemImage: "chart.bar.fill")
                        .font(.title2).bold()
                        .foregroundColor(Color(red: 0.1, green: 0.5, blue: 0.75))
                        .padding(.bottom, 10)
                    
                    HStack {
                        MetricCard(title: "Total de Registros", value: "\(totalRegistros)", subtitle: "Em 21 dias", icon: "doc.text.fill", color: .red)
                        MetricCard(title: "Sequência Atual", value: "0", subtitle: "dias consecutivos", icon: "flame.fill", color: .red)
                        MetricCard(title: "Humor Médio", value: String(format: "%.1f/5", humorMedio), subtitle: "Mais Comum: Cansado", icon: "face.smiling.fill", color: .yellow)
                    }
                    
                    // --- Insights ---
                    CardView(borderColor: Color.clear, backgroundColor: Color.yellow.opacity(0.1)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("✨ Insights da Sua Jornada")
                                .font(.headline)
                            Text("🔹 Você está passando por um período mais desafiador, mas registrar suas emoções já é um grande passo!")
                                .font(.caption)
                            Text("🔹 Você tem registrado suas emoções por 21 dias - isso mostra dedicação ao seu bem-estar!")
                                .font(.caption)
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

// MARK: - Componentes Auxiliares (Simplificados)

struct CardView<Content: View>: View {
    var borderColor: Color = .gray.opacity(0.2)
    var backgroundColor: Color = .white
    let content: Content
    
    init(borderColor: Color = .gray.opacity(0.2), backgroundColor: Color = .white, @ViewBuilder content: () -> Content) {
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        CardView(borderColor: color.opacity(0.3)) {
            VStack(alignment: .leading, spacing: 5) {
                Label(title, systemImage: icon)
                    .font(.caption)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.title2).bold()
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    MapaPessoalView()
}
