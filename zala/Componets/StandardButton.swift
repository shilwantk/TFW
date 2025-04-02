//
//  StandardButton.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import Foundation
import SwiftUI


struct BorderedButton: View {
    
    @State var title:       String
    @State var titleColor:  Color = Theme.shared.blue
    @State var color:         Color = Theme.shared.blue
    @State var leftIcon:     Image? = nil
    @State var rightIcon:   Image? = nil
    @State var rightIconColor:   Color? = nil
    @State var height:   CGFloat = 55
    
    var onTapped: (() -> Void)?
    var body: some View {
        Button {
            onTapped?()
        } label: {
            HStack(alignment: .center) {
                if let leftIcon {
                    leftIcon
                }
                Text(title)
                    .foregroundColor(titleColor)
                    .bold()
                if let rightIcon {
                    if let rightIconColor {
                        rightIcon
                            .renderingMode(.template)
                            .foregroundColor(rightIconColor)
                    } else {
                        rightIcon
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: height)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 1)
            )
        }
    }
}


struct StandardButton: View {
    
    @State var title:       String
    @State var titleColor:  Color = .white
    @State var color:         Color = Theme.shared.blue
    @State var leftIcon:     Image? = nil
    @State var rightIcon:   Image? = nil
    @State var rightIconColor:   Color? = nil
    @State var height:   CGFloat = 55
    
    var onTapped: (() -> Void)?
    var body: some View {
        Button {
            onTapped?()
        } label: {
            HStack(alignment: .center) {
                if let leftIcon {
                    leftIcon
                        .renderingMode(.template)
                        .foregroundColor(titleColor)
                }
                Text(title)
                    .foregroundColor(titleColor)
                    .bold()
                if let rightIcon {
                    if let rightIconColor {
                        rightIcon
                            .renderingMode(.template)
                            .foregroundColor(rightIconColor)
                    } else {
                        rightIcon
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: height)
        }
        .tint(color)
        .background(RoundedRectangle(cornerRadius: 12).fill(color))
        
//        .buttonStyle(.borderedProminent)
    }
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(title: "View Assessment Details")
    }
}

extension StandardButton {
    func onTapped(action: @escaping (() -> Void)) -> StandardButton {
        StandardButton(title: "", onTapped: action)
    }
}



struct SubscriptionButton: View {
    
    @Binding var title:       String
    @State var titleColor:  Color = .white
    @State var color:         Color = Theme.shared.blue
    @State var leftIcon:     Image? = nil
    @State var rightIcon:   Image? = nil
    @State var rightIconColor:   Color? = nil
    @State var height:   CGFloat = 55
    
    var onTapped: (() -> Void)?
    var body: some View {
        Button {
            onTapped?()
        } label: {
            HStack(alignment: .center) {
                if let leftIcon {
                    leftIcon
                }
                Text(title)
                    .foregroundColor(titleColor)
                    .bold()
                if let rightIcon {
                    if let rightIconColor {
                        rightIcon
                            .renderingMode(.template)
                            .foregroundColor(rightIconColor)
                    } else {
                        rightIcon
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: height)
        }
        .tint(color)
        .background(RoundedRectangle(cornerRadius: 12).fill(color))
        
//        .buttonStyle(.borderedProminent)
    }
}

extension SubscriptionButton {
    func onTapped(action: @escaping (() -> Void)) -> SubscriptionButton {
        SubscriptionButton(title: $title, onTapped: action)
    }
}
