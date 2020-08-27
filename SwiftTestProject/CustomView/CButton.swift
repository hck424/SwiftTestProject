//
//  CButton.swift
//  CustomViewExample
//
//  Created by 김학철 on 2020/06/29.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import CoreGraphics

func imageFromColor(color: UIColor) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

class CButton: UIButton {
    public var data: Any?
    @IBInspectable var localizeText: String? {
        didSet {
            if localizeText != nil { setNeedsLayout()}
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth > 0 {setNeedsLayout()}
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            if borderColor != nil { setNeedsLayout()}
        }
    }
    @IBInspectable var halfCornerRadius:Bool = false {
        didSet {
            if halfCornerRadius {setNeedsLayout()}
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            if cornerRadius > 0 { setNeedsLayout()}
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let local = localizeText {
            self.setTitle(NSLocalizedString(local, comment: ""), for: .normal)
        }
        
        self.clipsToBounds = true
        var raduis:CGFloat = 0.0
        if borderWidth > 0 && borderColor != nil {
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
        }
        if halfCornerRadius {
            raduis = self.layer.bounds.height/2
        }
        else if cornerRadius > 0 {
            raduis = cornerRadius
        }
        
        self.layer.cornerRadius = raduis
    }

}
