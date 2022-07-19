//
//  ViewController.swift
//  Hcl JD ck Get
//
//  Created by scjtqs on 2022/7/19.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate {

    var webView: WKWebView!
    var oldWebView: UIWebView!
    var pt_pin = ""
    var pt_key = ""
    var msg = ""
    var msgTitle = ""
    
    override func loadView() {
        
        if #available(iOS 11, *) {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            preferences.javaScriptCanOpenWindowsAutomatically = true
            let webConfiguration = WKWebViewConfiguration()
            webConfiguration.preferences = preferences
            
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            
//            let userAgentValue = "Chrome/56.0.0.0 Mobile"
//            webView.customUserAgent = userAgentValue
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.uiDelegate = self
            view = webView
            
        } else {
            oldWebView = UIWebView()
            oldWebView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            oldWebView.delegate = self
            view = oldWebView
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myURL = URL(string: "https://m.jd.com")
        let myRequest = URLRequest(url: myURL!)
        
        if #available(iOS 11, *) {
            webView.load(myRequest)
            webView.navigationDelegate = self
            let dataStore = WKWebsiteDataStore.default()
            dataStore.httpCookieStore.getAllCookies({ (cookies) in
                for cookie in cookies {
                    dataStore.httpCookieStore.delete(cookie)
                }
            })
           
        } else {
            oldWebView.loadRequest(myRequest)
            oldWebView.delegate = self
        }
        
    }
    

    
    // web页面加载完成后执行，这里用于提取cookie
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("view")
        if #available(iOS 11, *) {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.httpCookieStore.getAllCookies({ (cookies) in
            for cookie in cookies {
                if cookie.name == "pt_pin" {
                    self.pt_pin = cookie.value
                }
                if cookie.name == "pt_key" {
                    self.pt_key = cookie.value
                }
                print("cookie:",cookie.name," value: ",cookie.value)
            }
            if !self.pt_pin.isEmpty && !self.pt_key.isEmpty {
                // 推送到 hcl地址
                self.pushCookie()
            }
            })
        } else {
            guard let cookies = HTTPCookieStorage.shared.cookies else {
                return
            }
            // print(cookies)
            if self.pt_pin.isEmpty || self.pt_key.isEmpty {
                for cookie in cookies {
                    if cookie.name == "pt_pin" {
                        self.pt_pin = cookie.value
                    }
                    if cookie.name == "pt_key" {
                        self.pt_key = cookie.value
                    }
                    print("cookie:",cookie.name," value: ",cookie.value)
                }
            }

            if !self.pt_pin.isEmpty && !self.pt_key.isEmpty {
                // 推送到 hcl地址
                    self.pushCookie()
            }
        }
    }
    
    // 通过http推送cookie，并弹窗提示。
    func pushCookie () {
          let ck = String(format: "pt_pin=%@;pt_key=%@;", arguments: [self.pt_pin,self.pt_key])
          let baseUrl = "https://jd.900109.xyz:8443/notify"
          let url = baseUrl + "?hhkb=" + ck.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
          let u = URL(string: url)
          let semaphore = DispatchSemaphore(value: 0) // 异步改同步。
          URLSession(configuration: .default).dataTask(with: u!,completionHandler: {
              (data, response, error) in
              guard let data = data, let _:URLResponse = response, error == nil else {
                      print("error")
                  self.setmsg(title: "推送ck失败", msg: error!.localizedDescription)
                  semaphore.signal()
                  return
              }
              let dataString =  String(data: data, encoding: String.Encoding.utf8)
              print(dataString)
              self.setmsg(title: "推送完成", msg: dataString!)
              semaphore.signal()
              return
          }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        self.createAlert(withTitle: self.msgTitle, andDescription: self.msg)
    }
    
    // 用于异步进程传递数据
    func setmsg(title: String ,msg: String) {
        self.msgTitle=title
        self.msg=msg
    }
    
    // 弹窗提示，不能在 http的异步任务中调用。
    func createAlert(withTitle title:String,andDescription description: String) {
         let alert = UIAlertController.init(title: title, message: description, preferredStyle: .alert)
         let okAction = UIAlertAction.init(title: "Ok", style: .default) {
             _ in print("You tapped ok")
            //custom action here.
         }
         alert.addAction(okAction)
         self.present(alert, animated: true, completion: nil)
    }
}
