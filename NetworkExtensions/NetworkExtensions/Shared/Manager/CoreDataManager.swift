//
//  CoreDataManager.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 05.01.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private var managedObjectModel:NSManagedObjectModel?
    private var persistentStoreCoordinator:NSPersistentStoreCoordinator?
    private var managedObjectContext:NSManagedObjectContext
    
    init() throws {
        // persistent store coordinator
        guard let directoryURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier)?.appendingPathComponent("data"),
            let modelURL = Bundle.main.url(forResource:"NetworkExtensions", withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            else {
                throw Errors.createDatabase
            }
        // create file if it doesn't exist
        if !FileManager.default.fileExists(atPath: directoryURL.absoluteString) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true,
                       NSReadOnlyPersistentStoreOption: false]
        
        // db file
        //let persistentContainer = NSPersistentContainer(name: "Network_Filter")
        let dbURL = directoryURL.appendingPathComponent("Network_Filter.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: options)
        store.didAdd(to: coordinator)
        
        persistentStoreCoordinator = coordinator
        
        // managed object context
        managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
    }
    
    enum Errors:Error {
        case createDatabase
        case missingObjectField
        case noSuchRule
        case ruleAlreadyExists
    }
    
    func fetchAll() throws -> [FilterRule] {
        var result: [FilterRule] = []
        
        let fetchRequest: NSFetchRequest<FilterRule> = FilterRule.fetchRequest();
        do {
            result = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch
        {
            NSLog("CoreDataManager :: Error on FetchAll")
        }
        return result
    }
    
    func create(filterBy: String, value: String) throws {
        let toInsert = NSEntityDescription.insertNewObject(forEntityName: "FilterRule", into: self.managedObjectContext) as! FilterRule
        toInsert.uuid = UUID()
        toInsert.filterBy = filterBy
        toInsert.value = value
        
        self.managedObjectContext.insert(toInsert)
        try self.saveContext()
    }
    
    func delete(by uuid: UUID) throws {
        let toDelete = try self.fetchByUUID(uuid: uuid)
        
        self.managedObjectContext.delete(toDelete)
        try self.saveContext()
    }
    /*
    func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NFDataContainer")

        let results = try self.managedObjectContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            self.managedObjectContext.delete(managedObjectData)
        }
    }
    */
    func fetchByUUID(uuid: UUID) throws -> FilterRule {
        var result: FilterRule = FilterRule()
        let fetchRequest: NSFetchRequest<FilterRule> = FilterRule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        
        result = try self.managedObjectContext.fetch(fetchRequest).first!
        return result
    }
    
    //MARK: - Core Data Saving/Roll back support
    func saveContext() throws {
        var caughtError:Error?
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                } catch {
                    caughtError = error
                }
            }
        }
        
        if let error = caughtError {
            throw error
        }
    }
    
    func rollbackContext () {
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                self.managedObjectContext.rollback()
            }
        }
    }
}
