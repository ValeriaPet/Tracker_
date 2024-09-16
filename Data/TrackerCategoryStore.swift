
import CoreData
import UIKit

final class CategoryStore {
    
    private weak var delegate: StoreService?
    private let context: NSManagedObjectContext
    
    init(delegate: StoreService) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func fetchCategoryList() -> Set <String> {
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "CategoryCoreData")
        guard let storedCategories = try? context.fetch(request) else {
            print("@@@ func fetchCategories: Сохраненные категории отсутствуют")
            return []
        }
        
        var categories: Set <String> = []
        
        storedCategories.forEach {item in
            if let category = item.category {
                categories.insert(category)
            }
        }
        return categories
    }

    func storeCategory(category title: String) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        
        categoryCoreData.category = title
        categoryCoreData.trackers = []
        delegate?.saveContext()
    }
    
    func storeCategoryWithTracker(category title: String, tracker: TrackerCoreData) {
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.category), title)
        
        guard let categoryCoreData = try? context.fetch(request) else {
            print("@@@ func storeCategoryWithTracker: Ошибка получения категории для сохранения нового трекера")
            return
        }
        tracker.category = categoryCoreData[0]
        delegate?.saveContext()
    }
}
