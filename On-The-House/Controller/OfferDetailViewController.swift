//
//  OfferDetailViewController.swift
//  On-The-House
//
//  Created by beier nie on 18/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class OfferDetailViewController: UIViewController {
    @IBOutlet weak var OurPriceLabel: UILabel!
    @IBOutlet weak var Member: UILabel!
    @IBOutlet weak var AdminFee: UILabel!
    @IBOutlet weak var Admin: UILabel!
    @IBOutlet weak var ourPrice: UILabel!
    @IBOutlet weak var Rate: RatingControl!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var WebVideoPlayer: UIWebView!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var TicketButton: UIButton!
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventDescription: UITextView!
    var offerDetail:OfferModel!
    var videoUrl: URL!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
    
    
    override func viewDidLoad() {
        getTrailer()
        OurPriceLabel.text = "OurPrice*:"
        ourPrice.text = offerDetail.ourPrice
        Member.text = offerDetail.membershipLevel
        Admin.text = offerDetail.admin
        AdminFee.text = offerDetail.adminFee
        Name.text = offerDetail.name
        Rate.rating = offerDetail.rate
        EventImage.image = offerDetail.photo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // to get description without trailer url and get the trailer url
    func getTrailer(){
        var tempStr="" as String
        let pattern = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        let allMatches = matches(for: pattern, in: offerDetail.description as String)
        
        //play a online video
        if allMatches.count > 0{
            videoUrl = URL(string: allMatches[0])
            let webRequest = URLRequest(url: videoUrl)
            WebVideoPlayer.loadRequest(webRequest)
        }else
        {
            print("Missing Trailer!")
        }
        let splitedArray = offerDetail.description.split(separator: "\r\n")
        for i in splitedArray{
            if i == "Trailer"{
                break
            }else{
                tempStr = tempStr+i
            }
        }
        EventDescription.text  = tempStr
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // matches video url
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            let finalResult = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return finalResult
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    @IBAction func ShareButton(_ sender: Any) {
        let activity = UIActivityViewController(activityItems: [offerDetail.photo], applicationActivities: nil)
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

