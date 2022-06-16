//
//  BaseInterceptor.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/23.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
//        var token = UserDefaultsManager.shared.getTokens() as String
        
        // 헤더 부분 넣어주기
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        print("토큰 리퀘스트!! 헤헷")
        
        completion(.success(request))
    }
}
