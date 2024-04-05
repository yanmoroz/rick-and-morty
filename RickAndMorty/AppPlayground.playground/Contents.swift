import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func execute(_ action: @escaping () -> Void) {
    action()
}

protocol APIService {
    typealias Completion<T> = (Result<T, Error>) -> Void
    func request(_ endpoint: Endpoint,
                 completion: @escaping Completion<Endpoint.DecodeType>)
}

//class APIServiceImpl: APIService {
//
//}

protocol Endpoint {
    associatedtype DecodeType
}

struct Foo: Decodable {
    
}

execute {
    
}
