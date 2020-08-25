//
//  PiChartView.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/24.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import QuartzCore

class PieChartView: UIView {
    
    var polygon:Int = 8
    var aniStartAngle:Float = 0.0
    var aniEndAngle:Float = 0.0
    private let kRotationAnimationKey = "rotationanimationkey"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.loadXib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXib()
//        fatalError("init(coder:) has not been impletmented")
    }
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    func loadXib() {
        let xib: UIView? = Bundle.main.loadNibNamed("PieChartView", owner: nil, options: nil)?.first as? UIView
        
        if xib != nil {
            addSubview(xib!)
            xib?.translatesAutoresizingMaskIntoConstraints = false
            xib?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            xib?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            xib?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            xib?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
        self.layoutIfNeeded()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layoutIfNeeded()
        
        let per: CGFloat = 360/CGFloat(polygon)
        var st:CGFloat = per/2.0;
        var ed: CGFloat = 0.0
        
        for i in 0..<polygon {
//            let count:UInt32 = UInt32(Variables.arrColor.count)
//            let colorIndex:Int = Int(arc4random()%count)
            let colorIndex:Int = i % Variables.arrColor.count
            ed = st + per
            let hexColor = Variables.arrColor[colorIndex]
            drawSlice(rect: self.bounds, stPercent: st, edPercent:ed , color: UIColor.init(hex: hexColor))
            st = ed
        }
    }
    
    private func drawSlice(rect: CGRect, stPercent:CGFloat, edPercent:CGFloat, color: UIColor) {
        let center = CGPoint(x: rect.origin.x + rect.width/2, y: rect.origin.y + rect.height/2)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = (stPercent/180.0) * CGFloat.pi
        let endAngle = (edPercent/180.0) * CGFloat.pi
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        color.setFill()
        path.fill()
        self.setNeedsDisplay()
    }
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: kRotationAnimationKey)
        }

        if layer.animation(forKey: kRotationAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = aniStartAngle
            aniEndAngle = aniStartAngle + Float.pi*2*Float(5-duration)
            animation.toValue = aniEndAngle
            animation.duration = duration
            animation.isCumulative = true
            animation.repeatCount = 1
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            layer.add(animation, forKey: kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
}
