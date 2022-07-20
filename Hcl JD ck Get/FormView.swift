//
//  form.swift
//  Hcl JD ck Get
//
//  Created by scjtqs on 2022/7/20.
//
import SwiftUI

struct HomeForm: View {
    @State var openurl: String
    @State var posturl: String
    @State var botton = false
    
    init(openUrl: String, postUrl: String) {
        self.openurl = openUrl
        self.posturl = postUrl
    }
    
    var body: some View {
        if self.botton {
            VStack {
                let screenSize = UIScreen.main.bounds.size
                FormControl(openurl: self.$openurl, posturl: self.$posturl)
                    .frame(width: screenSize.width, height: screenSize.height)
            }
        } else {
            NavigationView {
                Form {
                    Text("初学者做的web跳转页面").font(.headline)
                    HStack {
                        Image(systemName: "person.circle.fill")
                        TextField("打开页面地址", text: $openurl)
                    }
                    HStack {
                        Image(systemName: "envelope.circle.fill")
                        TextField("结果推送地址", text: $posturl)
                    }
                    Button(
                        action: {
                            botton = true
                            // 更新缓存
                            UserDefaults.standard.set(self.openurl, forKey: "OPENURL")
                            UserDefaults.standard.set(self.posturl, forKey: "POSTURL")
                        },
                        label: { Text("提交") }
                    )
                }.navigationBarTitle(Text("webview"))
            }
        }
    }
}
