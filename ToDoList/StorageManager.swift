//
//  StorageManager.swift
//  ToDoList
//
//  Created by Никита Гвоздиков on 24.11.2020.
//


import UIKit
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init () {}
    
    lazy var context = persistentContainer.viewContext
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func deleteItem(at index: Int) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if var tasks = try? context.fetch(fetchRequest) {
            context.delete(tasks.remove(at: index))
        }
        saveContext()
    }
    
    func getTask() -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return nil}
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else {return nil}
        return task
    }
    
    
    func fetchData( tasks: inout [Task]) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch let error {
            print(error)
        }
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    
    
}
