//
//  VKLoginViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 16.01.2021.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scope = 262150 + 8192
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7728654"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "\(scope)"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
    
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { (result, param) in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
//        print(params)
        
        guard
            let token = params["access_token"],
            let userIdString = params["user_id"],
            let _ = Int(userIdString)
        else {
            decisionHandler(.allow)
            return
        }
        
        Session.shared.token = token
        performSegue(withIdentifier: "LoggedIn", sender: nil)
        
//        NetworkService.loadFriends()
//        NetworkService.loadPhotos()
//        NetworkService.loadGroups()
//        NetworkService.searchGroups(by: "Москва")
        
        decisionHandler(.cancel)
    }
}
