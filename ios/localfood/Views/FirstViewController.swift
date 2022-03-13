import UIKit

class FirstViewController: UIViewController {
    var viewController: UIViewController? = nil
    var overlapViewController: UIViewController? = nil
    enum Target {
        case signin
        case home
    }
    var target: Target = .signin
    var first = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if first {
            ServerAPI.user(
                resultFunc: { success, message in
                    if success {
                        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //let pushFcmToken = appDelegate.fcmToken ?? ""
                        //ServerAPI.setPushFcmToken(pushFcmToken: pushFcmToken)
                        self.show(.home)
                    } else {
                        self.show(.signin)
                    }
            })
            first = false
        }
    }

    func show(_ target: Target) {
        self.target = target
        var newViewController: UIViewController?
        switch target {
        case .signin:
            newViewController = storyboard!.instantiateViewController(withIdentifier: "SigninSceneViewController")
        case .home:
            newViewController = storyboard!.instantiateViewController(withIdentifier: "MainTabViewController")
        }

        if viewController != nil {
            viewController!.dismiss(animated: true, completion: {
                self.viewController = newViewController
                self.viewController!.modalTransitionStyle = .crossDissolve
                self.present(self.viewController!, animated: true, completion: nil)
            })
        } else {
            viewController = newViewController
            viewController!.modalTransitionStyle = .crossDissolve
            self.present(viewController!, animated: true, completion: nil)
        }
    }
}
