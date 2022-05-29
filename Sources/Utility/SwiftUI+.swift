import SwiftUI

extension Color {
    public static var secondaryLabel: Color { .init(.secondaryLabel) }
}

enum SystemSymbol: String {
    case ellipsis = "ellipsis"
    case gearshape = "gearshape"
    case minusMagnifyingGlass = "minus.magnifyingglass"
    case plusMagnifyingGlass = "plus.magnifyingglass"
    case squareAndArrowUp = "square.and.arrow.up"
    case playFill = "play.fill"
}

extension Label where Title == Text, Icon == Image {
    init<S>(_ title: S, systemSymbol symbol: SystemSymbol) where S : StringProtocol {
        self.init(title, systemImage: symbol.rawValue)
    }
}

extension Image {
    init(systemSymbol symbol: SystemSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}

extension UIImage {
    convenience init?(systemSymbol symbol: SystemSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
