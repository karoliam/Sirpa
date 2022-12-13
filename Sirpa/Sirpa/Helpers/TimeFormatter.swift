//
//  TimeFormatter.swift
//  Sirpa
//
//  Created by Karoliina Multas on 13.12.2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class TimeFormatter: ObservableObject {
    
    func formatDate(date: Timestamp) -> String {
        let timestampToDate = date.dateValue()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm yyyy-MM-dd"
        let dateString = formatter.string(from: timestampToDate)
        return dateString
        
    }
    
}

