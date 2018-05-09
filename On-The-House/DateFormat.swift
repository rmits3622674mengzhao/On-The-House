//
//  DateFormat.swift
//  On-The-House
//
//  Created by Kay Hoang on 27/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
struct DateFormat {
    
    static func getFormattedDate(dateToConvert: Double, format: String) -> String {
        let date = NSDate(timeIntervalSince1970: dateToConvert)
        let dateFormating = DateFormatter()
        dateFormating.dateFormat = format
        return dateFormating.string(from: date as Date)
    }
}

