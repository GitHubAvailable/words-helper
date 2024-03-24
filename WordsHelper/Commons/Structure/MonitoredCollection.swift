//
//  MonitoredCollection.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/13/24.
//

import Foundation

/// A container type that stores a certain type of element
/// while record the frequency of certain property about
/// the elements.
public protocol MonitoredCollection<C> {
    associatedtype C: Collection
    associatedtype T: Hashable
    
    var key: String { get }
    var data: C { get }
    
    func freq(_ sample: T) -> Int
}
