//
//  NfcTableViewController.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/07/06.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit

class NfcTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:NfcViewController = segue.destination as! NfcViewController;
        if segue.identifier == "read" {
            vc.type = .read
        }
        else {
            vc.type = .write
        }
        
    }
}
