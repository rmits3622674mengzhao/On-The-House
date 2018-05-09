//
//  SearchedTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 2018/5/8.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit
import os

class SearchTableViewController: UITableViewController {
    
    var postBody = [String: String]()
    var dateItem = "" as String
    var catagoryItem = [String]()
    var stateItem = [String]()
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
    var searchedOffer = [OfferModel]()
    // to implement the structure of resonpse json
    struct JsonRec : Decodable{
        let status : String
        let events: [Events]
        
        enum CodingKeys : String, CodingKey{
            case status = "status"
            case events = "events"
        }
    }
    
    struct Events : Decodable{
        let id : String
        let name:String
        let image: URL
        let description:String
        let rate: Int
        let ourPrice : String
        let admin : String
        let membershipLevel: String
        let adminFee: String
        
        enum CodingKeys : String, CodingKey {
            case id = "id"
            case name = "name"
            case image = "image_url"
            case description = "description"
            case rate = "rating"
            case ourPrice = "full_price_string"
            case admin = "our_price_heading"
            case membershipLevel = "membership_levels"
            case adminFee = "our_price_string"
        }
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
    
    // generate post body
    func generatePostBody(){
        for i in stateItem{
            postBody["zone_id[]"] = i
        }
        for j in catagoryItem{
            postBody["category_id[]"] = j
        }
        print("----------")
        print(postBody)
        print("----------")
    }
    
    // to get current events
    func getConnect(){
        //         Post request
        let urlString: String = "http://ma.on-the-house.org/api/v1/events/current"
        guard let URLreq = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        var postRequest = URLRequest(url: URLreq)
        postRequest.httpMethod = "POST"
        generatePostBody()
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
                for i in receivedData.events{
                    if let data = try? Data(contentsOf: i.image)
                    {
                        let image: UIImage = UIImage(data: data)!
                        let offer1 = OfferModel(id: i.id, name: i.name, photo: image, description: i.description, rate: i.rate, ourPrice: i.ourPrice, admin: i.admin, membershipLevel: i.membershipLevel, adminFee: i.adminFee)
                        self.searchedOffer.append(offer1)
                    }
                }
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnect()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return searchedOffer.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SECELL"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell  else {
            fatalError("The dequeued cell is not an instance of OfferEventCell.")
        }
        let searchedEvents = searchedOffer[indexPath.row]
        cell.Name.text = searchedEvents.name
        cell.EventImage.image = searchedEvents.photo
        cell.Rate.rating  = searchedEvents.rate
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destinationViewController.
        //      Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"SEeventsShow":
            os_log("Show Searched events Details.", log: OSLog.default, type: .debug)
            guard let detailViewController = segue.destination as? OfferDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedEventCell = sender as? SearchTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedCell = searchedOffer[indexPath.row]
            detailViewController.offerDetail = selectedCell
            
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

