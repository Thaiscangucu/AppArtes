import SwiftUI

/// Geometric logo mark — outer frame + offset inner square + tick foot.
struct ObskaMark: View {
    var size: CGFloat = 24
    var color: Color = .obskaInk
    var accent: Color = .obskaAccent

    var body: some View {
        Canvas { ctx, _ in
            let s = size
            let scale = s / 64

            // Outer frame (stroke)
            var outer = Path()
            outer.addRect(CGRect(x: 6 * scale, y: 6 * scale,
                                 width: 52 * scale, height: 52 * scale))
            ctx.stroke(outer, with: .color(color), lineWidth: 3 * scale)

            // Inner offset filled square (accent)
            var inner = Path()
            inner.addRect(CGRect(x: 18 * scale, y: 18 * scale,
                                 width: 40 * scale, height: 40 * scale))
            ctx.fill(inner, with: .color(accent))

            // Tick foot
            var tick = Path()
            tick.addRect(CGRect(x: 6 * scale, y: 58 * scale,
                                width: 3 * scale, height: 8 * scale))
            ctx.fill(tick, with: .color(color))
        }
        .frame(width: size, height: size + (size * 8 / 64)) // extra for tick
    }
}

#Preview {
    HStack(spacing: 24) {
        ObskaMark(size: 48)
        ObskaMark(size: 24)
        ObskaMark(size: 16)
    }
    .padding()
    .background(Color.obskaPaper)
}
