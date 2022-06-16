//
//  ApiClient.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/18.
//

import Foundation
import Alamofire

// API 호출 클라이언트
final class ApiClient {
    static let shared = ApiClient()
    
    static let BASE_URL = "http://127.0.0.1:8000/api/"
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor() // application/json
    ])
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    var session: Session
    
    init() {
        print("ApiClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    let decoder = JSONDecoder()
}
