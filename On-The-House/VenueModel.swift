//
//  VenueModel.swift
//  On-The-House
//
//  Created by Kay Hoang on 18/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class VenueModel{
    var id:String?
    var address1 :String?
    var address2:String?
    var city:String?
    var zone_name:String?
    var zip:String?
    var country_name:String?
    
    struct VenueKeys {
        static let id = "id"
        static let address1 = "address1"
        static let address2 = "address2"
        static let city = "city"
        static let zone_name = "zone_name"
        static let zip = "zip"
        static let country_name = "country_name"
    }

    init(venueDiction: [String:Any]){
        id = (venueDiction[VenueKeys.id] as? String)
        address1 = (venueDiction[VenueKeys.address1] as? String)
        address2 = (venueDiction[VenueKeys.address2] as? String)
        city = (venueDiction[VenueKeys.city] as? String)
        zone_name = (venueDiction[VenueKeys.zone_name] as? String)
        zip = (venueDiction[VenueKeys.zip] as? String?)!
        country_name = (venueDiction[VenueKeys.country_name] as? String)
    }
}

