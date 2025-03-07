import CoreData

// MARK: - DataManagerProtocol
protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    
    func find<T: NSManagedObject>(entityName: EntityName, predicates: [NSPredicate]) -> [T] 
    func save(dataArray: [[String: Any]], entityName: EntityName) throws
    func add(data: [String: Any], entityName: EntityName, completion: @escaping (Result<Void, Error>) -> Void)
    func update(data: [String: Any], by id: Int, entityName: EntityName, completion: @escaping (Result<Void, Error>) -> Void)
    func remove(entity: NSManagedObject, completion: @escaping (Result<Void, Error>) -> Void)
    func search<T: NSManagedObject>(entityName: EntityName, attributeNames: [String], searchText: String, completion: @escaping (Result<[T], Error>) -> Void) 
}

enum EntityName: String {
    case taskItem = "TaskItemCoreModel"
}

// MARK: - CoreDataManager
final class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    
    // MARK: - NSPersistentContainer
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - NSManagedObjectContext
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("Context saved successfully")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func find<T: NSManagedObject>(entityName: EntityName, predicates: [NSPredicate]) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName.rawValue)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }
    
    func save(dataArray: [[String: Any]], entityName: EntityName) throws {
        for data in dataArray {
            let entity = NSEntityDescription.insertNewObject(forEntityName: entityName.rawValue, into: viewContext)
            for (key, value) in data {
                entity.setValue(value, forKey: key)
            }
        }
        try viewContext.save()
    }
    
    func add(data: [String: Any], entityName: EntityName, completion: @escaping (Result<Void, Error>) -> Void) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName.rawValue, into: viewContext)
        
        for (key, value) in data {
            entity.setValue(value, forKey: key)
        }
    
        do {
            try viewContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to add task"])))
        }
    }
    
    func update(data: [String: Any], by id: Int, entityName: EntityName, completion: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %d", id)
        let entities: [TaskItemCoreModel] = find(entityName: entityName, predicates: [predicate])
        
        guard let entityToUpdate = entities.first else {
            completion(.failure(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity with id \(id) not found"])))
            return
        }
        
        for (key, value) in data {
            entityToUpdate.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to update task with id \(id)"])))
        }
    }
    
    func remove(entity: NSManagedObject, completion: @escaping (Result<Void, Error>) -> Void) {
        viewContext.delete(entity)
        do {
            try viewContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func search<T: NSManagedObject>(entityName: EntityName, attributeNames: [String], searchText: String, completion: @escaping (Result<[T], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName.rawValue)
        
        let predicates = attributeNames.map { attributeName in
            NSPredicate(format: "%K CONTAINS[cd] %@", attributeName, searchText)
        }
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            completion(.success(result))
        } catch {
            completion(.failure(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to search entities: \(error)"])))
        }
    }
}
