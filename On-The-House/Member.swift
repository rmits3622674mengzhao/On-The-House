//
//  Member.swift
//  On-The-House
//
//  Created by zmnwrs on 7/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
class Member {
    
    var id: String?
    var first_name: String?
    var last_name:String?
    var email:String?
    var password: String?
    var nickname:String?
    var password_confirm:String?
    var terms: String?
    var zone_id: String?
    var country_id: String?
    var timezone_id: String?
    var zip: String?
    var membership_level_id: String?
    var title: String?
    var age: String?
    var phone: String?
    var address1: String?
    var address2: String?
    var city: String?
    var postString:String?
    var focus_groups: String?
    var paid_marketing: String?
    var newsletters: String?
    var categories: [Int]?
    
    var status: String?
    var message: [String]?
    
    struct memberKeys {
        static let id = "id"
        static let first_name = "first_name"
        static let last_name = "last_name"
        static let email = "email"
        static let password = "password"
        static let nickname = "nickname"
        static let password_confirm = "password_confirm"
        static let terms = "terms"
        static let zone_id = "zone_id"
        static let country_id = "country_id"
        static let timezone_id = "timezone_id"
        static let zip = "zip"
        static let membership_level_id = "membership_level_id"
        static let title = "title"
        static let age = "age"
        static let phone = "phone"
        static let address1 = "address1"
        static let address2 = "address2"
        static let city = "city"
        static let focus_groups = "focus_groups"
        static let paid_marketing = "paid_marketing"
        static let newsletters = "newsletters"
        static let categories = "categories"
    }
    
    
    init(memberDiction: [String:Any]) {
        id = memberDiction[memberKeys.id] as? String
        first_name = memberDiction[memberKeys.first_name] as? String
        last_name = memberDiction[memberKeys.last_name] as? String
        email = memberDiction[memberKeys.email] as? String
        password = memberDiction[memberKeys.password] as? String
        nickname = memberDiction[memberKeys.nickname] as? String
        password_confirm = memberDiction[memberKeys.password_confirm] as? String
        terms = memberDiction[memberKeys.terms] as? String
        zone_id = memberDiction[memberKeys.zone_id] as? String
        country_id = memberDiction[memberKeys.country_id] as? String
        timezone_id = memberDiction[memberKeys.timezone_id] as? String
        zip = memberDiction[memberKeys.zip] as? String
        membership_level_id = memberDiction[memberKeys.membership_level_id] as? String
        title = memberDiction[memberKeys.title] as? String
        age = memberDiction[memberKeys.age] as? String
        phone = memberDiction[memberKeys.phone] as? String
        address1 = memberDiction[memberKeys.address1] as? String
        address2 = memberDiction[memberKeys.address2] as? String
        city = memberDiction[memberKeys.city] as? String
        focus_groups = memberDiction[memberKeys.focus_groups] as? String
        paid_marketing = memberDiction[memberKeys.paid_marketing] as? String
        newsletters = memberDiction[memberKeys.newsletters] as? String
        categories = memberDiction[memberKeys.categories] as? [Int]
    }
    
    init(){
        
    }
    
    func setStatus(statusInput:String) {
        self.status = statusInput
    }
    
    func setErrorMessage(erroMsg:[String]){
        self.message = erroMsg
    }
    
    //    func append(parentStr: String, childStr: String) -> String {
    //        return "\(parentStr)&childStr=\(childStr)"
    //    }
    
    
    func getPostString(){
        self.postString = "nickname=\(String(describing: self.nickname))&first_name=\(self.first_name)&last_name=\(self.last_name)&email=\(self.email)&password=\(self.password)&password_confirm=\(self.password_confirm)&terms=\(self.terms)&zone_id=\(self.zone_id)&country_id=\(self.country_id)&timezone_id=\(self.timezone_id)&zip=\(self.zip)"
    }
}

