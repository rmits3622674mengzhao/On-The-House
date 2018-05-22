//
//  SearchViewController.swift
//  On-The-House
//
//  Created by beier nie on 7/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import os

class SearchViewController: UIViewController{
    
    let urlString: String = "http://ma.on-the-house.org/api/v1/events/current"
    let apiConnection = APIconnection()
    let formatter = DateFormatter()
    let defaults = UserDefaults.standard
    var catagoryItem = [String]()
    var stateItem = [String]()
    var categoryKey = [String]()
    var stateKey = [String]()
    var dateKey = [String]()
    var dateItem :String!
    
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var stateButton: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    
    
    func getName() {
        catagoryItem=defaults.object(forKey: "SavedCateArray") as? [String] ?? [String]()
        if (catagoryItem.count>0){
            let stringArray = catagoryItem.map{ String($0) }
            let string = stringArray.joined(separator: "-")
            categoryButton.setTitle(string, for: .normal)
        }
        stateItem = defaults.object(forKey: "SavedStateArray") as? [String] ?? [String]()
        if stateItem.count>0{
            let stringArray = stateItem.map{ String($0) }
            let string = stringArray.joined(separator: "-")
            stateButton.setTitle(string, for: .normal)
        }
        
        dateItem = defaults.string(forKey: "SavedDate") as? String
        if dateItem != nil{
            let string = dateItem
            dateButton.setTitle(string, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destinationViewController.
        //      Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"SEshow":
            os_log("Show searched events.", log: OSLog.default, type: .debug)
            
            getKeys()
            apiConnection.getConnect(urlString: urlString, postBody: getCheckPostbody(), method: "checkStatus")
            // check if any events can be searched and returned
            if apiConnection.errorStatus == true{
                let searchedController = segue.destination as? UINavigationController
                guard
                    let nextView = searchedController?.topViewController as? OfferTableViewController else {
                        fatalError("Unexpected destination: \(segue.destination)")
                }
                nextView.stateItem = stateKey
                nextView.catagoryItem = categoryKey
                nextView.dateItem = dateKey
                
            }else{
                showAlert(msgMessage: "There are cunrrent no event")
            }
        default:
            print("Can't find the identifer")
            break
        }
    }
    
    //get category key , state key ,date
    func getKeys(){
        if catagoryItem.count>0{
            
            for i in catagoryItem{
                let key = DataTransition.categories[i]!
                categoryKey.append(String(key))
            }
        }
        if stateItem.count>0{
            for j in stateItem{
                let statekey = DataTransition.states[j]!
                stateKey.append(String(statekey))
            }
        }
        if dateItem != nil{
            switch dateItem{
            case "Today":
                dateKey = getCurrentDate()
            case "This Weekend":
                dateKey = getCurrentWeekend()
            case "Next 7 Days":
                dateKey = nextSevenDays()
            case "Next Month":
                dateKey = nextMonth()
            default:
                print ("Error!")
                break
            }
        }
    }
    
    func getCheckPostbody() ->[String: String]{
        var tempPostBody = [String: String]()
        tempPostBody["page"] = "1"
        tempPostBody["limit"] = "10"
        if dateKey.count == 1{
            tempPostBody["date"] = "range"
            tempPostBody["date_from"] = dateKey[0]
            tempPostBody["date_to"] = dateKey[0]
        }
        if dateKey.count>1{
            tempPostBody["date"] = "range"
            tempPostBody["date_from"] = dateKey[0]
            tempPostBody["date_to"] = dateKey[1]
        }
        for i in stateKey{
            tempPostBody["zone_id[]"] = i
        }
        for j in categoryKey{
            tempPostBody["category_id[]"] = j
        }
        return tempPostBody
    }
    
    override func viewDidLoad() {
        getName()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get current date
    func getCurrentDate() -> [String]{
        
        var today: [String] = []
        //         to get current date as yyyy-mm-dd
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        today.append(currentDate)
        return today
        
    }
    
    //get current weekend
    func getCurrentWeekend() -> [String] {
        
        var weekend:[String] = []
        let date = Date()
        let component = Calendar.Component.weekday
        let cal = Calendar.current
        let currentWeekday = cal.component(component, from: date)
        
        let saturday = cal.date(byAdding: component, value: 6 - currentWeekday + 1, to: date)
        let sunday = cal.date(byAdding: component, value: 7 - currentWeekday + 1, to: date)
        
        
        formatter.dateFormat = "yyyy"
        let Syear = formatter.string(from: saturday!)
        let Sunyear = formatter.string(from: sunday!)
        formatter.dateFormat = "MM"
        let Smonth = formatter.string(from: saturday!)
        let Sunmonth = formatter.string(from: sunday!)
        formatter.dateFormat = "dd"
        let Sday = formatter.string(from: saturday!)
        let SuDay = formatter.string(from: sunday!)
        
        let sate = "\(Syear)-\(Smonth)-\(Sday)"
        let sun = "\(Sunyear)-\(Sunmonth)-\(SuDay)"
        weekend.append(sate)
        weekend.append(sun)
        return weekend
    }
    
    func nextSevenDays() -> [String] {
        
        var sevenDays:[String] = []
        let endDay = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        let date = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        let start = formatter.string(from: date)
        let end = formatter.string(from: endDay!)
        sevenDays.append(start)
        sevenDays.append(end)
        return sevenDays
    }
    
    func nextMonth() -> [String] {
        
        var nextMonth:[String] = []
        let endMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let date = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        let start = formatter.string(from: date)
        let end = formatter.string(from: endMonth!)
        nextMonth.append(start)
        nextMonth.append(end)
        return nextMonth
        
    }
    
    func showAlert(msgMessage:String){
        let alert = UIAlertController(title: "Error", message: msgMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        self.present(alert, animated: true, completion: nil)
    }
}


