//
//  VerticalButton.swift
//  CustomViewExample
//
//  Created by 김학철 on 2020/06/29.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit

class VerticalButton: CButton {
    
    @IBInspectable var imageSize:CGSize = CGSize.zero

    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerButtonImageAndTitle()
    }
    
    func centerButtonImageAndTitle() {
        let size = self.bounds.size
//        let titleSize = self.titleLabel!.frame.size
        
        let top = max(self.imageEdgeInsets.top, self.contentEdgeInsets.top)
        let left = max(contentEdgeInsets.left, titleEdgeInsets.left)
        let right = max(contentEdgeInsets.right, titleEdgeInsets.right)
        
        self.imageView?.frame = CGRect.init(x: size.width/2 - imageSize.width/2,
                                            y: top,
                                            width: imageSize.width,
                                            height: imageSize.height)
        self.imageView?.layer.borderColor = UIColor .red.cgColor
        self.imageView?.layer.borderWidth = 1.0
        
        self.titleLabel?.frame = CGRect.init(x: left,
                                             y: top + imageSize.height,
                                             width: size.width - left - right,
                                             height: (titleLabel?.frame.size.height)!)
        
//        self.imageEdgeInsets = UIEdgeInsets(top: self.imageEdgeInsets.top + self.contentEdgeInsets.top,
//                                            left: size.width/2 - imageSize.width/2,
//                                            bottom: self.imageEdgeInsets.bottom,
//                                            right: 0)
//
//        self.titleEdgeInsets = UIEdgeInsets(top: self.titleEdgeInsets.top,
//                                            left: -imageSize.width + size.width/2 - titleSize.width/2,
//                                            bottom: self.titleEdgeInsets.bottom,
//                                            right: 0)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }

}
