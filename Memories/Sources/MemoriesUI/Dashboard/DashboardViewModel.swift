import SwiftUI
import MemoriesModels
import MemoriesServices
import Photos

@Observable
class DashboardViewModel {
    var memorySections = [MemorySection]()
    var layout = ColumnLayout.single
    var loading = true
    var hasPhotosAccess = false
    var error = false
    
    let currentMonthAndDay: String = Date
        .now
        .formatted(
            .dateTime
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.defaultDigits)
        )
    
    private var assets = PHFetchResult<PHAsset>()
    private let photosService = PhotosService()
    private let logger = Logger()
    private var loaded = false
    
    var hasMemories: Bool {
        !memorySections.isEmpty
    }
    
    func handleAppear(force: Bool = false) async {
        guard !loaded || force || !hasPhotosAccess else { return }
        loaded = true
        defer { loading = false }
        
        await checkPhotosAccess()
        
        guard hasPhotosAccess else { return }
        
        getAssets()
    }
    
    func checkPhotosAccess() async {
        let result = await photosService.requestAccess()
                
        hasPhotosAccess = switch result {
        case .notDetermined: // need to prompt here
            false
        case .restricted:
            true
        case .denied:
            false
        case .authorized:
            true
        case .limited:
            true
        @unknown default:
            false
        }
    }
    
    func getAssets() {
        assets = photosService.getAssets()
        
//        photosService.fetchMedia(addMedia: self.addMedia)
        let sections = computeMemorySections()
        
        memorySections = sections
        loading = false
    }
    
    func getImage(_ asset: PHAsset) async -> UIImage? {
        do {
            return try await photosService.getImage(id: asset.localIdentifier)
        } catch {
            logger.log(error)
            return nil
        }
    }
    
    func computeMemorySections() -> [MemorySection] {
        var media = [MediaWrapper]()
        
        assets.enumerateObjects { asset, _, _ in
            guard let creationDate = asset.creationDate else { return }
            
            // Only worrying about image support for now
            guard asset.mediaType == .image else { return }
            guard let wrapper = MediaWrapper(asset: asset) else {
                return
            }
            media.append(wrapper)
        }
        
        let mediaGroupedByYear = media.reduce(into: [:] as [Int: [MediaWrapper]]) { acc, media in
            let components = Calendar.current.dateComponents([.year], from: media.createdDate)
            guard let year = components.year else { return }
            acc[year, default: []].append(media)
        }
        
        return mediaGroupedByYear
            .map { key, values in
                MemorySection(
                    year: key,
                    media: values.sorted(by: { $0.createdDate > $1.createdDate })
                )
            }
            .sorted(by: { $0.year > $1.year })
    }
    
    func toggleLayout() {
        layout = switch layout {
        case .single: .double
        case .double: .triple
        case .triple: .quadruple
        case .quadruple: .single
        }
    }
    
    func viewMediaInPhotos() {
        
    }
    
    func sendNotification() async {
        // 8am
        let date = DateComponents(hour: 8, minute: 0)

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(
            identifier: "Shaba",
            content: .init(),
            trigger: trigger
        )
        do {
            try await UNUserNotificationCenter.current().add(request)
            logger.info("Notification scheduled")
        } catch {
            logger.log(error)
        }
    }
    
    func share(year: Int, media: MediaWrapper) {
//        let text = "My memory from \(currentMonthAndDay), \(year)"
//        let itemSource = ActivityItemSource(text: text, image: media.placeholderImage)
//        let activityController = UIActivityViewController(
//            activityItems: [media.placeholderImage, text, itemSource],
//            applicationActivities: nil
//        )
//        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}
