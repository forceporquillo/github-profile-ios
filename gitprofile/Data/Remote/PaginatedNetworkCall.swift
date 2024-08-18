//
//  PaginatedNetworkCall.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation

protocol PaginatedNetworkCall {
    
    associatedtype T: Decodable
    
    var networkComponent: NetworkComponent { get set }
    
    func execute(completion: @escaping CompletionHandler<PaginatedNetworkResponse<T>>)
    
}

extension PaginatedNetworkCall {

    private func execute(
        urlRequest: URLRequest,
        strategy: FetchStrategy,
        completion: @escaping CompletionHandler<PaginatedNetworkResponse<T>>
    ) {
        var mutableUrlRequest = urlRequest
        switch strategy {
        case .cacheOverRemote:
            mutableUrlRequest.cachePolicy = .returnCacheDataElseLoad
        case .invalidateRemotely:
            mutableUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        }
        URLSession.shared.dataTask(with: mutableUrlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let next = networkComponent.parseLinkHeader(response?.headerField(forKey: "Link") ?? "")["next"]
            let since = networkComponent.getQueryParameterValue(urlString: next ?? "", param: "page")
            
            guard let data = data else {
                completion(.success(PaginatedNetworkResponse(data: [], next: since)))
                return
            }
            do {
                let response = try networkComponent.decoder.decode([T].self, from: data)
                completion(.success(PaginatedNetworkResponse(data: response, next: since)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct PaginatedNetworkResponse<T>{
    var data: [T]
    var next: String?
}
