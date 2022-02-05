import Foundation

private var ioDispatchQueue = DispatchQueue(label: "memories.io", attributes: .concurrent)

extension DispatchQueue {
    static var io: DispatchQueue {
        get { ioDispatchQueue }
        set(value) { ioDispatchQueue = value }
    }
}
