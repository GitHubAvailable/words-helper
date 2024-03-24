//
//  WordsHelperApp.swift
//  WordsHelper
//
//  Created by Mark Liu on 12/23/23.
//

import SwiftUI

@main
struct WordsHelperApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { WordsList() }) { file in
            ContentView()
                .environmentObject(file.document)
                // .tint(.green)
                // .preferredColorScheme(.dark)
        }
    }
}
