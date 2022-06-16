//
//  AuthModel.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/20.
//

import Foundation

// MARK: - Responses

// 로그인, 회원가입 리스폰스
struct AuthResponseModel: Codable {
    let user: User
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case token = "token"
    }
}
// 현재 사용자 조회 리스폰스
struct UserInfoResponseModel: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
}

// 모든 사용자 조회 리스폰스
struct UserListResponseModel: Codable {
    let data: [User]
}


// MARK: - User model
struct User: Codable, Identifiable {
    let id: Int // 오류나면 옵셔널로
    let name: String?
    let email: String
    var profileImageURL: String?
    let phoneNumber: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case profileImageURL = "profile_image_url"
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
    }
    
    static var current: User?
    
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as! Int
        name = dictionary["name"] as? String
        email = dictionary["email"] as! String
        
        profileImageURL = dictionary["profile_image_url"] as? String
//        let profileImageURLString = dictionary["profile_image_url"] as? String
//        profileImageURL.load(urlString: image)
        
        phoneNumber = dictionary["phone_number"] as? String
        createdAt = dictionary["created_at"] as! String
    }
}

// 리프레시토큰, 만료기간 등 목록 더 추가될 때 활용, JSON에서 토큰 단일 String이 아닌 데이터 목록으로 넘어오게 laravel 구성했을 경우에만
struct TokenData: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

//// MARK: - 회원가입
//struct RegisterModel: Encodable {
//    let name: String
//    let email: String
//    let password: String
//    let passwordConfirmation: String
//
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case email = "email"
//        case password = "password"
//        case passwordConfirmation = "password_confirmation"
//    }
//}
//
//// MARK: - 로그인
//struct LoginModel: Encodable {
//    let email: String?
//    let password: String?
//}


// 리스폰스 쉽게 받는 방법
//struct LoginResponseModel {
//    let name: String
//    let email: String
//}
