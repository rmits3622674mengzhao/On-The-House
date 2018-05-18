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
    var venueID:String?
    var eventName:String?
    var eventDate:String?
    var ticketQty:String?
    var eventVenue:String?
    var venueName:String?
    var venueAddress:String?
    var venue: VenueModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        lbEventName.text = eventName
        lbDate.text = eventDate
        lbTicketQty.text = ticketQty
        lbMsg.text = "You can pick up your tickets from here 30 minutes prior to show start time."
        lbEventVenue.text = eventVenue
        lbVenueName.text = venueName
        loadVenueDetail()
    }
    func loadVenueDetail(){
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/venue/\(venueID!)"){
            let network = NetworkProcessor(url: memberURL)
            network.downloadJSONFromURL(){jsonDictionary in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        if let venueDictionary = jsonDictionary?["venue"] as? [String:Any]{
                            let venue = VenueModel(venueDiction: venueDictionary)
                            self.venue = venue
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
