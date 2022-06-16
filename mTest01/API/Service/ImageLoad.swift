//
//  ImageLoad.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/27.
//

import Foundation
import UIKit

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self ] in
            if let data = try? Data(contentsOf: url) {
                guard let image = self?.image else { return }
            }
        }
    }
}
