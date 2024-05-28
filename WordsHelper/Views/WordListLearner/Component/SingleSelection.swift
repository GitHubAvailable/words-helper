//
//  SingleSelection.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/18.
//

import SwiftUI

struct SingleSelection: View {
    /// The text to be displayed on the option.
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundStyle(.primary)
                .padding()
            
            Spacer()
        }
    }
}

#Preview {
    SingleSelection(
        text: "test"
    )
}
