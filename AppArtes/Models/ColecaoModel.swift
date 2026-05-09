import Foundation
import SwiftData

@Model
final class Colecao {
    @Attribute(.unique) var id: String
    var titulo: String
    @Relationship(deleteRule: .cascade) var obras: [ObraDeArte] = []
    
    init(id: String = UUID().uuidString, titulo: String) {
        self.id = id
        self.titulo = titulo
    }
}
