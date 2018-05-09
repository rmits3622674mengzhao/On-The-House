//
//  SelectPreferedCategoriesInProfileTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 2/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class SelectPreferedCategoriesInProfileTableViewController: UITableViewController {
    
    var memberToken:Member?
    //contain selected value
    var selectedCategories: [Int] = []
    //contain all keys in categories array
    var CategoriesKeys: [String] = Array(DataTransition.categories.keys)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CategoriesKeys)
        if let selectedCat = UserDefaults.standard.array(forKey: "categories") as? [Int]{
            selectedCategories = selectedCat
        }
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
        
        return CategoriesKeys.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath) as! PreferedCategoriesTableViewCell
        cell.lbCategory.text = CategoriesKeys[indexPath.row]
        if (self.selectedCategories != []){
            if(self.selectedCategories.contains(DataTransition.categories[cell.lbCategory.text!]!)){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! PreferedCategoriesTableViewCell
        let index = selectedCategories.index(of: DataTransition.categories[currentCell.lbCategory.text!]!)
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            selectedCategories.remove(at: index!)
            UserDefaults.standard.set(selectedCategories, forKey: "categories")
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedCategories.append(DataTransition.categories[currentCell.lbCategory.text!]!)
            UserDefaults.standard.set(selectedCategories, forKey: "categories")
        }
        if (selectedCategories != []){
            print(selectedCategories)
        }else{
            print("no cat selected")
        }
        
        
    }
}
