//
//  CommentTableViewCell.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/31.
//

import UIKit
import Alamofire

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentProfileImageView: UIImageView!
    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    @IBOutlet weak var commentEditButton: UIButton!
    @IBOutlet weak var commentDeleteButton: UIButton!
    
    
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
}
