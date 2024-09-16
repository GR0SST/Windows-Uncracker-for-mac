//
//  ContentView.swift
//  WindowsUncracker
//
//  Created by Grosst Grosst on 9/15/24.
//

import SwiftUI

struct Title: View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    var scale: CGFloat {
        CGFloat(settingsManager.scale) / 100
    }
    
    var opasity: CGFloat {
        CGFloat(settingsManager.opasity) / 100
    }
    
    var xOffset: Int {
        settingsManager.xOffset
    }
    
    var yOffset: Int {
        settingsManager.yOffset
    }
    
    var hideDockIcon: Bool {
        settingsManager.hideDockIcon
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                Text("Activate Windows").font(.custom("Segoe UI", size: 33*scale)).fontWeight(.regular).foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.53, opacity: opasity) ).frame(maxWidth: .infinity, alignment:.leading)
            }
            HStack(alignment: .top) {
                Text("Go to Settings to activate Windows.").font(.custom("Segoe UI", size: 25*scale)).fontWeight(.light).foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.53, opacity: opasity) ).kerning(1*scale).frame(maxWidth: .infinity, alignment:.leading)
            }
        }
        .frame(width: 430*scale, height:80*scale , alignment: .center)
        
        .onAppear {
            setup()
            
        }
        .onChange(of: settingsManager.scale) { _ in
            update()
        }
        .onChange(of: settingsManager.opasity) { _ in
            update()
        }
        .onChange(of: settingsManager.xOffset) { _ in
            update()
        }
        .onChange(of: settingsManager.yOffset) { _ in
            update()
        }
        .onChange(of: settingsManager.hideDockIcon) { _ in
            update()
        }
        
        
    }
    private func update() {
        for window in NSApplication.shared.windows {
            if !window.title.contains("main") { // Replace with your condition
                continue
            }
            if let app = NSApp {
                app.setActivationPolicy(hideDockIcon ? .accessory : .regular)
            }
            window.orderFront(nil)
            
            let xOffsetNormalised: CGFloat = CGFloat(xOffset)/100
            let yOffsetNormalised:CGFloat = 1-(CGFloat(yOffset)/100)
            
            let width: CGFloat = 420 * scale
            let height: CGFloat = 80 * scale
            
            let screenFrame = NSScreen.main?.frame ?? CGRect.zero
            
            let xPosition: CGFloat = screenFrame.width*xOffsetNormalised // Set your desired x position
            let yPosition: CGFloat = screenFrame.height*yOffsetNormalised // Set your desired y position
            
            let windowFrame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            // Set the window's frame
            window.setFrame(windowFrame, display: true)
        }
    }
    private func setup() {
        // Accessing the NSWindow for the SwiftUI view
        
        for window in NSApplication.shared.windows {
            window.title = "main"
            if let app = NSApp {
                app.setActivationPolicy(hideDockIcon ? .accessory : .regular)
            }
            window.level = .floating
            window.isOpaque = false
            window.backgroundColor = NSColor.clear
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            window.styleMask.insert(.fullSizeContentView)
            
            window.styleMask.remove(.titled)
            
            window.styleMask.remove(.miniaturizable)
            window.styleMask.remove(.resizable)
            window.hasShadow = false
            
            window.ignoresMouseEvents = true
            
            window.orderFront(nil)
            
            let xOffsetNormalised: CGFloat = CGFloat(xOffset)/100
            let yOffsetNormalised:CGFloat = 1-(CGFloat(yOffset)/100)
            
            let width: CGFloat = 420 * scale
            let height: CGFloat = 80 * scale
            
            let screenFrame = NSScreen.main?.frame ?? CGRect.zero
            
            let xPosition: CGFloat = screenFrame.width*xOffsetNormalised // Set your desired x position
            let yPosition: CGFloat = screenFrame.height*yOffsetNormalised // Set your desired y position
            
            let windowFrame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            // Set the window's frame
            window.setFrame(windowFrame, display: true)
        }
    }
}


struct SliderView: View {
    @EnvironmentObject var settingsManager: SettingsManager // Access the shared SettingsManager
    
    var body: some View {
        VStack {
            Slider(value: Binding(
                get: { Double(settingsManager.scale) },
                set: { settingsManager.scale = Int($0) }
            ), in: 0...100)
            .padding([.leading, .trailing], 15)
            Text("Scale: \(settingsManager.scale)").padding([.bottom], 5)
            
            Slider(value: Binding(
                get: { Double(settingsManager.opasity) },
                set: { settingsManager.opasity = Int($0) }
            ), in: 0...100)
            .padding([.leading, .trailing], 15)
            Text("Opacity: \(settingsManager.opasity)").padding([.bottom], 5)
            
            Slider(value: Binding(
                get: { Double(settingsManager.xOffset) },
                set: { settingsManager.xOffset = Int($0) }
            ), in: 0...100)
            .padding([.leading, .trailing], 15)
            Text("Horizontal Offset: \(settingsManager.xOffset)").padding([.bottom], 5)
            
            Slider(value: Binding(
                get: { Double(settingsManager.yOffset) },
                set: { settingsManager.yOffset = Int($0) }
            ), in: 0...100)
            .padding([.leading, .trailing], 15)
            Text("Vertical Offset: \(settingsManager.yOffset)").padding([.bottom], 15)
            
            Button(action: {
                settingsManager.hideDockIcon.toggle()
            }) {
                Text(settingsManager.hideDockIcon ? "Show on Dock" : "Hide on Dock")
            }
            
            Button(action: {
                NSApp.terminate(nil)
            }) {
                Text("Quit")
                    .foregroundColor(.red)
            }
        }
        .frame(width: 250, height: 300)
    }
}
#Preview {
    
    SliderView().environmentObject(SettingsManager())
}
