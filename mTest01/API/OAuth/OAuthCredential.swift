//
//  OAuthCredential.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/26.
//

import Foundation
import Alamofire

struct OAuthCredential : AuthenticationCredential {
    var requiresRefresh: Bool
    
    
    let token: String
    
//    let refreshToken: String
////
//    let expiration: Date
////
//    // Require refresh if within 5 minutes of expiration
//    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiration }
    
}
