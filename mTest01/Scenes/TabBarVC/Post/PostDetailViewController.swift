//
//  PostDetailViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/25.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostDetailViewController: UIViewController {
    
//    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var postCommentTableView: UITableView!
    
    var post: Post? {
        didSet { print("post - didSet : post.title : \(post?.title)") }
    }
    var comments: [Comment] = []
    var comment: Comment?
    let formatter = DateFormatter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PostDetailVC - viewDidLoad() 호출됨")
        print("post 번호 : \(post?.id)")
        print("post 제목 : \(post?.title)")
        print("post 내용 : \(post?.body)")
        postCommentTableView.delegate = self
        postCommentTableView.dataSource = self
        
        
        
        configureHiddenButton()
        self.configurePostStackView()
        print("font 및 radius 등 반영됨")
        
        // 네비게이션 바 버튼을 추가한다.
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정하기", style: .plain, target: self, action: #selector(goToEditPostView))
        
        self.editButton.addTarget(self, action: #selector(editPost), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear() called")
        
        loadData()
    }
    
    // 수정 삭제 버튼 보이기 조건
    func configureHiddenButton() {
        if post?.userId as Int? == User.current?.id as Int? {
            self.editButton.layer.isHidden = false
            self.deleteButton.layer.isHidden = false
        } else {
            self.editButton.layer.isHidden = true
            self.deleteButton.layer.isHidden = true
        }
    }
    
    // 그래픽 요소
    private func configurePostStackView() {
        
        self.nameLabel.text = post?.user.name //유저디폴트로 글쓰니까 포스트 기록으로도 된다 씨발!!!!!!!!!!!!!!!!!!!
        self.nameLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        
        let date = self.stringToDate(strDate: post?.createdAt ?? "")
        let stringDate = self.dateToString(date: date)
        self.dateLabel.text = stringDate
        self.dateLabel.font = .systemFont(ofSize: 13.0, weight: .medium)
        self.dateLabel.textColor = .gray
        
        self.titleLabel.text = post?.title
        self.titleLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.titleLabel.numberOfLines = 2
        
        self.bodyLabel.text = post?.body
        self.bodyLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        self.bodyLabel.numberOfLines = 100
//        stackView.distribution = .fillProportionally
        
        self.profileImageView.clipsToBounds = true
        //self.avatarImageView.backgroundColor = .lightGray
        self.profileImageView.layer.cornerRadius = 20.0
        let basicProfileImage = "/storage/profile_multiply/basicProfileImage.png"
        let url: String = post?.user.profileImageURL ?? basicProfileImage
        profileImageView.sd_setImage (
            with: URL (string: "\(API.BASE_URL)\(url)")
         )
        
    }
    
    fileprivate func loadData(){
        
       callingCommentListAPI { (comments: [Comment]?, error: Error?) in
            if let comments = comments {
                self.comments = comments
                self.postCommentTableView.reloadData()
                print("댓글 배열에 들어있다. : \(self.comments.count)")
                self.postCommentTableView?.refreshControl?.endRefreshing()
            } else {
                
                
                // Pop up alert upon (network) error
                // Source: https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: - 댓글 조회
    fileprivate func callingCommentListAPI(completion: @escaping ([Comment]?, Error?) -> ()) {
        
        print("APIManager - callingCommentListAPI() called")
        
        let headers: HTTPHeaders = [
            "contentType" : "application/json; charset=utf-8",
            "Accept" : "application/json; charset=utf-8"
        ]
        
        print(comment_list_url + "/\((post?.id)!)")
        
        AF.request(comment_list_url + "/\((post?.id)!)", method: .get, headers: headers).responseJSON { (response) in print(response)
            switch response.result {
            case .failure(let error):
                completion(nil, error)
                return
            case .success:
                if let value = response.value as? [String: AnyObject] {
                    if let commentArray = value["data"] as? NSArray {
                        let comments = commentArray.compactMap({ (dictionary) -> Comment in
                            Comment(dictionary: dictionary as! [String : AnyObject])
                        })
                        
                        completion(comments, nil)
                        return
                    } else {
                        print("댓글 목록 조회 실패")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "댓글 목록 조회 실패"])
                        completion(nil, error)
                        return
                    }
                }
            }
        }
    }
    
    @objc fileprivate func deletePost(){
        print("deletePost() called")
        
        guard let postId = post?.id else { return }
        
        AF.request(post_list_url + "/\(postId)", method: .delete, parameters: nil, encoding: JSONEncoding.default)
        .response { response in
            print("포스팅 삭제 성공!~ \(response)")
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    
    @objc fileprivate func editPost(){
        print("goToPostEditView() called")
        
        performSegue(withIdentifier: "goToPostEditVC", sender: self)
    }
    
    //MARK: - 날짜 변환기
    public func stringToDate(strDate: String) -> Date {
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "ko_KR")
        //formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        
        
        return formatter.date(from: strDate)!
    }
    
    public func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd EEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}
    //MARK: - EditPostViewControllerDelegate 메소드
extension PostDetailViewController: PostEditViewControllerDelegate {
    
    func editPostCompleted(title: String, body: String) {
        
        //존나 천재적인 발상 이걸로 라벨 바꾸고
        self.titleLabel.text = title
        self.bodyLabel.text = body
        //포스트 저장 값도 바꿈 var로 선언해서
        post?.title = title
        post?.body = body
    }
    
//    func editPostCompleted(editedPostItem: Post) {
//        print("PostDetailViewController - editPostCompleted / editedPostItem.title : \(editedPostItem.title)")
//        post? = editedPostItem
//        self.titleLabel.text = editedPostItem.title
//        self.bodyLabel.text = editedPostItem.body
//
//    }
    
    
    
    // 화면을 넘기는 부분이다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToPostEditVC"){
            
            var vc = segue.destination as! PostEditViewController
            
            print("세그웨이로 넘어왔다. selectedPost.title : \(post?.title)")
            
            vc.receivedPost = self.post
            vc.delegate = self
        }
    }
}


