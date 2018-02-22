//
//  LoginViewModel.swift
//  RxSwiftLoginView
//
//  Created by Navdeep on 28/9/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import Foundation
import RxSwift

struct LoginViewModel {
    
    var username = Variable<String>("")
    var password = Variable<String>("")
    
    // Computed property to retunr the result of expected validation
    var isValid : Observable <Bool> {
        return Observable.combineLatest(username.asObservable(), password.asObservable()){ usernameString, passwordString in
            usernameString.characters.count >= 4 && passwordString.characters.count >= 4
        }
    }
}
