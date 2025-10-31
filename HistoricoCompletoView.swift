//
//  HistoricoCompletoView.swift
//  flow_v2
//
//  Created by user on 23/10/25.
//
import SwiftUI

// MARK: - 1. ESTRUTURAS DE DADOS

/// Representa um registro de humor/evento
struct Registro: Identifiable {
    let id = UUID()
    let data: Date
    let emocao: String
    let tag: String
    let texto: String
}

/// Opções disponíveis para o filtro de Período
enum PeriodoFiltro: String, CaseIterable, Identifiable {
    case todos = "Todos os registros"
    case ultimaSemana = "Última Semana"
    case ultimoMes = "Último Mês"
    case ultimoAno = "Último Ano"
    
    var id: String { self.rawValue }
}

// MARK: - DADOS DE EXEMPLO (MOCK DATA)

let registrosDeExemplo: [Registro] = [
    Registro(data: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, emocao: "Alegria", tag: "Trabalho", texto: "Projeto entregue com sucesso!"),
    Registro(data: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, emocao: "Foco", tag: "Estudos", texto: "Consegui estudar 8 horas hoje, dia produtivo."),
    Registro(data: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, emocao: "Gratidão", tag: "Pessoal", texto: "Passeio em família foi ótimo e relaxante."),
    Registro(data: Calendar.current.date(byAdding: .month, value: -5, to: Date())!, emocao: "Tristeza", tag: "Saúde", texto: "Dia difícil e exaustivo no hospital, mas já passou."),
    Registro(data: Calendar.current.date(byAdding: .year, value: -2, to: Date())!, emocao: "Raiva", tag: "Finanças", texto: "Gasto inesperado que desequilibrou o orçamento."),
]

let todasAsEmocoes = ["Alegria", "Foco", "Gratidão", "Tristeza", "Raiva"]
let todasAsTags = ["Trabalho", "Estudos", "Pessoal", "Saúde", "Finanças"]

// MARK: - COMPONENTES VISUAIS

/// Componente para o layout de cada filtro (rótulo, Picker e separador)
struct FiltroMenu<Content: View>: View {
    let label: String
    let content: Content
    
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            // O Picker
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, -8) // Ajusta a margem do Picker
            
            Divider()
        }
    }
}

/// Componente para exibir um único registro na lista
struct RegistroCardView: View {
    let registro: Registro
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(registro.emocao)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text(registro.data, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text("#\(registro.tag)")
                .font(.caption)
                .foregroundColor(.green)
                .padding(.bottom, 2)
            Text(registro.texto)
                .font(.body)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

// MARK: - VIEW PRINCIPAL

struct HistoricoCompletoView: View {
    @State private var periodoSelecionado: PeriodoFiltro = .todos
    @State private var emocaoSelecionada: String = "Todas as emoções"
    @State private var tagSelecionada: String = "Todas as tags"
    
    // Propriedade Computada para Aplicar os Filtros
    var filteredRegistros: [Registro] {
        var baseDate: Date?
        
        // 1. Filtragem por Período
        switch periodoSelecionado {
        case .todos:
            baseDate = nil
        case .ultimaSemana:
            baseDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        case .ultimoMes:
            baseDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        case .ultimoAno:
            baseDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        }
        
        let filtradoPorPeriodo = registrosDeExemplo.filter { registro in
            guard let base = baseDate else { return true }
            return registro.data >= base
        }
        
        // 2. Filtragem por Emoção
        let filtradoPorEmocao = filtradoPorPeriodo.filter { registro in
            if emocaoSelecionada == "Todas as emoções" {
                return true
            }
            return registro.emocao == emocaoSelecionada
        }
        
        // 3. Filtragem por Tag
        let filtradoFinal = filtradoPorEmocao.filter { registro in
            if tagSelecionada == "Todas as tags" {
                return true
            }
            return registro.tag == tagSelecionada
        }
        
        // Retorna a lista filtrada, ordenada do mais novo para o mais antigo
        return filtradoFinal.sorted { $0.data > $1.data }
    }
    
    var body: some View {
        //NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - CARD DE FILTROS (Layout Vertical Aprimorado)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .foregroundColor(.blue)
                            Text("Opções de Filtro")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        // Layout vertical garante que o texto não quebre
                        VStack(spacing: 15) {
                            
                            // 1. Filtro de Período
                            FiltroMenu(label: "Filtrar por Período") {
                                Picker("Período", selection: $periodoSelecionado) {
                                    ForEach(PeriodoFiltro.allCases) { periodo in
                                        Text(periodo.rawValue).tag(periodo)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            
                            // 2. Filtro de Emoção
                            FiltroMenu(label: "Filtrar por Emoção") {
                                Picker("Emoção", selection: $emocaoSelecionada) {
                                    Text("Todas as emoções").tag("Todas as emoções")
                                    ForEach(todasAsEmocoes, id: \.self) { emocao in
                                        Text(emocao).tag(emocao)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            
                            // 3. Filtro de Tag
                            FiltroMenu(label: "Filtrar por Tag") {
                                Picker("Tag", selection: $tagSelecionada) {
                                    Text("Todas as tags").tag("Todas as tags")
                                    ForEach(todasAsTags, id: \.self) { tag in
                                        Text("#\(tag)").tag(tag)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        
                        // Contador de resultados
                        Text("\(filteredRegistros.count) de \(registrosDeExemplo.count) registros encontrados")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    
                    // MARK: - LISTA DE REGISTROS
                    
                    if filteredRegistros.isEmpty {
                        Text("Nenhum registro encontrado para os filtros selecionados.")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        // Exibe os registros filtrados
                        ForEach(filteredRegistros) { registro in
                            RegistroCardView(registro: registro)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            //.navigationTitle("Histórico Completo")
            .background(Color(.systemGray6).ignoresSafeArea(edges: .bottom))            //.background(Color(.systemGray6).edgesIgnoringSafeArea(.all)) // Fundo cinza claro
        //}
    }
}

// Para visualizar a view no Xcode Canvas (se estiver usando)
struct HistoricoCompletoView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricoCompletoView()
    }
}
