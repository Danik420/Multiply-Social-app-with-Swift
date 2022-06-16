//
//  Contants.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/20.
//

import Foundation

struct API {
//    static let BASE_URL : String = "http://3.39.239.11:80" // AWS EC2
        static let BASE_URL : String = "http://127.0.0.1:8000"
}

let register_url = "\(API.BASE_URL)/api/user/register"
let login_url = "\(API.BASE_URL)/api/user/login"
let logout_url = "\(API.BASE_URL)/api/user/logout"
let post_list_url = "\(API.BASE_URL)/api/user/post"
let comment_list_url = "\(API.BASE_URL)/api/user/comment"
let my_url = "\(API.BASE_URL)/api/user/my"
let delete_profile_image = "\(API.BASE_URL)/api/user/delete/profile_image"
