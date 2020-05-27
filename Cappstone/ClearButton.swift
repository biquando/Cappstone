//
//  ClearButton.swift
//  Cappstone
//
//  Created by Quan Do on 5/19/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import Foundation
import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    var yOffset: CGFloat = 0
    
    public func body(content: Content) -> some View {
        HStack {
            
            content
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .offset(x: -13, y: yOffset)
            }
        }
    }
}
