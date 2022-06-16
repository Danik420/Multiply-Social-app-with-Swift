//
//  LoginViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/21.
//

import UIKit
import Alamofire
import Combine

class LoginViewController: UIViewController, ObservableObject {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var niemibutton: UIButton!
    
    
    
    // ObservableObject - Combine 관련 코드
    @Published var loggedInUser: User? = nil
    @Published var users : [User] = []
    var subscription = Set<AnyCancellable>()
    
    var email: String = ""
    var password: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //confirmButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }

    
//    /// 로그인 하기
//    func login(email: String, password: String){
//        print("UserVM: login() called")
//        APIManager.shared.callingLoginAPI(login: login)
//            .sink { (completion: Subscribers.Completion<AFError>) in
//                print("UserVM completion: \(completion)")
//            } receiveValue: { (receivedUser: User) in
//                self.loggedInUser = receivedUser
//                self.loginSuccess.send()
//            }.store(in: &subscription)
    
    
    @IBAction func tapNIEMIButton(_ sender: UIButton) {
        APIManager.shared.currentUserInfoAPI()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PorfileViewController - loadUser() completion: \(completion)")
            } receiveValue: { (receivedUser: User) in
                print("PorfileViewController - loadUser() receivedUser: \(receivedUser)")
                self.loggedInUser = receivedUser
            }.store(in: &subscription)
    }
    
    
    // 로그인 완료 이벤트
    var loginSuccess = PassthroughSubject<(), Never>()
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        print("LoginViewController: tapConfirmButton called")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        APIManager.shared.callingLoginAPI(email: email, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in debugPrint(completion)
                switch completion {
                case .finished:
                    debugPrint(completion)
                    print("로그인 내용: \(completion)")
                    self.performSegue(withIdentifier: "goToPostVC", sender: nil)
                case .failure(let error):
                    print("에러 내용: \(error.localizedDescription)")
                    self.showAlert(title: "Alert", message: "회원정보를 확인해주세요.", okButton: "확인", noButton: "")
                }
            } receiveValue: { (receivedUser: User) in
                self.loggedInUser = receivedUser
                self.loginSuccess.send()
            }.store(in: &subscription)
        debugPrint("받아왔나? receivedUser: \(self.loggedInUser)")
        print("로그인 완료 끝")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToPostVC"){
            // var vc = segue.destination as! PostViewController
            print("포스트 목록 화면으로 이동")
        }
    }
    
    // self.navigationController?.popViewController(animated: true)
    
    //    // 회원가입시 이메일 인증 화면으로
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if(segue.identifier == "goToVerificationVC"){
    //
    //            var vc = segue.destination as! VerificationViewController
    //
    //            print("이메일 인증 세그 이동")
    //
    //        }
    //    }

//MARK: - Alert
        func showAlert(title:String, message:String, okButton:String, noButton:String) {
                // [UIAlertController 객체 정의 실시]
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                
                // [인풋으로 들어온 확인 버튼이 nil 아닌 경우]
                if(okButton != "" && okButton.count>0){
                    let okAction = UIAlertAction(title: okButton, style: .default) { (action) in
                        // [확인 버튼 클릭 이벤트 내용 정의 실시]
                        return
                    }
                    alert.addAction(okAction) // 버튼 클릭 이벤트 객체 연결
                }
                
                // [인풋으로 들어온 취소 버튼이 nil 아닌 경우]
                if(noButton != "" && noButton.count>0){
                    let noAction = UIAlertAction(title: noButton, style: .default) { (action) in
                        // [취소 버튼 클릭 이벤트 내용 정의 실시]
                        return
                    }
                    alert.addAction(noAction) // 버튼 클릭 이벤트 객체 연결
                }
                
                // [alert 팝업창 활성 실시]
                present(alert, animated: false, completion: nil)
            }

}
    
