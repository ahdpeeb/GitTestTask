//
//  LoginViewModel.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/3/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import RxSwift
import AlamofireImage

class LoginViewModel: ViewModel {
    func login(login: String, pass: String) -> Observable<User?> {
        let credentialData = "\(login):\(pass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let adapter = AccessTokenAdapter(accessToken: base64Credentials)
        sessionManager.adapter = adapter
        imageDownloader = ImageDownloader(sessionManager: sessionManager)
        
        let loginURL = "https://api.github.com/user"
        return self.loadJSON(url: loginURL, method: .get)
            .map { User(JSON: $0) }
    }
}
