//
//  LoadingView.swift
//  LoadingIndicator
//
//  Created by Mehul Patel on 22/02/19.
//  Copyright © 2019 PS. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView {
    
    var activity = UIActivityIndicatorView()
    var centerYConstraint = NSLayoutConstraint()
    
    //----------------------------------------------------
    //MARK:- Memory management methods
    //----------------------------------------------------
    
    deinit {}
    
    //----------------------------------------------------
    //MARK:- Custom methods
    //----------------------------------------------------
    func setupUI() {
        activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.tintColor = UIColor.gray
       // activity.color = UIColor.colorPrimary
        self.addSubview(activity)
        activity.startAnimating()

        self.addConstraint(NSLayoutConstraint.init(item: activity,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self, attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0.0))
        centerYConstraint = NSLayoutConstraint.init(item: activity,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self, attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0.0)
        self.addConstraint(centerYConstraint)
    }
    
    func updateCenterYMargin(margin : CGFloat) {
        centerYConstraint.constant = margin
        self.layoutIfNeeded()
    }
    
    //----------------------------------------------------
    //MARK:- Init methods
    //----------------------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
