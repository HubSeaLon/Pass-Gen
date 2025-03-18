# Générateur et gestionnaire de mot de passe

## Idée de noms 
- MyPass
- SafePass
- passwd

## Inspirations 
- PSWD (IOS App Store)
- https://www.motdepasse.xyz


## Principales fonctionnalités 
- 2 parties : générateur de mot de passe et le gestionnaire de mot de passe

### Générateur de mot de passe 

**Générateur de mots de passe aléatoires personnalisés :**
- nombre de mdp générés
- longueur des mdp
Choix de :
- Sépérateur : {-,;,|,+,.,!,?,/,*,_}
- Espacement : Longueur_mdp - 1 (exemple : longueur 10, espacement 2 : eZ-1p-?p-7)
- Lettre majuscule : Oui ou non 
- Lettre minuscule : Oui ou non
- Chiffres : Oui ou non
- Symboles : Oui ou non et choix de d'exclure des symboles

- API pour voir si un mot de passe apparait dans une fuite de données : Have I been pwned ?
Ou si on veut pas payer, on redirige l'utilisateur avec un lien sur la page.

- Indicateur de sécurité pour le mot de passe généré

**Plus complexe** :
- Rajouter le choix du nombre minimum du caractères ou le nombre exact pour lettre majuscule/minuscule, chiffre et symboles.
- enregistrer des configurations de génération mdp

**Générateur de mots de passe phonétiques :**
- Donner le choix à l'utilisateur d'écrire une phrase, mots, ou n'importe et de les transformer en phonétique pour que le mdp soit plus facile à retenir.
- Exemple : "J'aime les chiens" -> "j/@iMé-Lè5-çH|En5". Idées : créer plusieurs dictionnaire pour chaque lettre pouvant être remplacés par un autre caractères.


## Gestionnaire de mot de passe
- Pour accéder au gestionnaire il faudra utiliser la biométrie ou un mdp fort
- Pour l'instant, stocker en local les mdp
- Chiffrer le stockage des mdp
- Utiliser la biométrie ou un mdp pour afficher en clair
- Indicateur de sécurité pour un mot de passe stocké et entré dans le gestionnaire

**Pous complexe**
- Remplissage automatique des mots de passe sur sites web et applications

## Notes 

Pour le temps qu'on a je trouve que juste garder la partie générateur de mot de passe me parait très bien. On a déjà plusieurs fonctionnalités dans cette partie. 

Sinon si on garde le générateur et le gestionnaire, chacun pour faire de son côté.



