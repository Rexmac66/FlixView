//
//  AppDelegate.swift
//  WKWebView
//
//  Created by Marco Barnig on 17/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa

// protocol
protocol feedBack {
    func output()
}    

var preferences: NSDictionary!


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var presentationOptions: NSApplication.PresentationOptions!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
         readPrefs()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOAD"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DIALOG"), object: self)
        
        let myWindow = NSApplication.shared.mainWindow!
        myWindow.delegate = self
        
        // Insert code here to initialize your application
        
        if preferences["HideMenuBar"] as! Bool {  // YES
            presentationOptions = [
                NSApplication.PresentationOptions.hideDock                 ,    // 2
                // .autoHideMenuBar            ,         // 4  )
                NSApplication.PresentationOptions.hideMenuBar                  ,     // 8     )  autoHide or Hide! not both
                NSApplication.PresentationOptions.disableAppleMenu           ,       //16
                //   .disableProcessSwitching    ,         // 32
                //      .disableForceQuit           ,           // 64
                //    .disableSessionTermination ,            // 128
                //      .disableHideApplication    ,     // 256
                NSApplication.PresentationOptions.fullScreen                  ,         // 1024
            ]
        } else {
            presentationOptions = [
                NSApplication.PresentationOptions.hideDock                     ,    // 2
                NSApplication.PresentationOptions.autoHideMenuBar            ,         // 4  )
                // .hideMenuBar                  ,     // 8     )  autoHide or Hide! not both
                NSApplication.PresentationOptions.disableAppleMenu               ,       //16
                //   .disableProcessSwitching    ,         // 32
                //      .disableForceQuit           ,           // 64
                //    .disableSessionTermination ,            // 128
                //      .disableHideApplication    ,     // 256
                NSApplication.PresentationOptions.fullScreen                           // 1024
            ]
        }
        
        //   myWindow.toggleFullScreen(self)
       // myWindow.contentView?.enterFullScreenMode(NSScreen.main()!, withOptions:presentationOptions)
       // self.view.wantsLayer = true

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }  // end func
    
    func readPrefs() {
        if let path = Bundle.main.path(forResource: "Preferences", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            preferences = dict as NSDictionary?
            print("---+++ Preferences:\(preferences!))")
            
        } else {
            print("--=!!! Prefs Read ERROR!")
        }
        // print("---+++ Prefs: VideoFolder: \(preferences["VideoFolder"]!)")
        // dump( preferences)
    }
    
}  // end class

extension AppDelegate: NSWindowDelegate {
    func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
        print("---+++ Window Full Screen, Will use options: \(presentationOptions!)")
        return NSApplication.PresentationOptions(rawValue: presentationOptions.rawValue)
    }
}

