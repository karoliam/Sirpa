//
//  CoreDataManager.swift
//  Sirpa
//
//  Created by iosdev on 12/5/22.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Sirpa")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core data store failed \(error.localizedDescription)")
            }
        }
    }

    func getAllOnlineUsers() -> [OnlineUser] {

        let fetchRequest: NSFetchRequest<OnlineUser> = OnlineUser.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("getAllOnlineUsers failed")
            return []
        }
    }
    
    func saveUserID(userID: String) {
            
            let idUser = OnlineUser(context: persistentContainer.viewContext)
            idUser.userID = userID
        
            do{
                try persistentContainer.viewContext.save()
            } catch {
                print("Failed to save userid \(error)")
            }
        }
    }
