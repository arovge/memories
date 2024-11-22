import SwiftUI

struct PhotosUnavailableView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ContentUnavailableView {
            Label("No photos access", systemSymbol: .xmark)
        } description: {
            Text("Allow photos access in settings to find memories")
        } actions: {
            Button("Settings") {
                openURL.callAsFunction(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
    }
}
