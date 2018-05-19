//
//  APIconnection.swift
//  On-The-House
//
//  Created by beier nie on 17/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import Foundation

class APIconnection {
    var MAXPAGE = 100000 as Int
    var offer = [OfferModel]()
    var errorStatus : Bool!
    
    // to implement the structure of resonpse(current events) json
    struct JsonRec : Decodable{
        let status : String
        let events: [Events]
        let events_total : Int
        
        enum CodingKeys : String, CodingKey{
            case status = "status"
            case events = "events"
            case events_total = "events_total"
        }
    }
    
    struct Events : Decodable{
        let id : String
        let name:String
        let image: URL
        let description:String
        let rate: Int
        let ourPrice : String
        let admin : String
        let membershipLevel: String
        let adminFee: String
        
        enum CodingKeys : String, CodingKey {
            case id = "id"
            case name = "name"
            case image = "image_url"
            case description = "description"
            case rate = "rating"
            case ourPrice = "full_price_string"
            case admin = "our_price_heading"
            case membershipLevel = "membership_levels"
            case adminFee = "our_price_string"
        }
    }
    
    struct JsonError : Decodable{
        let status : String
        enum CodingKeys : String, CodingKey{
            case status = "status"
        }
    }
    
    // to implement the structure of resonpse(past events) json
    struct JsonPast : Decodable{
        let status : String
        let events: [PastEvents]
        let events_total : Int
        
        enum CodingKeys : String, CodingKey{
            case status = "status"
            case events = "events"
            case events_total = "events_total"
            
        }
    }
    
    struct PastEvents : Decodable{
        let id : String
        let name:String
        let description:String
        let rate: Int
        
        enum CodingKeys : String, CodingKey {
            case id = "id"
            case name = "name"
            case description = "description"
            case rate = "rating"
        }
    }
    
    // generate post string
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    // to get current or past events  or check if any events can repsonse
    public func getConnect(urlString :String, postBody:[String: String], method:String){
        
        guard let URLreq = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        var postRequest = URLRequest(url: URLreq)
        postRequest.httpMethod = "POST"
        let postString = getPostString(params: postBody)
        postRequest.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: postRequest) {
            (data, response, error) in
            guard error == nil else {
                print("Error: calling POST!")
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            if method == "checkStatus"{
                // firstly check if the resonse is sucessful
                guard let checkStatus = try? JSONDecoder().decode(JsonError.self, from: responseData) else{
                    print("Response Error!")
                    return
                }
                if checkStatus.status == "success"{
                    self.errorStatus = true
                }else{
                    self.errorStatus = false
                }
                
            }
            
            // parse the current events result as JSON
            if method == "currentEvent"{
                guard let receivedData = try? JSONDecoder().decode(JsonRec.self, from: responseData) else{
                    print("Could not get Current events JSON from responseData as dictionary")
                    return
                }
                if receivedData.status == "success"{
                    self.MAXPAGE = receivedData.events_total
                    for i in receivedData.events{
                        if let data = try? Data(contentsOf: i.image)
                        {
                            let image: UIImage = UIImage(data: data)!
                            let offer1 = OfferModel(id: i.id, name: i.name, photo: image, description: i.description, rate: i.rate, ourPrice: i.ourPrice, admin: i.admin, membershipLevel: i.membershipLevel, adminFee: i.adminFee)
                            self.offer.append(offer1)
                        }
                    }
                }
            }
            if method == "pastEvent"{
                guard let receivedData = try? JSONDecoder().decode(JsonPast.self, from: responseData) else{
                    print("Could not get Past events JSON from responseData as dictionary")
                    return
                }
                if receivedData.status == "success"{
                    self.MAXPAGE = receivedData.events_total
                    for i in receivedData.events{
                        // to get description without trailer url
                        var tempStr="" as String
                        let splitedArray = i.description.split(separator: "\r\n")
                        for i in splitedArray{
                            if (i == "Tralier"){
                                break
                            }else{
                                tempStr = tempStr+i
                            }
                        }
                        let offer1 = OfferModel(id: i.id, name: i.name, photo: #imageLiteral(resourceName: "Logo"), description: tempStr, rate: i.rate)
                        self.offer.append(offer1)
                        
                    }
                }
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
}

