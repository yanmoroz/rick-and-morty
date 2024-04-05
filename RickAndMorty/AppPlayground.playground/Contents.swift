import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func execute(_ action: @escaping () -> Void) {
    action()
}

enum NetworkServiceError: Error {
    case urlError(URLError)
    case serverError(statusCode: Int, response: URLResponse?)
}

protocol NetworkService {
    typealias Completion = (Result<Data?, NetworkServiceError>) -> Void
    func request(_ urlRequest: URLRequest, completion: @escaping Completion)
}

class NetworkServiceImpl: NetworkService {
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let error = error as? URLError else {
                completion(.success(data))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.urlError(error)))
                return
            }
            
            completion(
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
