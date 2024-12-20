import SwiftUI

public enum SystemSymbol: String {
    case ellipsis = "ellipsis"
    case gearshape = "gearshape"
    case minusMagnifyingGlass = "minus.magnifyingglass"
    case plusMagnifyingGlass = "plus.magnifyingglass"
    case squareAndArrowUp = "square.and.arrow.up"
    case playFill = "play.fill"
    case xmark = "xmark"
    case photo = "photo"
    case photoOnRectangleAngled = "photo.on.rectangle.angled"
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

extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    public init <S: StringProtocol>(_ title: S, systemSymbol symbol: SystemSymbol, description: Text? = nil) {
        self.init(title, systemImage: symbol.rawValue, description: description)
    }
}
