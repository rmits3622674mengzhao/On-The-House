//
//  paymentResponse.swift
//  On-The-House
//
//  Created by zmnwrs on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
class PaymentResponse{
    var status:String?
    var paypal:Int?
    var reservation_id:Int?
    var paypay_email: String?
    var item_name:String?
    var item_sku:String?
    var item_price:String?
    
    // Optional variables
    
    var item_quantity: String?
    var shipping_price: String?
    
    // error messages
    
    var messages: [String]?
    var type:String?
    
    
    
    
    
    struct paymentKeys {
        static let status = "status"
        static let paypal = "paypal"
        static let reservation_id = "reservation_id"
        static let paypal_email = "paypal_email"
        static let item_name = "item_name"
        static let item_sku = "item_sku"
        static let item_price = "item_price"
        
        // optional variables
        static let item_quantity = "item_quantity"
        static let shipping_price = "shipping_price"
        
        // error message
        static let messages = "messages"
        static let type = "type"
    }
    
    init(paymentResponseDictionary:[String:Any]) {
        status = paymentResponseDictionary[paymentKeys.status] as? String
        if(status == "success"){
            paypal = paymentResponseDictionary[paymentKeys.paypal] as? Int
            if(paypal == 1){
                reservation_id = paymentResponseDictionary[paymentKeys.reservation_id] as? Int
                paypay_email = paymentResponseDictionary[paymentKeys.paypal_email] as? String
                item_name = paymentResponseDictionary[paymentKeys.item_name] as? String
                item_sku = paymentResponseDictionary[paymentKeys.item_sku] as? String
                item_price = paymentResponseDictionary[paymentKeys.item_price] as? String
                
                do{
                    try item_quantity = paymentResponseDictionary[paymentKeys.item_quantity] as? String
                    try shipping_price = paymentResponseDictionary[paymentKeys.shipping_price] as? String
                }catch{
                    item_quantity = "not assigned"
                    shipping_price = "not assigned"
                }
            }else if(paypal == 0){
                reservation_id = paymentResponseDictionary[paymentKeys.reservation_id] as? Int
                print("The pay is success directly")
            }
//            var error = paymentResponseDictionary["error"] as? [String:Any]
//            messages = error[paymentKeys.messages] as? [String]
//            type = error[paymentKeys.type] as? String
        }
    }
    
    
    
}
