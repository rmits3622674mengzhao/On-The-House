//
//  SelectTitleTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 5/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class SelectStateTableViewController: UITableViewController {
    var StateKeys: [String] = Array(DataTransition.states.keys)
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
        return StateKeys.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! SelectStateTableViewCell
        cell.lbState.text = StateKeys[indexPath.row]
        if let currentStateID = UserDefaults.standard.string(forKey: "zone_id"){
            let stateIDtoString:String = DataTransition.getKey(id: Int(currentStateID)!, dictionaries: DataTransition.states)
            if (cell.lbState.text == stateIDtoString){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let currentCell = tableView.cellForRow(at: indexPath) as! SelectStateTableViewCell
        UserDefaults.standard.set(DataTransition.states[currentCell.lbState.text!], forKey: "zone_id")
        tableView.reloadData()
    }
}
