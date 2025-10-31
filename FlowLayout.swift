//
//  FlowLayout.swift
//  flow_v2
//
//  Created by user on 10/10/25.
//

import SwiftUI

// MARK: - TagItem (Estrutura auxiliar para o visual de cada tag de contexto)
struct TagItem: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(15)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - FlowLayout (Layout principal para envolver itens em várias linhas)

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable & CustomStringConvertible {
    
    let items: Data
    var itemSpacing: CGFloat = 8
    let content: (Data.Element) -> Content
    
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
                // Usamos fixedSize para que a View não ocupe todo o espaço disponível,
                // mas apenas o necessário para o conteúdo (tags).
                .fixedSize(horizontal: false, vertical: true)
        }
        
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width: CGFloat = .zero
        var height: CGFloat = .zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .padding(.horizontal, itemSpacing / 2)
                    .padding(.vertical, itemSpacing / 2)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height + itemSpacing
                        }
                        let result = width
                        
                        
                        width -= d.width
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        return result
                    }
            }
        }
    }
}
