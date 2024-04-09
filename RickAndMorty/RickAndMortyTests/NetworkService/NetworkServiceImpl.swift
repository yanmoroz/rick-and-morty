//
//  NetworkServiceImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    func request(
        _ urlRequest: URLRequest,
        handler: @escaping Completion
    ) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let error = error as? URLError else {
                handler(.success(data))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(.urlError(error)))
                return
            }
            
            handler(
                .failure(
                    .serverError(
                        statusCode: response.statusCode,
                        response: response
                    )
                )
            )
        }.resume()
    }
}
