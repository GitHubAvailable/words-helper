//
//  ValueEditor.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/9/24.
//

import Foundation
import SwiftUI

/// A type that represents a row that displays
/// one attribute of a `Word`.
protocol EditorFrame {
    associatedtype T: View
    associatedtype V: View
    
    /// The name of the attribute.
    var label: String { get }
    
    /// The field embedded in this editor.
    @ViewBuilder var view: () -> T { get }
    
    /// The view of the row.
    @ViewBuilder var body: V { get }
}
