//
//  PostCreateViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/25.
//

import UIKit
import Alamofire


class PostCreateViewController: UIViewController {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var imageInput: UILabel!
    @IBOutlet weak var bodyInput: UITextView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBodyInput()
        titleInput.delegate = self
        bodyInput.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registerPost))
        print("PostCreateViewController - viewDidLoad() called")
        
        
    }
    
    // 뷰 CSS 설정
    private func configureBodyInput() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.bodyInput.layer.borderColor = borderColor.cgColor
        self.bodyInput.layer.borderWidth = 0.5
        self.bodyInput.layer.cornerRadius = 5.0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    //MARK: - fileprivate 메소드 Alamofire
    @objc fileprivate func registerPost(){
        print("registerPost() called")
        
        print("입력된 타이틀:  \(titleInput.text ?? "")")
        print("입력된 바디:  \(bodyInput.text ?? "")")
        
        
        let parameters: [String: Any] = [
            "user_id": UserDefaultsManager.shared.getUserId() as Int,
            "title" : (titleInput.text ?? "") as String,
            "body" : (bodyInput.text ?? "") as String
        ]
        
        let headers: HTTPHeaders = [
                "Accept" : "application/json; charset=UTF-8",
                "Content-Type" : "application/json; charset=UTF-8"
            ]

        AF.request(post_list_url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(contentType: ["application/json"])
        .response { response in debugPrint(response)
            print("포스팅 등록 성공!~ \(response)")
            
//        AF.request("http://127.0.0.1:8000/api/post", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(contentType: ["application/json"])
//        .responseJSON { response in
//            print("포스팅 등록 결과: \(response)")
            
            self.navigationController?.popViewController(animated: true)
            
            
        }
    }
    
}
    
    //MARK: - TextField 델리겟 메소드
    
extension PostCreateViewController: UITextViewDelegate, UITextFieldDelegate {
    
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
