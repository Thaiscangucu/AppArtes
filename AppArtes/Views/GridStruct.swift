import SwiftUI

// Alterei o nome genérico de "Data" para "DataCollection" para evitar conflito com o Foundation.Data
struct WaterfallGrid<DataCollection, Content>: View where DataCollection: RandomAccessCollection, DataCollection.Element: Identifiable, Content: View {
    
    let data: DataCollection
    let columns: Int
    let spacing: CGFloat
    
    // Adicionado @ViewBuilder para permitir o uso de "if let" na hora de criar as imagens
    @ViewBuilder let content: (DataCollection.Element) -> Content
    
    private func splitData() -> [[DataCollection.Element]] {
        var columnsData: [[DataCollection.Element]] = Array(repeating: [], count: columns)
        
        for (index, item) in data.enumerated() {
            let columnIndex = index % columns
            columnsData[columnIndex].append(item)
        }
        
        return columnsData
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: spacing) {
                    let colData = splitData()[columnIndex]
                    
                    ForEach(colData) { item in
                        content(item)
                    }
                }
            }
        }
    }
}
