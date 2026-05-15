import SwiftUI

// MARK: - Typography

extension Font {
    /// Fraunces serif — display, titles, prices.
    static func fraunces(_ size: CGFloat, weight: Weight = .regular) -> Font {
        Font.custom("Fraunces", size: size).weight(weight)
    }

    /// Fraunces italic — artist names, captions with editorial flavour.
    static func frauncesItalic(_ size: CGFloat) -> Font {
        Font.custom("Fraunces-Italic", size: size)
    }

    /// SF Mono tracking — lot numbers, timer, micro labels.
    static func obskaMonoCaption(_ size: CGFloat = 11) -> Font {
        Font.system(size: size, design: .monospaced).weight(.medium)
    }
}

// MARK: - Spacing & Radius tokens

enum Obska {
    static let radiusCard:   CGFloat = 4
    static let radiusButton: CGFloat = 4
    static let radiusChip:   CGFloat = 4
    static let radiusPill:   CGFloat = 999
    static let radiusAvatar: CGFloat = 4
    static let navButtonSize: CGFloat = 36
}

// MARK: - Reusable button label modifier

struct ObskaCTALabel: ViewModifier {
    var disabled: Bool = false
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .tracking(0.3)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(disabled ? Color.obskaHair : Color.obskaAccent)
            .clipShape(RoundedRectangle(cornerRadius: Obska.radiusButton))
    }
}

extension View {
    func obskaCTA(disabled: Bool = false) -> some View {
        self.modifier(ObskaCTALabel(disabled: disabled))
    }
}

// MARK: - Hairline circle nav button

struct ObskaCircleButton: View {
    let systemName: String
    var frosted: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(frosted ? Color(UIColor.label) : Color.obskaInk)
                .frame(width: Obska.navButtonSize, height: Obska.navButtonSize)
                .background {
                    if frosted {
                        Circle()
                            .fill(.ultraThinMaterial)
                    } else {
                        Circle()
                            .fill(Color.clear)
                            .overlay(Circle().stroke(Color.obskaHair, lineWidth: 1))
                    }
                }
        }
    }
}
