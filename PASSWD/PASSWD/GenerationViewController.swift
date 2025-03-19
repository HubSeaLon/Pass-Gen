//
//  GenerationViewController.swift
//  PASSWD
//
//  Created by Elias Baroudi on 19/03/2025.
//

import UIKit

class GenerationViewController: UIViewController {
    
    @IBOutlet weak var sousVue1: UIView!
    
    @IBOutlet weak var sousVue2: UIView!
    
    @IBOutlet weak var barMdpVue: UIView! // Changer la couleur selon la robustesse du mdp
    
    @IBOutlet weak var mdpVue: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() { // Aryaa SK Coding - YouTube
        sousVue1.layer.cornerRadius = 10
        sousVue1.translatesAutoresizingMaskIntoConstraints = true
        
        sousVue2.layer.cornerRadius = 10
        sousVue2.translatesAutoresizingMaskIntoConstraints = true
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
