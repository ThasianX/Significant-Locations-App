import SwiftUI

struct AppColors {
    static let tags: [String: UIColor] = [
        "Berry Red" : .berryRed,
        "Salmon" : .salmon,
        "Lime Green" : .limeGreen,
        "Sky Blue" : .skyBlue
    ]

    static let identifiers: [String] = tags.ascendingKeys

    static let themes: [UIColor] = [
        .persianPink,
        .cadiumOrange,
        .skyBlue,
        .violetGum,
        .blackPearl,
        .gladeGreen,
        .winterHazel,
        .radicalRed
    ]
}
