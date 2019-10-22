//
//  WebViewController.swift
//  WKWebView
//
//  Created by Marco Barnig on 17/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate {
    
    var delegate: feedBack?   
    
    var myWebView: WKWebView!
    
    func output(item: AnyObject) {
        outputText += "ScrollView : " + String(describing: item.scrollView)
        outputText += "Title : " + item.title!
        // print("URL : " + String(item.url)!) // crash
        outputText += "UserAgent : " + item.customUserAgent!
        outputText += "serverTrust : " + String(describing: item.serverTrust)
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ myWebView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        outputText += "1. The web content is loaded in the WebView.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ myWebView: WKWebView, didCommit navigation: WKNavigation!) {
        outputText += "2. The WebView begins to receive web content.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
        myWebView.alphaValue = 1.0
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when, execute:{
            self.goFulllScreen()
        })
        
    }  // end func
    
    func webView(_ myWebView: WKWebView, didFinish navigation: WKNavigation!) {
        outputText += "3. The navigating to url \(myWebView.url!) finished.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    //    let when = DispatchTime.now() + 1
    //    DispatchQueue.main.asyncAfter(deadline: when, execute:{
    //        self.goFulllScreen()
    //    } )
    }  // end func
    
    func webViewWebContentProcessDidTerminate(_ myWebView: WKWebView) {
        outputText += "The Web Content Process is finished.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ myWebView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        outputText += "An error didFail occured.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ myWebView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        outputText += "An error didFailProvisionalNavigation occured.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ myWebView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        outputText += "The WebView received a server redirect.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    // the following function handles target="_blank" links by opening them in thesame view
    func webView(_ myWebView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        outputText += "New Navigation.\n"
        if navigationAction.targetFrame == nil {
            outputText += "Trial to open a blank window.\n"
            outputText += "navigationAction : " + String(describing: navigationAction) + ".\n"
            let newLink = navigationAction.request
            outputText += "\nThe new navigationAction is : " + String(describing: navigationAction) + ".\n\n"
            outputText += "The new URL is : " + String(describing: newLink.url!) + ".\n"
            NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)  
            openSafari(link: newLink.url!)
        }  // end if
        return nil
    } // end func
    
    func openSafari(link: URL) {
        let checkURL = link
        if NSWorkspace.shared.open(checkURL as URL) {
            outputText += "URL Successfully Opened in Safari.\n"
        } else {
            outputText += "Invalid URL in Safari.\n"
        }  // end if
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func    
    
    func react() {
       // outputText += "\nHi. How are you? Here is the \"dummy\" react function speaking!\n\n"
        if let doAction = delegate { 
            DispatchQueue.main.async() { 
                doAction.output()
            }  // end dispatch
        } // end if doAction        
    }  // end func

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadWebPage), name: NSNotification.Name(rawValue: "LOAD"), object: nil)
        // Do view setup here.
        outputText += "0. WebViewController View loaded.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
        let configuration = WKWebViewConfiguration()
        myWebView = WKWebView(frame: .zero, configuration: configuration)
        myWebView.translatesAutoresizingMaskIntoConstraints = false
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        myWebView.alphaValue = 0.7
        //myWebView.configuration.preferences.plugInsEnabled = true // sliverlight still no go
        let userAgentValue = "Mozilla/5.0 (Macintosh; RexIntel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
        // "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
        myWebView.customUserAgent = userAgentValue

        view.addSubview(myWebView)
        
        // topAnchor only available in version 10.11
        [myWebView.topAnchor.constraint(equalTo: view.topAnchor),
         myWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         myWebView.leftAnchor.constraint(equalTo: view.leftAnchor),
         myWebView.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach  { 
            anchor in
            anchor.isActive = true
        }  // end forEach
    //    // let myURL = URL(string: "http://localhost:8042")
    //    let myURL = URL(string: "http://netflix.com")  // "http://www.web3.lu/")
    //    print("---+++ \(preferences)")
    //   // let webTitle = preferences["WebSite"] as! String
    //   // let myURL = URL(string: webTitle)
    //    let myRequest = URLRequest(url: myURL!)
    //    myWebView.load(myRequest)
    }  // end func
    
    @objc func loadWebPage() {
        // let myURL = URL(string: "http://netflix.com")  // "http://www.web3.lu/")
        let webTitle = preferences["WebSite"] as! String
        let myURL = URL(string: webTitle)
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
    }
    
    //----------------------------------------------
    //override func viewDidAppear() {
    //    let presOptions: NSApplicationPresentationOptions = [
    //
    //        //----------------------------------------------
    //        // These are all the options for the NSApplicationPresentationOptions
    //        // BEWARE!!!
    //        // Some of the Options may conflict with each other
    //        //----------------------------------------------
    //
    //        //  .Default                   |
    //        //  .AutoHideDock              |   // Dock appears when moused to
    //        //  .autoHideMenuBar            // Menu Bar appears when moused to
    //        //  .DisableForceQuit          |   // Cmd+Opt+Esc panel is disabled
    //        //  .DisableMenuBarTransparency|   // Menu Bar's transparent appearance is disabled
    //        //  .FullScreen                |   // Application is in fullscreen mode
    //        .hideDock                   ,   // Dock is entirely unavailable. Spotlight menu is disabled.
    //        //.hideMenuBar               ,   // Menu Bar is Disabled\
    //        .autoHideMenuBar            ,       // NOTE: .autoHideMemuBar .hideMenuBar ar mutualy exclusive
    //        .disableAppleMenu          ,   // All Apple menu items are disabled.
    //        .disableProcessSwitching   ,   // Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
    //        .disableSessionTermination ,   // PowerKey panel and Restart/Shut Down/Log Out are disabled.
    //        .disableHideApplication    ,  // Application "Hide" menu item is disabled.
    //        .autoHideToolbar
    //    ]
    //
    //    let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions:
    //        presOptions.rawValue]
    //
    //    //let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions :
    //      //   NSNumber(unsignedLong: presOptions.rawValue)]
    //
    //    self.view.enterFullScreenMode(NSScreen.main()!, withOptions:optionsDictionary)
    //    self.view.wantsLayer = true
    //}
    
    //----------------------------------------------
    func goFulllScreen() {
        var presOptions: NSApplication.PresentationOptions = [
            
            //----------------------------------------------
            // These are all the options for the NSApplicationPresentationOptions
            // BEWARE!!!
            // Some of the Options may conflict with each other
            //----------------------------------------------
            
            //  .Default                   |
            //  .AutoHideDock              |   // Dock appears when moused to
            //  .autoHideMenuBar            // Menu Bar appears when moused to
            //  .DisableForceQuit          |   // Cmd+Opt+Esc panel is disabled
            //  .DisableMenuBarTransparency|   // Menu Bar's transparent appearance is disabled
            //  .FullScreen                |   // Application is in fullscreen mode
            NSApplication.PresentationOptions.hideDock                   ,   // Dock is entirely unavailable. Spotlight menu is disabled.
            //.hideMenuBar               ,   // 8 Menu Bar is Disabled\
            NSApplication.PresentationOptions.autoHideMenuBar            ,    // 4 NOTE: .autoHideMemuBar .hideMenuBar ar mutualy exclusive
            NSApplication.PresentationOptions.disableAppleMenu          ,   // All Apple menu items are disabled.
            NSApplication.PresentationOptions.disableProcessSwitching   ,   // Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
            NSApplication.PresentationOptions.disableSessionTermination ,   // PowerKey panel and Restart/Shut Down/Log Out are disabled.
            NSApplication.PresentationOptions.disableHideApplication    ,  // Application "Hide" menu item is disabled.
            NSApplication.PresentationOptions.autoHideToolbar
        ]

        if preferences["HideMenuBar"] as! Bool {    // flip bits 4,8  if hide menubar
            presOptions =  NSApplication.PresentationOptions(rawValue: presOptions.rawValue ^ 12) // NSApplicationPresentationOptions.autoHideDock
        }
      // let binStr =  String(presOptions.rawValue, radix:2)
      //  print("---+++ pres Options: \( binStr)")
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions:
            presOptions.rawValue]
        
        //let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions :
        //   NSNumber(unsignedLong: presOptions.rawValue)]
        
        self.view.enterFullScreenMode(NSScreen.main!, withOptions:optionsDictionary)
        self.view.wantsLayer = true
    }
    
}  // end class
