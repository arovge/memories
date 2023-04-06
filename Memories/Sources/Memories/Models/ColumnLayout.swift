import SwiftUI

enum ColumnLayout: Int, CaseIterable {
    case single = 1
    case double = 2
    case triple = 3
    case quadruple = 4
    
    var nextZoomInLevel: ColumnLayout? {
        switch self {
        case .single: return nil
        case .double: return .single
        case .triple: return .double
        case .quadruple: return .triple
        }
    }
    
    var nextZoomOutLevel: ColumnLayout? {
        switch self {
        case .single: return .double
        case .double: return .triple
        case .triple: return .quadruple
        case .quadruple: return nil
        }
    }
    
    mutating func zoomOut() {
        switch self {
        case .single: self = .double
        case .double: self = .triple
        case .triple: self = .quadruple
        default: break
        }
    }
    
    mutating func zoomIn() {
        switch self {
        case .double: self = .single
        case .triple: self = .double
        case .quadruple: self = .triple
        default: break
        }
    }
}
