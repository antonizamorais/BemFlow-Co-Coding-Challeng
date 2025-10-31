//
//  RegistroDiario.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import Foundation
import SwiftData

@Model
final class RegistroDiario {
    var id: UUID = UUID()
    var data: Date
    var emocaoPrincipal: String
    var descricao: String // Campo de texto longo
    var tags: [String] // Array de tags

    init(data: Date, emocaoPrincipal: String, descricao: String, tags: [String]) {
        self.data = data
        self.emocaoPrincipal = emocaoPrincipal
        self.descricao = descricao
        self.tags = tags
    }
}
