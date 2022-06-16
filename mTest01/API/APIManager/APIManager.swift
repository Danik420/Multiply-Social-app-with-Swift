//
//  APIManager.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/20.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine
import KeychainAccess

class APIManager {
    static let shared = APIManager()
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor() // application/json
    ])
    
    var session: Session
    
    init() {
        print("APIManager - init() called")
        session = Session(interceptor: interceptors)
    }
    
    //MARK: - 회원가입
    func callingRegisterAPI(name: String, email: String, password: String, passwordConfirmation: String, phoneNumber: String) -> AnyPublisher<User, AFError>{
        print("APIManager - callingRegisterAPI() called")
        
        return APIManager.shared.session
            .request(AuthRouter.register(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation, phoneNumber: phoneNumber))
            .publishDecodable(type: AuthResponseModel.self)
            .value()
            .map{ response in
                // 받은 토큰 정보 어딘가에 영구 저장
                // userdefaults, keychain
                UserDefaultsManager.shared.setTokens(token: response.token)
                UserDefaultsManager.shared.setUserId(userId: response.user.id)
                UserDefaultsManager.shared.setLoggedIn(value: true)
                print("유저 정보 :\(response.user.id)")
                print("토큰 정보 :\(response.token)")
                return response.user
            }.eraseToAnyPublisher()
        
    }
    
    //MARK: - completionHandler
    enum APIErrors: Error {
        case custom(message: String)
    }
    
    typealias Handler = (Swift.Result<Any?, APIErrors>) -> Void
    
    //MARK: - 로그인
    
    func callingLoginAPI(email: String, password: String) -> AnyPublisher<User, AFError>{
        
        print("APIManager - callingLoginAPI() called")
        
        return APIManager.shared.session
            .request(AuthRouter.login(email: email, password: password))
            .publishDecodable(type: AuthResponseModel.self)
            .value()
            .map { response in debugPrint("리스폰스: \(response)")
                // 받은 토큰 정보 어딘가에 영구 저장
                // userdefaults, keychain
//                UserDefaultsManager.shared.setUser(user: response.user)
                UserDefaultsManager.shared.setTokens(token: response.token)
                UserDefaultsManager.shared.setUserId(userId: response.user.id)
                UserDefaultsManager.shared.setLoggedIn(value: true)
                print("유저 :\(response.user)")
                print("유저 id :\(response.user.id)")
                print("토큰 정보 :\(response.token)")

                User.current = response.user
//                print(" 테스트: \(User.current?.name)")
                return response.user
            }.eraseToAnyPublisher()
    }
    
    //MARK: - 로그아웃
    func callingLogoutAPI() {
        print("APIManager - callingLogoutAPI() called")
        
        var token = UserDefaultsManager.shared.getTokens() as String
        print("요청한 토큰: \(token)")
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(token)",
            "contentType" : "application/json; charset=UTF-8",
            "Accept" : "application/json; charset=UTF-8"
        ]

        
        AF.request(logout_url, method: .post,  headers: headers).responseJSON { response in debugPrint(" 결과: \(response)")
        }
        
    }
    
    
    //MARK: - 자유게시판 조회
    func callingPostListAPI(completion: @escaping ([Post]?, Error?) -> ()) {
        
        print("APIManager - callingPostListAPI() called")
        
        let headers: HTTPHeaders = [
            "contentType" : "application/json; charset=utf-8",
            "Accept" : "application/json; charset=utf-8"
        ]
        
        AF.request(post_list_url, method: .get, headers: headers).responseJSON { (response) in print(response)
            switch response.result {
            case .failure(let error):
                completion(nil, error)
                return
            case .success:
                if let value = response.value as? [String: AnyObject] {
                    if let postArray = value["data"] as? NSArray {
                        let posts = postArray.compactMap({ (dictionary) -> Post in
                            Post(dictionary: dictionary as! [String : AnyObject])
                        })
                        
                        completion(posts, nil)
                        return
                    } else {
                        print("포스팅 목록 조회 실패")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "포스팅 목록 조회 실패"])
                        completion(nil, error)
                        return
                    }
                }
            }
        }
    }
    


    
    //MARK: - 현재사용자 정보
    func currentUserInfoAPI() -> AnyPublisher<User, AFError>{
        print("APIManager - currentUserInfoAPI() called")

        var token = UserDefaultsManager.shared.getTokens() as String
        print("요청한 토큰: \(token)")
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]

        
        return APIManager.shared.session
            .request(my_url, headers: headers)
            .publishDecodable(type: UserInfoResponseModel.self)
            .value()
            .map{ response in debugPrint(response)
                UserDefaultsManager.shared.setUserId(userId: response.user.id)
                User.current = response.user
                print("접속 유저 정보: \(User.current)")
//                print(" 현재 접속자: \(User.current?.name)")
                return response.user
            }.eraseToAnyPublisher()
    }
    
    
    // 모든 사용자 정보
    func fetchUsers() -> AnyPublisher<[User], AFError>{
        print("AuthApiService - fetchUsersInfo() called")
        
        
        let storedTokenData = UserDefaultsManager.shared.getTokens()
        
        
        let credential = OAuthCredential(requiresRefresh: false, token: storedTokenData)
        
        // Create the interceptor
        let authenticator = OAuthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                        credential: credential)
        
        return APIManager.shared.session
            .request(UserRouter.fetchUsers, interceptor: authInterceptor)
            .publishDecodable(type: UserListResponseModel.self)
            .value()
            .map{ $0.data }.eraseToAnyPublisher()
    }
    
    
}
