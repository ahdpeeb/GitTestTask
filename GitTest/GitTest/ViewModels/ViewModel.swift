//
//  BaseViewModel.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/1/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

public enum RxRequstError: Error {
    case unknown
    /// Response is not successful. (not in `200 ..< 300` range)
    case httpRequestFailed(response: HTTPURLResponse, statusCode: Int)
    /// Deserialization error.
    case deserializationError(responceValue: Any)
    
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "Unknown error has occurred."
        case let .httpRequestFailed(_, statusCode):
            return "HTTP request failed with `\(statusCode)`."
        case let .deserializationError(responceValue):
            return "Error during deserialization of the response: \(responceValue)"
        }
    }
}

class ViewModel {
    public func loadJSON(url: URLConvertible, method: HTTPMethod = .get, parametres: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<[String: Any]> {
        return Observable<[String: Any]>.create { (observer) -> Disposable in
            let task = sessionManager.request(url, method: method, parameters: parametres, encoding: encoding, headers: headers).validate()
            task.responseJSON(queue: DispatchQueue.main, completionHandler: { serverResponce in
                guard let value = serverResponce.result.value else {
                    guard let responce = serverResponce.response else {
                        observer.onError(RxRequstError.unknown)
                        return
                    }
                    
                    let error = RxRequstError.httpRequestFailed(response: responce, statusCode: responce.statusCode)
                    observer.onError(error)
                    return
                }
                
                guard let json = value as? [String: Any] else {
                    observer.onError(RxRequstError.deserializationError(responceValue: value))
                    return
                }
                
                observer.onNext(json)
                observer.onCompleted()
            })
            
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
    
    public func loadAny(url: URLConvertible, method: HTTPMethod = .get, parametres: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<Any> {
        return Observable<Any>.create { (observer) -> Disposable in
            let task = sessionManager.request(url, method: method, parameters: parametres, encoding: encoding, headers: headers).validate()
            task.responseJSON(queue: DispatchQueue.main, completionHandler: { serverResponce in
                guard let value = serverResponce.result.value else {
                    guard let responce = serverResponce.response else {
                        observer.onError(RxRequstError.unknown)
                        return
                    }
                    
                    let error = RxRequstError.httpRequestFailed(response: responce, statusCode: responce.statusCode)
                    observer.onError(error)
                    return
                }
                
                observer.onNext(value)
                observer.onCompleted()
            })
            
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
}
