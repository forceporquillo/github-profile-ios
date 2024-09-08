//
//  GetUsersNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

class GetAllUsersNetworkCall {
    
    private let logger = LoggerFactory.create(clazz: GetAllUsersNetworkCall.self)
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
        params: [URLQueryItem]? = [],
        strategy: FetchStrategy = FetchStrategy.cacheOverRemote,
        completion: @escaping CompletionHandler<GetUsersResponse>
    ) {
        urlComponents.queryItems = params

        let urlRequest = NetworkComponent.createUrlRequest(url: self.urlComponents.url!, method: "GET")
        logger.log(message: String(describing: urlRequest))
//        switch strategy {
//        case .cacheOverRemote:
//            urlRequest.cachePolicy = .returnCacheDataElseLoad
//        case .invalidateRemotely:
//            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
//        }
 
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let next = self.networkManager.parseLinkHeader(response?.headerField(forKey: "Link") ?? "")["next"]
            let since = self.networkManager.getQueryParameterValue(urlString: next ?? "", param: "since")
            
            guard let data = data else {
                completion(.success(GetUsersResponse(data: nil, next: since)))
                return
            }
            do {
                let decodedResponse = try self.networkManager.decoder.decode([UserResponse].self, from: data)
                completion(.success(GetUsersResponse(data: decodedResponse, next: since)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct GetUsersResponse {
    var data: [UserResponse]?
    var next: String?
}
