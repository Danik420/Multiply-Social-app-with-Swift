//
//  UploadProfileImageController.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/27.
//




// MARK: - 이미지 업로드 함수 예시 파일입니다. 실제로는 미사용

import UIKit
import Alamofire

class UploadProfileImageController: UIImagePickerController {

    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
    }
    
    func viewProfileChangeClicked(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 앨범", style: .default) { (action) in self .openLibrary() }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        // photoLibrary 는 이후 지원 중단, PHPicker로 향후 변경
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
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

extension UploadProfileImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let token = UserDefaultsManager.shared.getTokens()
        let header: HTTPHeaders = [
            "Authorization": "Bearer: \(token)"
        ]
        
        let resizedImage = resizeImage(image: selectedImage, newWidth: 500)
        let imageData = resizedImage?.jpegData(compressionQuality: 0.5)
        
        AF.upload(
            multipartFormData: { MultipartFormData in
                if ((imageData) != nil) {
                    MultipartFormData.append(imageData!, withName: "profile_images", fileName: "profileImage.jpeg", mimeType: "image/jpeg")
                }
            }, to: API.BASE_URL + "profile_update", method: .post, headers: header).responseJSON(completionHandler: { (response) in
                print(response)
                
                if let error = response.error {
                    print(error)
                    return
                }
                
                let json = response.result
                
                if (json != nil){
                    print(json)
                }
            }
            )}
}


