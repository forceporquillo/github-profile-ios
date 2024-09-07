//
//  GetUserOrgsNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

class GetUserOrgsNetworkCall {
    
    private let networkManager: NetworkComponent
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users"
        return components
    }()

    init(_ networkManager: NetworkComponent) {
        self.networkManager = networkManager
    }

    func execute(
        username: String,
        completion: @escaping CompletionHandler<Paginated<[UserOrgsResponse]>>
    ) {
        urlComponents.path = "/users/\(username)/orgs"
        let urlRequest = networkManager.createUrlRequest(url: self.urlComponents.url!, method: "GET")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let nextLink = self.networkManager.parseLinkHeader(response?.headerField(forKey: "Link") ?? "")["next"]
            let since = self.networkManager.getQueryParameterValue(urlString: nextLink ?? "", param: "page")
            let page = Int(since ?? "-1") ?? -1
            
            guard let data = data else {
                print("User has no organizations")
                completion(.success(Paginated(data: [], next: page)))
                return
            }
            do {
                let decodedResponse: [UserOrgsResponse] = try self.networkManager.decoder.decode([UserOrgsResponse].self, from: data)
                print("User has no organizaitons")
                completion(.success(Paginated(data: decodedResponse, next: page)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct Paginated<T> {
    var data: T
    var next: Int
}
