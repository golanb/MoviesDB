//
//  File.swift
//  
//
//  Created by Golan Bar-Nov on 09/04/2024.
//

import Foundation
import Utility

enum HTTPMethod: String {
    case get, post, put, patch, delete
}



final public class Network {
    private let token: Token
    private let session: URLSession
    
    public static var shared = Network()
    
    public init(token: Token, session: URLSession = .shared) {
        self.token = token
        self.session = session
    }
    
    private convenience init() {
        self.init(token: .tmdb)
    }
    
    /// URLRequest factory
    private func urlRequest(url: URL, method: HTTPMethod = .get, urlParameters: [String: Any] = [:], body: [String: Any]? = nil) throws -> URLRequest {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = urlParameters.map { (name, value) in
            URLQueryItem(name: name, value: String(describing: value))
        }
        if method == .get {
            urlComponents.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
        }
        guard let requestUrl = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue.uppercased()
        request.setValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        return request
    }
    
    func request<T: Decodable>(path: String, method: HTTPMethod = .get, urlParameters: [String: Any] = [:], body: [String: Any]? = nil, decoder: JSONDecoder = .defaultDecoder) async throws -> T {
        let url = BaseURL.api.appending(path: path)
        let request = try urlRequest(url: url, method: method, urlParameters: urlParameters, body: body)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            let error = try? JSONDecoder().decode(NetworkError.self, from: data)
            throw error ?? URLError(.badServerResponse)
        }
        do {
            let result: T = try decoder.decode(T.self, from: data)
            return result
        } catch {
            debugPrint(dump(error))
            throw error
        }
    }
}
