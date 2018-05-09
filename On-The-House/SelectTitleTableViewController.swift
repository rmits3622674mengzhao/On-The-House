//
//  SelectTitleTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 5/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class SelectTitleTableViewController: UITableViewController {
    static let title:[String] = ["Mr", "Mrs", "Miss", "Ms", "Dr"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return SelectTitleTableViewController.title.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! SelectTitleTableViewCell
        cell.lbTitle.text = SelectTitleTableViewController.title[indexPath.row]
        if let currentTitle = UserDefaults.standard.string(forKey: "title"){
            if (cell.lbTitle.text == currentTitle){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let currentCell = tableView.cellForRow(at: indexPath) as! SelectTitleTableViewCell
        UserDefaults.standard.set(currentCell.lbTitle.text, forKey: "title")
        tableView.reloadData()
    }
}
