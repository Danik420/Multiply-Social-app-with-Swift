//
//  PostEditViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/25.
//

import UIKit
import Alamofire

protocol PostEditViewControllerDelegate {
    // 포스팅 수정이 완료 되었다.
    
    func editPostCompleted(title: String, body: String)
}


class PostEditViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var imageInput: UILabel!
    @IBOutlet weak var bodyInput: UITextView!
    
    
    var receivedPost: Post?
    
    var delegate: PostEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        print("에딧 VC - viewDidLoad() 호출됨 / receivedPost.id : \(receivedPost?.id) / receivedPost.title : \(receivedPost?.title)")
        
        // navigationItem.title = "포스팅 수정하기"
        // 네비게이션 바 버튼을 추가한다.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정완료", style: .plain, target: self, action: #selector(editComplete))
        configureBodyInput()
        bodyInput.delegate = self
        titleInput.delegate = self
        
        titleInput.text = receivedPost?.title
        bodyInput.text = receivedPost?.body
    }
    
    // 뷰 CSS 설정
    private func configureBodyInput() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.bodyInput.layer.borderColor = borderColor.cgColor
        self.bodyInput.layer.borderWidth = 0.5
        self.bodyInput.layer.cornerRadius = 5.0
    }
    
    @objc fileprivate func editComplete(){
        
        let parameters: [String: Any] = [
            "title" : (titleInput.text ?? "") as String,
            "body" : (bodyInput.text ?? "") as String
        ]
        
        let headers: HTTPHeaders = [
                "Accept" : "application/json",
                "Content-Type" : "application/json"
            ]
        
        print("editComplete() called")
        
        print("입력된 타이틀:  \(titleInput.text ?? "")")
        print("입력된 바디:  \(bodyInput.text ?? "")")
        
        guard let receivedPostId = receivedPost?.id else { return }
        
        AF.request(post_list_url + "/\(receivedPostId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in debugPrint(response)
                switch response.result {
                case .failure(let error):
                    print("에러 내용: \(error.localizedDescription)")
                    return
                case .success:
                    print("수정 내용: \(response)")
                    self.delegate?.editPostCompleted(title: self.titleInput.text ?? "", body: self.bodyInput.text)
                    return
                }
                
                
                
            }
         
         self.navigationController?.popViewController(animated: true)
        
    }

}

//MARK: - TextField 델리겟 메소드

extension PostEditViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing / textField : \(textField.text)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing / textField : \(textField.text)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("타이틀입력: \(textField.text)")
        return true
        
    }
    
    //MARK: - textView 델리겟 메소드
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("바디입력: \(textView.text)")
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing / textView : \(textView.text)")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing / textView : \(textView.text)")
    }
}
