//
//  ContentView.swift
//  StatusClock
//
//  Created by Pulsely on 11/12/22.
//

import SwiftUI

let DEFAULTS_TIME_ZONE = "DEFAULTS_TIME_ZONE"
let DEFAULTS_SHOW_HIDE_SECONDS = "DEFAULTS_SHOW_HIDE_SECONDS"


struct CustomizedMenuItem: View {
    @Binding var hoverTitle:String
    @State var title:String
    
    var action: () -> Void

    var body: some View {
        
        Button {
            action()

        } label: {
            
            
            HStack {
                Text( title )
                
                Spacer()
            }
            
            .foregroundColor( hoverTitle == title ? .white : .black )
            .frame(alignment: .leading)
            .frame(minWidth: .zero, maxWidth: .infinity)
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
            .contentShape(Rectangle())
            /*
            HStack {
                Text( value )
                
                Spacer()
            }
            
            .foregroundColor( hoverTitle == value ? .white : .black )
            .frame(alignment: .leading)
            .frame(minWidth: .zero, maxWidth: .infinity)
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
            .contentShape(Rectangle())
             */
        }
        
        .buttonStyle(.plain)
        .onHover { inside in
            if inside {
                self.hoverTitle = title
            } else {
                self.hoverTitle = ""
            }
        }
        .background(   hoverTitle == title ? .blue : .clear  )
        .cornerRadius(3)

    }
    
}


struct ContentView: View {
    @StateObject var viewModel:TimeCalculator = TimeCalculator()

    @State var hoverTitle = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach (self.viewModel.array_values, id: \.self) { value in

                CustomizedMenuItem(hoverTitle: self.$hoverTitle, title: value) {
                    self.viewModel.updateTimezone( value )
                    
                    NSApplication.shared.keyWindow?.close()

                }
            }
            Divider()
            
            
            if (self.viewModel.show_seconds) {
                CustomizedMenuItem(hoverTitle: self.$hoverTitle, title:  "Hide seconds" ) {
                    self.viewModel.show_seconds.toggle()
                    NSApplication.shared.keyWindow?.close()

                }
            } else {
                CustomizedMenuItem(hoverTitle: self.$hoverTitle, title: "Show seconds") {
                    self.viewModel.show_seconds.toggle()
                    NSApplication.shared.keyWindow?.close()

                }
            }

            
            Divider()
            
            CustomizedMenuItem(hoverTitle: self.$hoverTitle, title:  "About" ) {
                self.viewModel.show_seconds.toggle()
                if let url = URL(string: "https://www.pulsely.com") {
                    NSWorkspace.shared.open(url)
                }

            }

            Divider()
            
            CustomizedMenuItem(hoverTitle: self.$hoverTitle, title: "Quit") {
                self.viewModel.show_seconds.toggle()
                NSApplication.shared.terminate(nil)

            }
        }.frame(minWidth: 120.0)

        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
