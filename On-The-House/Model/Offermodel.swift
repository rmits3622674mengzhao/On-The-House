//
//  OfferModel.swift
//  On-The-House
//
//  Created by beier nie on 22/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class OfferModel{
    var id : String
    var name: String
    var photo: UIImage?
    var description: String
    var ourPrice: String
    var admin: String
    var membershipLevel:String
    var adminFee:String
    var rate:Int
    var competition: Bool
    
    init(id: String, name:String, photo:UIImage, description: String, rate:Int, ourPrice:String,admin:String,membershipLevel:String,adminFee:String,competition:Bool){
        self.id = id
        self.name = name
        self.photo = photo
        self.description = description
        self.rate = rate
        self.ourPrice = ourPrice
        self.admin = admin
        self.membershipLevel = membershipLevel
        self.adminFee = adminFee
        self.competition = competition
    }
    
    init(id: String, name: String,  photo:UIImage, description:String, rate:Int) {
        self.id = id
        self.name = name
        self.description = description
        self.rate = rate
        self.ourPrice = ""
        self.admin = ""
        self.adminFee = ""
        self.membershipLevel = ""
        self.competition = false
       
    }
}

