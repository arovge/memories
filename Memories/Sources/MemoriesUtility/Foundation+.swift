import Foundation
import UIKit

extension Date {
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
