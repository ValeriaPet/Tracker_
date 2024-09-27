import CoreData

final class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private init() {
        registerTransformers()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context successfully saved!")
            } catch {
                let nserror = error as NSError
                print("Failed to save context: \(nserror), \(nserror.userInfo)")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    private func registerTransformers() {
        let transformerName = NSValueTransformerName("WeekdayValueTransformer")
        let transformer = WeekdayValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: transformerName)
    }
}
