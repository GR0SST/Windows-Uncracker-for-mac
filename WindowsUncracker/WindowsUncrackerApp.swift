//
//  WindowsUncrackerApp.swift
//  WindowsUncracker
//
//  Created by Grosst Grosst on 9/15/24.
//

import SwiftUI




@main
struct WindowsUncrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settingsManager = SettingsManager()
    var body: some Scene {
        WindowGroup {
            Title()
                .environmentObject(settingsManager)
            
                .onAppear {
                    // You can also add code here if needed
                    //print(SettingsManager().scale)
                    appDelegate.settingsManager = settingsManager


                }
        }.commands {
            CommandGroup(replacing: .newItem) {
                Button("New Window") {

                }
            }
        }
    }
    
}


// WindowDelegate to handle window closure
class WindowDelegate: NSObject, NSWindowDelegate {
    private let onClose: () -> Void
    
    init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }
    
    func windowWillClose(_ notification: Notification) {
        onClose()
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var settingsManager: SettingsManager?
    var statusItem: NSStatusItem?
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // Set up the button in the menu bar
        if let button = statusItem?.button {
                    // Set the custom PNG image as the menu bar icon
                    if let customImage = NSImage(named: "menubarIconBlack.png") {
                        button.image = customImage
                        button.imageScaling = .scaleProportionallyDown
                    } else {
                        // Handle case where the image is not found
                        button.image = NSImage(systemSymbolName: "questionmark", accessibilityDescription: "Placeholder Icon")
                    }
                    button.action = #selector(togglePopover)
                }

        // Create a SwiftUI view for the slider and attach it to the popover
        if let settingsManager = settingsManager {
            let sliderView = SliderView().environmentObject(settingsManager) // Use the shared instance
            popover = NSPopover()
            popover.behavior = .transient
            popover.contentSize = NSSize(width: 150, height: 50)
            popover.contentViewController = NSViewController()
            popover.contentViewController?.view = NSHostingView(rootView: sliderView)
        }
    }

    // Action when the menu bar button is clicked
    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover.isShown {
               // print(po)
                popover.performClose(nil)
                
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
                
            }
        }
    }
}



class SettingsManager: ObservableObject {
    private let defaults = UserDefaults.standard
    
    @Published var opasity: Int {
        didSet {
            defaults.set(opasity, forKey: "opasity")
        }
    }
    
    @Published var scale: Int {
        didSet {
            defaults.set(scale, forKey: "scale")
        }
    }
    
    @Published var xOffset: Int {
        didSet {
            defaults.set(xOffset, forKey: "xOffset")
        }
    }
    
    @Published var yOffset: Int {
        didSet {
            defaults.set(yOffset, forKey: "yOffset")
        }
    }
    
    @Published var hideDockIcon: Bool {
          didSet {
              defaults.set(hideDockIcon, forKey: "hideDockIcon")
              updateDockIconVisibility()
          }
      }
    
    init() {
        self.opasity = defaults.value(forKey: "opasity") as? Int ?? 90
        self.scale = defaults.value(forKey: "scale") as? Int ?? 80
        self.xOffset = defaults.value(forKey: "xOffset") as? Int ?? 86
        self.yOffset = defaults.value(forKey: "yOffset") as? Int ?? 96
        self.hideDockIcon = defaults.value(forKey: "hideDockIcon") as? Bool ?? false
        updateDockIconVisibility()
    }
    
    private func updateDockIconVisibility() {
        DispatchQueue.main.async {
            if let app = NSApp {
                app.setActivationPolicy(self.hideDockIcon ? .accessory : .regular)
            } else {
                print("Error: NSApp is nil.")
            }
        }
    }
}
