// Kevin Li - 4:07 PM - 2/29/20

import Foundation

protocol LoginService {
    var isUserLoggedIn: Bool { get }
    func logIn(completion: @escaping (_ loggedIn: Bool) -> ())
    func logOut()
}

struct MockSuccessLoginService: LoginService {
    var isUserLoggedIn: Bool = false

    func logIn(completion: @escaping (Bool) -> ()) {
        completion(true)
    }

    func logOut() { }
}

struct MockFailureLoginService: LoginService {
    var isUserLoggedIn: Bool = false

    func logIn(completion: @escaping (Bool) -> ()) {
        completion(false)
    }

    func logOut() { }
}
