//
//  OfferTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 22/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import os

class OfferTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    func sideMenus() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    var offer = [OfferModel]()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        getConnect()
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // to get current events
    func getConnect(){
        //         to get current date as yyyy-mm-dd
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        //         Post request
        let urlString: String = "http://ma.on-the-house.org/api/v1/events/current"
        guard let URLreq = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        var postRequest = URLRequest(url: URLreq)
        postRequest.httpMethod = "POST"
        //        let postBody: [String: Any] = ["page":1,"limit":10,"date":dateString,"category_id":[5,15,38],"zone_id":[16,18,22]]
        let postBody: [String: Any] = ["page":1,"limit":10]
        let postJson: Data
        do {
            postJson = try JSONSerialization.data(withJSONObject: postBody, options: [])
            postRequest.httpBody = postJson
        } catch {
            print("Error: cannot create postJSON")
            return
        }
        
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
                        self.offer.append(offer1)
                    }
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (offer.count == 0)
        {
            print("Error: failed to load data!")
        }
        // #warning Incomplete implementation, return the number of rows
        return offer.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CECell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OfferEventCell  else {
            fatalError("The dequeued cell is not an instance of OfferEventCell.")
        }
        let offerEvents = offer[indexPath.row]
        cell.NameLabel.text = offerEvents.name
        cell.ImageView.image = offerEvents.photo
        cell.ratingControl.rating  = offerEvents.rate
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destinationViewController.
        //      Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"ShowDetail":
            os_log("Show Details.", log: OSLog.default, type: .debug)
            guard let detailViewController = segue.destination as? OfferDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedEventCell = sender as? OfferEventCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedCellImage = offer[indexPath.row]
            detailViewController.offerDetail = selectedCellImage
            
        default:
            print("Can't find the identifer")
            break
        }
    }
    
    @IBAction func ShareButton(_ sender: Any) {
        
        let activity = UIActivityViewController(activityItems: [#imageLiteral(resourceName: "Logo")], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        self.present(activity, animated: true, completion: nil)
        
        //        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
        //            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        //
        //            self.present(fbShare, animated: true, completion: nil)
        //
        //        } else {
        //            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
        //
        //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //            self.present(alert, animated: true, completion: nil)

    }
    
}



