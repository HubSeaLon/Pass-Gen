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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bouton(_ sender: Any) {
        if let url = URL(string: "https://haveibeenpwned.com/Passwords") {
            UIApplication.shared.open(url)
        } else { print("URL introuvable")}
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
