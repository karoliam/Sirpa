//
//  ViewModel.swift
//  Sirpa
//
//  Created by Karoliina Multas on 23.11.2022.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    
    @Published var list = [Trip]()
    
    func getMemories() {
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
                        self.list = snapshot.documents.map { d in
                            // Create a todo item for each document returned
                            print("d tossa \(d)")

                            return Trip(id: d.documentID, tripName: d["tripName"] as? String ?? "")
                        }
                        print("selflist tossa \(self.list)")
                    }
                }
               

            }
            else {
                // Handle the error
            }
                
        }
    }

}
