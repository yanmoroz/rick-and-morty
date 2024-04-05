import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func execute(_ action: @escaping () -> Void) {
    action()
}

protocol APIService {
    associatedtype DecodeType
    
    typealias Completion<T> = (Result<T, Error>) -> Void
    func request(_ urlRequest: URLRequest, completion: @escaping Completion<DecodeType>)
}

class APIServiceImpl<DecodeType>: APIService {
    func request(_ urlRequest: URLRequest, completion: @escaping Completion<DecodeType>) {
        // ...
    }
}

struct Foo: Decodable {
    
}

execute {
    let apiService = APIServiceImpl<Foo>()
    let urlRequest = URLRequest(url: URL(string: "https://foo.bar")!)
    apiService.request(urlRequest) { result in
        
    }
}
