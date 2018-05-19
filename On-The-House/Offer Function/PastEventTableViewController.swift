//
//  PastEventTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit
import os

class PastEventTableViewController: UITableViewController {
    let urlString: String = "http://ma.on-the-house.org/api/v1/events/past"
    let apiConnection = APIconnection()
    var postBody = [String: String]()
    var refresher:UIRefreshControl!
    var loadPage = 1 as Int
    
    // generate post body
    func generatePostBody(genePage:String) ->[String: String] {
        var tempPostBody = [String: String]()
        tempPostBody["page"] = genePage
        tempPostBody["limit"] = "10"
        return tempPostBody
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loadPage == 1{
            apiConnection.getConnect(urlString: urlString, postBody: generatePostBody(genePage: String(loadPage)), method: "pastEvent")
        }
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refresher.addTarget(self, action: #selector(PastEventTableViewController.getFreser), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getFreser(){
        if loadPage * 10 < apiConnection.MAXPAGE{
            loadPage = loadPage+1
            apiConnection.getConnect(urlString: urlString, postBody: generatePostBody(genePage: String(loadPage)), method: "pastEvent")
            tableView.reloadData()
        }else{
            refresher.attributedTitle = NSAttributedString(string: "No new data!")
        }
        refresher.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apiConnection.offer.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PECELL"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PastEventCell else{
            fatalError("The dequeued cell is not an instance of PastEventCell.")
        }
        let pastEvents = apiConnection.offer[indexPath.row]
        cell.PastEventName.text = pastEvents.name
        cell.PastEventDescription.text = pastEvents.description
        cell.PastEventRatingControl.rating = pastEvents.rate
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destinationViewController.
        //      Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"PastDetail":
            os_log("Show Past Details.", log: OSLog.default, type: .debug)
            guard let detailViewController = segue.destination as? PastOfferDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedEventCell = sender as? PastEventCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedCell = apiConnection.offer[indexPath.row]
            detailViewController.pastOfferDetail = selectedCell
            
        default:
            print("Can't find the identifer")
            break
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

