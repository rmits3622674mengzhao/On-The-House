//
//  Member.swift
//  On-The-House
//
//  Created by zmnwrs on 7/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
class Member {
    
    var id: Int?
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
    var postString:String?
    
    var status: String?
    var message: String?
    
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
    }
    
    
    init(memberDiction: [String:Any]) {
        id = memberDiction[memberKeys.id] as? Int
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
    }
    
    init(){
        
    }
    
    func setStatus(statusInput:String) {
        self.status = statusInput
    }
    
    //    func append(parentStr: String, childStr: String) -> String {
    //        return "\(parentStr)&childStr=\(childStr)"
    //    }
    
    
    func getPostString(){
        self.postString = "nickname=\(String(describing: self.nickname))&first_name=\(self.first_name)&last_name=\(self.last_name)&email=\(self.email)&password=\(self.password)&password_confirm=\(self.password_confirm)&terms=\(self.terms)&zone_id=\(self.zone_id)&country_id=\(self.country_id)&timezone_id=\(self.timezone_id)&zip=\(self.zip)"
    }
}
