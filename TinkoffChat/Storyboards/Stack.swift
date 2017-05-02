//
//  Stack.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 26/04/2017.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//


import Foundation

import CoreData



protocol CoreDataStackContextProvider
{
    var mainContext : NSManagedObjectContext? { get }
    
    var saveContext : NSManagedObjectContext? { get }
}




class CoreDataStack : CoreDataStackContextProvider {
    
    let managedObjectModelName = "Model"
    
    var _managedObjectModel : NSManagedObjectModel?
    var managedObjectModel : NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                if let modelURL = getModelURL() {
                    _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
                }
            }
            
            return _managedObjectModel
        }
    }
    
    var _persistentStoreCoordinator : NSPersistentStoreCoordinator?
    var persistentStoreCoordinator : NSPersistentStoreCoordinator? {
        get {
            if _persistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("No managed object model!")
                    
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                        configurationName: nil,
                                                                        at: getStoreURL(),
                                                                        options: nil)
                }
                catch {
                    assert(false, "error adding store to coordinator: \(error)")
                }
            }
            
            return _persistentStoreCoordinator
        }
    }
    
    var _masterContext : NSManagedObjectContext?
    var masterContext : NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("No store coordinator!")
                    
                    return nil
                }
                
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            
            return _masterContext
        }
    }
    
    var _mainContext : NSManagedObjectContext?
    var mainContext : NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    var _saveContext : NSManagedObjectContext?
    var saveContext : NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No main context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    
    
    func getStoreURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("Model.sqlite")
    }
    
    func getModelURL() -> URL? {
        guard let modelURL = Bundle.main.url(forResource:"Model",
                                             withExtension:"momd") else {
                                                return nil
        }
        return modelURL
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
