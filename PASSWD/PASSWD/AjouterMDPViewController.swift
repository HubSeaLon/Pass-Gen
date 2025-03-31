//
//  AjouterMDPViewController.swift
//  PASSWD
//
//  Created by Elias Baroudi on 31/03/2025.
//

import UIKit

class AjouterMDPViewController: UIViewController {
    
    @IBOutlet weak var application: UITextField!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    var annule = false
    var ajout = false
    
    override func viewDidLoad() {
        annule = false
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation

    
    
    // On transmet toutes les informations via segue.destination
    
    //var c: CoffreViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //c = segue.destination as! CoffreViewController
    }
    
    /*func AjoutMDP(){
        // Lecture du fichier
        if let fileURL = Bundle.main.url(forResource: "passwd", withExtension: "db") {
            do {
                
                // Generation de la ligne à inserer
                
                let text = "\(application.text ?? ""),\(login.text ?? ""),\(mdp.text ?? "")" //just a text
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print(text)
            } catch {
                // Gérer les erreurs de lecture du fichier
                print("Erreur lors de la lecture du fichier: \(error.localizedDescription)")
            }
        } else {
            print("Le fichier n'a pas été trouvé dans le bundle.")
        }
    }*/
    
    func AjoutMDP(){
        // Lecture du fichier
        if let fileURL = Bundle.main.url(forResource: "passwd", withExtension: "db") {
            do {
                let texte = "\(application.text ?? ""),\(login.text ?? ""),\(mdp.text ?? "")" //just a text
                if let data = texte.data(using: .utf8) {
                    do {
                        let fileHandle = try FileHandle(forWritingTo: fileURL)
                        fileHandle.seekToEndOfFile() // Se positionner à la fin du fichier
                        if let data = texte.data(using: .utf8) {
                            fileHandle.write(data) // Écrire les nouvelles données
                        }
                        print("Fichier écrit avec succès à \(fileURL.path)")
                    } catch {
                        print("Erreur lors de l'écriture du fichier : \(error)")
                    }
                }
            } catch {
                // Gérer les erreurs de lecture du fichier
                print("Erreur lors de la lecture du fichier: \(error.localizedDescription)")
            }
        } else {
            print("Le fichier n'a pas été trouvé dans le bundle.")
        }
    }
    
    @IBAction func fermer(_ sender: UIButton) {
        if sender.tag == 0 {AjoutMDP()} // Si on annulé on passe le booléen à false
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
