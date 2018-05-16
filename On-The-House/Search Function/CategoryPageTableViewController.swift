//
//  CategoryPageTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import os

class CategoryPageTableViewController: UITableViewController {

    var checkCatagory = [String]()
    var catorylist:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        catorylist = ["Adult Industry", "Arts & Craft", "Ballet", "Cabaret", "CD (Product)", "Children", "Cirus and Physical Theatre", "Comedy", "Dance", "DVD (Product)", "Family", "Festival", "Film", "Health and Fitness", "Magic", "Miscellaneous", "Music", "Musical", "Networking, Seminars, Workshops", "Opera", "Operetta", "Reiki Course", "Speaking Engagement", "Sport", "Studio Audience", "Theatre", "Vaudeville"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catorylist.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "caCell") as! CategoryEventCell
        cell.CategoryLabel.text = catorylist[indexPath.row] as? String
        
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if let index = checkCatagory.index(of: catorylist[indexPath.row] as! String){
                checkCatagory.remove(at: index)
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            checkCatagory.append(catorylist[indexPath.row] as! String)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destinationViewController.
        //      Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"ShowCata":
            os_log("Pass category value.", log: OSLog.default, type: .debug)
            let searchedController = segue.destination as? UINavigationController
            
            guard
                let nextView = searchedController?.topViewController as? SearchViewController
                
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            nextView.defaults.set(checkCatagory, forKey: "SavedCateArray")
            
        default:
            print("Can't find the identifer")
            break
        }
    }
}


