//
//  PropertyType.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/6/24.
//

import Foundation

/// The available field types.
///
/// Currently not used.
enum FieldType {
    case realNumber
    case integer
    case text
    case longText
    case binary
    case selection
}

/// The available text field types.
enum TextType {
    case `default`
    case longText
}

/// Available selection field types.
enum SelectionValue {
    case `default`
}
