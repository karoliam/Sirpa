//
//  CoreDataManager.swift
//  Sirpa
//
//  Created by iosdev on 12/5/22.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    let container =  NSPersistentContainer(name: "Sirpa")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core data store failed \(error.localizedDescription)")
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("jee data on tallennettu")
        } catch {
            print("buu data ei tallennettu")
        }
    }
    
    func getAllOnlineUsers() -> [OnlineUser] {

        let fetchRequest: NSFetchRequest<OnlineUser> = OnlineUser.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("getAllOnlineUsers failed")
            return []
        }
    }
    
    func saveUserID(userID: String, context: NSManagedObjectContext) {
            
            let idUser = OnlineUser(context: context)
            idUser.userID = userID
            
        save(context: context)
        }
    }
