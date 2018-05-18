//
//  RatingViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 18/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    var eventID:String?
    var memberID:String?
    var rating:Int?
    var comments:String = ""
    var hasRated:Int?

    @IBOutlet weak var lbThankYou: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var ratingStack: RatingController!
    @IBOutlet weak var wholeRatingStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
        }
        comments = commentsTextView.text
        if (hasRated == 0){
            wholeRatingStack.isHidden = false
            lbThankYou.isHidden = true
        }else{
            wholeRatingStack.isHidden = true
            lbThankYou.isHidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rateNowbtn(_ sender: UIButton) {
        if (ratingStack.starsRating >= 1){
            rateEvent()
        }else{
            let msgMessage = "Invalid rating point!"
            OperationQueue.main.addOperation {
                self.showAlert(msgMessage: msgMessage)
            }
        }
    }
    
    func showAlert(msgMessage:String){
        let alert = UIAlertController(title: "Sorry", message: msgMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func rateEvent(){
        let postBodys = "event_id=\(eventID!)&member_id=\(memberID!)&rating=\(ratingStack.starsRating)&comments=\(comments)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/event/rate"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        DispatchQueue.main.async{
                            self.wholeRatingStack.isHidden = true
                            self.lbThankYou.isHidden = false
                        }
                    }else if status == "error"{
                        print("fail to load json")
                    }
                }
            }
        }
    }
}
