//
//  UserDafaultsManager.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/23.
//

import Foundation
import CloudKit

class UserDefaultsManager {
    enum Key: String, CaseIterable{
        case isLoggedIn
        case user
        case userId
        case token
    }
    
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    
    // 저장된 모든 데이터 지우기
    func clearAll(){
        print("UserDefaultsManager - clearAll() called")
        Key.allCases.forEach{ UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
    
    //MARK: 로그인 상태 저장
    func setLoggedIn(value: Bool) {
        UserDefaults.standard.set(value, forKey: Key.isLoggedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: 로그인 상태 체크
    func isLoggedIn()-> Bool {
        return UserDefaults.standard.bool(forKey: Key.isLoggedIn.rawValue)
    }

    
    //MARK: 유저 ID 저장
    func setUserId(userId: Int){
        UserDefaults.standard.set(userId, forKey: Key.userId.rawValue)
        UserDefaults.standard.synchronize()
    }

    //MARK: 유저 ID 불러오기
    func getUserId() -> Int{
        return UserDefaults.standard.integer(forKey: Key.userId.rawValue)
    }

    // 토큰들 저장
    func setTokens(token: String){
        print("UserDefaultsManager - setTokens() called")
        UserDefaults.standard.set(token, forKey: Key.token.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // 토큰들 가져오기
    func getTokens()->String{
        return UserDefaults.standard.string(forKey: Key.token.rawValue) ?? ""
    }

    
}
