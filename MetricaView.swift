//
//  MetricaView.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import SwiftUI

struct MetricaView: View {
    let titulo: String
    let valor: String
    let detalhe: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(titulo)
                .font(.caption)
                .foregroundColor(.orange)
            
            Text(valor)
                .font(.title2).bold()
            
            Text(detalhe)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
