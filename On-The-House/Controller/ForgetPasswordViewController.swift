//
//  ForgetPasswordViewController.swift
//  On-The-House
//
//  Created by beier nie on 26/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var WebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "https://www.itsonthehouse.com.au/member/forgot-password")
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.WebView.loadRequest(request)
                    
                } else {
                    
                    print("ERROR: \(error)")
                    
                }
                
            }
            
            task.resume()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

