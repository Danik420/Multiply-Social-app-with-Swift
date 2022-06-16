//
//  ProfileViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/26.
//

import UIKit
import Alamofire
import Combine
import SDWebImage


class ProfileViewController: UIViewController, ObservableObject {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var myPostButton: UILabel!
    @IBOutlet weak var myCommentButton: UILabel!
    @IBOutlet weak var userListButton: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: properties
    var subscription = Set<AnyCancellable>()
    @Published var loggedInUser: User? = nil
    @Published var users : [User] = []
    
    let picker = UIImagePickerController()
    
    //MARK: - Floating Button 프로필 이미지 변경
    
    private let profileImageButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //버튼 내 아이콘 설정
        let ImageConfig = UIImage.SymbolConfiguration(weight: .medium)
        let iconImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: ImageConfig)
        button.setImage(iconImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 8, bottom: 9, right: 8)
        //버튼 설정
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        button.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        // Corner Radius
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        
        picker.delegate = self
        
        configureButtons()
        
        
        
        view.addSubview(profileImageButton)
        profileImageButton.addTarget(self, action: #selector(tapProfileImageButton), for: .touchUpInside)
    }
    
    //MARK: - subView for Floating Button
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 버튼 크기, 위치 조정
        profileImageButton.frame = CGRect(
            x: view.frame.size.width - 40 - 10,
            y: view.frame.size.height - 40 - 584,
            width: 40,
            height: 40
        )
    }
    
    // 유저 정보 받아오기, tap뷰로 연결된 경우 탭뷰컨트롤러 정보 한번에 로드되기 때문에 진입화면에서 API 콜해줘야된단다.
    func loadUser() {
        APIManager.shared.currentUserInfoAPI()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PorfileViewController - loadUser() completion: \(completion)")
            } receiveValue: { (receivedUser: User) in
                print("PorfileViewController - loadUser() receivedUser: \(receivedUser)")
                self.loggedInUser = receivedUser
                
                print("유저 네임:\(receivedUser.name)")
                // self.profileImageView.url = receivedUser.profileImageURL 수정 필요
                
                // 셀 프로필 이미지 관리 - 이미지 및 기본 이미지 url로 직접 송출. (ProfileVC에서 사용한 방식은 cell row에서는 사용 불가)
                let basicProfileImage = "/storage/profile_multiply/basicProfileImage.png"
                let url: String = receivedUser.profileImageURL ?? basicProfileImage
                print("유알엘: \(API.BASE_URL)\(url)")
                self.profileImageView.sd_setImage (
                    with: URL (string: "\(API.BASE_URL)\(url)")
                )
                
                // 회원 정보
                self.nameLabel.text = receivedUser.name
                self.phoneNumber.text = receivedUser.phoneNumber ?? "연락처를 입력해주세요"
                
                let date = self.stringToDate(strDate: receivedUser.createdAt)
                let stringDate = self.dateToString(date: date)
                self.createdAt.text = "\(stringDate)요일에 가입했어요"
                
                // 프로필 이미지 관리 - 이미지만 직접 송출 기본이미지는 UIImage 활용
//                guard let url: String = receivedUser.profileImageURL else { return }
//                self.profileImageView.sd_setImage (
//                   with: URL (string: "http://127.0.0.1:8000\(url)"),
//                   placeholderImage: UIImage (named: "mBackground") // define your default Image
//                )
                
            }.store(in: &subscription)
    }
    
    func configureButtons() {
        //모서리 굴곡률
        // btn.layer.cornerRadius = 10
        //테두리 굵기
        self.myPostButton.layer.borderWidth = 1
        self.myCommentButton.layer.borderWidth = 1
        self.userListButton.layer.borderWidth = 1
        self.logoutButton.layer.borderWidth = 1
        //테두리 색상
        self.myPostButton.layer.borderColor = UIColor.gray.cgColor
        self.myCommentButton.layer.borderColor = UIColor.gray.cgColor
        self.userListButton.layer.borderColor = UIColor.gray.cgColor
        self.logoutButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        APIManager.shared.callingLogoutAPI()
//        User.current = nil
        UserDefaultsManager.shared.clearAll()
        
        self.performSegue(withIdentifier: "goToLoginVC", sender: nil)
        // 탭바 전체 dismiss, 로그인 화면(root view)로 전환
        // self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - 이미지 업로드 기능
    @objc func tapProfileImageButton(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 앨범", style: .default) { (action) in self .openLibrary() }
        let basicProfileImage = UIAlertAction(title: "삭제", style: .default) { (action) in self .basicProfileImage() }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(basicProfileImage)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 사진첩 열기
    func openLibrary() {
        // photoLibrary 는 이후 지원 중단, PHPicker로 향후 변경
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }
    
    // 기본이미지로 변경
    func basicProfileImage() {
        print("프로필 사진 삭제 - basicProfileImage() called")

        let token = UserDefaultsManager.shared.getTokens()
        let userId = UserDefaultsManager.shared.getUserId()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(token)",
            "contentType" : "application/json; charset=UTF-8",
            "Accept" : "application/json; charset=UTF-8"
        ]
        
        AF.request(delete_profile_image + "/\(userId)", method: .delete, encoding: JSONEncoding.default, headers: headers)
        .response { response in debugPrint(response)
            print("결과: \(response)")
            self.loadUser()
            print("삭제 완료")
        }
    }
    
    // 이미지 리사이징, 반환 타입 꼭 UIImage? 옵셔널로 반환해줘야 에러 안 남.
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}


// MARK: - 이미지 관련 델리게이트 프로토콜
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        print("프로필 사진 변경 요청")
        let token = UserDefaultsManager.shared.getTokens()
        let userId = UserDefaultsManager.shared.getUserId()
        
        let resizedImage = resizeImage(image: selectedImage, newWidth: 500)
        let imageData = resizedImage?.jpegData(compressionQuality: 0.5)
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(token)",
            "contentType" : "application/json; charset=UTF-8",
            "Accept" : "application/json; charset=UTF-8"
        ]
        
        AF.upload(
            multipartFormData: { MultipartFormData in
                if ((imageData) != nil) {
                    MultipartFormData.append(imageData!, withName: "profile_image_url", fileName: "profile_image_url", mimeType: "image/png")
                }
            }, to: API.BASE_URL + "/api/user/update/\(userId)", method: .post, headers: headers).responseJSON(completionHandler: { (response) in
                print("리스폰스: \(response)")
                
                if let error = response.error {
                    print(error)
                    return
                }
                
                let json = response.result
                
                if (json != nil){
                    self.loadUser()
                    print("리절트: \(json)")
                }
                
                
            }
            )
        
        dismiss(animated: true, completion: nil)
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
        formatter.dateFormat = "yyyy년 MM월 dd일, EEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
