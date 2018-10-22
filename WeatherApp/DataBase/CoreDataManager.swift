//
//  File.swift
//  WeatherApp
//
//  Created by MacBook on 10/19/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Weather14DayModel")
        container.loadPersistentStores(completionHandler: {( _, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertName(name: String) -> WeatherForecastCoreDate? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: "WeatherForecastCoreDate", in: managedContext) else {
                return nil
        }
        
        let weatherForecastCoreDate = NSManagedObject(entity: entity,
                                                      insertInto: managedContext)
        weatherForecastCoreDate.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            return weatherForecastCoreDate as? WeatherForecastCoreDate
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func delete(name: WeatherForecastCoreDate) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        managedContext.delete(name)
        do {
            try managedContext.save()
        } catch {
        }
    }
    
    func fetchAll() -> [WeatherForecastCoreDate]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherForecastCoreDate")
        
        do {
            let people = try managedContext.fetch(fetchRequest)
            return people as? [WeatherForecastCoreDate]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
