//
//  ViewModel.swift
//  Sirpa
//
//  Created by Karoliina Multas on 23.11.2022.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ViewModel: ObservableObject {
    
    @Published var tripList = [Trip]()
    @Published var postList = [Posts]()
    @Published var userList = [User]()
    @Published var retrievedImages = [UIImage]()
    @Published var imageDictionary = [String:UIImage]()

    let db = Firestore.firestore()
    
    func retreiveAllPostPhotos() {
        // get the data from the database
        db.collection("posts").addSnapshotListener { snapshot, error in
            if error == nil && snapshot != nil {
                
                var paths = Dictionary<String, String>()
                // loop through all the returned docs
                for doc in snapshot!.documents {
                    // extract the file path
                    paths.updateValue(doc[ "file"] as! String, forKey: doc.documentID)
                }
                
                // loop through each file path and fetch the data from storage
                for path in paths {
                    // get a reference to storage
                    let storageRef = Storage.storage().reference()
                    // specify the path
                    let fileRef = storageRef.child(path.value)
                    // retreive the data
                    fileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        // check for errors
                        if error == nil && data != nil {
                            // create a UIImage and put it in our array for display
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    self.retrievedImages.append(image)
                                    self.imageDictionary.updateValue(image, forKey: path.key)
                                    
                                }
                            }
                        }
                    }
                } // end loop throughs
            }
        }
    }
    

    func addTripData(userID: String, tripName: String, timeAdded: Timestamp) {
 
        // Get a reference to the database
        
        // Add a document to the collection
        db.collection("trip").addDocument(data: ["userID": userID, "tripName": tripName, "timeAdded": timeAdded]) { error in
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
    
    func addPostData(file: String, latitude: Double, longitude: Double, notes: String, tripID: String, timeAdded: Timestamp) {
        // Get a reference to the database
        
        // Add a document to the collection
        db.collection("posts").addDocument(data: ["file": file, "latitude": latitude, "longitude": longitude, "notes": notes, "tripID": tripID, "timeAdded": timeAdded]) { error in
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
    
    func addUserData(file: String, homeCountry: String, username: String, timeAdded: Timestamp) {
        
        db.collection("userInfo").addDocument(data: ["file": file, "homeCountry": homeCountry, "username": username, "timeAdded": timeAdded]) { error in
            if error == nil {
                self.getUserInfo()
            }
            else {
                // handle error
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
    
    func getUserInfo() {
        
        db.collection("userInfo").addSnapshotListener { snapshot, error in
            
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.userList = snapshot.documents.map { d in
                            return User(id: d.documentID, file: d["file"] as? String ?? "", homeCountry: d["homeCountry"] as? String ?? "",
                                        username: d["username"] as? String ?? "", timeAdded: d["timeAdded"] as? Timestamp ?? Timestamp()

                            )
                            
                        }.sorted(by: {$0.timeAdded.compare($1.timeAdded) == .orderedDescending})
                    }
                } else {
                    // error
                }
            }
        }
    }
    
    func getTripNames() {
        // Read the documents at a specific path
        db.collection("trip").addSnapshotListener { snapshot, error in
            
            // check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        // get all the documents and create Todos
                        self.tripList = snapshot.documents.map { d in
                            // Create a todo item for each document returned
                            
                            return Trip(id: d.documentID, tripName: d["tripName"] as? String ?? "", userID: d["userID"] as? String ?? "", timeAdded: d["timeAdded"] as? Timestamp ?? Timestamp())
                        }.sorted(by: {$0.timeAdded.compare($1.timeAdded) == .orderedDescending})
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
                            return Posts(id: d.documentID, file: d["file"] as? String ?? "", latitude: d["latitude"] as? Double ?? 0.0 , longitude: d["longitude"] as? Double ?? 0.0, notes: d["notes"] as? String ?? "", tripID: d["tripID"] as? String ?? "",  timeAdded: d["timeAdded"] as? Timestamp ?? Timestamp())
                        }
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
