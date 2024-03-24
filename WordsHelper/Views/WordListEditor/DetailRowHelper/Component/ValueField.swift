//
//  PropertyEditor.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/8/24.
//

import Foundation
import SwiftUI

/// A type that reperents an editable
/// field of a single value.
protocol ValueField {
    associatedtype E: View
    associatedtype V
    
    /// The value to be displayed and edited.
    var value: V { get set }
    
    /// The view of the field.
    @ViewBuilder var body: E { get }
}
