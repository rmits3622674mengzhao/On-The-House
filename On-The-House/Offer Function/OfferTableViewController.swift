//
//  OfferTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import os

class OfferTableViewController: UITableViewController {
    
    
    var postBody = [String: String]()
    var dateItem = [String]()
    var refresher:UIRefreshControl!
    var catagoryItem = [String]()
    var stateItem = [String]()
    var loadPage = 1 as Int
    var MAXPAGE = 100000 as Int
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
    
    struct JsonError : Decodable{
        let status : String
        enum CodingKeys : String, CodingKey{
            case status = "status"
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
    func generatePostBody(genePage:String){
        postBody["page"] = genePage
        postBody["limit"] = "10"
        if dateItem.count == 1{
            postBody["date"] = "range"
            postBody["date_from"] = dateItem[0]
            postBody["date_to"] = dateItem[0]
        }
        if dateItem.count>1{
            postBody["date"] = "range"
            postBody["date_from"] = dateItem[0]
            postBody["date_to"] = dateItem[1]
        }
        for i in stateItem{
            postBody["zone_id[]"] = i
        }
        for j in catagoryItem{
            postBody["category_id[]"] = j
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        if loadPage == 1{
            getConnect(tempPage: String(loadPage))
        }
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refresher.addTarget(self, action: #selector(PastEventTableViewController.getFreser), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @objc func getFreser(){
        if loadPage * 10 < MAXPAGE{
            loadPage = loadPage+1
            getConnect(tempPage: String(loadPage))
            tableView.reloadData()
        }else{
            refresher.attributedTitle = NSAttributedString(string: "No new data!")
        }
        refresher.endRefreshing()
        
    }
    
    // to get current events
    func getConnect(tempPage:String){
        //         Post request
        let urlString: String = "http://ma.on-the-house.org/api/v1/events/current"
            
        guard let URLreq = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        var postRequest = URLRequest(url: URLreq)
        postRequest.httpMethod = "POST"
        generatePostBody(genePage:tempPage)
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
            
            // firstly check if the resonse is sucessful
            guard let checkStatus = try? JSONDecoder().decode(JsonError.self, from: responseData) else{
                print("Response Error!")
                return
            }
            if checkStatus.status == "success"{
                // parse the result as JSON
                
                // TODO
                guard
                    
                let receivedData = try? JSONDecoder().decode(JsonRec.self, from: responseData)
                    
                else{
                   print("Could not get JSON from responseData as dictionary")
                    return
               }
                if receivedData.status == "success"{
                    self.MAXPAGE = receivedData.events_total
                    for i in receivedData.events{
                        if let data = try? Data(contentsOf: i.image)
                        {
                            let image: UIImage = UIImage(data: data)!
                            let offer1 = OfferModel(id: i.id, name: i.name, photo: image, description: i.description, rate: i.rate, ourPrice: i.ourPrice, admin: i.admin, membershipLevel: i.membershipLevel, adminFee: i.adminFee)
                            self.offer.append(offer1)
                        }
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



