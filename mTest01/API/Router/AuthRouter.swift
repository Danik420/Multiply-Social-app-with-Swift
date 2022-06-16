//
//  AuthRouter.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/23.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입, 로그인, 토큰갱신
enum AuthRouter: URLRequestConvertible {
    
    case register(name: String, email: String, password: String, passwordConfirmation: String, phoneNumber: String)
    case login(email: String, password: String)
    case logout
    case tokenRefresh
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register:
            return "/api/user/register"
        case .login:
            return "/api/user/login"
        case .logout:
            return "/api/user/logout"
        case .tokenRefresh:
            return "/api/user/token-refresh"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .post
        }
    }
    
    var parameters: Parameters{
        switch self {
            // 레지스터, 로그인 let 방식 둘 다 쓸 수 있음)
        case .register(let name, let email, let password, let passwordConfirmation, let phoneNumber):
            var params = Parameters()
            params["name"] = name
            params["email"] = email
            params["password"] = password
            params["password_confirmation"] = password
            params["phone_number"] = phoneNumber
            return params
            
        case .login(let email, let password):
            var params = Parameters()
            params["email"] = email
            params["password"] = password
            return params
            
        case .logout:
            var params = Parameters()
            return params
            
        case .tokenRefresh:
            var params = Parameters()
            let token = UserDefaultsManager.shared.getTokens()
            params["token"] = token
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
    
    
}
