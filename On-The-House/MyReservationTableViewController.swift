//
//  MyReservationTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 19/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import UIKit

class MyReservationTableViewController: UITableViewController{
    
    //var offerToken:OfferModel?
    var Reservations :[[String: Any]] = [[:]]
    var Venue : [String:Any] = [:]
    var memberID = ""
    var noReservation = true
    var venueToken:VenueModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
            print("This is member ID: \(memberID)")
        }
        self.loadMyReservations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.Reservations.count == 0){
            return 1
        }
        return self.Reservations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as! MyReservationTableViewCell
        if(noReservation){
            cell.nameCell.text = "You have no current reservation!"
            cell.lbVenueName.text = ""
            cell.lbVenueLabel.text = ""
        }else{
            cell.lbVenueLabel.text = "Venue:"
            cell.nameCell.text = Reservations[indexPath.row]["event_name"] as? String
            cell.lbVenueName.text = Reservations[indexPath.row]["venue_name"] as? String
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myReservationDetail"){
            let detailView = segue.destination as! MyCurrentReservationDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            detailView.eventName = (self.Reservations[(indexPath?.row)!]["event_name"] as? String)!
            detailView.eventDate = (self.Reservations[(indexPath?.row)!]["date"] as? String)!
            detailView.ticketQty = (self.Reservations[(indexPath?.row)!]["num_tickets"] as? String)!
            detailView.venueName = (self.Reservations[(indexPath?.row)!]["venue_name"] as? String)!
            detailView.venueID = (self.Reservations[(indexPath?.row)!]["venue_id"] as? String)!
            detailView.eventID = (self.Reservations[(indexPath?.row)!]["event_id"] as? String)!
            detailView.canRate = (self.Reservations[(indexPath?.row)!]["can_rate"] as? Int)!
            detailView.hasRated = (self.Reservations[(indexPath?.row)!]["has_rated"] as? Int)!
            detailView.canCancel = (self.Reservations[(indexPath?.row)!]["can_cancel"] as? Int)!
            detailView.reservationID = (self.Reservations[(indexPath?.row)!]["reservation_id"] as? String)!
            detailView.isExpired = false
        }
    }
    
    func loadMyReservations(){
        let postBodys = "member_id=\(memberID)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/reservations"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        self.Reservations = (jsonDictionary?["reservations"] as? [[String: Any]])!
                        if(self.Reservations.count != 0){
                            self.noReservation = false
                        }
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }else if status == "error"{
                        print("fail to load reservations")
                    }
                }
            }
        }
    }
}

