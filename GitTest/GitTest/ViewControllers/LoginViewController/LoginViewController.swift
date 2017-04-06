//
//  LoginViewController.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/3/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    let disposeBag = DisposeBag()
    private let keychainWrapper = KeychainWrapper()
    
    @IBOutlet var loginButton: UIButton!
    var rootView: LoginView { return self.getView()! }
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writeAuthentication()
        self.subscribeOnEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: Private func
    
    fileprivate func subscribeOnEvents() {
        self.loginButtonValidation()
        self.subscribeOnloginButtomTap()
    }
    
    private func shouldCacheCredentials(_ shouldCache: Bool) {
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
    private func loginButtonValidation() {
        let loginValid = self.rootView.emailTextField.rx.text
            .map { $0?.isEmpty == false }
            .shareReplay(1)
        
        let passValid = self.rootView.passwordTextField.rx.text
            .map { $0?.isEmpty == false }
            .shareReplay(1)
        
        let fields = Observable.combineLatest(loginValid, passValid) { (login, pass) -> Bool in
            return login && pass
        }
        
        fields.subscribe(loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func subscribeOnloginButtomTap() {
        let tapEvent = self.loginButton.rx.tap
            .throttle(3, scheduler: MainScheduler.asyncInstance)
        tapEvent.flatMap ({ _ -> Observable<User?> in
                self.rootView.isLoadingViewVisible = true
                let login = self.rootView.emailTextField.text!
                let pass = self.rootView.passwordTextField.text!
                return self.loginViewModel.login(login: login, pass: pass)
        }).debug()
        .subscribe(onNext: { (user) in
            self.rootView.isLoadingViewVisible = false
            self.saveAuthentication()
            self.performSegue(withIdentifier: Constants.SeguesID.repositoriesList, sender: self)
        }, onError: { (error) in
            self.rootView.isLoadingViewVisible = false
            self.errorHandling(error: error as! RxRequstError)
            
            self.subscribeOnloginButtomTap()
        }).addDisposableTo(disposeBag)
    }
    
    private func errorHandling(error: RxRequstError) {
        UserDefaults.standard.set(false, forKey: Constants.loginKey)
        let controller = UIAlertController.presentSimpleError(title: "Error occurred", message: error.debugDescription)
        self.present(controller, animated: true)
    }
    
    //MARK: cache authentication
    
    private func saveAuthentication() {
        guard let login = self.rootView.emailTextField.text, let pass = self.rootView.passwordTextField.text else { return }
        UserDefaults.standard.set(true, forKey: Constants.loginKey)
        
        keychainWrapper.mySetObject(login, forKey: kSecAttrAccount)
        keychainWrapper.mySetObject(pass, forKey: kSecValueData)
        keychainWrapper.writeToKeychain()
    }
    
    private func loadAuthentication() -> (login: String, pass: String)?  {
        guard let savedLogin = keychainWrapper.myObject(forKey: kSecAttrAccount) as? String,
              let savedPass = keychainWrapper.myObject(forKey: kSecValueData) as? String
        else { return nil }
        return (login: savedLogin, pass: savedPass)
    }
    
    private func writeAuthentication() {
        let isLoggined = UserDefaults.standard.bool(forKey: Constants.loginKey)
        if isLoggined {
            let tuple = self.loadAuthentication()
            self.rootView.emailTextField.text = tuple?.login
            self.rootView.passwordTextField.text = tuple?.pass
            self.loginButton.isEnabled = true
        }
    }
}
