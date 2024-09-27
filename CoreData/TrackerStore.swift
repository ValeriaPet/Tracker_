
import Foundation
import CoreData

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    init(context: NSManagedObjectContext = CoreDataHelper.shared.viewContext) {
        self.context = context
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Failed to fetch trackers: \(error)")
        }
    }
    
    internal func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) throws {
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else {
            throw NSError(domain: "TrackerStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to find entity description"])
        }

        let newTracker = TrackerCoreData(entity: trackerEntity, insertInto: context)
        newTracker.id = tracker.id
        newTracker.title = tracker.title
        newTracker.color = UIColorTransform.hexString(from: tracker.color)
        newTracker.emoji = tracker.emoji
        newTracker.creationDate = tracker.creationDate
        newTracker.category = category

        // Сохранение расписания через трансформер
        let transformer = WeekdayValueTransformer()
        if let transformedSchedule = transformer.transformedValue(tracker.schedule) {
            newTracker.schedule = transformedSchedule as? NSObject
        }

        category.addToTrackers(newTracker)

        do {
            try context.save()
            print("Successfully saved tracker: \(tracker.title)")
        } catch {
            print("Error saving tracker: \(error)")
            throw error
        }
    }

}


extension TrackerStore {
    
    private func decodingTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let colorHex = trackerCoreData.color,
              let emoji = trackerCoreData.emoji else { return nil }

        let color = UIColorTransform.color(from: colorHex)
        
        let transformer = WeekdayValueTransformer()
        guard let transformedSchedule = trackerCoreData.schedule as? Data,
              let schedule = transformer.reverseTransformedValue(transformedSchedule) as? [Weekday] else {
            return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: [], creationDate: trackerCoreData.creationDate ?? Date())
        }

        return Tracker(id: id,
                       title: title,
                       color: color,
                       emoji: emoji,
                       schedule: schedule,
                       creationDate: trackerCoreData.creationDate ?? Date())
    }
    
    func fetchTrackers() -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        do {
            let trackerCoreDataArray = try context.fetch(fetchRequest)
            let trackers = trackerCoreDataArray.compactMap { decodingTracker(from: $0) }
            return trackers
        } catch {
            print("Failed to fetch trackers: \(error)")
            return []
        }
    }
}


