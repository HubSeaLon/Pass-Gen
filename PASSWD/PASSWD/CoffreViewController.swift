//
//  CoffreViewController.swift
//  PASSWD
//
//  Created by Hubert Geoffray on 30/03/2025.
//

import UIKit
import LocalAuthentication  // Pour utiliser Face ID ou empreinte

class CoffreViewController: UIViewController {

    @IBOutlet var vue: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            verifierBiometrie()
        }
    
    
    func verifierBiometrie() {
        let context = LAContext()
        var error: NSError?

        // ✅ Autorise Face ID, Touch ID ou code de l'appareil
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let raison = "Authentifiez-vous pour accéder à cette section."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: raison) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        // Authentification réussie 🎉
                        self.vue.isHidden = false
                    } else {
                        // ❌ Échec ou annulation → retour
                        self.fermerVueOuRetour()
                    }
                }
            }
        } else {
            // Pas de Face ID / Touch ID / code activé
            fermerVueOuRetour()
        }
    }


    func fermerVueOuRetour() {
        // Option 1 : revenir à un autre onglet
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 0 // Revenir au 1er onglet
        }

        // Option 2 : ou masquer le contenu / afficher un écran bloqué
        // self.view.isHidden = true
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
