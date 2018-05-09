//
//  MyMembershipViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 26/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyMembershipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewMembershipHistory: UITableView!
    var membership :[String: Any]?
    var membershipHistory :[[String: Any]]?
    var userFullName:String?
    @IBOutlet weak var lbUserFullname: UILabel!
    @IBOutlet weak var lbCurrentMembership: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbCurrentMembership.text = UserDefaults.standard.string(forKey:"membership_level_name")! + " Member"
        lbUserFullname.text = userFullName
        
        tableViewMembershipHistory.dataSource = self
        tableViewMembershipHistory.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.membershipHistory!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Membership History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableViewMembershipHistory.dataSource = self
        let cell = tableViewMembershipHistory.dequeueReusableCell(withIdentifier: "myMemHis", for: indexPath) as! MyMembershipHistoryTableViewCell
        cell.lbMembershipName.text = membershipHistory![indexPath.row]["membership_level_name"] as? String
        //convert date format
        let startDateAsString = membershipHistory![indexPath.row]["date_created"] as! String
        let endDateAsString = membershipHistory![indexPath.row]["date_expires"] as! String
        if let startDateAsDouble = Double(startDateAsString), let endDateAsDouble = Double(endDateAsString){
            let startDate:String = DateFormat.getFormattedDate(dateToConvert: startDateAsDouble, format: "dd/MM/YYYY")
            let endDate:String = DateFormat.getFormattedDate(dateToConvert: endDateAsDouble, format: "dd/MM/YYYY")
            cell.lbDuration.text = startDate + " - " + endDate
        }
        return cell
    }
    
}

