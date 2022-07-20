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
    var openurl: String = "https://m.jd.com"
    var posturl: String = "https://jd.900109.xyz:8443/notify"
    
    override func loadView() {
        self.getParams()
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
            self.oldWebView = UIWebView()
            self.oldWebView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.oldWebView.delegate = self
            view = self.oldWebView
        }
    }
    
    // 初始化返回按钮，点击按钮返回主页面。
    func initBtn() {
        let screenSize = UIScreen.main.bounds.size
        let jumpBtn = UIButton(type: .system)
        jumpBtn.setTitle("返回", for: .normal)
        jumpBtn.frame = CGRect(x: screenSize.width / 2 - 50, y: screenSize.height - 50, width: 100, height: 30)
        jumpBtn.backgroundColor = UIColor(red: 50 / 255, green: 123 / 255, blue: 255 / 255, alpha: 1)
        jumpBtn.setTitleColor(UIColor.white, for: .normal)
        // 按钮绑定事件
        jumpBtn.addTarget(self, action: #selector(self.pageReturn), for: .touchDown)
        self.view.addSubview(jumpBtn)
    }
    
    @objc func pageReturn() {
        // 返回主页面
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initBtn()
        let myURL = URL(string: self.openurl)
        
        let myRequest = URLRequest(url: myURL!)
        
        if #available(iOS 11, *) {
            webView.load(myRequest)
            webView.navigationDelegate = self
            let dataStore = WKWebsiteDataStore.default()
            dataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    dataStore.httpCookieStore.delete(cookie)
                }
            }
            
        } else {
            self.oldWebView.loadRequest(myRequest)
            self.oldWebView.delegate = self
        }
    }
    
    // web页面加载完成后执行，这里用于提取cookie
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("openurl:", self.openurl, " posturl:", self.posturl)
        print("view")
        if #available(iOS 11, *) {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    if cookie.name == "pt_pin" {
                        self.pt_pin = cookie.value
                    }
                    if cookie.name == "pt_key" {
                        self.pt_key = cookie.value
                    }
                    print("cookie:", cookie.name, " value: ", cookie.value)
                }
                if !self.pt_pin.isEmpty, !self.pt_key.isEmpty {
                    // 推送到 hcl地址
                    self.pushCookie()
                }
            }
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
                    print("cookie:", cookie.name, " value: ", cookie.value)
                }
            }
            
            if !self.pt_pin.isEmpty, !self.pt_key.isEmpty {
                // 推送到 hcl地址
                self.pushCookie()
            }
        }
    }
    
    // 通过http推送cookie，并弹窗提示。
    func pushCookie() {
        let ck = String(format: "pt_pin=%@;pt_key=%@;", arguments: [self.pt_pin, self.pt_key])
        let baseUrl = self.posturl
        let url = baseUrl + "?hhkb=" + ck.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let u = URL(string: url)
        let semaphore = DispatchSemaphore(value: 0) // 异步改同步。
        URLSession(configuration: .default).dataTask(with: u!, completionHandler: {
            data, response, error in
            guard let data = data, let _: URLResponse = response, error == nil else {
                print("error")
                self.setmsg(title: "推送ck失败", msg: error!.localizedDescription)
                semaphore.signal()
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
            self.setmsg(title: "推送完成", msg: dataString!)
            semaphore.signal()
        }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        self.createAlert(withTitle: self.msgTitle, andDescription: self.msg)
    }
    
    // 用于异步进程传递数据
    func setmsg(title: String, msg: String) {
        self.msgTitle = title
        self.msg = msg
    }
    
    func getParams() {
        let dataStore = UserDefaults.standard
        self.openurl = dataStore.string(forKey: "OPENURL") ?? "https://m.jd.com"
        self.posturl = dataStore.string(forKey: "POSTURL") ?? "https://jd.900109.xyz:8443/notify"
    }
    
    // 弹窗提示，不能在 http的异步任务中调用。
    func createAlert(withTitle title: String, andDescription description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            _ in print("You tapped ok")
            // custom action here.
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
