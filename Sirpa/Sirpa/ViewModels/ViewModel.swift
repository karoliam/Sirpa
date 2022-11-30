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

    let db = Firestore.firestore()

    func addTripData(postID: String, userID: String, tripName: String, timeAdded: String) {
 
        // Get a reference to the database
        
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
    
    func addPostData(file: String, location: String, notes: String, timeAdded: String, tripID: String) {
        // Get a reference to the database
        
        // Add a document to the collection
        db.collection("posts").addDocument(data: ["file": file, "location": location, "notes": notes, "timeAdded": timeAdded, "tripID": tripID]) { error in
            if error == nil {
                //no errors
                //call get data to retreive the latest data
                self.getPosts()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func updatePostData(notes: String, id: String) {
        
        DispatchQueue.main.async {
            self.db.collection("posts").document(id).updateData(["notes" : notes]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Note updated succesfully")
                }
            }

        }
    }
    
    func getTripNames() {
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
   
        // Read the documents at a specific path
        
        
        db.collection("posts").addSnapshotListener { snapshot, error in
            
            // check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        // get all the documents and create Todos
                        self.postList = snapshot.documents.map { d in
                            // Create a todo item for each document returned
                            return Posts(id: d.documentID , location: d["location"] as? String ?? "", notes: d["notes"] as? String ?? "", tripID: d["tripID"] as? String ?? "" )
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
