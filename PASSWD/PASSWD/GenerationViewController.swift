//
//  GenerationViewController.swift
//  PASSWD
//
//  Created by Elias Baroudi on 19/03/2025.
//

import UIKit

// UITextFieldDelegate pour pouvoir enlever le clavier
class GenerationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    // Phonétique
    @IBOutlet weak var textPhonetique: UITextField!
    
    let charPhonetique: [Character: [String]] = [
        "a": ["a", "à", "â", "ä", "A", "À", "Â", "Ä", "4", "@"],
        "b": ["b", "B", "8", "ß"],
        "c": ["c", "ç", "C", "Ç", "<", "("],
        "d": ["d", "D"],
        "e": ["e", "é", "è", "ê", "ë", "E", "É", "È", "Ê", "Ë", "3"],
        "f": ["f", "F", "ph", "PH"],
        "g": ["g", "G", "9", "6"],
        "h": ["h", "H", "#"],
        "i": ["i", "î", "ï", "I", "Î", "Ï", "1", "!", "|"],
        "j": ["j", "J"],
        "k": ["k", "K", "c", "C", "q", "Q"],
        "l": ["l", "L", "1", "|", "!", "£"],
        "m": ["m", "M"],
        "n": ["n", "N", "ñ", "Ñ"],
        "o": ["o", "ô", "ö", "O", "Ô", "Ö", "0"],
        "p": ["p", "P", "¶"],
        "q": ["q", "Q", "9"],
        "r": ["r", "R", "®"],
        "s": ["s", "S", "$", "5"],
        "t": ["t", "T", "7", "+"],
        "u": ["u", "ù", "û", "ü", "U", "Ù", "Û", "Ü"],
        "v": ["v", "V", "\\/"],
        "w": ["w", "W", "\\/\\/", "vv", "VV"],
        "x": ["x", "X", "%", "×"],
        "y": ["y", "Y", "¥"],
        "z": ["z", "Z", "2"],
        " ": ["_", "-"]
    ]
    
    
    @IBAction func generateurPhonetique(_ sender: UITextField) {
        
        // Génération MDP
        var resultat = ""
        
        // Gérer la casse
        let texte = sender.text?.lowercased() ?? ""
    
        // On remplace aléatoirement chaque lettre de l'alphabet ou l'espace par un caractères du dictionnaire.
        for char in texte {
            if let lettre = charPhonetique[char] {
                resultat += lettre.randomElement().map { String($0) } ?? "?"
            } else {
                resultat += String(char)
            }
        }
        textMotdepasse.text = resultat
        
        
        // Complexite
        if textMotdepasse.text == "" {
            initialisationVueMdp()
            return
        }
        
        complexiteMdp(resultat)
    }
    
 
    func refreshPhonetique() {
        let texte = textPhonetique.text?.lowercased() ?? ""
        
        var resultat = ""
        
        for char in texte {
            if let lettre = charPhonetique[char] {
                resultat += lettre.randomElement().map { String($0) } ?? "?"
            } else {
                resultat += String(char)
            }
        }
        textMotdepasse.text = resultat
    }
    
    
    
    // Générateur MDP
    
    // Données et initialisation des PickerView
    @IBOutlet weak var pickerLongueur: UIPickerView!
    @IBOutlet weak var pickerSeparateur: UIPickerView!
    @IBOutlet weak var pickerEspacement: UIPickerView!
    
    let nombreLongueur = Array(1...256)
    let typeSeparateur: [Character] = Array("-|!?/*")

    var longueurSelectionnee: Int = 1
    var nombreEspacement: [Int] = []
    var separateurSelectionnee: String = "-"
    var espacementSelectionnee: Int = 1
    
    // Initilisations des données
    let majuscules: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let minuscules: [Character] = Array("abcdefghijklmnopqrstuvwxyz")
    let chiffres = Array("0123456789")
    let symboles = Array("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~") // 33 symboles ASCII
    
    // Switchs
    @IBOutlet weak var switchSeparateur: UISwitch!
    @IBOutlet weak var switchPhonetique: UISwitch!
    
    @IBOutlet weak var switchMajuscule: UISwitch!
    @IBOutlet weak var switchMinuscule: UISwitch!
    @IBOutlet weak var switchChiffre: UISwitch!
    @IBOutlet weak var switchSymbole: UISwitch!
    
    // Boutons
    @IBAction func refresh(_ sender: Any) {
        if switchPhonetique.isOn {
            refreshPhonetique()
        } else {
            genererMotDePasse()
        }
        
    }
    
    
    // UI
    @IBOutlet weak var sousVue1: UIView!
    @IBOutlet weak var sousVue2: UIView!
    @IBOutlet weak var sousVue3: UIView!
    
 
    
    // Complexité du mdp en nombre
    @IBOutlet weak var complexiteMdp: UILabel!
    @IBOutlet weak var barComplexite: UIProgressView!
    @IBOutlet weak var motComplexite: UILabel!
    @IBOutlet weak var textMotdepasse: UITextView!
    
    
    func initialisationVueMdp() {
        complexiteMdp.text = "0 bits"
        barComplexite.progress = 0.0
        motComplexite.text = "Néant"
        textMotdepasse.text = ""
    }
    
    
    // return pour retirer le clavier (GPT)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Ferme le clavier
        return true
    }
    
    // Taper en dehors pour retirer le clavier (GPT)
    @objc func cacherClavier() {
        view.endEditing(true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pouvoir retirer le clavier (GPT)
        textPhonetique.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(cacherClavier))
        view.addGestureRecognizer(tap)


        // UI etat de base
        pickerSeparateur.isHidden = true
        pickerEspacement.isHidden = true
        
        // PickerView
        // Assigner les pickerView au delegate et dataSource

        let pickers: [UIPickerView] = [pickerLongueur, pickerSeparateur, pickerEspacement]
        
        // Activer l'interaction et l'affichage des picker
        for picker in pickers {
            picker.delegate = self
            picker.dataSource = self
        }
        
        
        // Switch
        // Etat actuel
        switchSeparateur.isOn = false
        updateUISwitchSeparateur(isSwitchOn: false)

        switchPhonetique.isOn = false
        updateUISwitchPhonetique(isSwitchOn: false)

        initialisationVueMdp()
        
        textPhonetique.autocorrectionType = .no
        textPhonetique.spellCheckingType = .no
    }
    
    
    override func viewDidLayoutSubviews() { // Aryaa SK Coding - YouTube
        sousVue1.layer.cornerRadius = 10
        sousVue1.translatesAutoresizingMaskIntoConstraints = true
        
        sousVue2.layer.cornerRadius = 10
        sousVue2.translatesAutoresizingMaskIntoConstraints = true
        
        textMotdepasse.layer.borderWidth = 1.0
        textMotdepasse.layer.borderColor = UIColor.gray.cgColor
        textMotdepasse.layer.cornerRadius = 10
        
    }
    

    // Switch
    // Fonction appelée quand l'utilisateur change l'état du switch
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        switch sender {
            case switchSeparateur:
                updateUISwitchSeparateur(isSwitchOn: sender.isOn)
                
            case switchPhonetique:
                updateUISwitchPhonetique(isSwitchOn: sender.isOn)
                
                if sender.isOn {
                    initialisationVueMdp()
                } else {
                    genererMotDePasse()
                }
            
            default:
                genererMotDePasse()
        }
    }
    
    
    // MAJ des éléments si le switchSeparateur est activé
    func updateUISwitchSeparateur(isSwitchOn: Bool){
    
        pickerEspacement.isHidden = !isSwitchOn
        pickerSeparateur.isHidden = !isSwitchOn
        if isSwitchOn {
            pickerEspacement.reloadAllComponents()
            print("Séparateur choisi : \(separateurSelectionnee)")
            print("nombre espacement choisi : \(espacementSelectionnee)")
        }
        genererMotDePasse()
    }
    
    
    
    // Change le visuel quand le phonétique est activé
    func updateUISwitchPhonetique(isSwitchOn: Bool) {
        
        // Change l'opacité pour montrer la désactivation
        sousVue1.alpha = isSwitchOn ? 0.5 : 1.0
        sousVue2.alpha = isSwitchOn ? 0.5 : 1.0
        
        // Désactive l'interaction si activé
        sousVue1.isUserInteractionEnabled = !isSwitchOn
        sousVue2.isUserInteractionEnabled = !isSwitchOn
        
        textPhonetique.isEnabled = isSwitchOn ? true : false
        textPhonetique.text = ""
    }
    
    
    // Picker View
    
    // Nombre de colonnes
    func numberOfComponents(in pickerLongueur: UIPickerView) -> Int {
        return 1 // 1 seule colonne par picker
    }
    
    // Nombre de ligne selon le picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerLongueur {
            return nombreLongueur.count
            
        } else if pickerView == pickerSeparateur {
            return typeSeparateur.count
        } else if pickerView == pickerEspacement {
            
            // print("pickerEspacement a \(nombreEspacement.count) lignes disponibles")
        
            return pickerView == pickerEspacement ? nombreEspacement.count : 0
        }
        return 0
    }
    
    
    // Affichage des valeurs dans picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerLongueur {
            return "\(nombreLongueur[row])"
        } else if pickerView == pickerSeparateur {
            return String(typeSeparateur[row])
        } else if pickerView == pickerEspacement {
            // print("Affichage pickerEspacement : \(nombreEspacement[row])")
            return "\(nombreEspacement[row])"
        }
        return nil
    }
    
    // Action quand un élément est sélectionné
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerLongueur {
            longueurSelectionnee = nombreLongueur[row]
            if Int(longueurSelectionnee) < 10 {
                pickerSeparateur.isHidden = true
                switchSeparateur.isHidden = true
                switchSeparateur.isHidden = true
                updateUISwitchSeparateur(isSwitchOn: false)
                switchSeparateur.isOn = false
            } else {
                switchSeparateur.isHidden = false
                majEspacement(longueur: longueurSelectionnee)
            }
            
            print("Longueur sélectionnée : \(longueurSelectionnee)")
            
        } else if pickerView == pickerSeparateur {
            separateurSelectionnee = String(typeSeparateur[row])
            print("Sépérateur choisi : \(separateurSelectionnee)")
            
        } else if pickerView == pickerEspacement {
            espacementSelectionnee = nombreEspacement[row]
            print("Nombre séparateur choisi : \(espacementSelectionnee)")
        }
        genererMotDePasse()
    }
    
    // Fonction pour rafraichir dynamiquement le pickerViewEspacement selon la longueur
    func majEspacement(longueur: Int) {
           let nouvelEspacement = Array(1..<longueur)

           if nouvelEspacement == nombreEspacement {
               print("Pas de changement dans    nombreEspacement, pas de reload.")
               return
           }

           nombreEspacement = nouvelEspacement.isEmpty ? [1] : nouvelEspacement
           print("Nouveau espacement : \(nombreEspacement)")

           pickerEspacement.reloadAllComponents()
           pickerEspacement.setNeedsLayout()
    }
    
    // Générateur mot de passe
    
    func genererMotDePasse() {
        var caracteres = [Character]() // Initialisation
        var obligatoires = [Character]() // Initialisation des caractères obligatoires pour garantir l'option cochée
        
        if switchSymbole.isOn {
            caracteres += symboles
            obligatoires.append(symboles.randomElement()!)
        }
        if switchMajuscule.isOn {
            caracteres += majuscules
            obligatoires.append(majuscules.randomElement()!)
        }
        if switchChiffre.isOn {
            caracteres += chiffres
            obligatoires.append(chiffres.randomElement()!)
        }
        if switchMinuscule.isOn {
            caracteres += minuscules
            obligatoires.append(minuscules.randomElement()!)
        }

        // Vérifier si au moins une catégorie est sélectionnée
        guard !caracteres.isEmpty else {
            textMotdepasse.text = "Sélectionnez au moins une option !"

            complexiteMdp.text = "0 bits"
            motComplexite.text = "Néant"
            motComplexite.textColor = UIColor.black
            barComplexite.progress = 0.0
            return
        }
        
        caracteres.shuffle() // Uniformiser le tableau
    
        let espacement = espacementSelectionnee

        /* Calcul du nombre de caractères réels (en respectant la position des séparateurs)
        
         nbCaracteresReels = longueur * (espacement/espacement+1)
         espacement/espacement+1 = proportion de groupe dans le mot de passe
         
         exemple : longueur 10, espacement 1 : x-x-x-x-x-
         
         10 * (1/2) = 10 * 0.5 = 5 caractères réels
        */
        
        var nbCaracteresReels: Int
        
        if switchSeparateur.isOn {
            nbCaracteresReels = Int((Double(longueurSelectionnee) * Double(espacement) / Double(espacement + 1)).rounded())
        } else {
            nbCaracteresReels = longueurSelectionnee
        }

        guard nbCaracteresReels >= obligatoires.count else {
            textMotdepasse.text = "Longueur trop courte pour inclure chaque type"
            return
        }

        // Construire le mot de passe brut (sans séparateurs)
        var motSansSeparateur = obligatoires
        while motSansSeparateur.count < nbCaracteresReels {
            motSansSeparateur.append(caracteres.randomElement()!)
        }

        motSansSeparateur.shuffle()
        
        // mdp final en ajoutant séparateur si il y en a
        var motFinal = ""
        
        // .enumerated permet d'avoir l'index et le caractère
        for (index, char) in motSansSeparateur.enumerated() {
            motFinal.append(char)
            
            if switchSeparateur.isOn,
               (index + 1) % espacement == 0,
               motFinal.count < longueurSelectionnee {
                motFinal.append(separateurSelectionnee)
            }
        }
        
       
        // Cas ou le mot final est < a la longueur donc on rajoute un caractère. Exemple : Longueur 14 et espacement 7, le mot final sera - 1 la longueur
        
        if motFinal.count < longueurSelectionnee { motFinal.append(caracteres.randomElement()!)}
        
        print("Longueur mot final : \(motFinal.count)")
        print("Longueur choisi : \(longueurSelectionnee)")

        textMotdepasse.text = motFinal
        complexiteMdp(motFinal)
    }
    
    
    
    /* Complexité d'un mot de passe : E = L * log2(B)
     
    E : Entreprie en bits
    L : longueur mot de passe (nombre de caractères)
    B : nombre de caractères différents qu'ils peuvent prendre
     
    Cas ou on rajoute les séparateurs la formule deviendrait (raisonement GPT):
     
    E = L * log2(B) + log2(k) + log2(C(L-1,k))
    ou k est nombre de séparateurs
    C(L-1,k)) : coefficient binomial du nombre de façon de choisir ou placer le séparateur
    
     
     */
    
    func complexiteMdp (_ mdp: String) {
        var E: Double = 0.0
        var arrondiE: Double = 0.0
        let k = 6 // 6 pour le nombre de sépérateur

        var base = 0
        let tabInput: [Character] = Array(mdp)
        let longueur = Double(tabInput.count)
        var maj = false
        var min = false
        var num = false
        var sym = false
        var autres = false // Autres caractères non-ASCII
        
        for char in tabInput {
            if let ascii = char.asciiValue {
                if !maj && ascii >= 65 && ascii <= 90 {
                    maj = true
                } else if !min && ascii >= 97 && ascii <= 122 {
                    min = true
                } else if !num && ascii >= 48 && ascii <= 57 {
                    num = true
                } else if !sym && (
                    (ascii >= 33 && ascii <= 47) ||
                    (ascii >= 58 && ascii <= 64) ||
                    (ascii >= 91 && ascii <= 96) ||
                    (ascii >= 123 && ascii <= 126)
                ) {
                    sym = true
                }
            } else { autres = true}
        }
        
        if maj { base += 26 }
        if min { base += 26 }
        if num { base += 10 }
        if sym { base += 33 }
        if autres { base += 150 }
        
        if switchSeparateur.isOn {
            var coefBinomial: Double = 1.0
            
            for i in 0..<k { // 6 pour le nombre de séparateur
                coefBinomial *= (Double(longueur-1) - Double(i))
                coefBinomial /= (Double(i) + 1)
            }
            
            E = Double(longueur) * log2(Double(base)) + log2(Double(k)) + log2(coefBinomial)
        } else {
            E = Double(longueur) * log2(Double(base))
        }
        
        
        
        arrondiE = round(100*E)/100
        complexiteMdp.text = String(arrondiE) + " bits"
        
        // Vérifie si arrondiE peut etre infini ou NaN
        guard arrondiE.isFinite, !arrondiE.isNaN else {
            print("Erreur : valeur non convertible en Int (\(arrondiE))")
            return
        }
        
        switch Int(arrondiE) {
        case (0...27):
            motComplexite.textColor = UIColor(ciColor: CIColor(red: 220/225, green: 20/255, blue: 60/255, alpha: 1))
            barComplexite.progressTintColor = UIColor.red // Couleur de la progressBar
            motComplexite.text = "Très faible ⚠️"
        case (28...35):
            motComplexite.textColor = UIColor(ciColor: CIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1))
            motComplexite.text = "Faible ⚠️"
        case (36...59):
            motComplexite.textColor = UIColor(ciColor: CIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1))
            barComplexite.progressTintColor = UIColor.orange
            motComplexite.text = "Moyen ⚠️"
        case (60...128):
            motComplexite.text = "Fort ☑️"
            barComplexite.progressTintColor = UIColor.green
            motComplexite.textColor = UIColor(ciColor: CIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1))
        case (127...):
            motComplexite.textColor = UIColor(ciColor: CIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1))
            barComplexite.progressTintColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
            motComplexite.text = "Très fort ✅"
        default:
            barComplexite.progressTintColor = UIColor.black
            motComplexite.text = "Erreur"
        }
        
        
        // Bar complexité
        
        let i: Int = Int(arrondiE)
        let max: Int = 128
        
        if i <= max {
            let ratio = Float(i) / Float(max)
            barComplexite.progress = ratio
        } else {
            barComplexite.progress = 1.0
        }
        
    }
    
    
    @IBAction func copierMdp(_ sender: UIButton) {
        guard let motDePasse = textMotdepasse.text, !motDePasse.isEmpty else { return }
            if motDePasse == "Sélectionnez au moins une option !" || motDePasse == "Longueur trop courte pour inclure chaque type" {
                return
            }
            UIPasteboard.general.string = motDePasse
            afficherToast(message: "Mot de passe copié !")
    }
    
    
    // appel à ChatGPT qui nous a généré un message pop up Toast
    func afficherToast(message: String, duree: Double = 2.0) {
        // Dimension du toast
        let toastWidth: CGFloat = 200
        let toastHeight: CGFloat = 30
        
        // Position horizontale centrée
        let toastX = self.view.frame.size.width / 2 - toastWidth / 2
        
        // Position vertiale ajustée à 242 pixels du bas de l'écran
        let toastY = self.view.frame.size.height - 242

        // Création d'un label pour le toast
        let toastLabel = UILabel(frame: CGRect(x: toastX, y: toastY, width: toastWidth, height: toastHeight))
        
        
        // Caractéristiques du label
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7) // couleur fond noir avec opacité de 0.7
        toastLabel.textColor = UIColor.white  // Couleur texte blanc
        toastLabel.textAlignment = .center // Centrage
        toastLabel.font = UIFont.systemFont(ofSize: 14.0) // Taille police 14
        toastLabel.text = message  // Texte affiché
        toastLabel.alpha = 0.0  // Texte invisible au départ car animation ensuite
        toastLabel.layer.cornerRadius = 10  // Bord arrondi
        toastLabel.clipsToBounds = true  // S'assurer que le texte reste dans les bords

        self.view.addSubview(toastLabel) // Ajouter au 1er plan le Toast

            
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0   // animation qui fait apparaitre progressivement le Toast
        }) { _ in
            // Temps de l'affichage du Toast (0.5 secondes)
            UIView.animate(withDuration: 0.5, delay: duree, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                // Fais disparaitre le label une fois l'animation terminée
                toastLabel.removeFromSuperview()
            }
        }
    }

}
