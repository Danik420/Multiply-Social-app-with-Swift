//
//  CommentModel.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/30.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let postId: Int
    let userId: Int?
    let user: User
    var body: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case postId = "post_id"
        case userId = "user_id"
        case user = "user"
        case body = "body"
        case createdAt = "created_at"
    }
    
    // 댓글 목록용 딕셔너리
    init(dictionary: [String: AnyObject]) {
        let dictionary = dictionary

        id = dictionary["id"] as! Int
        postId = dictionary["post_id"] as! Int
        userId = dictionary["user_id"] as? Int
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

    static func comments(with array: [[String: AnyObject]]) -> [Comment] {
        var comments: [Comment] = []
        for commentDictionary in array {
            let comment = Comment(dictionary: commentDictionary)
            comments.append(comment)
        }
        return comments
    }
}
