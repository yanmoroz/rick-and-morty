//
//  URL+Extensions.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

extension URL {
    var singleDashed: URL {
        guard let url = URL(string: absoluteString.replacingOccurrences(of: "//", with: "/")) else {
            return self
        }
        
        return url
    }
}
