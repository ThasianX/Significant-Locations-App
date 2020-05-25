// Kevin Li - 8:21 AM - 5/25/20

import SwiftUI

struct ExpandAndFoldModifier: ViewModifier {
    let foldOffset: CGFloat
    let shouldFold: Bool
    let isActiveIndex: Bool

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .modifier(self.makeNestedModifier(withMinY: geometry.frame(in: .global).minY))
        }
    }

    private func makeNestedModifier(withMinY minY: CGFloat) -> _ExpandAndFoldModifier {
        _ExpandAndFoldModifier(foldOffset: foldOffset, minY: minY, shouldFold: shouldFold, isActiveIndex: isActiveIndex)
    }
}

private struct _ExpandAndFoldModifier: ViewModifier {
    let foldOffset: CGFloat
    let minY: CGFloat
    let shouldFold: Bool
    let isActiveIndex: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: isActiveIndex ? topOfScreen : 0)
            .rotation3DEffect(rotationAngle, axis: (x: -200, y: 0, z: 0), anchor: .bottom)
            .opacity(opacity)
    }

    private var topOfScreen: CGFloat {
        -minY
    }

    private var shouldStartFolding: Bool {
        minY < foldOffset
    }

    private var rotationAngle: Angle {
        guard shouldFold && shouldStartFolding else { return .degrees(0) }
        return .degrees(-foldDegree) // negative because we want to fold inward
    }

    private var foldDegree: Double {
        // When the minY of the provided cell is equal to the foldOffset, the
        // fold degree should be 0 and as such, the fold delta is 1.
        // fold degree becomes 90 when fold delta becomes 0, which is when
        // the cell is completely folded
        guard foldDelta >= 0 else { return 90 }
        return 90 - (90 * foldDelta)
    }

    private var opacity: Double {
        guard shouldFold && shouldStartFolding && (foldDelta >= 0) else { return 1 }
        // 0.4 padding because we don't want the cell to fully fade when it's folded
        return foldDelta + 0.4
    }

    private var foldDelta: Double {
        Double((VisitCellConstants.height + (minY - foldOffset)) / VisitCellConstants.height)
    }
}
