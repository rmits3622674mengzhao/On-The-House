//
//  SelectTitleTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 5/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class SelectAgeGroupTableViewController: UITableViewController {
    static let ageGroup:[String] = ["< 15", "15 - 20", "21 - 30", "31 - 40", "41 - 50", "51 - 60", "61 - 70", "71 - 80", "> 80"]
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
        return SelectAgeGroupTableViewController.ageGroup.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ageCell", for: indexPath) as! SelectAgeGroupTableViewCell
        cell.lbAge.text = SelectAgeGroupTableViewController.ageGroup[indexPath.row]
        if let currentAge = UserDefaults.standard.string(forKey: "age"){
            if (cell.lbAge.text == currentAge){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let currentCell = tableView.cellForRow(at: indexPath) as! SelectAgeGroupTableViewCell
        UserDefaults.standard.set(currentCell.lbAge.text, forKey: "age")
        tableView.reloadData()
    }
}
