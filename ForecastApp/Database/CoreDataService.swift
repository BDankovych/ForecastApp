//
//  CoreDataService.swift
//  ForecastApp
//
//  Created by Bohdan Dankovych on 11/18/18.
//  Copyright © 2018 Bohdan Dankovych. All rights reserved.
//

import UIKit
import CoreData


class CoreDataService {
    
    static let instance: CoreDataService = CoreDataService()
    
    private init(){ }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "ForecastApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = AppDelegate.applicationDocumentsDirectory.appendingPathComponent("ForecastAppDB.sqlite")
        var error: Error? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    static func loadAllCities() -> [PlaceModel] {
        return []
    }
    
    private func getObjects<T: NSManagedObject>(_ entity: T.Type, moc: NSManagedObjectContext? = nil, fetchRequest: NSFetchRequest<NSFetchRequestResult>? = nil) -> [T] {
        
        guard let moc = moc ?? CoreDataService.instance.managedObjectContext else {
            return []
        }
        
        var resutArray: [T] = []
        let fetchRequest = fetchRequest ?? NSFetchRequest(entityName: "\(entity)")
        
        resutArray = executeFetchRequest(fetchRequest, moc: moc) ?? []
        
        return resutArray
    }
    
    private static func insertObject<T: NSManagedObject>(_ entity: T.Type, moc: NSManagedObjectContext? = nil) -> T? {
        
        guard let moc = moc ?? CoreDataService.instance.managedObjectContext else {
            return nil
        }
        
        var newObject: T? = nil
        let entityName = "\(entity)"
        newObject = NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                        into: moc) as? T
        
        return newObject
    }
    
    private func executeFetchRequest<T: NSManagedObject>(_ request: NSFetchRequest<NSFetchRequestResult>, moc: NSManagedObjectContext) -> [T]? {
        
        var error: Error? = nil
        var result: [T]? = nil
        
        do {
            result = try moc.fetch(request) as? [T]
        } catch let catchedError {
            error = catchedError
        }
        
        if error != nil {
            result =  nil
        }
        
        return result
    }
}
