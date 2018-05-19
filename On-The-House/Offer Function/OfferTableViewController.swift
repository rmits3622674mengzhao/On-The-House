import UIKit
import os

class OfferTableViewController: UITableViewController {
    
    let urlString: String = "http://ma.on-the-house.org/api/v1/events/current"
    let apiConnection = APIconnection()
    var dateItem = [String]()
    var refresher:UIRefreshControl!
    var catagoryItem = [String]()
    var stateItem = [String]()
    var loadPage = 1 as Int
     var islogedIn:Bool?
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
    
    // generate post body
    func generatePostBody(genePage:String) ->[String: String] {
        var tempPostBody = [String: String]()
        tempPostBody["page"] = genePage
        tempPostBody["limit"] = "10"
        if dateItem.count == 1{
            tempPostBody["date"] = "range"
            tempPostBody["date_from"] = dateItem[0]
            tempPostBody["date_to"] = dateItem[0]
        }
        if dateItem.count>1{
            tempPostBody["date"] = "range"
            tempPostBody["date_from"] = dateItem[0]
            tempPostBody["date_to"] = dateItem[1]
        }
        for i in stateItem{
            tempPostBody["zone_id[]"] = i
        }
        for j in catagoryItem{
            tempPostBody["category_id[]"] = j
        }
        return tempPostBody
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        islogedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        sideMenus()
        if loadPage == 1{
            apiConnection.getConnect(urlString: urlString, postBody: generatePostBody(genePage: String(loadPage)), method: "currentEvent")
        }
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refresher.addTarget(self, action: #selector(OfferTableViewController.getFreser), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @objc func getFreser(){
        if loadPage * 10 < apiConnection.MAXPAGE{
            loadPage = loadPage+1
            apiConnection.getConnect(urlString: urlString , postBody: generatePostBody(genePage: String(loadPage)), method: "currentEvent")
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apiConnection.offer.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CECell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OfferEventCell  else {
            fatalError("The dequeued cell is not an instance of OfferEventCell.")
        }
        let offerEvents = apiConnection.offer[indexPath.row]
        cell.NameLabel.text = offerEvents.name
        cell.ImageView.image = offerEvents.photo
        cell.ratingControl.rating  = offerEvents.rate
        
        if offerEvents.membershipLevel.contains("Bronze") {
            cell.MemberLabel.isHidden = true
        }else{
            cell.MemberLabel.isHidden = false
        }
         islogedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if let membershipName = UserDefaults.standard.string(forKey:"membership_level_name"), let logincheck = islogedIn{
            if logincheck  && membershipName == "Bronze"{
                print(membershipName)
            cell.loginBtn.isHidden = true
                if offerEvents.membershipLevel.contains("Bronze"){
                    cell.upgradeBtn.isHidden = true
                }else{cell.ticketBtn.isHidden = true}
        }else if logincheck  && membershipName == "Gold"{
            cell.loginBtn.isHidden = true
            cell.upgradeBtn.isHidden = true
            
            }else {
                cell.ticketBtn.isHidden = true
                cell.upgradeBtn.isHidden = true
            }
            
        }
       
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
            let selectedCellImage = apiConnection.offer[indexPath.row]
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



