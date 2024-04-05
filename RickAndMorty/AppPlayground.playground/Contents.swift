import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func execute(_ action: @escaping () -> Void) {
    action()
}

execute {
    let urlRequest = URLRequest(url: URL(string: "https://foo.bar")!)
    URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
        // handle error and validate response
        // Data -> some T
        if let data {
            let foo = try? JSONDecoder().decode(Foo.self, from: data)
            // completion(...)
        }
    }
}

struct Foo: Decodable {
    
}

protocol APIService {
    typealias Completion<T> = (Result<T, Error>) -> Void
    func request<T>(_ urlRequest: URLRequest, completion: @escaping Completion<T>)
}

class APIServiceImpl: APIService {
    func request<T>(_ urlRequest: URLRequest, completion: @escaping Completion<T>) {
        // ...
    }
}

execute {
    let apiService = APIServiceImpl()
    let urlRequest = URLRequest(url: URL(string: "https://foo.bar")!)
    apiService.request(urlRequest) { result in
        // ...
    }
}
