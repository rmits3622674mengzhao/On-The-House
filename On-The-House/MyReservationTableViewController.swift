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
    
    var offerToken:OfferModel?
    var Reservations :[[String: Any]] = [[:]]
    var memberID = ""
    var noReservation = true
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
                        print("fail to load json")
                    }
                }
            }
        }
    }
}

