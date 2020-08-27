//
//  PiChartView.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/24.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import QuartzCore
internal protocol PieChartViewDelegate {
    func piechartViewRotationFinish();
}
class PieChartView: UIView, CAAnimationDelegate {
    var delegate:PieChartViewDelegate?
    var arrData = [Any]()
    var arrSlice = [Any]()
    var canSpin: Bool = true
    var saveAngle: Double = 0.0
    
    var polygon:Int = 1
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
    }
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    func testDAataMake() {
        arrData.removeAll()
        arrData.append("김치찌깨")
        arrData.append("초밥")
        arrData.append("짜장면")
        arrData.append("감자탕")
        arrData.append("돈까스")
        arrData.append("마라탕")
        arrData.append("순대국")
        arrData.append("김밥")
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
            self.testDAataMake()
        }
        
        self.layoutIfNeeded()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layoutIfNeeded()
        
        polygon = arrData.count
        let per: CGFloat = 360.0/CGFloat(polygon)
        var st:CGFloat = 0.0
        var ed: CGFloat = 0.0
        
        if polygon % 2 == 0 {
            st = 90-per/2
        }
        else {
            st = 90-per
        }
        
        for slice in arrSlice {
            (slice as AnyObject).removeFromSuperview()
        }
        arrSlice.removeAll()
        for i in 0..<polygon {
//            let count:UInt32 = UInt32(Variables.arrColor.count)
//            let colorIndex:Int = Int(arc4random()%count)
            let colorIndex:Int = i % Variables.arrColor.count
            ed = st + per
            let hexColor = Variables.arrColor[colorIndex]
            let data = arrData[i]
            drawSlice(rect: self.bounds, stPercent: st, edPercent:ed , color: UIColor.init(hex: hexColor), index:i, data:data)
            st = ed
        }
    }
    
    private func drawSlice(rect: CGRect, stPercent:CGFloat, edPercent:CGFloat, color: UIColor, index: Int, data: Any) {
        let center = CGPoint(x: rect.origin.x + rect.width/2, y: rect.origin.y + rect.height/2)
        let radius = min(rect.width, rect.height) / 2
        
        let startAngle = (stPercent/180.0) * CGFloat.pi
        let endAngle = (edPercent/180.0) * CGFloat.pi
        let lableAngle = endAngle - (CGFloat.pi)/CGFloat(polygon)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        color.setFill()
        path.fill()

        let btn = CButton.init(frame: path.bounds)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        btn.titleLabel?.textColor = UIColor.init(red: 235/255, green:235/255 , blue:235/255, alpha: 1)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
//        btn.layer.borderWidth = 1.0
//        btn.layer.borderColor = UIColor.red.cgColor
        addSubview(btn)
        
        let btnCenter = btn.center
        btn.frame = CGRect.init(x: 0, y: 0, width: btn.frame.size.width*0.8, height: btn.frame.size.height*0.5)
        print("center = \(btn.center)")
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        btn.center = btnCenter
        btn .setTitle(data as? String, for: .normal)
        btn.transform = btn.transform.rotated(by: lableAngle)
        arrSlice.append(btn)
        
        btn.data = ["startAngle":startAngle, "endAngle":endAngle, "stPer":stPercent, "edPer":edPercent, "data":data]
        btn.addTarget(self, action: #selector(onclickedButtonActions(_:)), for: .touchUpInside)
        self.setNeedsDisplay()
    }
    
    func startRotation(angle:Double = Double.pi * 21 + .pi / 4.0) {
        
        if !canSpin {
            return
        }
        
        self.canSpin = false
        let angle = Double.pi * 21 + .pi / Double(Int.random(in: 1...polygon))
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = saveAngle
        let toValue = saveAngle + angle
        rotate.duration = 5
        rotate.isRemovedOnCompletion = false
        rotate.fillMode = CAMediaTimingFillMode.forwards
        rotate.toValue = toValue
        rotate.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 1.0, 1.0, 1)
//        rotate.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotate.delegate = self
        rotate.repeatCount = 1
        self.layer.transform = CATransform3DMakeRotation(CGFloat(toValue), 0, 0, 1)
        self.layer.add(rotate, forKey: kRotationAnimationKey)
    
    }
    
    @objc func onclickedButtonActions(_ sender: CButton) {
        print(sender.data)
    }
    
    //MARK: CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) {
        self.canSpin = false
        print(anim.timeOffset)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.canSpin = true
        if let animation: CABasicAnimation = anim as? CABasicAnimation {
            print(animation.toValue as Any)
            
            saveAngle = animation.toValue as! Double
            print("\(String(describing: animation.toValue)),   \(saveAngle*Double(CGFloat.pi)/18)")
            saveAngle = saveAngle.remainder(dividingBy: 360.0)
            
            if let delegate = delegate {
                delegate.piechartViewRotationFinish()
            }
        }
        
    }
    
    
//    func stopRotating() {
//        if layer.animation(forKey: kRotationAnimationKey) != nil {
//            let transform = layer.presentation()?.transform
//            layer.transform = transform!
//            layer.removeAnimation(forKey: kRotationAnimationKey)
//
//        }
//    }
}
