//
//  Clabel.swift
//  CustomViewExample
//
//  Created by 김학철 on 2020/06/25.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
@IBDesignable

class Clabel: UILabel {
    
    @IBInspectable var localizeText: String? {
        didSet {
            if localizeText != nil { setNeedsLayout()}
        }
    }
    
    @IBInspectable var insetTB :CGFloat = 0.0 {
        didSet {
            if insetTB > 0 { setNeedsLayout() }
        }
    }
    @IBInspectable var insetLR :CGFloat = 0.0 {
        didSet {
            if insetLR > 0 { setNeedsLayout() }
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
        
        super.draw(rect)
        
        if let local = localizeText {
            self.text = NSLocalizedString(local, comment: "")
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
        
        invalidateIntrinsicContentSize()
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets.init(top: insetTB, left: insetLR, bottom: insetTB, right: insetLR)
        super.drawText(in: rect.inset(by: inset))
    }
    override var intrinsicContentSize: CGSize {
        let size:CGSize = super.intrinsicContentSize
        return CGSize.init(width: size.width + 2*insetLR, height: size.height + 2*insetTB)
    }
}
