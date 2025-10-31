//
//  Dica.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import Foundation
import SwiftData

@Model
final class Dica {
    var id: UUID = UUID()
    var conteudo: String
    var emocao: String
    var likes: Int
    var data: Date
    
    init(conteudo: String, emocao: String, likes: Int, data: Date) {
        self.conteudo = conteudo
        self.emocao = emocao
        self.likes = likes
        self.data = data
    }
}
