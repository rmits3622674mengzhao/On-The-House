//
//  RatingControl.swift
//  On-The-House
//
//  Created by Dong Wang on 2018/4/18.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    // to set the size of rate cell
    private var ratingButtons = [UIButton]()
    var rating = 3{
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var rateSize: CGSize = CGSize(width: 15.0, height: 15.0) {
        didSet {
            setButtons()
        }
    }
    
    @IBInspectable var rateCount: Int = 5 {
        didSet {
            setButtons()
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setButtons()
    }
    
    func ratingButtonTapped(button: UIButton) {
        //        guard let index = ratingButtons.index(of: button) else {
        //            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        //        }
        
        // to change the rating stars
        // Calculate the rating of the selected button
        //        let selectedRating = index + 1
        //
        ////        if selectedRating == rating {
        ////            // If the selected star represents the current rating, reset the rating to 0.
        ////            rating = 0
        ////        } else {
        ////            // Otherwise set the rating to the selected star
        //        rating = selectedRating
        //        }
    }
    
    private func setButtons() {
        
        // clear any existing buttons
        //      for button in ratingButtons {
        //            removeArrangedSubview(button)
        //            button.removeFromSuperview()
        //        }
        //      ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let fulledStar = UIImage(named: "heart_full", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"heart_empty", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<rateCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(fulledStar, for: .selected)
            
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: rateSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: rateSize.width).isActive = true
            
            // Add the button actions
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
}

