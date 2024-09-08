//
//  GetUserOrgsNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

class GetUserOrgsNetworkCall {
    
    private let logger = LoggerFactory.create(clazz: GetUserOrgsNetworkCall.self)
    
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
        completion: @escaping CompletionHandler<PagingData<[UserOrgsResponse]>>
    ) {
        urlComponents.path = "/users/\(username)/orgs"
        let urlRequest = NetworkComponent.createUrlRequest(url: self.urlComponents.url!, method: "GET")
        logger.log(message: String(describing: urlRequest))
        
        URLSession.shared.dataTask(with: urlRequest) { [self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let nextLink = self.networkManager.parseLinkHeader(response?.headerField(forKey: "Link") ?? "")["next"]
            let since = self.networkManager.getQueryParameterValue(urlString: nextLink ?? "", param: "page")
            let page = Int(since ?? "-1") ?? -1
            
            logger.log(message: "next page link -> \(page)")
            guard let data = data else {
                logger.log(message: "Success -> content size: 0 endOfPaginationReached: true")
                completion(.success(PagingData(data: [], next: page, endOfPaginationReached: true)))
                return
            }
            do {
                let decodedResponse: [UserOrgsResponse] = try self.networkManager.decoder.decode([UserOrgsResponse].self, from: data)
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

struct PagingData<T> {
    var data: T
    var next: Int
    var endOfPaginationReached: Bool = false
}
