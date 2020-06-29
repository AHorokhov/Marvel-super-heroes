//
//  Manager.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/16/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

struct Constants {
    static let publicKey = "e38964264c4569bca354bad5d062267a"
    static let privateKey = "242be8e9ab24f302ee6fb63ff0ca3c65f256779d"
    static let hash = DataCreator().MD5Hash(string: "1\(Constants.privateKey)\(Constants.publicKey)")
    static let completedKey = "ts=1&apikey=\(Constants.publicKey)&hash=\(Constants.hash)"
    static let offset = "offset="
    static let mainUrl = "https://gateway.marvel.com:443/v1/public/"
    static let charactes = "characters"
}

private let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
typealias HeroesCompletionClosure = ( _ heroes: [Hero?], _ totalCount: Int,  _ error: NSError?) -> Void
typealias ItemsCompletionClosure = (_ items: [ItemType: [Item]], _ error: NSError?) -> Void

public class Manager {
    
    private init() {}
    static let shared = Manager()

    func getAllHeroes(offset: Int, withCompletion completion: HeroesCompletionClosure?) {
        let urlString = "\(Constants.mainUrl)\(Constants.charactes)?\(Constants.completedKey)&\(Constants.offset)\(offset)"
        guard let url = URL(string: urlString) else { return }
        let task = downloadSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion?([], 0, error as NSError?)
                return
            }
            let results = self.getResultsFrom(json: json).map { Hero.init(json: $0) }
            let totalCount = self.getTotalCount(json: json)
            completion?(results, totalCount, error as NSError?)
        }
        task.resume()
    }
    
    func getResultsFrom(json: Any) -> [[String: Any]] {
        guard let dictionary = json as? [String: Any],
            let data = dictionary["data"] as? [String: Any],
            let results = data["results"] as? [[String: Any]] else {
                return []
        }
        return results
    }
    
    func getTotalCount(json: Any) -> Int {
        guard let dictionary = json as? [String: Any],
            let data = dictionary["data"] as? [String: Any],
            let totalCount = data["total"] as? Int else {
                return 0
        }
        return totalCount
    }
}

struct DataCreator {
    
    func MD5Hash(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        let hashString = digestData.map { String(format: "%02hhx", $0) }.joined()
        return hashString
    }
}
