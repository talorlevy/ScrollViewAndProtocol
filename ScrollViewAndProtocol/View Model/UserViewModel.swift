//
//  UserViewModel.swift
//  ScrollViewAndProtocol
//
//  Created by Talor Levy on 2/21/23.
//

import Foundation

class UserViewModel {
    
    static let shared = UserViewModel()
    private init() {}
    
    var user: UserModel?
    
}
