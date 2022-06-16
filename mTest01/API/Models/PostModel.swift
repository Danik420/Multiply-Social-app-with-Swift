//
//  PostModel.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/22.
//

import Foundation


struct Post: Codable {
    let id: Int
    let userId: Int?
    let user: User
    var title: String
    var body: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case user = "user"
        case title = "title"
        case body = "body"
        case createdAt = "created_at"
    }
    
    init(dictionary: [String: AnyObject]) {
        let dictionary = dictionary
        
        id = dictionary["id"] as! Int
        userId = dictionary["user_id"] as? Int
        title = dictionary["title"] as! String
        body = dictionary["body"] as! String
        createdAt = dictionary["created_at"] as! String
        
        // set user
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
//        // Format createdAt date string
//        let createdAtOriginalString = dictionary["created_at"] as! String
//        let formatter = DateFormatter()
//        // Configure the input format to parse the date string
//        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
//        // Convert String to Date
//        guard let date = formatter.date(from: createdAtOriginalString) else { return }
//        // Configure output format
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        // Convert Date to String and set the createdAtString property
//        createdAt = formatter.string(from: date)
    }
    
    static func posts(with array: [[String: AnyObject]]) -> [Post] {
        var posts: [Post] = []
        for postDictionary in array {
            let post = Post(dictionary: postDictionary)
            posts.append(post)
        }
        return posts
    }
}





