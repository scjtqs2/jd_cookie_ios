//
//  FormController.swift
//  Hcl JD ck Get
//
//  Created by scjtqs on 2022/7/20.
//

import SwiftUI

import UIKit

struct FormControl: UIViewControllerRepresentable {
    
    @Binding var openurl: String
    @Binding var posturl: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    

    func makeUIViewController(context: Context) -> HomeViewController {
        let control = HomeViewController()
        print("初始化")
        return control
    }

    func updateUIViewController(_ uiView: HomeViewController, context: Context) {
        let vc = HomeViewController()
        print("更新页面咯")
        vc.setParams(openurl: self.openurl, postUrl: self.posturl)
//        vc.pageJump()
    }

    class Coordinator: NSObject {
        var control: FormControl

        init(_ control: FormControl) {
            self.control = control
        }

        @objc
        func updateCurrentPage(sender: HomeViewController) {
            
        }
    }
}
