import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var nameDisplayView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDismissKeyboard()
    }

    @IBAction func pushSignup(_ sender: Any) {
        if usernameView.text != "" && passwordView.text != "" {
            ServerAPI.signup(
                username: usernameView.text!.trimmingCharacters(in: .whitespaces),
                password: passwordView.text!.trimmingCharacters(in: .whitespaces),
                nameDisplay: nameDisplayView.text!.trimmingCharacters(in: .whitespaces),
                resultFunc: { success, message in
                    if success {
                        let alertController = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.showAlert(title: "Failed", message: message)
                    }
            })
        }
    }
}
