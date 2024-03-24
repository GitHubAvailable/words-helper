//
//  MonitoredRandomAccessCollection.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/13/24.
//

import Foundation

/// A random access collection that monitors frequency
/// of certain information of stored elements.
public protocol MonitoredRandomAccessCollection<C>: MonitoredCollection
where C: RandomAccessCollection {
    
}
