//
//  SelectTitleTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 5/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class SelectTimeZoneTableViewController: UITableViewController {
    var TimeZoneKeys: [String] = Array(DataTransition.timezones.keys)
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return TimeZoneKeys.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timezoneCell", for: indexPath) as! SelectTimeZoneTableViewCell
        cell.lbTimeZone.text = TimeZoneKeys[indexPath.row]
        if let currentTimezoneID = UserDefaults.standard.string(forKey: "timezone_id"){
            let timeZoneIDtoString:String = DataTransition.getKey(id: Int(currentTimezoneID)!, dictionaries: DataTransition.timezones)
            if (cell.lbTimeZone.text == timeZoneIDtoString){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let currentCell = tableView.cellForRow(at: indexPath) as! SelectTimeZoneTableViewCell
        UserDefaults.standard.set(DataTransition.timezones[currentCell.lbTimeZone.text!], forKey: "timezone_id")
        tableView.reloadData()
    }
}
