//
//  GetUserReposNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/3/24.
//

import Foundation

class GetUserReposNetworkCall {
 
    private let networkManager: NetworkComponent
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        return components
    }()

    init(_ networkManager: NetworkComponent) {
        self.networkManager = networkManager
    }

    func execute(
        username: String,
        params: [URLQueryItem]? = [],
        strategy: FetchStrategy = FetchStrategy.cacheOverRemote,
        completion: @escaping CompletionHandler<GetRepositoriesResponse>
    ) {
        urlComponents.path = "/users/\(username)/repos"
        urlComponents.queryItems = params
        
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
            let since = self.networkManager.getQueryParameterValue(urlString: next ?? "", param: "page")

            guard let data = data else {
                completion(.success(GetRepositoriesResponse(data: nil, next: since)))
                return
            }
            do {
                let decodedResponse = try self.networkManager.decoder.decode([RepositoriesResponse].self, from: data)
                completion(.success(GetRepositoriesResponse(data: decodedResponse, next: since)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct GetRepositoriesResponse {
    var data: [RepositoriesResponse]?
    var next: String?
}
