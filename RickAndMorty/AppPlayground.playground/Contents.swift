import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let urlRequest = URLRequest(url: URL(string: "https://foo.bar")!)
URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
    // handle error and validate response
    // Data -> some T
    if let data {
        let foo = try? JSONDecoder().decode(Foo.self, from: data)
        // completion(...)
    }
}

struct Foo: Decodable {
    
}
