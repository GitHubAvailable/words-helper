//
//  DefaultHeader.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/18.
//

import SwiftUI

/// The default header view of the view of a `Word`.
struct DefaultHeader: View {
    /// The title to be displayed.
    private let title: String
    
    /// A note about the title.
    private let footnote: String
    
    init(_ title: String, _ footnote: String = "") {
        self.title = title
        self.footnote = footnote
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 40))
                .bold()
                .padding(.top, 30)
            Spacer()
        }
        
        HStack {
            Text(footnote)
                .font(.title2)
                .foregroundStyle(.secondary)
                .padding(.bottom, 5)
            Spacer()
        }
    }
}

#Preview {
    DefaultHeader("Header", "footnote")
}
