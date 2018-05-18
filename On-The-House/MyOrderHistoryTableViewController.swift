//
//  MyOrderHistoryTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 21/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MyOrderHistoryTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var offerToken:OfferModel?
    var pastReservations :[[String: Any]] = [[:]]
    var memberID = ""
    var noReservation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
        }
        self.loadMyReservations()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if(self.pastReservations.count == 0){
            return 1
        }
        return self.pastReservations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderHisCell", for: indexPath) as! MyOrderHistoryTableViewCell
        if(noReservation){
            cell.lbEventName.text = "You have no past reservation!"
            cell.lbEventVenue.text = ""
            cell.lbRating.text = ""
            cell.lbVenueLabel.text = ""
        }else{
            cell.lbVenueLabel.text = "Venue:"
            cell.lbEventName.text = pastReservations[indexPath.row]["event_name"] as? String
            cell.lbEventVenue.text = pastReservations[indexPath.row]["venue_name"] as? String
            if ((pastReservations[indexPath.row]["has_rated"] as? Int) == 1){
                cell.lbRating.text = "You has rated this event!"
            }else{
                cell.lbRating.text = "Please rate this event!"
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myPastReservationDetail"){
            let detailView = segue.destination as! MyCurrentReservationDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            detailView.eventName = (self.pastReservations[(indexPath?.row)!]["event_name"] as? String)!
            detailView.eventDate = (self.pastReservations[(indexPath?.row)!]["date"] as? String)!
            detailView.ticketQty = (self.pastReservations[(indexPath?.row)!]["num_tickets"] as? String)!
            detailView.venueName = (self.pastReservations[(indexPath?.row)!]["venue_name"] as? String)!
            detailView.venueID = (self.pastReservations[(indexPath?.row)!]["venue_id"] as? String)!
        }
    }
    
    func loadMyReservations(){
        let postBodys = "member_id=\(memberID)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/reservations/past"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        self.pastReservations = (jsonDictionary?["reservations"] as? [[String: Any]])!
                        if(self.pastReservations.count != 0){
                            self.noReservation = false
                        }
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }else if status == "error"{
                        print("fail to load json")
                    }
                }
            }
        }
    }
}

