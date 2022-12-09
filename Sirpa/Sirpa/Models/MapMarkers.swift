//
//  MapMarkers.swift
//  Sirpa
//
//  Created by iosdev on 2.12.2022.
//

import Foundation
import FirebaseFirestore

struct MapMarkers: Identifiable {
    let id: String
    let latitude: Double
    let longitude: Double
    let file: String
    let notes: String
    let timeStamp: Timestamp
    let tripID: String
    let userID: String
}
