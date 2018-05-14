//
//  StatePageTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import os

class StatePageTableViewController: UITableViewController {
    
    
    
    
    //    @IBAction func Done(_ sender: Any) {
    //        let controller = storyboard?.instantiateViewController(withIdentifier: "search")as! SearchViewController
    //        controller.stateItem = checkState
    //        self.present(controller, animated:true, completion:nil)
    //    }
    
    var checkState = [String]()
    var stateList:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        stateList = ["New South Wales", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia", "Australian Capital Territory"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stateList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "staCell") as! StateEventCell
        cell.stateLabel.text = stateList[indexPath.row] as? String
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if let index = checkState.index(of: stateList[indexPath.row] as! String){
                checkState.remove(at: index)
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            checkState.append(stateList[indexPath.row] as! String)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"ShowState":
            os_log("Pass state value.", log: OSLog.default, type: .debug)
            let searchedController = segue.destination as? UINavigationController
            guard
                let nextView = searchedController?.topViewController as? SearchViewController
                
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            nextView.defaults.set(checkState, forKey: "SavedStateArray")
            
        default:
            print("Can't find the identifer")
            break
        }
    }
    
}


