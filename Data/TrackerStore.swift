
import CoreData
import UIKit

final class TrackerStore {
    
    private weak var delegate: StoreService?
    private let context: NSManagedObjectContext
    
    init(delegate: StoreService) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func addToStore(tracker: Tracker, eventDate: Date?) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.id = tracker.id
        trackerCoreData.creationDate = tracker.creationDate
        trackerCoreData.title = tracker.title
        trackerCoreData.color =  UIColor(named: trackerCoreData.color as? String ?? "") ?? UIColor.clear
        
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.map { "\($0.rawValue)" }.joined(separator: ",")
        
        return trackerCoreData
    }

    
    func allTrackersCount() -> Int {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.resultType = .countResultType
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count
    }
}
