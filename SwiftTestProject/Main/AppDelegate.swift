//
//  AppDelegate.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/07/06.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import GoogleSignIn
import Firebase
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        KakaoSDKCommon.initSDK(appKey: Variables.KAKAO_NATIVE_APP_KEY)
        
        //네이버
        let naverThirdPartyLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
          // 네이버 앱으로 인증하는 방식을 활성화하려면 앱 델리게이트에 다음 코드를 추가합니다.
          naverThirdPartyLoginInstance?.isNaverAppOauthEnable = true
          // SafariViewContoller에서 인증하는 방식을 활성화하려면 앱 델리게이트에 다음 코드를 추가합니다.
          naverThirdPartyLoginInstance?.isInAppOauthEnable = true
          // 인증 화면을 iPhone의 세로 모드에서만 사용하려면 다음 코드를 추가합니다.
          naverThirdPartyLoginInstance?.setOnlyPortraitSupportInIphone(true)
          // 애플리케이션 이름
          naverThirdPartyLoginInstance?.appName = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String) ?? ""
          // 콜백을 받을 URL Scheme
        naverThirdPartyLoginInstance?.serviceUrlScheme = Variables.kUrlSampleAppUrlScheme
          // 애플리케이션에서 사용하는 클라이언트 아이디
        naverThirdPartyLoginInstance?.consumerKey = Variables.kConsumerKey
          // 애플리케이션에서 사용하는 클라이언트 시크릿
        naverThirdPartyLoginInstance?.consumerSecret = Variables.kConsumerSecret
        
        
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        if let scheme = url.scheme {
            if scheme.contains("naver") {
                let result = NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
                if result == CANCELBYUSER {
                    print("result: \(String(describing: result))")
                }
                return true
            }
            else if (scheme.contains("com.googleusercontent.apps")) {
                return (GIDSignIn.sharedInstance()?.handle(url))!
            }
        }
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

