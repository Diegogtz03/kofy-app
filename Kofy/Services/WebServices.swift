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
    case updateProfile
    case getLearningCollections
    case getLearningCards
    case getDoctors
    case createDoctor
    case updateDoctor
    case registerSession
    case sendSpeechSession
    case getSpeechSession
    case deleteSpeechSession
    case getPrescriptionSummary
    
    var baseURL: URL {
        return URL(string: "https://kofy-back.onrender.com")!
//        return URL(string: "http://10.22.157.229:3000")!
//        return URL(string: "http://192.168.1.66:3000")!
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
        case .updateProfile:
            return "profile/updateProfile"
        case .getLearningCollections:
            return "learning/getCardCollections"
        case .getLearningCards:
            return "learning/getCardCollections"
        case .getDoctors:
            return "profile/getDoctors"
        case .createDoctor:
            return "profile/createDoctor"
        case .updateDoctor:
            return "profile/createDoctor"
        case .registerSession:
            return "consult/createSpeechSession"
        case .sendSpeechSession:
            return "consult/summary"
        case .getSpeechSession:
            return "consult/getSummary"
        case .deleteSpeechSession:
            return "consult/endSession"
        case .getPrescriptionSummary:
            return "consult/reminders"
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
        case .updateProfile:
            return .put
        case .getLearningCollections:
            return .get
        case .getLearningCards:
            return .post
        case .getDoctors:
            return .post
        case .createDoctor:
            return .post
        case .updateDoctor:
            return .put
        case .registerSession:
            return .post
        case .sendSpeechSession:
            return .post
        case .getSpeechSession:
            return .post
        case .deleteSpeechSession:
            return .post
        case .getPrescriptionSummary:
            return .post
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType, headers: [String: String]?, params: Encodable?) -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(_ endpoint: EndpointType, headers: [String: String]?, params: Encodable?) -> AnyPublisher<T, Error> {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if (headers != nil) {
            headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        var bodyData = Data()
        
        if (params != nil) {
            do {
                bodyData = try JSONEncoder().encode(params!)
            } catch {
                print("Error serializing data")
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData
        }
        
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
    func updateProfile(headers: [String: String]?, params: Encodable) -> AnyPublisher<ProfileInformation, Error>
    func getCardCollections(headers: [String: String]?) -> AnyPublisher<[CardCollectionInfo], Error>
    func getCardCollectionCards(headers: [String: String]?, params: Encodable) -> AnyPublisher<[LearnCardContent], Error>
    func getDoctors(headers: [String: String]?, params: Encodable) -> AnyPublisher<[DoctorInfo], Error>
    func createDoctor(headers: [String: String]?, params: Encodable) -> AnyPublisher<DoctorInfo, Error>
    func updateDoctor(headers: [String: String]?, params: Encodable) -> AnyPublisher<DoctorInfo, Error>
    func registerSession(headers: [String: String]?) -> AnyPublisher<SessionData, Error>
    func sendSpeechSession(headers: [String: String]?, params: Encodable) -> AnyPublisher<GenericResult, Error>
    func getSpeechSession(headers: [String: String]?, params: Encodable) -> AnyPublisher<SummariesResult, Error>
    func deleteSpeechSession(headers: [String: String]?, params: Encodable) -> AnyPublisher<GenericResult, Error>
    func getPrescriptionSummary(headers: [String: String]?, params: Encodable) -> AnyPublisher<PrescriptionResult, Error>
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
    
    func updateProfile(headers: [String : String]?, params: Encodable) -> AnyPublisher<ProfileInformation, Error> {
        return apiClient.request(.updateProfile, headers: headers, params: params)
    }
    
    func getCardCollections(headers: [String : String]?) -> AnyPublisher<[CardCollectionInfo], Error> {
        return apiClient.request(.getLearningCollections, headers: headers, params: nil)
    }
    
    func getCardCollectionCards(headers: [String : String]?, params: Encodable) -> AnyPublisher<[LearnCardContent], Error> {
        return apiClient.request(.getLearningCards, headers: headers, params: params)
    }
    
    func getDoctors(headers: [String : String]?, params: Encodable) -> AnyPublisher<[DoctorInfo], Error> {
        return apiClient.request(.getDoctors, headers: headers, params: params)
    }
    
    func createDoctor(headers: [String : String]?, params: Encodable) -> AnyPublisher<DoctorInfo, Error> {
        return apiClient.request(.createDoctor, headers: headers, params: params)
    }
    
    func updateDoctor(headers: [String : String]?, params: Encodable) -> AnyPublisher<DoctorInfo, Error> {
        return apiClient.request(.updateDoctor, headers: headers, params: params)
    }
    
    func registerSession(headers: [String : String]?) -> AnyPublisher<SessionData, Error> {
        return apiClient.request(.registerSession, headers: headers, params: nil)
    }
    
    func sendSpeechSession(headers: [String : String]?, params: Encodable) -> AnyPublisher<GenericResult, Error> {
        return apiClient.request(.sendSpeechSession, headers: headers, params: params)
    }
    
    func getSpeechSession(headers: [String : String]?, params: Encodable) -> AnyPublisher<SummariesResult, Error> {
        return apiClient.request(.getSpeechSession, headers: headers, params: params)
    }
    
    func deleteSpeechSession(headers: [String : String]?, params: Encodable) -> AnyPublisher<GenericResult, Error> {
        return apiClient.request(.deleteSpeechSession, headers: headers, params: params)
    }
    
    func getPrescriptionSummary(headers: [String : String]?, params: Encodable) -> AnyPublisher<PrescriptionResult, Error> {
        return apiClient.request(.getPrescriptionSummary, headers: headers, params: params)
    }
}
