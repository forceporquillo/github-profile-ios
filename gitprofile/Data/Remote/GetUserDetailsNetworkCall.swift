//
//  GetUserDetailsNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/2/24.
//

import Foundation

class GetUserDetailsNetworkCall {
    
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
        strategy: FetchStrategy = FetchStrategy.cacheOverRemote,
        completion: @escaping CompletionHandler<UserDetailsResponse>
    ) {
        urlComponents.path = "/users/\(username)"

        var urlRequest = networkManager.createUrlRequest(url: self.urlComponents.url!, method: "GET")
        
        switch strategy {
        case .cacheOverRemote:
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        case .invalidateRemotely:
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let next = self.networkManager.parseLinkHeader(response?.headerField(forKey: "Link") ?? "")["next"]
            let since = self.networkManager.getQueryParameterValue(urlString: next ?? "", param: "since")
            
            guard let data = data else {
                completion(.failure(NSError(domain: Bundle.main.bundleIdentifier!, code: 204, userInfo: [NSLocalizedDescriptionKey: "No user details available from remote source"])))
                return
            }
            do {
                let decodedResponse = try self.networkManager.decoder.decode(UserDetailsResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
