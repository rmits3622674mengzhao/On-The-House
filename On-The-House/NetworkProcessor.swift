//
//  NetworkProcessor.swift
//  On-The-House
//
//  Created by zmnwrs on 7/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkProcessor
{
    // the reason why we use lazy here is that we don't need to down load the think from url until we need it
    lazy var configuration:URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        
    }
    
    // string will be saved as a dictionary here in that type:
    // reason why we use a () : like a signature of function??? why we need a () here?
    // my understanding is that () is like a function you passed around
    // like array in JAVA
    typealias JSONDictionaryHandler = (([String:Any]?) -> Void)
    
    func downloadJSONFromURL(_ completion: @escaping JSONDictionaryHandler){
        // this is the request we used for api call
        let request = URLRequest(url: self.url)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        // ok
                        if let data = data{
                            do {
                                let jsonDictionary =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                
                                completion(jsonDictionary as? [String:Any])
                            }catch let error as NSError{
                                print("\(error.localizedDescription)")
                                
                            }
                            
                        }
                    default:
                        print("Http response Code: \(httpResponse.statusCode)")
                    }
                }
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
    
    
    func PostJSONFromURL(postString: String, completion: @escaping JSONDictionaryHandler){
        // this is the request we used for api call
        var request = URLRequest(url: self.url)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        // ok
                        if let data = data{
                            do {
                                let jsonDictionary =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                print("responseString = \(jsonDictionary)")
                                
                                completion(jsonDictionary as? [String:Any])
                            }catch let error as NSError{
                                print("\(error.localizedDescription)")
                                
                            }
                            
                        }
                    default:
                        print("Http response Code: \(httpResponse.statusCode)")
                    }
                }
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
    static var postStatus: String = ""
    static var errorMesg: String = ""
    //HTTP post method- universal return error messages from the server
    static func post(command: String, parameter: [String: Any], compeletion: @escaping (Member?) -> Void){
        let url = "https://ma.on-the-house.org/" + command
        Alamofire.request(url, method: .post, parameters: parameter).responseJSON { (response) in
            switch response.result {
            case .success(_):
                self.postStatus = JSON(response.data!)["status"].string!
                if self.postStatus == "success"
                {
                    let json = JSON(response.data!)
                    if let memberDictionary = json["member"].dictionaryObject as? [String:Any]{
                        let member = Member(memberDiction: memberDictionary)
                        member.status = self.postStatus
                        compeletion(member)
                    }else{
                        compeletion(nil)
                    }
                }
                else
                {
                    var message: [String] = []
                    self.errorMesg = "The request has failed"
                    
                    let mesg = JSON(response.data!)["error"]["messages"].array!
                    
                    for m in mesg {
                        message.append(m.string!)
                        print(m)
                    }
                    compeletion(nil)
                }
            case .failure(_):
                print("connection faild")
                compeletion(nil)
            }
        }
    }
}





