import SwiftUI
import MemoriesModels
import MemoriesServices
import Photos

@Observable
class DashboardViewModel {
    var layout = ColumnLayout.triple
    var loading = true
    var hasPhotosAccess = false
    var error = false
    var memorySections = [MemorySection]()
    
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
        
        assets = photosService.getAssets()
        memorySections = computeMemorySections()
    }
    
    func checkPhotosAccess() async {
        let result = await photosService.requestAccess()
                
        hasPhotosAccess = switch result {
        case .notDetermined:
            // TODO: Prompt if access is not determined
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
    
    func computeMemorySections() -> [MemorySection] {
        var media = [MediaWrapper]()
        
        assets.enumerateObjects { asset, _, _ in
            // Only worrying about image support for now
            guard asset.mediaType == .image else { return }
            guard let wrapper = MediaWrapper(asset: asset) else {
                return
            }
            // guard wrapper.isMemory else { return }
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
    
    func getImage(_ asset: PHAsset) async -> UIImage? {
        do {
            return try await photosService.getImage(id: asset.localIdentifier)
        } catch {
            logger.log(error)
            return nil
        }
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
}
