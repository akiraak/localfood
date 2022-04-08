import Foundation
import Alamofire
import SwiftyJSON

class ServerAPI {
    //static let serverUrl = "https://akiraak1.ngrok.io/"
    static let serverUrl = "https://localfood.mspv2.com/"

    static func makeApi(_ api: String) -> String {
        let url = String(format: "%@api/v1/%@", serverUrl, api)
        print("ServerAPI url:", url)
        return url
    }

    static func signup(username: String, password: String, nameDisplay: String, resultFunc: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let parameters = [
            "username": username,
            "password": password,
            "name_display": nameDisplay,
        ]
        let url = makeApi("signup")
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: nil)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["status"] == "ok" {
                    resultFunc(true, nil)
                } else {
                    let message = json["message"].string
                    resultFunc(false, message)
                }
            case .failure(let error):
                resultFunc(false, error.errorDescription)
            }
        }
    }

    static func signin(username: String, password: String, /*pushFcmToken: String,*/ resultFunc: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let parameters = [
            "username": username,
            "password": password,
            //"push_fcm_token": pushFcmToken,
        ]
        let url = makeApi("signin")
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: nil)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            _userResponce(response: response, resultFunc: resultFunc)
        }
    }

    static func logout() {
        let url = makeApi("signout")
        AF.request(url).response { response in
            print(response)
        }
    }

    static func setPushFcmToken(pushFcmToken: String) {
        let parameters = [
            "push_fcm_token": pushFcmToken,
        ]
        let url = makeApi("set_push_fcm_token")
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: nil)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["status"] == "ok" {
                } else {
                    let message = json["message"].string
                    print(message!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    static func user(resultFunc: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let url = makeApi("user")
        AF.request(url)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            _userResponce(response: response, resultFunc: resultFunc)
        }
    }

    static func _userResponce(response: AFDataResponse<Any>, resultFunc: @escaping (_ success: Bool, _ message: String?) -> ()) {
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            if json["status"] == "ok" {
                let user = MyUser.create(json: json["data"])
                if user == nil {
                    resultFunc(false, "Faild creating user data.")
                } else {
                    resultFunc(true, nil)
                }
            } else {
                let message = json["message"].string
                resultFunc(false, message)
            }
        case .failure(let error):
            resultFunc(false, error.errorDescription)
        }
    }

    static func markets(resultFunc: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let url = makeApi("markets")
        AF.request(url)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["status"] == "ok" {
                    Markets.setup(json: json["data"]["markets"])
                    if Markets.shared != nil {
                        resultFunc(true, nil)
                    } else {
                        resultFunc(false, nil)
                    }
                } else {
                    let message = json["message"].string
                    resultFunc(false, message)
                }
            case .failure(let error):
                resultFunc(false, error.errorDescription)
            }
        }
    }
}
