//
//  DictionnaireViewController.swift
//  PASSWD
//
//  Created by Hubert Geoffray on 02/04/2025.
//

import UIKit

class DictionnaireViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Bouton qui ouvre le navigateur sur Have I Been Pwned
    @IBAction func bouton(_ sender: Any) {
        if let url = URL(string: "https://haveibeenpwned.com/Passwords") {
            UIApplication.shared.open(url)
        } else { print("URL introuvable")}
    }
}
