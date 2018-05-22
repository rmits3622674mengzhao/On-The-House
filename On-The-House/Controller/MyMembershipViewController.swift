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
    var memberID:String?
    var membershipHistory :[[String: Any]] = [[:]]
    @IBOutlet weak var lbUserFullname: UILabel!
    @IBOutlet weak var lbCurrentMembership: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMembershipHistory.dataSource = self
        tableViewMembershipHistory.delegate = self
        self.memberID = UserDefaults.standard.string(forKey: "member_id")!
        lbCurrentMembership.text = UserDefaults.standard.string(forKey:"membership_level_name")! + " Member"
        lbUserFullname.text = UserDefaults.standard.string(forKey:"first_name")! + " " + UserDefaults.standard.string(forKey:"last_name")!
        loadMembershipHistory()
    }
    func loadMembershipHistory(){
        let postBodys = "member_id=\(memberID!)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/membership/history"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        self.membershipHistory = (jsonDictionary?["memberships"] as? [[String: Any]])!
                        DispatchQueue.main.async{
                            self.tableViewMembershipHistory.reloadData()
                        }
                    }else if status == "error"{
                        print("fail to load json")
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.membershipHistory.count)
        return self.membershipHistory.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Membership History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewMembershipHistory.dataSource = self
        let cell = tableViewMembershipHistory.dequeueReusableCell(withIdentifier: "myMemHis", for: indexPath) as! MyMembershipHistoryTableViewCell
        cell.lbMembershipName.text = membershipHistory[indexPath.row]["membership_level_name"] as? String
        //convert date format
        let startDateAsString = membershipHistory[indexPath.row]["date_created"] as? String
        let endDateAsString = membershipHistory[indexPath.row]["date_expires"] as? String
        if let startDateAsDouble = startDateAsString?.toDouble(), let endDateAsDouble = endDateAsString?.toDouble(){
            let startDate:String = DateFormat.getFormattedDate(dateToConvert: startDateAsDouble, format: "dd/MM/YYYY")
            let endDate:String = DateFormat.getFormattedDate(dateToConvert: endDateAsDouble, format: "dd/MM/YYYY")
            cell.lbDuration.text = startDate + " - " + endDate
        }
        return cell
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

