import UIKit

class SigninViewController: UIViewController {
    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDismissKeyboard()
    }

    @IBAction func pushSignin(_ sender: Any) {
        if usernameView.text != "" && passwordView.text != "" {
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //let pushFcmToken = appDelegate.fcmToken ?? ""
            ServerAPI.signin(
                username: usernameView.text!.trimmingCharacters(in: .whitespaces),
                password: passwordView.text!.trimmingCharacters(in: .whitespaces),
                //pushFcmToken: pushFcmToken,
                resultFunc: { success, message in
                    if success {
                        let vc = self.presentingViewController as! FirstViewController
                        vc.show(.home)
                    } else {
                        self.showAlert(title: "Failed", message: message)
                    }
            })
        }
    }
}
