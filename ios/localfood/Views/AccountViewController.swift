//
//  AccountViewController.swift
//  localfood
//
//  Created by Akira Kozakai on 3/12/22.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.text = MyUser.shared!.name
        displayNameLabel.text = MyUser.shared!.name_display
    }
    
    @IBAction func pushSignout(_ sender: Any) {
        ServerAPI.logout()
        let vc = self.presentingViewController as! FirstViewController
        vc.show(.signin)
    }
}
