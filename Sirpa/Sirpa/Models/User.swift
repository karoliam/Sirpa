//
//  User.swift
//  Sirpa
//
//  Created by Karoliina Multas on 30.11.2022.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable {
    
    var id: String
    var file: String
    var homeCountry: String
    var username: String
    var timeAdded: Timestamp
}
