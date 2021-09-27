//
//  LoginViewModel.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/09/27.
//

import Foundation
import RxSwift

class LoginViewModel {
    let emailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(emailTextPublishSubject.asObservable(), passwordTextPublishSubject.asObservable())
            .map { email, password in
                return email.isValidEmail() && password.removeWhitespaces.count >= 6
            }
    }
}
