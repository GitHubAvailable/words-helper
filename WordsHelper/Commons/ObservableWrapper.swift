//
//  ObservableWrapper.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/1/26.
//

import Foundation

/// A wrapper that makes the data it stores observable.
public class ObservableWrapper<T: Any>: ObservableObject {
    /// The data it stores.
    @Published var wrappedObject: T
    
    /// Create an `ObservableWrapper` that holds the input data.
    init(_ wrappedObject: T) {
        self.wrappedObject = wrappedObject
    }
}
