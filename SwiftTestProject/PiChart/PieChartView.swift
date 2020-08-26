//
//  PiChartView.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/24.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import QuartzCore

class PieChartView: UIView, CAAnimationDelegate {
    var canSpin: Bool = true
    var saveAngle: Double = 0.0
    
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
    func startRotation(angle:Double = Double.pi * 21 + .pi / 4.0) {
        if !canSpin {
            return
        }
        self.canSpin = false
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = saveAngle
        let toValue = saveAngle + angle
        rotate.duration = 5
        rotate.isRemovedOnCompletion = false
        rotate.fillMode = CAMediaTimingFillMode.forwards
        rotate.toValue = toValue
        rotate.timingFunction = CAMediaTimingFunction(name: .easeOut)//CAMediaTimingFunction(controlPoints: 0.0, 1.0, 1.0, 1)
        rotate.delegate = self
        
        self.layer.transform = CATransform3DMakeRotation(CGFloat(toValue), 0, 0, 1)
        self.layer.add(rotate, forKey: kRotationAnimationKey)
    }
    
    
    func animationDidStart(_ anim: CAAnimation) {
        self.canSpin = false
        print(anim.timeOffset)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.canSpin = true
        if let animation: CABasicAnimation = anim as? CABasicAnimation {
            print(animation.toValue as Any)
            saveAngle = animation.toValue as! Double
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: kRotationAnimationKey) != nil {
            let transform = layer.presentation()?.transform
            layer.transform = transform!
            layer.removeAnimation(forKey: kRotationAnimationKey)
            
        }
    }
}
