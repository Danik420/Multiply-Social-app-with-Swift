//
//  PostViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/21.
//
import UIKit
import Alamofire
import SwiftyJSON

class PostViewController: UIViewController {
    
    @IBOutlet weak var PostTableView: UITableView!
    
    var user: User?
    // 포스팅 배열 초기화
    var posts: [Post] = []
    var selectedPost: Post?
    let formatter = DateFormatter()
    
    //MARK: - Floating Button 글작성 버튼
    
    private let writeButton: UIButton = {
        //버튼 사이즈
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        //버튼 내 아이콘 설정
        let ImageConfig = UIImage.SymbolConfiguration(weight: .medium)
        let Image = UIImage(systemName: "highlighter", withConfiguration: ImageConfig)
        button.setImage(Image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 18, right: 16)
        //버튼 설정
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        // Corner Radius
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainViewController - viewDidLoad() 호출됨")
        PostTableView.delegate = self
        PostTableView.dataSource = self
        
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        //새로고침
        PostTableView.refreshControl = refreshControl
        
        view.addSubview(writeButton)
        writeButton.addTarget(self, action: #selector(didTapWriteButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear() called")
        
        handleRefresh()
    }
    
    
    //MARK: - subView for Floating Button
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        writeButton.frame = CGRect(
            x: view.frame.size.width - 60 - 10,
            y: view.frame.size.height - 60 - 94,
            width: 60,
            height: 60
        )
    }
    
    //MARK: - objc func for refreshControl.addTarget
    
    @objc fileprivate func handleRefresh(){
        print("handleRefresh 호출됨")
        posts.removeAll()
        
        // self.page = 1
        loadData()  //(page: page)
    }
    
    //MARK: objc func for writeButton.addTarget
    @objc private func didTapWriteButton() {
        let postCreateViewController = UINavigationController(rootViewController: PostCreateViewController())
        postCreateViewController.modalPresentationStyle = .fullScreen
        
        performSegue(withIdentifier: "goToPostCreateVC", sender: self)
    }
    
    //MARK: - 데이터 호출
    fileprivate func loadData(){
        
        APIManager.shared.callingPostListAPI { (posts: [Post]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.PostTableView.reloadData()
                print("포스팅 배열에 들어있다. : \(self.posts.count)")
                self.PostTableView?.refreshControl?.endRefreshing()
            } else {
                
                
                // Pop up alert upon (network) error
                // Source: https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
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


//MARK: - 이미지 첨부


//MARK: - 테이블뷰 델리겟 메소드
extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedPost = posts[indexPath.row]
        
        
        //        let vc = PostDetailViewController(nibName: "PostDetailViewController", bundle: nil)
        //        vc.post = self.selectedPost
        //        navigationController?.pushViewController(vc, animated: true)
        
        // 화면 전환을 발동시킨다.
        performSegue(withIdentifier: "goToPostDetailVC", sender: self)
    }
    
    
    // 즉 쎌을 랜더링 한다
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("numberOfRowsInSection: \(self.posts.count)")
        self.posts.sort(by: { $0.createdAt > $1.createdAt }) // 날짜별 내림차순으로 전환 - id로 해도 됨
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
//        cell.post = self.posts[indexPath.row]
        
        // 셀 속성 관리
        cell.titleLabel.text = self.posts[indexPath.row].title as String
        cell.nameLabel.text = self.posts[indexPath.row].user.name as String?
        cell.bodyLabel.text = self.posts[indexPath.row].body as String
        let date = stringToDate(strDate: self.posts[indexPath.row].createdAt)
        let stringDate = dateToString(date: date)
        cell.dateLabel.text = stringDate as String
        
        // 셀 프로필 이미지 관리 - 이미지 및 기본 이미지 url로 직접 송출. (ProfileVC에서 사용한 방식은 cell row에서는 사용 불가)
        let basicProfileImage = "/storage/profile_multiply/basicProfileImage.png"
        let url = (self.posts[indexPath.row].user.profileImageURL ?? basicProfileImage)
        print("\(API.BASE_URL)\(url)")
        cell.profileImageView.sd_setImage (
            with: URL (string: "\(API.BASE_URL)\(url)")
//           placeholderImage: UIImage (named: "mBackground") // define your default Image
        )
        
        return cell
    }
    
    // 포스팅 클릭 시 자세히 보기 화면으로
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToPostDetailVC"){
            
            var vc = segue.destination as! PostDetailViewController
            
            print("세그웨이로 넘어왔다. selectedPost.title : \(selectedPost?.title)")
            
            vc.post = self.selectedPost
        }
    }
}
