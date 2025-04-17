//
//  CacheManager.swift
//  GitHub Profile
//
//  Created by Aljan Porquillo on 4/17/25.
//

import Foundation

public enum CacheError: Error {
    case keyNotFound
    case invalidData
    case encodingError(Error)
    case decodingError(Error)
}

public class CacheManager {
    
    // MARK: - Singleton
    
    public static let shared = CacheManager()
    
    private init() {}
    
    // MARK: - Properties
    
    private var cache = NSCache<NSString, CacheDataWrapperNS>()
    
    // MARK: - Configuration
    
    /// The default expiration time for cached items. You can override this on a per-item basis.
    public var defaultExpiration: TimeInterval = 60 * 10 // 10 minutes
    
    /// The maximum number of objects the cache should hold. 0 means no limit.
    public var memoryCapacity: Int {
        get { cache.countLimit }
        set { cache.countLimit = newValue }
    }
    
    /// The total memory capacity of the cache, in bytes.
    public var diskCapacity: Int {
        get { cache.totalCostLimit }
        set { cache.totalCostLimit = newValue }
    }
    
    // MARK: - Caching Functions
    
    /// Stores a Codable object in the cache with the given key and default expiration time.
    /// - Parameters:
    ///   - object: The Codable object to cache.
    ///   - key: The key to store the object under.
    public func store<T: Codable>(object: T, forKey key: String) {
        store(object: object, forKey: key, expiration: defaultExpiration)
    }
    
    /// Stores a Codable object in the cache with the given key and expiration time.
    /// - Parameters:
    ///   - object: The Codable object to cache.
    ///   - key: The key to store the object under.
    ///   - expiration: The expiration time for the object.
    public func store<T: Codable>(object: T, forKey key: String, expiration: TimeInterval) {
        let cacheKey = NSString(string: key)
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(object)
            let wrapper = CacheDataWrapperNS(data: encodedData, expirationDate: Date(timeIntervalSinceNow: expiration))
            cache.setObject(wrapper, forKey: cacheKey, cost: encodedData.count)
        } catch {
            print("Encoding error: \(error)") // Important: Log the error
        }
    }
    
    /// Retrieves a Codable object from the cache for the given key.
    /// - Parameters:
    ///   - key: The key of the object to retrieve.
    /// - Returns: The cached object, or nil if the key is not found or the data has expired.
    public func retrieve<T: Codable>(forKey key: String) -> T? {
        let cacheKey = NSString(string: key)
        
        guard let cachedWrapper = cache.object(forKey: cacheKey) else {
            return nil // Key not found
        }
        
        // Check for expiration.
        if cachedWrapper.expirationDate < Date() {
            // Data has expired, remove it from the cache.
            cache.removeObject(forKey: cacheKey)
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: cachedWrapper.data)
            return decodedObject
        } catch {
            print("Decoding error: \(error)") // Important: Log the error
            cache.removeObject(forKey: cacheKey) // Remove invalid data
            return nil
        }
    }

     /// Retrieves a Codable object from the cache for the given key.  Throws an error if retrieval fails.
    /// - Parameters:
    ///   - key: The key of the object to retrieve.
    /// - Returns: The cached object.
    public func retrieveObject<T: Codable>(forKey key: String) throws -> T {
        let cacheKey = NSString(string: key)

        guard let cachedWrapper = cache.object(forKey: cacheKey) else {
            throw CacheError.keyNotFound
        }

        // Check for expiration.
        if cachedWrapper.expirationDate < Date() {
            cache.removeObject(forKey: cacheKey)
            throw CacheError.keyNotFound
        }

        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: cachedWrapper.data)
            return decodedObject
        } catch {
            let error = CacheError.decodingError(error)
            print("Decoding error: \(error)")
            cache.removeObject(forKey: NSString(string: key)) // Remove invalid data
            throw error
        }
    }
    
    /// Removes the data from the cache for the given key.
    /// - Parameter key: The key of the data to remove.
    public func remove(forKey key: String) {
        let cacheKey = NSString(string: key)
        cache.removeObject(forKey: cacheKey)
    }
    
    /// Removes all data from the cache.
    public func removeAll() {
        cache.removeAllObjects()
    }
    
    // MARK: - Helper Class
    
    /// A wrapper class to store data and its expiration date.
    public class CacheDataWrapperNS: NSObject {
        let data: Data
        let expirationDate: Date
        
        init(data: Data, expirationDate: Date) {
            self.data = data
            self.expirationDate = expirationDate
        }
        
        public override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? CacheDataWrapperNS else { return false }
            return self.data == other.data && self.expirationDate == other.expirationDate
        }
        
        public override var hash: Int {
            var hasher = Hasher()
            hasher.combine(data)
            hasher.combine(expirationDate)
            return hasher.finalize()
        }
    }
}
