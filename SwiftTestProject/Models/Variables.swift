//
//  Variables.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/12.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit

public class Variables: NSObject {
    static public let KAKAO_NATIVE_APP_KEY = "44e5f0e04f490edcca2203ce90123e0c"
    static public let kUrlSampleAppUrlScheme  = "naverlogin" // 콜백을 받을 URL Scheme
    static public let kConsumerKey = "EpR3zxr3ChT0LGFZakgP" // 애플리케이션에서 사용하는 클라이언트 아이디
    static public let kConsumerSecret = "ZBzbMqkxqL" // 애플리케이션에서 사용하는 클라이언트 시크릿
    static public let kServiceAppName = "네이버 아이디로 로그인하기" // 애플리케이션 이름
//    static public let kGoogleClientId = "831386437991-480a835m5sf96nddgldheuahhtjsk6ip.apps.googleusercontent.com"
    static public let kGoogleClientId = "668538335631-ruhrpq52khb3jmptvpouqaa6an261rtv.apps.googleusercontent.com"
    
    static public let arrColor = [/*0x5A0A61, 0xE52FEF, 0xD5FE8C, 0x0900A8, 0x68CDA5, 0xB7DEFF, 0xEFACC9, 0x24503D, 0x2ECB75,
                                  0xF6D2B2, 0x73C4FF, 0xD8FEB4, 0xF1D5FF, 0xDBFEF7, 0xA6E3FF, 0xFAECDC, 0xEC9DFF, 0xCAD4FF,*/
                                  0xB77109, 0xF5CDF7, 0x86FBDF, 0xEEA01E, 0xF8FF00, 0xF6D0C7, 0x91CDFE, 0xCDD2FF, 0x1D423A/*,
                                  0xE15F13, 0xF2FB00, 0x520672, 0x59B156, 0xD75C94, 0x8712A4, 0xF3C256, 0xF6FFE7, 0x9D250B,
                                  0xEDA1F8, 0xC33511, 0xD96BE2, 0xF2C020, 0xF8805C, 0x82FCA6, 0xB1247D, 0x72E0BD, 0x03005C*/]

}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat ) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}



