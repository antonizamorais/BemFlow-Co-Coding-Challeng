//
//  ConfiguracoesPrivacidadeView.swift
//  flow_v2
//
//  Created by user on 23/10/25.
//

import SwiftUI

// Arquivo: ConfiguracoesPrivacidadeView.swift

struct ConfiguracoesPrivacidadeView: View {
    // Usaremos um @StateObject ou @Binding se fosse um modelo persistente
    @State var configuracoes = ConfiguracoesRelatorio()

    let periodosDisponiveis = ["Últimos 7 dias", "Último mês", "Últimos 3 meses", "Último ano"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Título Principal
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(Color.purple)
                Text("Configurações de Privacidade")
                    .font(.title2).bold()
            }
            .padding(.bottom, 10)

            // MARK: - 1. INCLUIR TEXTOS DETALHADOS
            VStack(alignment: .leading) {
                Toggle(isOn: $configuracoes.incluirTextosDetalhes) {
                    Text("Incluir detalhes pessoais")
                        .font(.headline)
                }
                Text("Incluir textos detalhados nos relatórios compartilhados")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6)) // Cor de fundo suave
            .cornerRadius(10)

            // MARK: - 2. MOSTRAR TAGS ESPECÍFICAS
            VStack(alignment: .leading) {
                Toggle(isOn: $configuracoes.mostrarTagsEspecificas) {
                    Text("Mostrar tags específicas")
                        .font(.headline)
                }
                Text("Incluir tags como #trabalho, #família nos relatórios")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // MARK: - 3. PERÍODO DOS DADOS
            VStack(alignment: .leading) {
                Text("Período dos dados")
                    .font(.headline)
                Text("Escolha o período para incluir nos relatórios")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Spacer()
                    Picker("Período", selection: $configuracoes.periodoSelecionado) {
                        ForEach(periodosDisponiveis, id: \.self) { periodo in
                            Text(periodo).tag(periodo)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .navigationTitle("Privacidade")
    }
}

#Preview {
    ConfiguracoesPrivacidadeView()
}
