//
//  NfcViewController.swift
//  SwiftTestProject
//
//  Created by 김학철 on 2020/07/09.
//  Copyright © 2020 김학철. All rights reserved.
//

import UIKit
import CoreNFC
import Foundation
import SystemConfiguration.CaptiveNetwork

enum NfcType: String {
    case read, write;
}
struct WiFiInfo {
    var rssi: String
    var networkName: String
    var macAddress: String
}
class NfcViewController: UIViewController {
    
    @IBOutlet weak var lbReadDescription: UILabel!
    @IBOutlet weak var svRead: UIStackView!
    @IBOutlet weak var svWrite: UIStackView!
    @IBOutlet weak var btnWrite: CButton!
    @IBOutlet weak var btnRead: CButton!
    @IBOutlet weak var tfWifiName: UITextField!
    @IBOutlet weak var tfWifiPassword: UITextField!
    @IBOutlet weak var lbReadName: UILabel!
    @IBOutlet weak var lbReadPass: UILabel!
    
    public var type:NfcType?
    var session: NFCNDEFReaderSession?
    
    var wifiName: String?
    var wifiPass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .read {
            svWrite.isHidden = true
        }
        else {
            svRead.isHidden = true
        }
        
        lbReadName.text = ""
        lbReadPass.text = ""
        lbReadDescription.text = ""
        if self.type == .write {
            tfWifiName.text = "dodam"
            tfWifiPassword.text = "dodam123!"
            
            let ssids = getWiFiInfo()
        }
    }
    func getWiFiInfo() -> WiFiInfo? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        var wifiInfo: WiFiInfo? = nil
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else {
                return nil
            }
            guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            var rssi: Int = 0
            print("ssid : \(ssid)")
            print("bssid : \(bssid)")
            //               if let strength = getWifiStrength() {
            //                   rssi = strength
            //               }
            //               wifiInfo = WiFiInfo(rssi: "\(rssi)", networkName: ssid, macAddress: bssid)
            break
        }
        return wifiInfo
    }
    
    @IBAction func onClickedButtonActions(_ sender: CButton) {
        
        if sender == btnRead {
            session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            session?.alertMessage = "Hold Your Iphone near an NDEF tag to write the message"
            session?.begin()
        }
        else if sender == btnWrite {
        
            wifiName = tfWifiName.text
            wifiPass = tfWifiPassword.text
            
            if wifiName!.count > 0 && wifiPass!.count > 0 {
                session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
                session?.alertMessage = "Hold Your Iphone near an NDEF tag to write the message"
                session?.begin()
            }
            else {
                print("textfield wifi name or pass empty")
            }
        }
    }
    func createTextPayload() -> NFCNDEFPayload? {
        
        guard let name = wifiName, let passwd = wifiPass else {
            return nil
        }
        
        if name.count == 0 || passwd.count == 0 {
            return nil
        }
        let msg = """
            {
                "wifi_name":"\(name)",
                "wifi_pass":"\(passwd)"
            }
            """
        
        return NFCNDEFPayload.wellKnownTypeTextPayload(string: msg, locale: Locale.current)
    }
}

extension NfcViewController: NFCNDEFReaderSessionDelegate {
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alert = UIAlertController(title: "Session Invaidated", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        
        
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.microseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try agin."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        
        let tag = tags.first!
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus { (ndfStatus: NFCNDEFStatus, capacity:Int, error:Error?) in
                if error != nil {
                    session.alertMessage = "Unable to query NDEF status of tag."
                    session.invalidate()
                    return
                }
                
                switch ndfStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                case .readWrite:
                    if self.type == .read {
                        tag.readNDEF { (message: NFCNDEFMessage?, error: Error?) in
                            var statusMessage: String
                            
                            if nil != error || nil == message {
                                statusMessage = "Fail to read NDEF from tag"
                            }
                            else {
                                statusMessage = "Found 1 NDEF message"
                                
                                if let recode = message?.records.first {
//                                    self.lbReadName.text = ""
//                                    self.lbReadPass.text = ""
                                    
                                    switch recode.typeNameFormat {
                                    case .nfcWellKnown:
                                        let typeNameFormat = recode.typeNameFormat.rawValue
                                        let type = String(data: recode.type, encoding: .utf8)
                                        let identifier = String(data: recode.identifier, encoding: .utf8)
                                    
                                        let hexString = recode.payload.hexEncodedString()
                                        let decodedStr = hexString.hexToString()
                                        let index = decodedStr.firstIndex(of: "{")!
                                        let countryCode = String(decodedStr[..<index])
                                        let json = String(decodedStr[index...])
                                        
                                        let data = json.data(using: .utf8)
                                        
                                        if let data = data {
                                            do {
                                                let dict = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                                                DispatchQueue.main.async {
                                                    if let name = dict["wifi_name"] as? String {
                                                        self.lbReadName.text = name
                                                    }
                                                    if let pass = dict["wifi_pass"] as? String {
                                                        self.lbReadPass.text = pass;
                                                    }
                                                    self.lbReadDescription.text = "type:\(type!), typeNameFormat:\(typeNameFormat), countryCode:\(countryCode )"
                                                }
                                            } catch {
                                                print("error1");
                                            }
                                        }
                                        else {
                                            print("error2");
                                        }
                                        print("decryte : \(decodedStr)")
                                        break
                                    case .absoluteURI:
                                        if let text = String(data: recode.payload, encoding: .utf8) {
                                            print("\(text)")
                                        }
                                        break
                                    case .media:
                                        if let type = String(data: recode.type, encoding: .utf8) {
                                            print("\(recode.typeNameFormat): " + type)
                                        }
                                        break
                                    case .nfcExternal, .empty, .unchanged, .unknown:
                                        fallthrough
                                    @unknown default:
                                        break
                                    }
                                    session.alertMessage = statusMessage
                                    session.invalidate()
                                }
                            }
                        }
                    }
                    else {
                        guard let payload = self.createTextPayload() else {
                            session.alertMessage = "Empty Write Data"
                            session.invalidate()
                            return
                        }
                        
                        tag.writeNDEF(NFCNDEFMessage.init(records: [payload])) { (error: Error?) in
                            if error != nil {
                                session.alertMessage = "Write NDEF message fail: \(error!)"
                                print(error?.localizedDescription ?? "")
                            }
                            else {
                                session.alertMessage = "Write NDEF message successful."
                                print("well done")
                            }
                            session.invalidate()
                        }
                    }
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            }
            
        }
    }
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        
    }
    
    
}
extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
extension String {
    func hexToString()-> String {
        var newString = ""
        var i = 0
        while i < self.count {
            let hexChar = (self as NSString).substring(with: NSRange(location: i, length: 2))
            if let byte = Int8(hexChar, radix: 16) {
                if (byte != 0) {
                    newString += String(format: "%c", byte)
                }
            }
            i += 2
        }
        return newString
    }
}
