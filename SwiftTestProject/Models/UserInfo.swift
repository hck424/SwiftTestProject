//
//  UserInfo.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/13.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    var userId: String?
    var email: String?
    var name: String?
    var nickname: String?
    var profileImageUrl: String?
    var birthday: String?
    var gender: String?
    var ageRange: String?
    
    var accessToken: String?
    var expiresIn: TimeInterval?
    var expiredAt: Date?
    var refreshToken: String?

}

