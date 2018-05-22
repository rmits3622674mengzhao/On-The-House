//
//  PreferencePageTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 2/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class PreferencePageTableViewController: UITableViewController {
    
    
    static let preferenceList:[String] = ["If Google Search, what did you search for?", "Friend" , "Newsletter", "Twitter", "Facebook" , "LinkedIN" , "Forum" , "If Blog, what blog was it?", "Footy Funatics", "Toorak Times", "Only Melbourne Website", "Yelp"  , "Good Weekend website"]
    
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
        return PreferencePageTableViewController.preferenceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preCell", for: indexPath) as! PreferenceEventCell
        cell.preferenceLable.text = PreferencePageTableViewController.preferenceList[indexPath.row]
        if let currentPreference = UserDefaults.standard.string(forKey: "preference"){
            if (cell.preferenceLable.text == currentPreference){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let currentCell = tableView.cellForRow(at: indexPath) as! PreferenceEventCell
        UserDefaults.standard.set(currentCell.preferenceLable.text, forKey: "preference")
        tableView.reloadData()
    }
}

/*    var preferenceList:NSArray = []
 
 var selectedPreference = Dictionary<Int, UITableViewCell>()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 preferenceList = ["If Google Search, what did you search for?", "Friend" , "Newsletter", "Twitter", "Facebook" , "LinkedIN" , "Forum" , "If Blog, what blog was it?", "Footy Funatics", "Toorak Times", "Only Melbourne Website", "Yelp"  , "Good Weekend website"
 ]
 
 
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
 override func numberOfSections(in tableView: UITableView) -> Int {
 // #warning Incomplete implementation, return the number of sections
 return 1
 }
 
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
 let index = tableView.cellForRow(at: indexPath)?.accessibilityElementCount() as? Int
 tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
 // RECORD WHAT CELL IS SLECTED
 
 self.selectedPreference.removeValue(forKey: (index)!)
 
 }else{
 tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
 self.selectedPreference[(tableView.cellForRow(at: indexPath)?.accessibilityElementCount())!] = tableView.cellForRow(at: indexPath)
 }
 }
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 super.prepare(for: segue, sender: segue)
 switch (segue.identifier ?? "") {
 case "preferenceBack":
 guard
 let nextView = segue.destination as? RegisterViewController
 else{
 fatalError("Unexpect destination: \(segue.destination)")
 }
 nextView.defaults.set(self.selectedPreference, forKey: "selectedPreference")
 default:
 print("can't find identifier")
 break
 }
 }
 
 }
 */

