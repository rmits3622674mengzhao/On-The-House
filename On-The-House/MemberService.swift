//
//  MemberService.swift
//  On-The-House
//
//  Created by zmnwrs on 7/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation

class MemberService {
    let memberBaseURL: URL?
    
    
    init() {
        memberBaseURL = URL(string: "http://ma.on-the-house.org/api/v1/member")
    }
    
    func getById(id: String, completion: @escaping (Member?) -> Void) {
        if let memberURL = URL(string: "\(memberBaseURL!)/\(id)"){
            let networkProcessor = NetworkProcessor(url: memberURL)
            networkProcessor.downloadJSONFromURL({(jsonDictionary) in
                // ToDo some how prase jsondictionary into a swift object
                if let memberDictionary = jsonDictionary?["member"] as? [String:Any]{
                    let member = Member(memberDiction: memberDictionary)
                    completion(member)
                }else{
                    completion(nil)
                }
                
            })
        }
    }
    
    // JUST regard completion as a return
    func createMember(member:String, completion: @escaping (Member?) -> Void) {
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
                            member.message = "Your email address or password is incorrect"
                            completion(member)
                        }else{
                            let member = Member()
                            member.status = "systemError"
                            member.message = "System error please try gain"
                            completion(member)
                        }
                    }
                }
            })
        }
        
    }
    
    // login service
    
    func login(postBody:String,completion: @escaping (Member?) -> Void){
        if let memberURL = URL(string: "\(memberBaseURL!)/login"){
            let networkProcessor = NetworkProcessor(url: memberURL)
            
            networkProcessor.PostJSONFromURL(postString: postBody, completion: {(jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        if let memberDictionary = jsonDictionary?["member"] as? [String:Any]{
                            let member = Member(memberDiction: memberDictionary)
                            member.status = status
                            //cat String from json to an integerArray
                            let catJson = memberDictionary["categories"] as! String
                            if(catJson != ""){
                                let catIntArray:[Int] = (memberDictionary["categories"] as! String).components(separatedBy: ",").map { Int($0)!}
                                member.categories = catIntArray
                            }
                            completion(member)
                        }else{
                            completion(nil)
                        }
                    }else if status == "error"{
                        let member = Member()
                        member.status = status
                        if let message = jsonDictionary?["messages"] as? [String]{
                            member.message = "Your email address or password is incorrect"
                        }
                        completion(member)
                    }else{
                        completion(nil)
                    }
                }}
            )
        }
    }
    
    //Update user profile
    func updateUserProfile(memberID:String,postBody:String,completion: @escaping (Member?) -> Void){
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/\(memberID)"){
            let networkProcessor = NetworkProcessor(url: memberURL)
            networkProcessor.PostJSONFromURL(postString: postBody, completion: {(jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        if let memberDictionary = jsonDictionary?["member"] as? [String:Any]{
                            let member = Member(memberDiction: memberDictionary)
                            member.status = status
                            completion(member)
                        }else{
                            completion(nil)
                        }
                    }else if status == "error"{
                        let member = Member()
                        member.status = status
                        if let message = jsonDictionary?["messages"] as? [String]{
                            member.message = "Your email address or password is incorrect"
                        }
                        completion(member)
                    }else{
                        completion(nil)
                    }
                }}
            )
        }
    }
}

