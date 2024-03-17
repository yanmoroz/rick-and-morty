//
//  HTTPRequestDecodable.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol HTTPRequestDecodable: HTTPRequest {
    associatedtype DecodeType
}
