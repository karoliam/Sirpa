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
    

    func addTripData(postID: String, userID: String, tripName: String, timeAdded: String) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Add a document to the collection
        db.collection("trip").addDocument(data: ["postID": postID, "userID": userID, "tripName": tripName, "timeAdded": timeAdded]) { error in
            if error == nil {
                //no errors
                //call get data to retreive the latest data
                self.getTripNames()
            }
            else {
                // Handle the error
            }
        }
    }
    
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
                            
                            return Trip(id: d.documentID, tripName: d["tripName"] as? String ?? "", postID: d["postID"] as? String ?? "", userID: d["userID"] as? String ?? "", timeAdded: d["timeAdded"] as? String ?? "")
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
    
    func deletePost(postToDelete: Posts) {
        // get reference to the database
        let db = Firestore.firestore()
        // specify the document ot delete
        db.collection("posts").document(postToDelete.id).delete {error in
            // check for errors
            if error == nil {
                // no errors
                // update the ui from the main thread
                DispatchQueue.main.async {
                    self.postList.removeAll { post in
                        // check for the todo to remove
                        return post.id == postToDelete.id
                    }
                }
            }
        }
    }

}
