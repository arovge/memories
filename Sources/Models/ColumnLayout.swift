import SwiftUI

enum ColumnLayout: CaseIterable {
    case single
    case double
    case triple
    case quadruple
    
    var columnCount: Int {
        switch self {
        case .single: return 1
        case .double: return 2
        case .triple: return 3
        case .quadruple: return 4
        }
    }
}
