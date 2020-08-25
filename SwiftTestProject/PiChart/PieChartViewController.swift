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
    var animating: Bool = false
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler), name:NSNotification.Name("StopTimer"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        chartView.setNeedsLayout()
        chartView.setNeedsDisplay()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopTimer"), object: nil)
        self.stopTimer()
    }
    @IBAction func clickedActionStop(_ sender: Any) {
        chartView.stopRotating()
        self.stopTimer()
        animating = false
    }
    @IBAction func clickedActionStart(_ sender: Any) {
        var duration = 1.0
        self.stopTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { (timer: Timer) in
            self.chartView.rotate(duration: duration)
            duration += duration
            if duration > 5 {
                self.stopTimer()
                self.chartView.aniStartAngle = self.chartView.aniEndAngle
//                self.chartView.stopRotating()
            }
        }
    }
    
    func stopTimer() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer?.fire()
            self.timer = nil
        }
    }
    
    //MARK:: NotificationHandler
    @objc func notificationHandler(_ notification: NSNotification) {
        self.stopTimer()
    }
}
