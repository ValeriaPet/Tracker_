
import Foundation
import CoreData
import UIKit

protocol CategoryStoreDelegate: AnyObject {
    func didUpdateData(in store: CategoryStore)
}

final class CategoryStore: NSObject {
    
    private weak var delegate: CategoryStoreDelegate?
    private let context: NSManagedObjectContext!
    private let trackerStore: TrackerStore
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
        super.init()
    }
}

extension CategoryStore {
    func addTrackerToCategory(_ tracker: Tracker, in category: TrackerCategoryCoreData) {
        do {
            try trackerStore.addNewTracker(tracker, to: category)
            try context.save()
            print("Successfully saved tracker to category: \(tracker.title)")
        } catch {
            print("Failed to add tracker to category: \(error)")
        }
    }
}


extension CategoryStore {
    func createCategory(_ category: TrackerCategory) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return }
        let categoryEntity = TrackerCategoryCoreData(entity: entity, insertInto: context)
        categoryEntity.name = category.name
        categoryEntity.trackers = NSSet()
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func fetchAllCategories() -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let categoriesCoreData = try context.fetch(fetchRequest)
            let categories = categoriesCoreData.compactMap { decodingCategory(from: $0) }
            return categories
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }

    func createOrAddTrackerToCategory(_ tracker: Tracker, with titleCategory: String) {
        do {
            let category = fetchOrCreateCategory(with: titleCategory)
            try trackerStore.addNewTracker(tracker, to: category)
            try context.save()
        } catch {
            print("Failed to add tracker to category: \(error)")
        }
    }

}

extension CategoryStore {
    
    private func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = trackerCategoryCoreData.name else { return nil }
        guard let trackersCoreDataSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData> else { return nil }

        let trackers = trackersCoreDataSet.compactMap { trackerCoreData in
            return decodingTracker(from: trackerCoreData)
        }

        return TrackerCategory(name: title, trackers: trackers)
    }

 
    private func decodingTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let colorHex = trackerCoreData.color,
              let emoji = trackerCoreData.emoji else { return nil }

        let color = UIColorTransform.color(from: colorHex)
        let schedule = trackerCoreData.schedule as? [Weekday] ?? []

        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule, creationDate: Date())
    }


    private func fetchTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers.first
        } catch {
            print("Failed to fetch tracker by ID: \(error)")
            return nil
        }
    }


    func fetchOrCreateCategory(with title: String) -> TrackerCategoryCoreData {
        if let existingCategory = fetchCategory(with: title) {
            return existingCategory
        } else {
            return createCategoryEntity(with: title)
        }
    }

    private func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.predicate = NSPredicate(format: "name == %@", title)
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.first
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }

    private func createCategoryEntity(with title: String) -> TrackerCategoryCoreData {
        let entity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context)!
        let newCategory = TrackerCategoryCoreData(entity: entity, insertInto: context)
        newCategory.name = title
        newCategory.trackers = NSSet()
        return newCategory
    }
}




