//
//  VideoStreamViewController.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/12.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class VideoStreamViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlStr = "https://mixdrop.co/e/qllr4wq6fpql46";
        let url: URL = URL.init(string: urlStr)!
        let player: AVPlayer = AVPlayer.init(url: url)
        let controller : AVPlayerViewController = AVPlayerViewController.init()
        controller.player = player;
        present(controller, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
