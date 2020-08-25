//
//  SocialLoginViewController.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/08/12.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import NaverThirdPartyLogin
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON

class SocialLoginViewController: UIViewController {

    @IBOutlet weak var lbUserInfo: UILabel!
    @IBOutlet weak var btnKakaoIn: CButton!
    @IBOutlet weak var btnKakaoLogOut: CButton!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var svUserInfo: UIStackView!
    @IBOutlet weak var btnNaverLogin: CButton!
    @IBOutlet weak var btnNaverLogOut: CButton!
    @IBOutlet weak var btnGoogleLogin: CButton!
    @IBOutlet weak var btnGoogleLogout: CButton!
    
    @IBOutlet weak var btnFBLogin: CButton!
    @IBOutlet weak var btnFBLogOut: CButton!
    var user: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        svUserInfo.isHidden = true
        btnNaverLogin.imageView?.contentMode = .scaleAspectFit
        btnGoogleLogin.imageView?.contentMode = .scaleAspectFit
        btnFBLogin.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func onClickedButtonActions(_ sender: UIButton) {
        if sender == btnKakaoIn {
            // 카카오톡 설치 여부 확인
            if (AuthApi.isKakaoTalkLoginAvailable()) {
                
                AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoTalk() success.")
                        
                        if let token: OAuthToken = oauthToken {
                            self.user = UserInfo()
                            self.user?.accessToken = token.accessToken
                            self.user?.expiresIn = token.expiresIn
                            self.user?.expiredAt = token.expiredAt
                            self.user?.refreshToken = token.refreshToken
                            self.getKakaoUserInfo()
                        }
                    }
                }
            }
        }
        else if sender == btnKakaoLogOut {
            svUserInfo.isHidden = true
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success")
                }
            }
        }
        else if sender == btnNaverLogin {
            let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
            naverConnection?.delegate = self
            naverConnection?.requestThirdPartyLogin()
        }
        else if sender == btnNaverLogOut {
            // 네이버 토큰 리셋
//            NaverThirdPartyLoginConnection.getSharedInstance()?.resetToken()
            
            // 네이버 토큰 삭제
            svUserInfo.isHidden = true
            NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
        }
        else if sender == btnGoogleLogin {
            //Google
            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance()?.delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
        else if sender == btnGoogleLogout {
            svUserInfo.isHidden = true
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOuterror as Error {
                print("Error signing out google: %@", signOuterror)
            }
        }
        else if sender == btnFBLogin {
            let loginManager = LoginManager()
            let readPermission:[Permission] = [.publicProfile, .email]
            loginManager.logIn(permissions: readPermission, viewController: self) { (result: LoginResult) in
                
                switch result {
                case .success(granted: _, declined: _, token: _):
                    self.signInfoFirebase()
                    break
                case .cancelled: break
                    
                case .failed(let error):
                    print(error)
                    break
                }
                
            }
        }
        else if sender == btnFBLogOut {
            svUserInfo.isHidden = true
            let loginManager = LoginManager()
            loginManager.logOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as Error {
                 print ("Error signing out: %@", signOutError)
            }
        }
    }
    func signInfoFirebase() {
        guard let accessToken = AccessToken.current?.tokenString else {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
//            let authError = error as NSError
//            if (isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
//              // The user is a multi-factor user. Second factor challenge is required.
//              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//              var displayNameString = ""
//              for tmpFactorInfo in (resolver.hints) {
//                displayNameString += tmpFactorInfo.displayName ?? ""
//                displayNameString += " "
//              }
//              self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
//                var selectedHint: PhoneMultiFactorInfo?
//                for tmpFactorInfo in resolver.hints {
//                  if (displayName == tmpFactorInfo.displayName) {
//                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                  }
//                }
//                PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
//                  if error != nil {
//                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
//                  } else {
//                    self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
//                      let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
//                      let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
//                      resolver.resolveSignIn(with: assertion!) { authResult, error in
//                        if error != nil {
//                          print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
//                        } else {
//                          self.navigationController?.popViewController(animated: true)
//                        }
//                      }
//                    })
//                  }
//                }
//              })
//            } else {
//              self.showMessagePrompt(error.localizedDescription)
//              return
//            }
            // ...
            return
          }
            self.fetchFacebookMe()
        
        }
    }
    func fetchFacebookMe() {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, birthday, gender, age_range, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
        
        connection.add(request) { (httpResponse, result, error: Error?) in
            if nil != error {
                print(error!)
                return
            }
            guard let result = result else {
                return
            }
            
            if let dic:Dictionary = result as? Dictionary<String, AnyObject> {
                self.user = UserInfo()
                self.user?.name = dic["name"] as? String
                self.user?.email = dic["email"] as? String
                self.user?.userId = dic["id"] as? String
                self.user?.birthday = dic["birthday"] as? String
                self.user?.profileImageUrl = nil
                if let picture: Dictionary = dic["picture"] as? Dictionary<String, AnyObject> {
                    if let data: Dictionary =  picture["data"] as? Dictionary<String, AnyObject> {
                        guard let url = data["url"] else {
                            return
                        }
                        self.user?.profileImageUrl = url as? String
                    }
                }
                DispatchQueue.main.async {
                    self.decorationUi()
                }
            }
        }
        connection.start()
    }
    func getKakaoUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print (error)
            }
            else {
                
                print ("me() success.")
                guard let user = user else {
                    return
                }
                self.svUserInfo.isHidden = false
                
                if let email = user.kakaoAccount?.email { self.user?.email = email }
                self.user?.profileImageUrl = nil
                if let profileImageUrl:URL = user.kakaoAccount?.profile?.profileImageUrl {self.user?.profileImageUrl = profileImageUrl.absoluteString }
                if let nickname = user.kakaoAccount?.profile?.nickname {
                    self.user?.nickname = nickname
                    self.user?.name = nickname
                }
                if let birthyear = user.kakaoAccount?.birthyear { self.user?.birthday = birthyear }
                if let birthday = user.kakaoAccount?.birthday { self.user?.birthday = birthday }
                if let ageRange = user.kakaoAccount?.ageRange { self.user?.ageRange = ageRange.rawValue }
                if let gender = user.kakaoAccount?.gender?.rawValue { self.user?.gender = gender}
                
                self.decorationUi()
            }
        }
    }
    
    func decorationUi() {
        self.svUserInfo.isHidden = false
        if let urlStr = self.user?.profileImageUrl {
            let url: URL = URL.init(string: urlStr)!
            do {
                let data:NSData = try NSData.init(contentsOf: url as URL)
                self.ivProfile.image = UIImage(data: data as Data)
            } catch {
            }
        }
        else {
            ivProfile.image = nil
        }
        
        var info = String()
        if let userId = user?.userId { info.append("userId: \(userId)\n") }
        if let email = user?.email { info.append("email: \(email)\n") }
        if let name = user?.name { info.append("name: \(name)\n") }
        if let nickname = user?.nickname { info.append("nickname: \(nickname)\n") }
//        if let profileImageUrl = user.profileImageUrl { info.append("profileImageUrl: \(profileImageUrl)\n") }
        if let birthday = user?.birthday { info.append("birthday: \(birthday)\n") }
        if let gender = user?.gender { info.append("gender: \(gender)\n") }
        if let ageRange = user?.ageRange { info.append("ageRange: \(ageRange)\n") }
        
        self.lbUserInfo.text = info
    }
    
    func naverDataFetch(){
        guard let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        guard let accessToken = naverConnection.accessToken else { return }
        let authorization = "Bearer \(accessToken)"
        
        if let url = URL(string: "https://openapi.naver.com/v1/nid/me") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                    self.user = UserInfo()
                    guard let response = json["response"] as? [String: AnyObject] else { return }
                    if let id = response["id"]  as?String { self.user?.userId = id }
                    if let email = response["email"]  as?String { self.user?.email = email}
                    if let name = response["name"]  as?String { self.user?.name = name }
                    if let nickname = response["nickname"]  as?String { self.user?.nickname = nickname  }
                    if let profileImageUrl = response["profile_image"]  as?String { self.user?.profileImageUrl = profileImageUrl}
                    if let birthday = response["birthday"] as? String { self.user?.birthday = birthday}
                    if let gender = response["gender"] as? String { self.user?.gender = gender }
                    
                    DispatchQueue.main.async {
                        self.decorationUi()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        }
    }
}

extension SocialLoginViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 로그인 성공 (로그인된 상태에서 requestThirdPartyLogin()를 호출하면 이 메서드는 불리지 않는다.)
        self.naverDataFetch()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 로그인된 상태(로그아웃이나 연동해제 하지않은 상태)에서 로그인 재시도
        self.naverDataFetch()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
         // 연동해제 콜백
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
         //  접근 토큰, 갱신 토큰, 연동 해제등이 실패
    }
    
}

extension SocialLoginViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("사용자가 로그인 취소, \(error)")
            return
        } else if let user = user {
            print("userID: \(user.userID)")
            print("idToken: \(user.authentication.idToken)")
            print("name: \(user.profile.name)")
            print("email: \(user.profile.email)")
            self.user = UserInfo()
            self.user?.name = user.profile.name
            self.user?.email = user.profile.email
            self.user?.accessToken = user.authentication.idToken
            self.user?.userId = user.userID;
            self.user?.profileImageUrl = nil
            self.decorationUi()
//            guard let authentication = user.authentication else { return }
//            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                               accessToken: authentication.accessToken)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
