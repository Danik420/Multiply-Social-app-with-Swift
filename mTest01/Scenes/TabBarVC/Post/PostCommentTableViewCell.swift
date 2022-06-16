//
//  PostCommentTableViewCell.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/22.
//

import UIKit
import Alamofire
import SDWebImage

class PostCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentProfileImageView: UIImageView!
    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    
    
    //MARK: - 이미지 모양 및 폰트 형태 강제 변경 함수 awakeFromNib()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commentProfileImageView.clipsToBounds = true
        //self.avatarImageView.backgroundColor = .lightGray
        self.commentProfileImageView.layer.cornerRadius = 20.0
        
        self.commentNameLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        
        self.commentDateLabel.font = .systemFont(ofSize: 13.0, weight: .medium)
        self.commentDateLabel.textColor = .gray
        
        
        self.commentBodyLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        self.commentBodyLabel.numberOfLines = 5
        
    }
    
    // awakeFromNib() 말고 이것도 쓸 수 있음
    // required init?(coder: NSCoder) {
    // super.init(coder: coder)
    // code
    // }
    
//    private func configureAvatarImageView() {
//        self.avatarImageView.clipsToBounds = true
//        //self.avatarImageView.backgroundColor = .lightGray
//        self.avatarImageView.layer.cornerRadius = 20.0
//    }
//
//    private func configureNameLabel() {
//        self.nameLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
//    }
//
//    private func configureDateLabel() {
//        self.dateLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
//        self.dateLabel.textColor = .secondaryLabel
//    }
//
//    private func configuretitleLabel() {
//        self.titleLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
//        self.titleLabel.numberOfLines = 5
//    }
//
//    private func configurebodyLabel() {
//        self.bodyLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
//        self.bodyLabel.numberOfLines = 5
//    }
    
//    func setup(post: Post) {
//        selectionStyle = .none
//
////        nameLabel.text = User?.name //post.user.name
////        dateLabel.text = "2022-04-22"
//        titleLabel.text = "t;qkf"
//        bodyLabel.text = "안녕하세요"
//
//    }
}
 
