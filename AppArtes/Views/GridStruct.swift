//
//  HomeView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI

struct MasonryGrid<Content: View, T: Identifiable>: View {
    let items: [T]
    let columns: Int
    let spacing: CGFloat
    let content: (T) -> Content
    
    init(items: [T], columns: Int = 2, spacing: CGFloat = 8, @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    private var columnsItems: [[T]] {
        var grid: [[T]] = Array(repeating: [], count: columns)
        for (index, item) in items.enumerated() {
            grid[index % columns].append(item)
        }
        return grid
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: spacing) {
                    ForEach(columnsItems[columnIndex]) { item in
                        content(item)
                    }
                }
            }
        }
    }
}
// Modelo de dado para o exemplo
struct PostItem: Identifiable {
    let id = UUID()
    let height: CGFloat
}
