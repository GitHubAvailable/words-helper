//
//  Word.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/4/24.
//

import Foundation

/// An object that represent a word in a `WordsList`.
/// 
/// Make each member visible in Objective-C to support KVC
@objcMembers
public final class Word : NSObject, Identifiable, Codable {
    
    /// Unique identifier of the `Word` object.
    ///
    /// May implement snowflake ID later to support sorting by creating time.
    public let id: UUID = UUID()
    
    /// The word to be remembered.
    ///
    /// `@Published` makes its changes observable to SwiftUI.
    @Published dynamic public var key: String
    
    /// Short helpful notes (e.g., the meaning of the word).
    @Published dynamic public var notes: String
    
    /// Detailed explanation (e.g., sample sentences).
    @Published public var detail: String
    
    /// Pronounciation of the word.
    @Published public var pronounce: String
    
    /// Proficiency on a scale from 1 to 5.
    @Published public var proficiency: Proficiency
    
    /// Keys needed for coding
    private enum CodingKeys: String, CodingKey {
        case key
        case notes
        case detail
        case pronounce
        case proficiency
    }
    
    /// Initiate a `Word` from `Decoder`.
    ///
    /// Conformance to `Codable`.
    ///
    /// - Parameter decoder: a decoder supported by the system
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.notes = try container.decode(String.self, forKey: .notes)
        self.detail = try container.decode(String.self, 
                                                forKey: .detail)
        self.pronounce = try container.decode(String.self, 
                                              forKey: .pronounce)
        self.proficiency = try container.decode(Proficiency.self,
                                                forKey: .proficiency)
    }
    
    /// Initiate a `Word` by specifying all properties.
    public init(key: String, notes: String = "", detail: String = "",
         pronounce: String = "", proficiency: Proficiency = .level1) {
        self.key = key
        self.notes = notes
        self.detail = detail
        self.pronounce = pronounce
        self.proficiency = proficiency
    }
    
    /// Initiate from Dictionary.
    ///
    /// - Parameter json: a dictionary that contain all relevant details of a `Word` object.
    public init(json: [String : Any]) {
        key = json["key"] as! String
        notes = json["notes"] as! String
        detail = json["detail"] as! String
        pronounce = json["pronounce"] as! String
        proficiency = Proficiency(rawValue: (json["proficiency"] as! Int))!
    }
    
    /// Encode the `Word` it belongs to.
    ///
    /// Conformance to `Codable`
    /// `@Published` variables need to encode manually.
    ///
    /// - Parameter encoder: an encoder type object supported by the system.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.key, forKey: .key)
        try container.encode(self.pronounce, forKey: .pronounce)
        try container.encode(self.notes, forKey: .notes)
        try container.encode(self.proficiency, forKey: .proficiency)
        try container.encode(self.detail, forKey: .detail)
    }
    
    /// Compare if two `Word` are equal (i.e., having the same `key`).
    ///
    /// Two words with the same key is not allowed in a `WordsList`
    /// to avoid confusion in th learning system.
    /// Confirmance to `Equitable & Hashable`.
    /// Currently not used.
    ///
    /// - Parameters:
    ///   - lhs: a `Word` to be compared.
    ///   - rhs: a `Word` to be compared.
    /// - Returns: `true` if they have the same `key` and `false` if different.
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.key == rhs.key
    }
    
    /// Hashvalue of the object is the hashvalue of the key.
    ///
    /// Two words with the same key is not allowed in a `WordsList`
    /// to avoid confusion in th learning system.
    /// Override `hash` as overriding `hash(into:)` for `NSObject`.
    public override var hash: Int {
        key.hashValue
    }
}
