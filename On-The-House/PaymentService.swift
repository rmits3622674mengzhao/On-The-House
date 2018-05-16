//
//  PaymentService.swift
//  On-The-House
//
//  Created by zmnwrs on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
class PaymentService{
    let memberBaseURL: URL?
    
    
    init() {
        memberBaseURL = URL(string: "http://ma.on-the-house.org/api/v1/reserve")
    }
    
    func initialPayment(member:String, completion: @escaping (Member?) -> Void) {
        if let memberURL = URL(string: "\(memberBaseURL!)/create"){
            let networkProcessor = NetworkProcessor(url: memberURL)
            networkProcessor.PostJSONFromURL(postString: member, completion: {(jsonDictionary) in
                DispatchQueue.main.sync {
                    print("service in")
                    if let status = jsonDictionary?["status"] as? String{
                        print(status)
                        if status == "success"{
                            if let memberDictionary = jsonDictionary?["member"] as? [String:Any]{
                                let member = Member(memberDiction: memberDictionary)
                                member.status = status
                                completion(member)
                            }else{
                                completion(nil)
                            }
                        }else if status == "error"{
                            print("error in")
                            let member = Member()
                            member.status = status
                            if let errormessage = jsonDictionary?["error"] as? [String:Any]{
                                if let message = errormessage["messages"] as? [String]{
                                    member.message = message
                                }
                            }
                            completion(member)
                        }else{
                            let member = Member()
                            member.status = "systemError"
                            member.message = ["System error please try gain"]
                            completion(member)
                        }
                    }
                }
            })
        }
        
    }
    
    
}
