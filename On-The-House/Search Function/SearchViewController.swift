//
//  SearchViewController.swift
//  On-The-House
//
//  Created by beier nie on 7/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import os

class SearchViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var catagoryItem = [String]()
    var stateItem = [String]()
    var categoryKey = [String]()
    var stateKey = [String]()
    var dateItem = "" as String
    
    func getDate(){
        //         to get current date as yyyy-mm-dd
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        dateItem = dateString
    }
    
    @IBOutlet var sView: UIView!
    
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var stateButton: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var dateData: UIPickerView!
    
    let datechoices = ["Today","This Weekend", "Next 7 Days","Next Month"]
    
    
    func getCategory() {
        if (catagoryItem.count>0){
            let stringArray = catagoryItem.map{ String($0) }
            let string = stringArray.joined(separator: "-")
            categoryButton.setTitle(string, for: .normal)
        }
    }
    
    func getState() {
        if stateItem.count>0{
            let stringArray = stateItem.map{ String($0) }
            let string = stringArray.joined(separator: "-")
            stateButton.setTitle(string, for: .normal)
        }
    }
    
    @IBAction func dateDone(_ sender: Any) {
        getDate()
        let title = datechoices[dateData.selectedRow(inComponent: 0)]
        dateButton.setTitle(title, for: .normal)
        displayPickerView(false)
    }
    
    @IBAction func dateSelect(_ sender: Any) {
        displayPickerView(true)
    }
    func displayPickerView(_ show: Bool){
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = (show) ? -10 : 173
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(sView)
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.heightAnchor.constraint(equalToConstant: 173).isActive = true
        sView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        sView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c =  sView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 173)
        c.identifier = "bottom"
        c.isActive = true
        sView.layer.cornerRadius = 10
        
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datechoices.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datechoices[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destinationViewController.
        //      Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case"SEshow":
            os_log("Show searched events.", log: OSLog.default, type: .debug)
            guard let searchedController = segue.destination as? SearchTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            getKey()
            searchedController.stateItem = stateKey
            searchedController.catagoryItem = categoryKey
        default:
            print("Can't find the identifer")
            break
        }
    }
    
    //get category key or state key
    func getKey(){
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
    }
    
    override func viewDidLoad() {
        getState()
        getCategory()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