//MARK: - 테이블뷰 델리겟 메소드
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.comments.count)
        return self.comments.count
    }
    
    // 댓글 클릭시 작동 기능
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        self.selectedPost = comments[indexPath.row]
//
//
//        //        let vc = PostDetailViewController(nibName: "PostDetailViewController", bundle: nil)
//        //        vc.post = self.selectedPost
//        //        navigationController?.pushViewController(vc, animated: true)
//
//        // 화면 전환을 발동시킨다.
//        performSegue(withIdentifier: "goToPostDetailVC", sender: self)
//    }
    
    
    // 즉 쎌을 랜더링 한다
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        self.comments.sort(by: { $0.createdAt > $1.createdAt }) // 날짜별 내림차순으로 전환 - id로 해도 됨
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
//        cell.post = self.posts[indexPath.row]
        
        // 셀 속성 관리
        cell.commentNameLabel.text = self.comments[indexPath.row].user.name as String?
        cell.commentBodyLabel.text = self.comments[indexPath.row].body as String
        let date = stringToDate(strDate: self.comments[indexPath.row].createdAt)
        let stringDate = dateToString(date: date)
        cell.commentDateLabel.text = stringDate as String
        
        // 셀 프로필 이미지 관리 - 이미지 및 기본 이미지 url로 직접 송출. (ProfileVC에서 사용한 방식은 cell row에서는 사용 불가)
        let basicProfileImage = "/storage/profile_multiply/basicProfileImage.png"
        let url = (self.comments[indexPath.row].user.profileImageURL ?? basicProfileImage)
        cell.commentProfileImageView.sd_setImage (
            with: URL (string: "\(API.BASE_URL)\(url)")
//           placeholderImage: UIImage (named: "mBackground") // define your default Image
        )
        
        func configureHiddenCommentButton() {
            print("히든버튼실행")
            print(comment?.user.id)
            print(User.current?.id)
            if self.comments[indexPath.row].userId as Int? == User.current?.id as Int? {
                print("테스트1")
                cell.commentEditButton.layer.isHidden = false
                cell.commentDeleteButton.layer.isHidden = false
            } else {
                print("테스트2")
                cell.commentEditButton.layer.isHidden = true
                cell.commentDeleteButton.layer.isHidden = true
            }
        }
        
        configureHiddenCommentButton()
        return cell
    }
    
    
    // 댓글 클릭 작동 대비 prepare
//    // 포스팅 클릭 시 자세히 보기 화면으로
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if(segue.identifier == "goToPostDetailVC"){
//
//            var vc = segue.destination as! PostDetailViewController
//
//            print("세그웨이로 넘어왔다. selectedPost.title : \(selectedPost?.title)")
//
//            vc.post = self.selectedPost
//        }
//    }
}
