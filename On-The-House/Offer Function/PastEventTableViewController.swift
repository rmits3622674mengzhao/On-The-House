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
    
    var postBody = [String: String]()
    var refresher:UIRefreshControl!
    var PastOffer = [OfferModel]()
    var loadPage = 1 as Int
    var MAXPAGE = 100000 as Int
    // to implement the structure of resonpse json
    struct JsonRec : Decodable{
        let status : String
        let events: [Events]
        let events_total : Int
        
        enum CodingKeys : String, CodingKey{
            case status = "status"
            case events = "events"
            case events_total = "events_total"
            
        }
    }
    
    struct Events : Decodable{
        let id : String
        let name:String
        let description:String
        let rate: Int
        
        enum CodingKeys : String, CodingKey {
            case id = "id"
            case name = "name"
            case description = "description"
            case rate = "rating"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loadPage == 1{
            getConnect(tempPage: String(loadPage))
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
    
    // generate post string
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    func getFreser(){
        if loadPage * 10 < MAXPAGE{
            loadPage = loadPage+1
            getConnect(tempPage: String(loadPage))
            tableView.reloadData()
        }else{
            refresher.attributedTitle = NSAttributedString(string: "No new data!")
        }
        refresher.endRefreshing()
    }
    
    // to get past events
    func getConnect(tempPage:String){
        //         Post request
        let urlString: String = "http://ma.on-the-house.org/api/v1/events/past"
        guard let URLreq = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        var postRequest = URLRequest(url: URLreq)
        postRequest.httpMethod = "POST"
        let postBody = [
            "page" :tempPage,
            "limit"  : "10",
            ]
        let postString = getPostString(params: postBody)
        postRequest.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: postRequest) {
            (data, response, error) in
            guard error == nil else {
                print("Error: calling POST!")
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON
            guard let receivedData = try? JSONDecoder().decode(JsonRec.self, from: responseData) else{
                print("Could not get JSON from responseData as dictionary")
                return
            }
            if receivedData.status == "success"{
                self.MAXPAGE = receivedData.events_total
                for i in receivedData.events{
                    // to get description without trailer url
                    var tempStr="" as String
                    let splitedArray = i.description.split(separator: "\r\n")
                    for i in splitedArray{
                        if (i == "Tralier" || i == "Tralier"){
                            break
                        }else{
                            tempStr = tempStr+i
                        }
                    }
                    let offer1 = OfferModel(id: i.id, name: i.name, photo: #imageLiteral(resourceName: "Logo"), description: tempStr, rate: i.rate)
                    self.PastOffer.append(offer1)
                    
                }
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
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
        if (PastOffer.count == 0)
        {
            print("Error: failed to load data!")
        }
        // #warning Incomplete implementation, return the number of rows
        return PastOffer.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PECELL"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PastEventCell else{
            fatalError("The dequeued cell is not an instance of PastEventCell.")
        }
        let pastEvents = PastOffer[indexPath.row]
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
            let selectedCell = PastOffer[indexPath.row]
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

