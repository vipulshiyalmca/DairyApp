//
//  LoadingOverlay.swift
//  TakiTaki
//
//  Created by psmacmini on 04/11/19.
//  Copyright © 2019 prompt. All rights reserved.
//

import UIKit

public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var titleLabel = UILabel()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView, withTitle: String) {
        overlayView.frame = CGRect(x: 0, y: 0, width: 100, height: 120)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        // add blur
//       let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//       let blurEffectView = UIVisualEffectView(effect: blurEffect)
//       blurEffectView.frame = overlayView.bounds
//       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//       overlayView.addSubview(blurEffectView)

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2 - 10)
        activityIndicator.color = UIColor.white
        
        titleLabel.frame = CGRect(x: 0, y: 80, width: 80, height: 20)
        titleLabel.center = CGPoint(x: overlayView.bounds.width / 2 + 10, y: overlayView.bounds.height / 2 + 30)
        titleLabel.text = withTitle
        titleLabel.textColor = UIColor.white
        
        overlayView.addSubview(activityIndicator)
        overlayView.addSubview(titleLabel)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}


