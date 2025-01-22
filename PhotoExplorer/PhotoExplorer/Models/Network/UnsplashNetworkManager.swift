//
//  UnsplashNetworkManager.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/18/25.
//

import Foundation
import Alamofire

final class UnsplashNetworkManager {
    static let shared = UnsplashNetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: UnsplashRequest,
                                   type: T.Type,
                                   completionHandler: @escaping ((T) -> Void),
                                   failureHandler: @escaping ((UnsplashError) -> Void)) {
        guard let url = api.endpoint else {
            print("Failed to create url")
            return
        }
        
        AF.request(url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                // Unsplash에서 전달하는 오류 메세지를 받고 싶어 아래와 같이 에러 메시지 디코딩 작업을 구현했습니다.
                // Alamofire를 사용한 방법을 아직 찾지 못해, 추후 개선을 진행하고자 합니다.
                self.decodingErrorMessage(response.data)
                let unsplashError = self.errorHandler(error)
                print("Error:", unsplashError)
                failureHandler(unsplashError)
            }
        }
    }
    
    private func decodingErrorMessage(_ data: Data?) {
        if let data = data {
            let decoded = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            print("Unsplash Error Message:", decoded ?? "")
        }
    }
    
    private func errorHandler(_ error: AFError) -> UnsplashError {
        switch error.responseCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500, 503:
            return .serverError
        default:
            return .unknown
        }
    }
}
