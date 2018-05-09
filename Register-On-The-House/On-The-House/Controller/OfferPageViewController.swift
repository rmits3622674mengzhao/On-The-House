//
//  OfferTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 22/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class OfferTableViewController: UITableViewController {
    var offer = [OfferModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return offer.count
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
     //
     // func loadSampleOffer(){
     
     //  let photo1 = UIImage(named:"1")
     //  let photo2 = UIImage(named:"2")
     //  let photo3 = UIImage(named:"3")
     //  let photo4 = UIImage(named:"4")
     //  let photo5 = UIImage(named:"5")
     
     //  guard let offer1 = OfferModel(name:"1", photo: photo1!, Description:"11111")else{
     //      fatalError("Unable to instantiate Offer1")
     //  }
     //  guard let offer2 = OfferModel(name:"2", photo: photo2!, Description:"11111")else{
     //      fatalError("Unable to instantiate Offer2")
     // }
     //  guard let offer3 = OfferModel(name:"3", photo: photo3!, Description:"11111")else{
     //      fatalError("Unable to instantiate Offer3")
     //  }
     //  guard let offer4 = OfferModel(name:"4", photo: photo4!, Description:"11111")else{
     //      fatalError("Unable to instantiate Offer4")
     //  }
     //  guard let offer5 = OfferModel(name:"5", photo: photo5!, Description:"11111")else{
     //      fatalError("Unable to instantiate Offer5")
     //  }
     //  offers += [offer1, offer2, offer3, offer4, offer5]*/
}


