import SwiftUI

extension Color {
    public static var secondaryLabel: Color { .init(.secondaryLabel) }
}

public enum SystemSymbol: String {
    case ellipsis = "ellipsis"
    case gearshape = "gearshape"
    case minusMagnifyingGlass = "minus.magnifyingglass"
    case plusMagnifyingGlass = "plus.magnifyingglass"
    case squareAndArrowUp = "square.and.arrow.up"
    case playFill = "play.fill"
}

extension Label where Title == Text, Icon == Image {
    public init<S>(_ title: S, systemSymbol symbol: SystemSymbol) where S: StringProtocol {
        self.init(title, systemImage: symbol.rawValue)
    }
}

extension Image {
    public init(systemSymbol symbol: SystemSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}

extension UIImage {
    public convenience init?(systemSymbol symbol: SystemSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
