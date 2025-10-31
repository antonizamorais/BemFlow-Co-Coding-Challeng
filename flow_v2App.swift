//
//  flow_v2App.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//
//
//  flow_v2App.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//
import SwiftUI
import SwiftData

// ==========================================================
// FUNÇÃO PARA INSERIR DICAS DE EXEMPLO (Nível de Arquivo)
// ==========================================================


private func inserirDicasDeExemplo(modelContext: ModelContext) {
    
    // Evita a duplicação
    do {
        let count = try modelContext.fetch(FetchDescriptor<Dica>()).count
        if count > 0 {
            print("Dicas de exemplo já existem. Pulando inserção.")
            return
        }
    } catch {
        print("Erro ao verificar dicas existentes: \(error)")
    }

    // Lista de 10 dicas variadas com likes diferentes (para Top 5)
    let dicasData: [(conteudo: String, emocao: String, likes: Int)] = [
        ("Técnica Pomodoro", "Ansioso", 199),
        ("Compartilhar gratidão", "Feliz", 189),
        ("Conversar com alguém de confiança", "Triste", 178),
        ("Cochilo de 20 minutos", "Cansado", 167),
        ("Criar algo com as mãos", "Produtivo", 167),
        ("Respiração 4-7-8", "Ansioso", 156),
        ("Caminhada de 10 minutos", "Triste", 134),
        ("Meditação guiada", "Ansioso", 98),
        ("Chá de camomila", "Cansado", 87),
        ("Escrever 3 preocupações", "Triste", 76),
    ]

    for item in dicasData {
        
        let novaDica = Dica(
            conteudo: item.conteudo,
            emocao: item.emocao,
            likes: item.likes,
            data: Date()
        )
         modelContext.insert(novaDica)
    }

    do {
        try modelContext.save()
        print("10 Dicas de exemplo inseridas com sucesso!")
    } catch {
        print("Falha ao salvar as dicas de exemplo: \(error)")
    }
}


@main
struct flow_v2App: App {
    
    var sharedModelContainer: ModelContainer = {

        let schema = Schema([
            RegistroDiario.self,
            Dica.self,
            DiarioColaborativo.self,  // NOVO MODELO INCLUÍDO
            EntradaDiario.self        // NOVO MODELO INCLUÍDO
            // Inclua AppUser.self se você o criou
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // CHAMADA: Inserir dados de exemplo ao inicializar o container
            Task { @MainActor in
                // É necessário injetar o ModelContext no ambiente da Dica para que isso compile
                // inserirDicasDeExemplo(modelContext: container.mainContext)
            }
            
            return container
        } catch {
            fatalError("Não foi possível criar ModelContainer para flow_v2App: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView() // Sua TabView principal
        }
        .modelContainer(sharedModelContainer)
    }
}
