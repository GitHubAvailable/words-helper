//
//  StringField.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/11/24.
//

import Foundation
import SwiftUI

/// A editable field that shows a long string
/// in a large textfield.
protocol StringField: ValueField {
    /// The text to be displayed.
    var value: String { get set }
    
    /// The prompt to be displayed.
    var prompt: String { get }
}
