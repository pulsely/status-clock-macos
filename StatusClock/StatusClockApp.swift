//
//  StatusClockApp.swift
//  StatusClock
//
//  Created by Pulsely on 11/12/22.
//

import SwiftUI

let STATUS_ITEM_VIEW_WIDTH_WITH_SECONDS = 92
//let STATUS_ITEM_VIEW_WIDTH_NO_SECONDS = 90.0

@main
struct StatusClockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel:TimeCalculator = TimeCalculator()
    
    @State private var display_time = ""
    
    func viewDidLoad() {
        self.viewModel.checkTimeZone()
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.display_time = self.viewModel.updateTime()
        }
    }
    
    var body: some Scene {
        Settings {
            ContentView()
        }

        /*
        MenuBarExtra {
            ForEach (self.viewModel.array_values, id: \.self) { value in
                Button( value ) {
                    self.viewModel.updateTimezone( value )
                }
                
            }
            Divider()
            
            Button(action: {
                self.viewModel.show_seconds.toggle()
            }) {
                if (self.viewModel.show_seconds) {
                    Text("Hide seconds")
                } else {
                    Text("Show seconds")
                }
            }
            
            Divider()
            
            Link("About", destination: URL(string: "https://www.pulsely.com/")!)
            
            Divider()
            
            Button("Quit") {
                
                NSApplication.shared.terminate(nil)
                
            }.keyboardShortcut("q")
        } label: {
            Text( self.display_time )
                .task {
                    self.viewDidLoad()
                }
        }*/
        
        
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)

        self.popover = popover
        
        
        let viewModel:TimeCalculator = TimeCalculator()
        
        var width:CGFloat
        
        
        if (!UserDefaults.standard.bool(forKey: DEFAULTS_SHOW_HIDE_SECONDS)) {
            width = NSStatusItem.variableLength
        } else {
            width = CGFloat(STATUS_ITEM_VIEW_WIDTH_WITH_SECONDS)
        }
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: width)
        statusBarItem.button?.title = viewModel.updateTime()
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.statusBarItem.button?.title = viewModel.updateTime()

            
        }
        statusBarItem.button?.action = #selector(togglePopover(_:))
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}

