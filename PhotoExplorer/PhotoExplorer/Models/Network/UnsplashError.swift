//
//  UnsplashError.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/23/25.
//


struct ErrorResponse: Decodable {
    let errors: [String]
}


enum UnsplashError: String, Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknown
    
    var description_en: String {
        switch self {
        case .badRequest:
            return "The request was unacceptable, often due to missing a required parameter"
        case .unauthorized:
            return "Invalid Access Token"
        case .forbidden:
            return "Missing permissions to perform request"
        case .notFound:
            return "The requested resource doesn’t exist"
        case .serverError:
            return "Something went wrong on our end"
        case .unknown:
            return "Unknown Error"
        }
    }
}
