//
//  DiarioColaborativoView.swift
//  flow_v2
//
//  Created by user on 30/10/25.
//

// Arquivo: DiarioColaborativoView.swift
import SwiftUI
import SwiftData

struct DiarioColaborativoView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tabSelecionada: String = "Todos" //
    
    @Query private var meusDiarios: [DiarioColaborativo]

    var body: some View {
        //NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - 1. CARD DE ESTATÍSTICAS
                    EstatisticasDiarioView()
                        .padding(.horizontal)
                    
                    // MARK: - 2. CARD DE CRIAÇÃO E PARTICIPAÇÃO
                    CriarParticiparDiarioCard()
                        .padding(.horizontal)
                    
                    // MARK: - 3. ABAS E LISTA DE DIÁRIOS
                    MeusDiariosListaView(diarios: meusDiarios, tabSelecionada: $tabSelecionada)
                        .padding(.top, 10)
                }
                .padding(.top)
            }
            //.navigationTitle("Diário Colaborativo")
            //.background(Color(.systemGray6).ignoresSafeArea())
        //}
    }
}

// MARK: - COMPONENTES AUXILIARES

// 3.1 Lista de Diários
struct MeusDiariosListaView: View {
    let diarios: [DiarioColaborativo]
    @Binding var tabSelecionada: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Meus Diários")
                .font(.title2).bold()
                .padding(.horizontal)

            // Tabs de Filtro
            HStack {
                Spacer()
                ForEach(["Todos", "Criados por mim", "Participando"], id: \.self) { tab in
                    Button(action: { tabSelecionada = tab }) {
                        Text(tab)
                            .font(.caption).bold()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(tabSelecionada == tab ? Color.blue.opacity(0.1) : Color(.systemGray5))
                            .foregroundColor(tabSelecionada == tab ? .blue : .gray)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)

            // Lista de Diários
            if diarios.isEmpty {
                Text("Você ainda não criou ou participa de nenhum diário.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(diarios.filter { _ in tabSelecionada != "Criados por mim" }) { diario in
                    DiarioCard(diario: diario)
                }
            }
        }
    }
}

// 3.2 Card de Diário Individual
struct DiarioCard: View {
    let diario: DiarioColaborativo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(diario.nome)
                .font(.headline)
            Text(diario.descricao)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Ícones de membros e atividade
            HStack {
                Image(systemName: "person.3.fill").foregroundColor(.purple)
                Text("\(diario.membros.count) membros")
                
                // Exemplo de botão
                Button("Compartilhar") {}
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 3)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

// 1. Componente de Estatísticas
struct EstatisticasDiarioView: View {
    // Dados de exemplo, substitua por @Query real
    let criados = 1
    let participando = 0
    let entradas = 1
    
    var body: some View {
        // Adaptado de Suas Estatísticas
        VStack(alignment: .leading, spacing: 10) {
            Text("Suas Estatísticas")
                .font(.headline)
            
            HStack(spacing: 15) {
                StatBox(label: "Diários Criados", value: "\(criados)", color: .purple)
                StatBox(label: "Diários Participando", value: "\(participando)", color: .green)
                StatBox(label: "Entradas Totais", value: "\(entradas)", color: .orange)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct StatBox: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title).bold()
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// 2. Componente de Criação e Participação
struct CriarParticiparDiarioCard: View {
    @State private var nomeDiario = ""
    @State private var descricaoDiario = ""
    @State private var linkOuCodigo = ""
    @State private var privacidade = "Privado"
    
    var body: some View {
        /*VStack {
            Text("Diário Colaborativo")
                .font(.title).bold()
                .foregroundColor(.white)
            Text("Crie e compartilhe diários com amigos, família ou grupos especiais")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(15)
        .padding(.bottom, 10)
        */
        // Layout adaptado para vertical
        VStack(spacing: 20) {
            Group {
                // Criar Novo Diário
                VStack(alignment: .leading, spacing: 10) {
                    Label("Criar Novo Diário", systemImage: "sparkles")
                        .font(.headline)
                    TextField("Nome do Diário", text: $nomeDiario)
                        .textFieldStyle(.roundedBorder)
                    TextField("Descrição...", text: $descricaoDiario, axis: .vertical)
                        .lineLimit(3...5)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Tipo de Privacidade", selection: $privacidade) {
                        Text("Privado (apenas convidados)").tag("Privado")
                        Text("Público").tag("Público")
                    }
                    .pickerStyle(.menu)
                    
                    Button("Criar Diário") {}
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                
                Divider()
                
                // Participar de Diário
                VStack(alignment: .leading, spacing: 10) {
                    Label("Participar de Diário", systemImage: "paperclip")
                        .font(.headline)
                    TextField("Link ou Código do Diário", text: $linkOuCodigo)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Participar") {}
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Text("ou")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                    
                    Button("Escanear QR Code") {}
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
}
#Preview {
    DiarioColaborativoView()
}
