//
//  HomeViewController.swift
//  Hcl JD ck Get
//
//  Created by scjtqs on 2022/7/20.
//

import UIKit

class HomeViewController: UIViewController {
    var openurl = ""
    var posturl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBtn()
    }

    // 初始化按钮，点击按钮跳转页面
    func initBtn() {
        let screenSize = UIScreen.main.bounds.size
        let jumpBtn = UIButton(type: .system)
        jumpBtn.setTitle("打开页面", for: .normal)
        jumpBtn.frame = CGRect(x: screenSize.width / 2 - 50, y: screenSize.height - 50, width: 100, height: 30)
        jumpBtn.backgroundColor = UIColor(red: 50 / 255, green: 123 / 255, blue: 255 / 255, alpha: 1)
        jumpBtn.setTitleColor(UIColor.white, for: .normal)
        // 按钮绑定事件，点击时执行
        jumpBtn.addTarget(self, action: #selector(self.pageJump), for: .touchDown)
        self.view.addSubview(jumpBtn)
    }

    func setParams(openurl: String, postUrl: String) {
        self.openurl = openurl
        self.posturl = postUrl
    }

    @objc func pageJump() {
        // 创建一个页面
        let destination = WebViewVC()
        // 跳转
        self.present(destination, animated: true, completion: nil)
    }
}
