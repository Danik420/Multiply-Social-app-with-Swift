//
//  ApiLogger.swift
//  mTest01
//
//  Created by Danik420 on 2022/05/18.
//

import Foundation
import Alamofire

final class ApiLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "mTest01")
    
    // Event called when any type of Request is resumed.
    func requestDidResume(_ request: Request) {
        print("ApiLogger - Resuming: \(request)")
    }
    
    // Event called whenever a DataRequest has parsed a response.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        debugPrint("ApiLogger - Finished: \(response)")
    }
}
