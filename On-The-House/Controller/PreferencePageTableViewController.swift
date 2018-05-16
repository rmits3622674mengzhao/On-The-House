//
//  PreferencePageTableViewController.swift
//  On-The-House
//
//  Created by beier nie on 2/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

/*
 class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
 var items:[String] = ["条目1","条目2","条目3","条目4","条目5"]
 
 //存储选中单元格的索引
 var selectedIndexs = [Int]()
 
 var tableView:UITableView?
 
 override func loadView() {
 super.loadView()
 }
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 //创建表视图
 self.tableView = UITableView(frame: self.view.frame, style:.plain)
 self.tableView!.delegate = self
 self.tableView!.dataSource = self
 //创建一个重用的单元格
 self.tableView!.register(UITableViewCell.self,
 forCellReuseIdentifier: "SwiftCell")
 self.view.addSubview(self.tableView!)
 }
 
 //在本例中，只有一个分区
 func numberOfSections(in tableView: UITableView) -> Int {
 return 1;
 }
 
 //返回表格行数（也就是返回控件数）
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return self.items.count
 }
 
 //创建各单元显示内容(创建参数indexPath指定的单元）
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
 -> UITableViewCell {
 //为了提供表格显示性能，已创建完成的单元需重复使用
 let identify:String = "SwiftCell"
 //同一形式的单元格重复使用，在声明时已注册
 let cell = tableView.dequeueReusableCell(withIdentifier: identify,
 for: indexPath) as UITableViewCell
 
 cell.textLabel?.text = self.items[indexPath.row]
 
 //判断是否选中（选中单元格尾部打勾）
 if selectedIndexs.contains(indexPath.row) {
 cell.accessoryType = .checkmark
 } else {
 cell.accessoryType = .none
 }
 
 return cell
 }
 
 // UITableViewDelegate 方法，处理列表项的选中事件
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 //判断该行原先是否选中
 if let index = selectedIndexs.index(of: indexPath.row){
 selectedIndexs.remove(at: index) //原来选中的取消选中
 }else{
 selectedIndexs.append(indexPath.row) //原来没选中的就选中
 }
 
 ////刷新该行
 self.tableView?.reloadRows(at: [indexPath], with: .automatic)
 }
 
 //确定按钮点击
 @IBAction func btnClick(_ sender: AnyObject) {
 print("选中项的索引为：", selectedIndexs)
 print("选中项的值为：")
 for index in selectedIndexs {
 print(items[index])
 }
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 }
 }
 */



class PreferencePageTableViewController: UITableViewController {


    var preferenceList:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceList = ["Friend","LinkedIN","Facebook","Forum","Website","Yelp"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return preferenceList.count
    }
*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return preferenceList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preCell") as! PreferenceEventCell
        cell.preferenceLable.text = preferenceList[indexPath.row] as? String
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
            
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }

    
}
