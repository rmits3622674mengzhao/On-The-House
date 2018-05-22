//
//  DataTransition.swift
//  On-The-House
//
//  Created by Kay Hoang on 29/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation

class DataTransition {
    //get timezone based on timezone_id
    static let timezones:[String : Int] = ["(GMT+08:00) Perth" : 92, "(GMT+09:30) Adelaide" : 100, "(GMT+09:30) Darwin": 101, "(GMT+10:00) Brisbane": 102, "(GMT+10:00) Canberra": 103, "(GMT+10:00) Hobart": 105, "(GMT+10:00) Melbourne": 106, "(GMT+10:00) Sydney": 108]
    //get state based on zone_id
    static let states:[String : Int] = ["New South Wales" : 211, "Northern Territory": 212, "Queensland" : 213, "South Australia": 214, "Tasmania": 215, "Victoria": 216, "Western Australia": 217, "Australian Capital Territory": 210]
    
    static let questions:[String: Int] = ["If Google Search, what did you search for?" : 1,"Friend" : 2, "Newsletter": 3, "Twitter": 4, "Facebook" : 5, "LinkedIN" : 6, "Forum" : 7, "If Blog, what blog was it?": 22, "Footy Funatics": 26, "Toorak Times": 27, "Only Melbourne Website": 28, "Yelp" :29 , "Good Weekend website" : 30
        
    ]
    static let statetimezone:[String : Int] = ["New South Wales" : 108, "Northern Territory": 101, "Queensland" : 102, "South Australia": 100, "Tasmania": 105, "Victoria": 106, "Western Australia": 92, "Australian Capital Territory": 103]
    static let categories:[String: Int] = ["Adult Industry": 28, "Arts & Craft": 22, "Ballet" : 9, "Cabaret" : 17, "CD (Product)": 37, "Children": 26, "Cirus and Physical Theatre": 16, "Comedy": 5, "Dance": 6, "DVD (Product)": 35, "Family": 32, "Festival": 15, "Film": 3, "Health and Fitness": 30, "Magic" : 38, "Miscellaneous":7, "Music": 4, "Musical":2, "Networking, Seminars, Workshops": 27, "Opera":8, "Operetta": 18, "Reiki Course": 20, "Speaking Engagement": 34, "Sport": 33, "Studio Audience": 31, "Theatre": 1, "Vaudeville": 19
    ]
    
    //universal function to get key
    static func getKey (id: Int, dictionaries: [String: Int]) -> String {
        var getString = ""
        for dictionary in dictionaries {
            if dictionary.value == id {
                getString = dictionary.key
                break
            }
        }
        return getString
    }
}
