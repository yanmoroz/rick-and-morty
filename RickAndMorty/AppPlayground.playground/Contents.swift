import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func execute(_ action: @escaping () -> Void) {
    action()
}

protocol APIService {
    typealias Completion<T> = (Result<T, Error>) -> Void
    func request<E: Endpoint>(_ endpoint: E,
                              completion: @escaping Completion<E.DecodeType>)
}

class APIServiceImpl: APIService {
    func request<E: Endpoint>(_ endpoint: E,
                              completion: @escaping Completion<E.DecodeType>) {
        URLSession.shared.dataTask(with: endpoint.urlRequest) { data, _, error in
            // ...
        }.resume()
    }
}

protocol Endpoint {
    associatedtype DecodeType
}

struct EndpointImpl<DecodeType>: Endpoint {
    typealias DecodeType = DecodeType
}

struct ResourcesResponse: Decodable {
    let episodes: URL
    let locations: URL
    let characters: URL
}

execute {
    let apiService = APIServiceImpl()
    let endpoint = EndpointImpl<ResourcesResponse>()
    apiService.request(endpoint) { result in
        switch result {
        case .success(let decoded):
            print(decoded)
        case .failure(let error):
            print(error)
        }
    }
}
