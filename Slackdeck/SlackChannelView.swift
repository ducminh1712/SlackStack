//
//  SlackChannelView.swift
//  Slackdeck
//
//  Created by mzp on 2017/04/29.
//  Copyright © 2017 mzp. All rights reserved.
//

import Cocoa
import WebKit

class SlackChannelView: WKWebView, WKNavigationDelegate {
    init(configuration : WKWebViewConfiguration) {
        super.init(frame: .zero, configuration: configuration)
        self.navigationDelegate = self
        self.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"

        // FIXME: this is example page
        if let url = URL(string: "https://misoca-inc.slack.com") {
            let request = URLRequest(url: url)
            self.load(request)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        insertContentsOfCSSFile(into: webView)
    }

    func insertContentsOfCSSFile(into webView: WKWebView) {
        guard let path = Bundle.main.path(forResource: "styles", ofType: "css") else {
            return
        }
        guard let cssString = try? String(contentsOfFile: path).replacingOccurrences(of: "\n", with: "") else {
            return
        }
        evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style); null")
    }
}
