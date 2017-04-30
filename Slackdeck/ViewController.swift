//
//  ViewController.swift
//  Slackdeck
//
//  Created by mzp on 2017/04/29.
//  Copyright © 2017 mzp. All rights reserved.
//

import Cocoa
import WebKit
import NorthLayout
import Ikemen

fileprivate let configuration = WKWebViewConfiguration()

class ViewController: NSViewController {
    private var channels : [SlackChannelView] = []
    private let stackView = NSStackView() ※ { sv in
        sv.spacing = 0.0
        sv.distribution = .fillEqually
    }

    override func loadView() {
        if let frame = NSScreen.main()?.frame {
            self.view = NSView(frame: NSMakeRect(0, 0, frame.width * 0.8, frame.height * 0.8))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        channels = Prefercences.urls.map { url in
            SlackChannelView(configuration: configuration) ※ { wk in
                wk.loadURL(url: url)
            }
        }
    }

    override func viewDidAppear() {
        let autolayout = view.northLayoutFormat([:], [
            "stack": stackView
        ])
        autolayout("V:|[stack]|")
        autolayout("H:|[stack]|")
        showChannels()
    }

    override func viewWillDisappear() {
        Prefercences.urls = channels.flatMap { channel in
            channel.url?.absoluteString
        }
    }

    // MARK: - channel
    func addChannel() {
        self.channels.append(SlackChannelView(configuration: configuration) ※ { wk in
            wk.loadURL(url: defaultUrl)
        })
        showChannels()
    }

    func removeChannel(responder : NSResponder) {
        self.channels = channels.filter { ch in
            ch != responder
        }
        showChannels()
    }

    // MARK: - row
    func addRow() {
    }

    func removeRow(responder : NSResponder) {
    }

    // MARK: - view
    private func showChannels() {
        stackView.setViews(channels, in: .leading)
    }

    // MARK: - URL
    private var defaultUrl : String {
        get {
            return self.channels.first?.url?.absoluteString ?? "https://misoca-inc.slack.com"
        }
    }
}
