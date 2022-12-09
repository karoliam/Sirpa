//
//  Post.swift
//  Sirpa
//
//  Created by Karoliina Multas on 23.11.2022.
//

import Foundation
import FirebaseFirestore

struct Posts: Identifiable {
    
    var id: String
    var file: String
    var latitude: Double
    var longitude: Double
    var notes: String
    var tripID: String
    var timeAdded: Timestamp
    
}
