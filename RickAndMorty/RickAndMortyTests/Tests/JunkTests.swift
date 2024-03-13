//
//  JunkTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 06.03.2024.
//

import XCTest
@testable import RickAndMorty

final class JunkTests: XCTestCase {
    
    struct Episode: Decodable {
        let id: Int
    }
    
    func test_simpleRequest() {
        let fakeExtenralCompletion: (Result<Any, Error>) -> Void = { result in
            
        }
        
        let expectation = XCTestExpectation()
        // 0. Build URL or URLRequest
        let url = URL(string: "https://rickandmortyapi.com/api/episode/5")!
        // 1. Proceed HTTP request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                expectation.fulfill()
            }
            
            // 2. Handle error
            if let error {
                fakeExtenralCompletion(.failure(error))
                return
            }
            
            // 3. Validate response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode > 300 {
                // ...
            }
            
            // 4. Check data exists ...
            guard let data else {
                fakeExtenralCompletion(.failure(NSError(domain: "network", code: 1234)))
                return
            }
            
            do {
                // ... and decode to some <T>
                let episode = try JSONDecoder().decode(Episode.self, from: data)
                fakeExtenralCompletion(.success(episode))
            } catch let decodeError {
                // 5. Handle decode error
                fakeExtenralCompletion(.failure(decodeError))
            }
        }
        
        task.resume()
        wait(for: expectation)
    }
    
    func test_simpleRequest_async() async {
        let fakeExtenralCompletion: (Result<Any, Error>) -> Void = { result in
            
        }
        
        // 0. Build URL or URLRequest
        let url = URL(string: "https://rickandmortyapi.com/api/episode/5")!
        do {
            // 1. Proceed http request
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 2. Validate response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode > 300 {
                // ...
            }
            
            // 3. and decode data to some <T>
            let episode = try JSONDecoder().decode(Episode.self, from: data)
            fakeExtenralCompletion(.success(episode))
        } catch {
            // 4. Handle error
            fakeExtenralCompletion(.failure(error))
        }
    }
}
