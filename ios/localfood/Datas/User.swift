import Foundation
import SwiftyJSON

class User {
    let id: Int
    let name: String
    let name_display: String
    let push_fcm_token: String

    init(
        id: Int,
        name:String,
        name_display:String,
        push_fcm_token: String) {
        self.id = id
        self.name = name
        self.name_display = name_display
        self.push_fcm_token = push_fcm_token
    }

    static func create(json: JSON) -> User? {
        print(json["id"])
        print(json["name_display"])
        if json["id"].exists() {
            return User(
                id: json["id"].int!,
                name: json["name"].string!,
                name_display: json["name_display"].string!,
                push_fcm_token: json["push_fcm_token"].string!)
        } else {
            return nil
        }
    }

}

class MyUser {
    static var shared: User?
    static func create(json: JSON) -> User? {
        shared = User.create(json: json)
        return shared
    }
    static func clean() {
        shared = nil
    }
}
