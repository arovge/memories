import SwiftUI
import LinkPresentation

class ActivityItemSource: NSObject, UIActivityItemSource {
    var text: String
    var image: UIImage
    var linkMetaData = LPLinkMetadata()
    
    init(text: String, image: UIImage) {
        self.text = text
        self.image = image
        linkMetaData.title = text
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        Bundle.main.icon as Any
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
}
