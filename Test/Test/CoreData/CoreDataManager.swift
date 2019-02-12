//
//  CoreDataManager.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/11.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import CoreData

protocol EntityNamable {
  static var entityName: String { get }
}

enum CoreDataResult {
  case success
  case failure(CoreDataError)
}

enum CoreDataError: Error {
  case newManagedObjectFailed
  case encodeJSONFailed
}

extension CoreDataError: CustomStringConvertible {
  var description: String {
    switch self {
    case .newManagedObjectFailed:
      return "CoreDataError: new Managed Object Failed"
    case .encodeJSONFailed:
      return "CoreDataError: encode JSON Failed"
    }
  }
}

class CoreDataManager {
  static let shared = CoreDataManager()
  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Test")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  lazy var viewContext: NSManagedObjectContext = {
    return persistentContainer.viewContext
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  // new ManagedObject
  func new<T: EntityNamable>() -> T? {
    guard let userEntity = NSEntityDescription.entity(forEntityName: T.entityName, in: viewContext) else { return nil }
    return NSManagedObject(entity: userEntity, insertInto: viewContext) as? T
  }

  func fetch<T>(request: NSFetchRequest<T>) -> [T] {
    var returnResults: [T]?
    viewContext.performAndWait({
      guard let results = try? viewContext.fetch(request) else {
        assertionFailure("CoreData fetch error")
        returnResults = []
        return
      }
      returnResults = results
    })
    return returnResults ?? []
  }
}
