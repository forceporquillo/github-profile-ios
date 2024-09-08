//
//  GetUserReposNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/3/24.
//

import Foundation

class GetUserReposNetworkCall {
 
    private let logger = LoggerFactory.create(clazz: GetUserReposNetworkCall.self)
    
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
        completion: @escaping CompletionHandler<PagingData<[RepositoriesResponse]>>
    ) {
        urlComponents.path = "/users/\(username)/repos"
        urlComponents.queryItems = params
        
        let urlRequest = NetworkComponent.createUrlRequest(url: self.urlComponents.url!, method: "GET")
       
        logger.log(message: "ApiCall to \(urlRequest) for user: \(username) with params: \(String(describing: params))")
        
//        urlRequest.cachePolicy = .useProtocolCachePolicy
//        switch strategy {
//        case .cacheOverRemote:
//            urlRequest.cachePolicy = .returnCacheDataElseLoad
//        case .invalidateRemotely:
//            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
//        }

        URLSession.shared.dataTask(with: urlRequest) { [self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let next = self.networkManager.parseLinkHeader(response?.headerField(forKey: "Link") ?? "")["next"]
            let since = self.networkManager.getQueryParameterValue(urlString: next ?? "", param: "page")
            let page = Int(since ?? "-1") ?? -1
            
            logger.log(message: "next page link -> \(page)")
            guard let data = data else {
                logger.log(message: "Success -> content size: 0 endOfPaginationReached: true")
                completion(.success(PagingData(data: [], next: page, endOfPaginationReached: true)))
                return
            }
            do {
                let decodedResponse = try self.networkManager.decoder.decode([RepositoriesResponse].self, from: data)
                let isEndOfPaginationReached = decodedResponse.isEmpty || page == -1
                logger.log(message: "Success -> content size: \(decodedResponse.count) endOfPaginationReached: \(isEndOfPaginationReached)")
                completion(.success(PagingData(data: decodedResponse, next: page, endOfPaginationReached: isEndOfPaginationReached)))
            } catch {
                logger.log(.error ,message: "Error occurred during decoding: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

//struct GetRepositoriesResponse {
//    var data: [RepositoriesResponse]
//    var next: String?
//}
