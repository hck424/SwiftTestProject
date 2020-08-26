//
//  PiChartViewController.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/24.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit

class PieChartViewController: UIViewController {
    
    @IBOutlet weak var chartView: PieChartView!
    var saveAngle: Double = 0.0
    
    var canSpin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        chartView.setNeedsLayout()
        chartView.setNeedsDisplay()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func clickedActionStop(_ sender: Any) {
        
    }
    @IBAction func clickedActionStart(_ sender: Any) {
        chartView.startRotation(angle:Double.pi * 21 + .pi / 4.0)
    }
    
}


