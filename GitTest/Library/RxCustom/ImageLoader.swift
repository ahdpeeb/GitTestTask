//
//  imageLoader.swift
//  Compas
//
//  Created by Nikola Andriiev on 01.11.16.
//  Copyright © 2016 Andriiev.Mykola. All rights reserved.
//

import RxSwift
import Foundation

let LinkError = "Inappropriate image link"

class ImageLoader {
    enum LoadErrors: Error {
        case urlError(description: String)
        case localURLError
    }
    
    public class func loadImage(stringURL: String) -> Observable<UIImage> {
       return Locker.syncedValue(lock: 0) { () -> Observable<UIImage> in
            return Observable<UIImage>.create { (observer) -> Disposable in
                guard let imageUrl = URL(string: stringURL) else {
                    observer.onError(LoadErrors.urlError(description: LinkError))
                    return Disposables.create()
                }
                
                let session = self.createSession()
                let task = session.dataTask(with: imageUrl, completionHandler: { (data, _, error) in
                    guard let image = (data.flatMap { UIImage(data: $0) }) else {
                        error.map { observer.onError($0) }
                        return
                    }
                    
                    observer.onNext(image)
                    observer.onCompleted()
                })
        
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
                
                }.observeOn(MainScheduler.asyncInstance)
                .shareReplayLatestWhileConnected()
        }
    }
    
    private class func createSession() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 15
        
        return URLSession(configuration: sessionConfig)
    }
    
}
