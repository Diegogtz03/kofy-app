//
//  WebServices.swift
//  Kofy
//
//  Created by Diego Gutierrez on 01/11/23.
//

import Foundation
import Combine

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}

enum UserEndpoint: APIEndpoint {
    case verify
    case login
    case signUp
    case getProfile
    case setProfile
    
    var baseURL: URL {
        return URL(string: "https://kofy-back.onrender.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .verify:
            return "/user/verify"
        case .signUp:
            return "/user/register"
        case .getProfile:
            return "/profile/getProfile"
        case .setProfile:
            return "/profile/setProfile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .verify:
            return .post
        case .signUp:
            return .post
        case .getProfile:
            return .post
        case .setProfile:
            return .post
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType, headers: [String: String]?, params: Encodable) -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(_ endpoint: EndpointType, headers: [String: String]?, params: Encodable) -> AnyPublisher<T, Error> {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if (headers != nil) {
            headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        var bodyData = Data()
        
        do {
            bodyData = try JSONEncoder().encode(params)
        } catch {
            print("Error serializing data")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

protocol UserServiceProtocol {
    func login(headers: [String: String]?, params: Encodable) -> AnyPublisher<VerificationModel, Error>
    func verify(headers: [String: String]?, params: Encodable) -> AnyPublisher<TokenVerificationModel, Error>
    func signUp(headers: [String: String]?, params: Encodable) -> AnyPublisher<VerificationModel, Error>
    func getProfile(headers: [String: String]?, params: Encodable) -> AnyPublisher<ProfileInformation, Error>
    func setProfile(headers: [String: String]?, params: Encodable) -> AnyPublisher<ProfileInformation, Error>
}

class UserService: UserServiceProtocol {
    let apiClient = URLSessionAPIClient<UserEndpoint>()
    
    func login(headers: [String: String]?, params: Encodable) -> AnyPublisher<VerificationModel, Error> {
        return apiClient.request(.login, headers: headers, params: params)
    }
    
    func verify(headers: [String : String]?, params: Encodable) -> AnyPublisher<TokenVerificationModel, Error> {
        return apiClient.request(.verify, headers: headers, params: params)
    }
    
    func signUp(headers: [String : String]?, params: Encodable) -> AnyPublisher<VerificationModel, Error> {
        return apiClient.request(.signUp, headers: headers, params: params)
    }
    
    func getProfile(headers: [String : String]?, params: Encodable) -> AnyPublisher<ProfileInformation, Error> {
        return apiClient.request(.getProfile, headers: headers, params: params)
    }
    
    func setProfile(headers: [String : String]?, params: Encodable) -> AnyPublisher<ProfileInformation, Error> {
        return apiClient.request(.setProfile, headers: headers, params: params)
    }
}
