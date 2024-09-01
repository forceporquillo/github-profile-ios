//
//  NetworkComponent.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import Foundation

struct NetworkComponent {
    
    static let shared = NetworkComponent()
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()

    private let memoryCapacity = 10 * 1024 * 1024 // 10MB
    private let diskCapacity = 100 * 1024 * 1024 // 100MB

    init() {
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "gitprofile")
        URLCache.shared = urlCache
    }
    
    func getQueryParameterValue(urlString: String, param: String) -> String? {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == param })?.value
    }
    
    func createUrlRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        // We need to set credentials in order to bypass rate limit error
        request.setValue(ApiCredentials.basic, forHTTPHeaderField: "Authorization")
        request.setValue("developer: \(ApiCredentials.username) app-name: \(Bundle.main.bundleIdentifier ?? "")", forHTTPHeaderField: "User-Agent")
        
        return request
    }
    
    func parseLinkHeader(_ header: String) -> [String: String] {
        var links: [String: String] = [:]
        let pattern = "<([^>]+)>; rel=\"([^\"]+)\""
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = header as NSString
            let results = regex.matches(in: header, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in results {
                if match.numberOfRanges == 3 {
                    let url = nsString.substring(with: match.range(at: 1))
                    let rel = nsString.substring(with: match.range(at: 2))
                    links[rel] = url
                }
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
        }
        
        return links
    }
    
    private enum Keys {
        static let apiKey = "API_KEY"
        static let username = "USERNAME"
    }

    private struct ApiCredentials {
        
        private static let infoDictionary: [String: Any] = {
            guard let dictionary = Bundle.main.infoDictionary else {
                fatalError("config file not found")
            }
            return dictionary
        }()

        private static let accessToken: String = {
            guard let apiKeyString = infoDictionary[Keys.apiKey] as? String else {
                fatalError("API Key not found")
            }
            return apiKeyString
        }()
        
        static let username: String = {
            guard let usernameString = infoDictionary[Keys.username] as? String else {
                fatalError("API Key not found")
            }
            return usernameString
        }()
        
        static let basic: String = {
            let basicCredentials = "\(username):\(accessToken)".data(using: .isoLatin1)
            return basicCredentials!.base64EncodedString()
        }()
    }

}

extension URLResponse {
    func headerField(forKey key: String) -> String? {
        (self as? HTTPURLResponse)?.allHeaderFields[key] as? String
    }
}

extension Result {
    func fold<T>(onSuccess: (Success) -> T, onFailure: (Failure) -> T) -> T {
        switch self {
        case .success(let value):
            return onSuccess(value)
        case .failure(let error):
            return onFailure(error)
        }
    }
}

typealias CompletionHandler<Success> = (Result<Success, Error>) -> Void
