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
            if let error {
                completion(.failure(error))
                return
            }
            
            // validate response
            
            if let data {
                let decoded = try! JSONDecoder().decode(E.DecodeType.self, from: data)
            }
        }.resume()
    }
}

protocol Endpoint {
    associatedtype DecodeType
    
    var urlRequest: URLRequest { get }
}

struct EndpointImpl<DecodeType>: Endpoint {
    typealias DecodeType = DecodeType
    
    var urlRequest: URLRequest
}

struct ResourcesResponse: Decodable {
    let episodes: URL
    let locations: URL
    let characters: URL
}

execute {
    let apiService = APIServiceImpl()
    let urlRequest = URLRequest(url: URL(string: "https://rickandmortyapi.com/api/")!)
    let endpoint = EndpointImpl<ResourcesResponse>(urlRequest: urlRequest)
    apiService.request(endpoint) { result in
        switch result {
        case .success(let decoded):
            print(decoded)
        case .failure(let error):
            print(error)
        }
    }
}
