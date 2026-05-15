import UIKit
import SwiftData

enum DataSeeder {
    static func seedIfNeeded(context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: "hasSeededMockCollections") else { return }
        insertBanksyCollection(into: context)
        insertMinhasObras(into: context)
        UserDefaults.standard.set(true, forKey: "hasSeededMockCollections")
    }

    // MARK: - Banksy

    private static func insertBanksyCollection(into context: ModelContext) {
        let colecao = Colecao(titulo: "Obras de Banksy")
        context.insert(colecao)

        let obras: [(titulo: String, descricao: String, preco: Double, bg: UIColor, accent: UIColor)] = [
            (
                "Girl with Balloon",
                "Uma das obras mais icônicas de Banksy: menina de vestido solta um balão em forma de coração, símbolo de esperança e perda. Vendida em leilão pela Sotheby's em 2018 por £1,04 milhão.",
                12_500,
                UIColor(red: 0.96, green: 0.93, blue: 0.88, alpha: 1),
                .systemRed
            ),
            (
                "Flower Thrower",
                "Manifestante mascarado arremessa um buquê de flores coloridas — inversão poética da violência em ato de beleza. Mural original em Jerusalém, 2003.",
                9_800,
                UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1),
                .systemYellow
            ),
            (
                "Love is in the Bin",
                "Obra que se autodestrutriu momentos após ser vendida por £1,04 milhão, tornando-se a primeira obra de arte a ser criada ao vivo em um leilão. Antes intitulada 'Girl with Balloon'.",
                18_200,
                UIColor(red: 0.93, green: 0.90, blue: 0.85, alpha: 1),
                UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
            ),
        ]

        for item in obras {
            let image = generatePlaceholder(bg: item.bg, accent: item.accent, size: CGSize(width: 800, height: 900))
            let obra = ObraDeArte(
                titulo: item.titulo,
                descricao: item.descricao,
                image: image,
                dataCriacao: randomPastDate(daysAgo: 60...365),
                preco: item.preco
            )
            context.insert(obra)
            colecao.obras.append(obra)
        }
    }

    // MARK: - Minhas Obras

    private static func insertMinhasObras(into context: ModelContext) {
        let colecao = Colecao(titulo: "Minhas Obras")
        context.insert(colecao)

        let obras: [(titulo: String, descricao: String, preco: Double, bg: UIColor, accent: UIColor)] = [
            (
                "Série Azul #1",
                "Exploração abstrata da cor azul em suas múltiplas tonalidades, inspirada nos céus do Cerrado brasileiro ao entardecer. Acrílica sobre tela, 60 × 60 cm.",
                450,
                .systemIndigo,
                .systemBlue
            ),
            (
                "Equilíbrio",
                "Formas geométricas simples em diálogo — círculo, retângulo e linha — buscando harmonia dentro do desequilíbrio. Nanquim e aquarela, 40 × 30 cm.",
                380,
                .systemOrange,
                .systemYellow
            ),
            (
                "Fragmentos #3",
                "Terceira peça da série Fragmentos. Composição em camadas que explora a memória como algo ao mesmo tempo presente e irrecuperável. Acrílica sobre papel, 50 × 70 cm.",
                520,
                .systemPurple,
                .systemPink
            ),
        ]

        for item in obras {
            let image = generateAbstractArt(color1: item.bg, color2: item.accent, size: CGSize(width: 800, height: 800))
            let obra = ObraDeArte(
                titulo: item.titulo,
                descricao: item.descricao,
                image: image,
                dataCriacao: randomPastDate(daysAgo: 2...30),
                preco: item.preco
            )
            context.insert(obra)
            colecao.obras.append(obra)
        }
    }

    // MARK: - Image Generators

    private static func generatePlaceholder(bg: UIColor, accent: UIColor, size: CGSize) -> Data? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let c = ctx.cgContext
            bg.setFill()
            c.fill(CGRect(origin: .zero, size: size))

            accent.withAlphaComponent(0.85).setFill()
            c.fillEllipse(in: CGRect(x: size.width * 0.3, y: size.height * 0.15,
                                      width: size.width * 0.4, height: size.width * 0.4))

            accent.withAlphaComponent(0.3).setFill()
            c.fill(CGRect(x: size.width * 0.1, y: size.height * 0.55,
                          width: size.width * 0.25, height: size.height * 0.35))

            accent.withAlphaComponent(0.15).setFill()
            c.fillEllipse(in: CGRect(x: size.width * 0.55, y: size.height * 0.6,
                                      width: size.width * 0.35, height: size.width * 0.35))
        }
        return image.jpegData(compressionQuality: 0.85)
    }

    private static func generateAbstractArt(color1: UIColor, color2: UIColor, size: CGSize) -> Data? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let c = ctx.cgContext
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [color1.cgColor, color2.cgColor] as CFArray,
                locations: [0, 1]
            ) else { return }
            c.drawLinearGradient(gradient,
                                 start: .zero,
                                 end: CGPoint(x: size.width, y: size.height),
                                 options: [])

            UIColor.white.withAlphaComponent(0.22).setFill()
            c.fillEllipse(in: CGRect(x: size.width * 0.1, y: size.height * 0.15,
                                      width: size.width * 0.5, height: size.height * 0.5))

            UIColor.white.withAlphaComponent(0.14).setFill()
            c.fill(CGRect(x: size.width * 0.4, y: size.height * 0.4,
                          width: size.width * 0.5, height: size.height * 0.35))

            UIColor.white.withAlphaComponent(0.08).setFill()
            c.fillEllipse(in: CGRect(x: size.width * 0.6, y: size.height * 0.05,
                                      width: size.width * 0.3, height: size.width * 0.3))
        }
        return image.jpegData(compressionQuality: 0.85)
    }

    private static func randomPastDate(daysAgo range: ClosedRange<Int>) -> Date {
        let days = Int.random(in: range)
        return Date(timeIntervalSinceNow: -Double(days) * 86_400)
    }
}
