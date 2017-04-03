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
    @IBOutlet var loginButton: UIButton!
    var rootView: LoginView { return self.getView()! }
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subscribeOnEvents()
    }
    
    //MARK: Private func
    
    fileprivate func subscribeOnEvents() {
        self.loginButtonValidation()
        self.subscribeOnloginButtomTap()
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
            user.map({ AppState.sharedInstance.logginedUser = $0 })
        }, onError: { (error) in
            self.rootView.isLoadingViewVisible = false
            self.errorHandling(error: error as! RxRequstError)
            self.subscribeOnloginButtomTap()
        }).addDisposableTo(disposeBag)
    }
    
    private func errorHandling(error: RxRequstError) {
        let controller = UIAlertController.presentSimpleError(title: "Error occurred", message: error.debugDescription)
        self.present(controller, animated: true)
    }
}
