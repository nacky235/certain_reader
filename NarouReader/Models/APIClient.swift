//
//  APIClient.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2021/01/02.
//

import Foundation

struct APILoginRequest: Codable {
    let word: String
//    let notword: String
    
    let title: Int //words in title
    let wname: Int // words in writer
    let keyword: Int //words in keyword
    
    var out: String = "json"
    var type: String = "re"
    var of: String = "t-n-w-s-bg-g"
    var lim: Int = 30 // (1- 500)
    let order: String
    let genre: String
    let biggenre: String
    
    var ncode: String
    
    init(word: String, title: Int, writer: Int, keyword: Int, order: Order, genre: Genre, biggenre: BigGenre) {
        self.word = word
        self.title = title
        self.wname = writer
        self.keyword = keyword
        self.order = order.name
        self.genre = genre.stringGenre
        self.biggenre = biggenre.stringBigGenre
        
        self.ncode = ""
    }
    
    init(ncode: String) {
        self.ncode = ncode
        
        self.word = ""
        self.title = 1
        self.wname = 1
        self.keyword = 1
        self.order = ""
        self.genre = ""
        self.biggenre = ""
    }
}

struct APILoginSuccessResponse: Codable {
    var allCount: AllCount
    var novels: [Novel]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.allCount = try container.decode(AllCount.self)
        var novels: [Novel] = []

        while !container.isAtEnd {
            let novel = try container.decode(Novel.self)
            novels.append(novel)
        }

        self.novels = novels
    }
}

extension APILoginRequest: APIEndpoint {
    func queryItem() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        for child in Mirror(reflecting: self).children {
            items.append(URLQueryItem(name: child.label ?? "", value: child.value as? String ?? ""))
        }
        
        return items
    }
    
    func endpoint() -> String {
        return "/api/?"
    }

    func dispatch(
        onSuccess successHandler: @escaping ((_: APILoginSuccessResponse) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {

        APIRequest.get(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}

protocol APIEndpoint {
    func endpoint() -> String
    func queryItem() -> [URLQueryItem]
}

class APIRequest {
    struct ErrorResponse: Codable {
        let status: String
        let code: Int
        let message: String
    }

    enum APIError: Error {
        case invalidEndpoint
        case errorResponseDetected
        case noData
    }
}

extension APIRequest {
    public static func post<R: Codable & APIEndpoint, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {

        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "GET"
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            endpointRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            onError(nil, error)
            return
        }

        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
}

extension APIRequest {
    public static func get<R: Codable & APIEndpoint, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {

        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "GET"

        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
}

extension APIRequest {
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {

        if let data = dataOrNil {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodedResponse)
            } catch {
                let originalError = error

                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    onError(errorResponse, APIError.errorResponseDetected)
                } catch {
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
}

extension APIRequest {
    public static func urlRequest(from request: APIEndpoint) -> URLRequest? {
        let endpoint = request.endpoint()
        let queryItems = request.queryItem()
        
        guard var endpointUrl = URLComponents(string: "https://api.syosetu.com/novelapi\(endpoint)") else {
            return nil
        }
        
        endpointUrl.queryItems = queryItems
//
        var endpointRequest = URLRequest(url: endpointUrl.url!)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return endpointRequest
    }
}

