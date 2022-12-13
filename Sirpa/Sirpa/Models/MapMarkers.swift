//
//  MapMarkers.swift
//  Sirpa
//
//  Created by iosdev on 2.12.2022.
//

import Foundation
import CoreLocation

import FirebaseFirestore
import Firebase
struct MapMarkers: Identifiable {
    let id: String
    var coordinate: CLLocationCoordinate2D
    let file: String
    let notes: String
    let timeStamp: Timestamp
    let tripID: String
    let userID: String
}
