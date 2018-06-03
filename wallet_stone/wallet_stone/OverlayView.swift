//
//  OverlayView.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 01/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class OverlayView {
    
    func loadView(_ view: UIView) -> UIView {
        
        //Overlay View
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.6
        
        //Label
        let innerLabel = UILabel()
        innerLabel.textColor = UIColor.black //UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0)
        innerLabel.frame = CGRect(x: 10, y: 0, width: 210, height: 50)
        innerLabel.text = "Carregando cotações ..."
        innerLabel.backgroundColor = UIColor.clear
        
        //View Center
        let innerView = UIView()
        innerView.backgroundColor = UIColor.white
        innerView.layer.cornerRadius = 10
        innerView.frame = CGRect(x: (view.frame.size.width - 200)/2 , y: 50, width: 200, height: 50)
        
        //Add Label
        innerView.addSubview(innerLabel)
        
        //Add Inner View
        overlayView.addSubview(innerView)
        
        return overlayView
    }
    
}
