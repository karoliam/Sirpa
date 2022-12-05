//
//  Post.swift
//  Sirpa
//
//  Created by Karoliina Multas on 23.11.2022.
//

import Foundation
struct Posts: Identifiable {
    
    var id: String
    var file: String
    var latitude: Double
    var longitude: Double
    var timeAdded: String
    var notes: String
    var tripID: String
    
}
