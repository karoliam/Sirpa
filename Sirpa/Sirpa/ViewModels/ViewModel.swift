//
//  ViewModel.swift
//  Sirpa
//
//  Created by Karoliina Multas on 23.11.2022.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    
    @Published var tripList = [Trip]()
    @Published var postList = [Posts]()
    
    
    
    
    func getTripNames() {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Read the documents at a specific path
        
        
        db.collection("trip").getDocuments { snapshot, error in
            
            // check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        // get all the documents and create Todos
                        self.tripList = snapshot.documents.map { d in
                            // Create a todo item for each document returned
                            print("d tossa \(d)")
                            
                            return Trip(id: d.documentID, tripName: d["tripName"] as? String ?? "")
                        }
                        print("selflist tossa \(self.tripList)")
                    }
                }
                
                
            }
            else {
                // Handle the error
            }
            
        }
    }
    
    
    func getPosts() {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Read the documents at a specific path
        
        
        db.collection("posts").getDocuments { snapshot, error in
            
            // check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        // get all the documents and create Todos
                        self.postList = snapshot.documents.map { d in
                            // Create a todo item for each document returned
                            return Posts(id: d.documentID , file: d["file"] as? String ?? "", location: d["location"] as? String ?? "", notes: d["notes"] as? String ?? "", tripId: d["tripId"] as? String ?? "" )
                        }
                        print("postaukset tossa \(self.postList)")
                    }
                }
                
                
            }
            else {
                // Handle the error
            }
            
        }
    }

}
