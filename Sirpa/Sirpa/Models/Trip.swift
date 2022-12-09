//
//  Trip.swift
//  Sirpa
//
//  Created by Karoliina Multas on 23.11.2022.
//

import Foundation
import FirebaseFirestore

struct Trip: Identifiable {
    
    var id: String
    var tripName: String
    var userID: String
    var timeAdded: Timestamp
    
}
