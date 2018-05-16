//
//  PreferencePageTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 2/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class PreferencePageTableViewController: UITableViewController {

    
    
    

    var preferenceList:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceList = ["Friend","LinkedIN","Facebook","Forum","Website","Yelp"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return preferenceList.count
    }
*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return preferenceList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preCell") as! PreferenceEventCell
        cell.preferenceLable.text = preferenceList[indexPath.row] as? String
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
            
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }

    
}
