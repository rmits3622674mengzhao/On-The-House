//
//  MyCurrentReservationDetailViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 17/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MyCurrentReservationDetailViewController: UIViewController {
    @IBOutlet weak var lbEventName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTicketQty: UILabel!
    @IBOutlet weak var lbEventVenue: UILabel!
    @IBOutlet weak var lbVenueName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbMsg: UILabel!
    @IBOutlet weak var lbcityzone: UILabel!
    @IBOutlet weak var lbcountry: UILabel!
    @IBOutlet weak var lbzip: UILabel!
    @IBOutlet weak var RateBtn: UIButton!
    @IBOutlet weak var lbExpiredTicket: UILabel!
    @IBOutlet weak var lbRatedEvent: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    var eventID:String?
    var venueID:String?
    var eventName:String?
    var eventDate:String?
    var ticketQty:String?
    var eventVenue:String?
    var venueName:String?
    var venueAddress:String?
    var canRate:Int?
    var hasRated:Int?
    var isExpired:Bool?
    var canCancel:Int?
    var reservationID:String?
    var venue: VenueModel?
    var memberID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
        }
        lbEventName.text = eventName
        lbDate.text = eventDate
        lbTicketQty.text = ticketQty
        lbMsg.text = "You can pick up your tickets from here 30 minutes prior to show start time."
        lbEventVenue.text = eventVenue
        lbVenueName.text = venueName
        loadVenueDetail()
        checkCanRate()
        checkHasRated()
        checkIsExpired()
        checkCanCancel()
    }
    func loadVenueDetail(){
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/venue/\(venueID!)"){
            let network = NetworkProcessor(url: memberURL)
            network.downloadJSONFromURL(){jsonDictionary in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        if let venueDictionary = jsonDictionary?["venue"] as? [String:Any]{
                            self.venue = VenueModel(venueDiction: venueDictionary)
                            if let add1 = self.venue?.address1, let add2 = self.venue?.address2, let city = self.venue?.city, let zone = self.venue?.zone_name, let zip = self.venue?.zip, let country = self.venue?.country_name{
                                DispatchQueue.main.async{
                                    self.lbAddress.text = "\(add1) \(add2)"
                                    self.lbcityzone.text = "\(city), \(zone)"
                                    self.lbzip.text = zip
                                    self.lbcountry.text = country
                                }
                            }
                        }
                    }else if status == "error"{
                        print("fail to load venue detail")
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ratingSeague"){
            let ratingView = segue.destination as! RatingViewController
            ratingView.eventID = eventID
            ratingView.hasRated = hasRated
        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        let cancelAlert = UIAlertController(title: "Are you sure?", message: "No refund will be made if you cancel this ticket and you can't get the ticket back.", preferredStyle: UIAlertControllerStyle.alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Yes, I want to cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.cancelTicket()
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "No, don't cancel my ticket", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Not cancel the ticket")
        }))
        
        present(cancelAlert, animated: true, completion: nil)
    }
    
    func checkCanCancel(){
        if (canCancel == 1){
            cancelBtn.isHidden = false
        }else{
            cancelBtn.isHidden = true
        }
    }
    
    func cancelTicket(){
        let postBodys = "reservation_id=\(reservationID!)&member_id=\(memberID!)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/reservation/cancel"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        let msgMessage = "Your ticket has been canceled!"
                        OperationQueue.main.addOperation {
                            self.showAlert(msgMessage: msgMessage)
                            self.cancelBtn.isHidden = true
                        }
                    }else if status == "error"{
                        print("fail to load reservations")
                    }
                }
            }
        }
    }
    
    func showAlert(msgMessage:String){
        let alert = UIAlertController(title: "Success", message: msgMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkCanRate(){
        if (canRate == 0){
            RateBtn.isHidden = true
        }else{
            RateBtn.isHidden = false
        }
    }
    
    func checkHasRated(){
        if (hasRated == 0){
            lbRatedEvent.isHidden = true
        }else{
            lbRatedEvent.isHidden = false
        }
    }
    
    func checkIsExpired(){
        if(isExpired)!{
            lbExpiredTicket.isHidden = false
        }else{
            lbExpiredTicket.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
