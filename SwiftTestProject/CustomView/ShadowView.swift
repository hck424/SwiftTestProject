//
//  ShadowView.swift
//  CustomViewExample
//
//  Created by 김학철 on 2020/06/25.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var sdColor: UIColor? {
        didSet {
            if sdColor != nil { setNeedsLayout() }
        }
    }
    @IBInspectable var sdOffset:CGSize = CGSize.zero {
        didSet {
            if sdOffset.width > 0 || sdOffset.height > 0 { setNeedsLayout()}
        }
    }
    @IBInspectable var sdRadius: CGFloat = 0.0 {
        didSet {
            if sdRadius > 0 {setNeedsLayout()}
        }
    }
    @IBInspectable var sdOpacity: Float = 0.0 {
        didSet {
            if sdOpacity > 0 { setNeedsDisplay()}
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let sColor = sdColor {
            layer.masksToBounds = false
            layer.shadowOffset = sdOffset
            layer.shadowColor = sColor.cgColor
            layer.shadowRadius = sdRadius
            layer.shadowOpacity = sdOpacity
            
//            let backgroundCGColor = backgroundColor?.cgColor
//            backgroundColor = nil
//            layer.backgroundColor = backgroundCGColor
            backgroundColor = nil
        }

    }
}
