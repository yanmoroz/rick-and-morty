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
        // ...
    }
}

protocol Endpoint {
    associatedtype DecodeType
}

struct EndpointImpl<DecodeType>: Endpoint {
    typealias DecodeType = DecodeType
}

struct Foo: Decodable {
    
}

execute {
    let apiService = APIServiceImpl()
    let endpoint = EndpointImpl<Foo>()
    apiService.request(endpoint) { result in
        
    }
}
