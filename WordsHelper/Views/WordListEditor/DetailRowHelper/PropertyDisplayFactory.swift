//
//  PropertyDisplayFactory.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/6/24.
//

import Foundation
import SwiftUI

/// A static factory that creates editor row components for display.
final class PropertyDisplayFactory {
    /// Create frames of specified type.
    ///
    /// - Parameters:
    ///    - frameType: the type of the frame.
    ///    - label: the label to be displayed.
    ///    - content: the field to be displayed within the frame.
    @ViewBuilder static func getFrame<V: View>(
        type frameType: FrameType = .default,
        _ label: String,
        @ViewBuilder content: @escaping () -> V
    ) -> some View {
        switch frameType {
        case .section:
            SectionFrame(label: String(localized: "\(label)"),
                                view: content)
        default:
            DefaultFrame(label: String(localized: "\(label)"),
                                view: content)
        }
    }
    
    /// Create a `StringField` of specified type.
    ///
    /// - Parameters:
    ///    - textType: the type of the textfield.
    ///    - value: the initial text to be edited.
    ///    - prompt: the prompt to be displayed.
    @ViewBuilder static func getStringField(
        type textType: TextType = .default,
        _ value: Binding<String>,
        prompt: String = ""
    ) -> some View {
        switch textType {
        case .longText:
            LongTextValueField(value: value, prompt: prompt)
        default:
            TextValueField(value: value, prompt: prompt)
        }
    }
    
    /// Create a `SelectionValueField` of specified style.
    ///
    /// - Parameters:
    ///    - value: the value to be edited.
    ///    - style: the style of the selection field.
    @ViewBuilder static func getSelectionField<T: IterPickable, S: PickerStyle>(
        _ value: Binding<T>,
        style: S = .automatic
    ) -> some View {
        switch style {
        default:
            SelectionValueField(value: value, style: style)
        }
    }
}
