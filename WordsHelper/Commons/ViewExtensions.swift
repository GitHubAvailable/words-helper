//
//  ViewExtensions.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/1/24.
//

import SwiftUI

extension View {
    /// Set navigation bar color for navigation view
    /// as there is no API available.
    ///
    /// - Parameters:
    ///    - backgroundColor: background color of navigation bar
    ///    - titileColor: color of title text
    ///
    /// - Returns: the view that calls the function.
    func navigationBarColor(
        backgroundColor: Color? = nil,
        titleColor: Color? = nil
    ) -> some View {
        if let bgColor: Color = backgroundColor {
            UINavigationBar.appearance().backgroundColor = UIColor(bgColor)
        }
        
        if let headingColor: Color = titleColor {
            let color = UIColor(headingColor)
            UINavigationBar.appearance().titleTextAttributes =
            [.foregroundColor : color]
            UINavigationBar.appearance().largeTitleTextAttributes =
            [.foregroundColor : color]
        }
        
        return self
    }
}
