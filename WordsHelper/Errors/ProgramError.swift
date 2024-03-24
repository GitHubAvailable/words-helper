//
//  AppError.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/8/24.
//

import Foundation

/// A general structure of Error object in the program.
/// Used as abstract class.
class ProgramError: Error {
    /// Error code.
    let code: Int
    
    /// The error message to be displayed.
    var msg: String
    
    /// Constructor of `ProgramError`.
    ///
    /// Required by Swift Language. Should only by used by subclass.
    init(code: Int, msg: String) {
        self.code = code
        self.msg = msg
    }
}
