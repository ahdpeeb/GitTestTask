//
//  AppState.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/3/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
var imageDownloader: ImageDownloader?

class AppState {
    //for defualt initialization
    static let sharedInstance = AppState()
    
    //sharedInstance by defualt is unloggined
    
    public var logginedUser: User? = nil
    public var isLoggined: Bool = false
    
    private init() { }
}
