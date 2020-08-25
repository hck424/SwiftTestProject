//
//  ClouserViewController.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/12.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit

class ClouserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let filteredList = filterGreaterThanValue(value: 3, numbers: [1, 3, 5, 6, 9, 10])
        print(filteredList)
        
        //clouser
        let filteredList2 = filterWithPredicateCloser(clouser: { (num) -> Bool in
            return num > 5
        }, numbers: [1, 3, 5, 6, 9, 10])
        print(filteredList2)
        
        let filteredList3 = filterWithPredicateCloser(clouser: greaterThanThree, numbers: [1, 3, 5, 6, 9, 10])
        print(filteredList3)
        
    }
    
    func filterGreaterThanValue(value: Int, numbers: [Int]) -> [Int] {
        var filteredSetOfNumbers = [Int]()
        for num in numbers {
            if num > value {
                filteredSetOfNumbers.append(num)
            }
        }
        return filteredSetOfNumbers
    }

    func greaterThanThree(value: Int) -> Bool {
        return value > 3
    }
    func filterWithPredicateCloser(clouser: (Int) -> Bool, numbers:[Int]) -> [Int] {
        var filteredSetOfNumbers = [Int]()
        for num in numbers {
            if clouser(num) {
                filteredSetOfNumbers.append(num)
            }
        }
        return filteredSetOfNumbers
    }
}
