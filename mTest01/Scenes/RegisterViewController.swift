//
//  RegisterViewController.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/21.
//

import UIKit
import Alamofire
import Combine

class RegisterViewController: UIViewController, ObservableObject {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: properties
    var subscription = Set<AnyCancellable>()
    @Published var loggedInUser: User? = nil
    @Published var users : [User] = []
    
    // 회원가입 완료 이벤트
    var registrationSuccess = PassthroughSubject<(), Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        print("RegisterViewController: tapCoonfirmButton called")
        
        guard let name = self.nameTextField.text else { return }
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let passwordConfirmation = self.passwordConfirmTextField.text else { return }
        guard let phoneNumber = self.phoneNumberTextField.text else { return }
        
        APIManager.shared.callingRegisterAPI(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation, phoneNumber: phoneNumber)
            .sink { (completion: Subscribers.Completion<AFError>) in debugPrint("가입결과 \(completion)")
                switch completion {
                case .finished:
                    debugPrint(completion)
                    print("회원가입 내용: \(completion)")
                    self.performSegue(withIdentifier: "goToPostVC", sender: nil)
                case .failure(let error):
                    print("에러 내용: \(error.localizedDescription)")
                    self.showAlert(title: "Alert", message: "회원정보를 확인해주세요.", okButton: "확인", noButton: "")
                }
            } receiveValue: { (receivedUser: User) in
                self.loggedInUser = receivedUser
                self.registrationSuccess.send()
            }.store(in: &subscription)
    }
    
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
