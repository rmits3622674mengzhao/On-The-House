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
    
    var name: String
    var photo: UIImage?
    var Description: String
    
    init(name:String, photo:UIImage, Description:String){
        self.name = name
        self.photo = photo
        self.Description = Description
        
    }
    
    
}
