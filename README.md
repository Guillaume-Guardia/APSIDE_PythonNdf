# Manuel de l'application NDF Python

[![CI](https://github.com/Guillaume-Guardia/APSIDE_PythonNdf/actions/workflows/ci.yml/badge.svg)](https://github.com/Guillaume-Guardia/APSIDE_PythonNdf/actions/workflows/ci.yml)

## Sommaire

**[Installation](#installation)**  
**[Clé de l'API Google](#cle_api)**  
**[Génération de ndf.exe](#generation_exe)**  
**[Lancement de l'application](#lancement_app)**  
**[Lancement de l'algorithme](#lancement_algo)**  
**[Visualisation des résultats](#resultats)**  
**[Bonus](#bonus)**

## Installation <a id="installation"></a>

1. [Télécharger Python 3.14](https://www.python.org/downloads/release/python-3148/) (ou une version plus récente). Pour vérifier l'installation : `python --version`.
    <!-- ![Vérification de l'installation de python](data/images/check_python.png) -->

2. [Télécharger Git](https://git-scm.com/downloads). Pour vérifier l'installation : `git --version`.
    <!-- ![Vérification de l'installation de git](data/images/check_git.png) -->

3. Récupérer le dépôt Git depuis GitHub avec la commande `git clone https://github.com/Guillaume-Guardia/APSIDE_PythonNdf`, puis se placer à la racine du dépôt avec la commande `cd APSIDE_PythonNdf`.
    <!-- ![Création d'un environnement virtuel](data/images/gitclone.png)-->

4. Créer l'environnement virtuel *.venv* à la racine du dépôt (il est ignoré par Git) et installer les dépendances avec la commande `dev.bat install`.
    <!-- ![Création d'un environnement virtuel](data/images/dependance1.png) -->
    <!-- ![Création d'un environnement virtuel](data/images/dependance2.png) -->

5. Configurer la clé de l'API Google dans la variable d'environnement `GOOGLE_API_KEY` (voir [Clé de l'API Google](#cle_api)).

6. Facultatif : générer le fichier *ndf.exe* avec la commande `dev.bat exe` (voir [Génération de ndf.exe](#generation_exe)).

7. Créer un raccourci vers le fichier *ndf.exe* (ou *ndf.bat*) sur le bureau.
    <!-- ![Création d'un environnement virtuel](data/images/create_shortcut.png) -->

### Commandes de développement

Le script *dev.bat*, à la racine du dépôt, regroupe les commandes utiles (la CI utilise les mêmes) :
* `dev.bat install` : crée l'environnement virtuel *.venv* s'il n'existe pas et installe les dépendances (application et développement).
* `dev.bat test` : vérifie les dépendances et lance les tests. Les tests qui appellent l'API Google ne sont lancés que si la variable d'environnement `GOOGLE_API_KEY` est définie. Les tests utilisent une base de données temporaire : la base de l'application (*src/pyndf/db/pydb.db*) n'est pas modifiée.
* `dev.bat run` : lance l'application.
* `dev.bat exe` : génère le fichier *ndf.exe* à partir de *ndf.bat*.
* `dev.bat` : installe les dépendances, puis lance les tests.

## Clé de l'API Google <a id="cle_api"></a>

L'application calcule les distances avec l'API Google Distance Matrix, qui nécessite une clé. **La clé n'est jamais stockée dans le dépôt Git**, car celui-ci est public : elle est lue dans la variable d'environnement `GOOGLE_API_KEY`.

### Obtenir une clé

1. Se connecter à la [console Google Cloud](https://console.cloud.google.com/apis/credentials) et sélectionner le projet dans lequel l'API *Distance Matrix* est activée. Cette API est désormais « legacy » : elle ne peut plus être activée dans un nouveau projet, il faut donc réutiliser le projet existant.
2. Cliquer sur *Créer des identifiants* > *Clé API*.
3. Restreindre la clé : dans *Restrictions relatives aux API*, n'autoriser que l'API *Distance Matrix*. Cela limite les dégâts en cas de fuite de la clé.

Si une clé a été publiée par erreur (commit, capture d'écran, message…), il faut la supprimer dans la console Google Cloud et en créer une nouvelle : la retirer du code ne suffit pas, car elle reste dans l'historique Git.

### Configurer la clé

* Sur le poste : lancer une seule fois la commande `setx GOOGLE_API_KEY "la_cle"`. La variable est enregistrée pour l'utilisateur Windows, mais seuls les terminaux et programmes ouverts **après** la commande la voient : il faut donc relancer le terminal et l'application.
* Pour la CI GitHub : ajouter un secret `GOOGLE_API_KEY` dans *Settings* > *Secrets and variables* > *Actions* du dépôt. Sans ce secret, les tests qui appellent l'API Google sont ignorés.

Sans clé (ou avec une clé au mauvais format), l'application démarre normalement, mais les distances qui ne sont ni dans le cache ni dans la base de données ne peuvent pas être calculées : elles apparaissent avec le statut rouge *NO_API_KEY* dans l'onglet *Analyse de l'API Google*. Une clé au bon format mais refusée par Google (clé révoquée, API non autorisée…) donne le statut *REQUEST_DENIED*.

## Génération de ndf.exe <a id="generation_exe"></a>

Le fichier *ndf.exe* n'est pas versionné dans Git : il est généré à partir de *ndf.bat* avec l'outil [Bat To Exe Converter](https://www.f2ko.de/en/b2e.php).

1. Installer Bat To Exe Converter (emplacement par défaut : `C:\Program Files\Bat To Exe Converter`). S'il est installé ailleurs, définir la variable d'environnement `B2E` avec le chemin de *Bat_To_Exe_Converter.exe*.
2. Lancer la commande `dev.bat exe` à la racine du dépôt. Le fichier *ndf.exe* est créé (ou remplacé) à côté de *ndf.bat*, avec l'icône *data/icons/pyndf.ico*.

À savoir :
* Il faut régénérer *ndf.exe* après chaque modification de *ndf.bat*, car l'exécutable contient une copie du script.
* *ndf.exe* doit rester à la racine du dépôt, car il utilise le dossier *.venv* et le dossier *src* situés à côté de lui. Pour le lancer depuis le bureau, il faut créer un raccourci plutôt que de le déplacer.
* Les lignes commençant par `::` en haut de *ndf.bat* sont des commentaires ajoutés par Bat To Exe Converter (ses réglages encodés). Elles ne sont pas exécutées et peuvent être conservées.
* Depuis Git Bash, la ligne de commande de Bat To Exe Converter échoue (« Incorrect command line »), car Git Bash transforme les options `/bat`, `/exe`, etc. en chemins. Il faut utiliser `dev.bat exe` depuis cmd ou PowerShell.

## Lancement de l'application <a id="lancement_app"></a>

Il existe plusieurs manières de démarrer l'application :
* Par la ligne de commande `python src/pyndf/main.py [-h] [--log {notset,debug,info,warn,error,critical}] [-e EXCEL] [-c CSV] [-o OUTPUT] [-l LANGUAGE]`, à la racine du dépôt Git. Il faut d'abord activer l'environnement virtuel avec la commande `.venv\Scripts\activate`, à la racine du dépôt Git.

  Arguments facultatifs :
  + `-h`, `--help` : affiche la liste des options.
  + `--log {notset,debug,info,warn,error,critical}` : niveau des logs affichés.
  + `-e EXCEL`, `--excel EXCEL` : fichier Excel à utiliser.
  + `-c CSV`, `--csv CSV` : fichier CSV à utiliser.
  + `-o OUTPUT`, `--output OUTPUT` : répertoire de sauvegarde.
  + `-l LANGUAGE`, `--language LANGUAGE` : langue de l'application (`en` ou `fr`).
* Par la commande `dev.bat run`, à la racine du dépôt Git.
* En double-cliquant sur le fichier *ndf.bat*. Les arguments de la ligne de commande ci-dessus sont aussi acceptés, par exemple : `ndf.bat -l en`.
* En double-cliquant sur le fichier *ndf.exe* (après l'avoir généré).
* En double-cliquant sur un raccourci vers le fichier *ndf.bat* ou *ndf.exe*.

Toutes ces méthodes ouvrent la fenêtre de l'application, prête à être utilisée.

  <!-- ![Création d'un environnement virtuel](data/images/patron.png) -->

## Lancement de l'algorithme <a id="lancement_algo"></a>

Pour lancer l'algorithme depuis l'interface graphique, il suffit de cliquer sur le bouton de génération des fichiers PDF, au centre de l'onglet *Processus*. Il faut bien entendu avoir renseigné au préalable les paramètres suivants :
* le fichier EXCEL (dont l'extension correspond à l'un des motifs `*.xl*` ou `*.XLS`) ;
* le fichier CSV issu de la base de données ;
* le répertoire de sauvegarde.

Si toutes les conditions sont réunies, on peut cliquer sur le bouton pour démarrer l'algorithme. La barre de statut d'exécution apparaît alors : un message, un bouton *Annuler* qui arrête l'exécution de l'algorithme, et une barre de progression.

### 1re étape : lecture du fichier EXCEL

L'algorithme passe en revue chaque ligne non vide du fichier EXCEL renseigné. Chaque ligne dont le libellé correspond à l'expression régulière `.*DEPLACEMENT.*` est sélectionnée.

*Astuce : avant de démarrer l'algorithme, l'onglet de visualisation du fichier EXCEL affiche en bleu les lignes qui seront sélectionnées.*

### 2e étape : lecture du fichier CSV

Comme pour le fichier EXCEL, l'algorithme détermine les lignes de données à sélectionner, c'est-à-dire les lignes qui contiennent au moins une indemnité non nulle.

*Astuce : comme pour le fichier EXCEL, on peut visualiser, avant le démarrage du processus, les lignes qui seront sélectionnées.*

### 3e étape : calcul de la distance entre l'adresse du client et l'adresse de l'intervenant

Cette étape récupère la distance que parcourt l'intervenant pour se rendre au travail. Les mesures s'appuient sur l'API Google Distance Matrix.

### 4e étape : création des fichiers PDF

Pour chaque matricule présent dans les fichiers CSV et EXCEL, le programme crée une note de frais avec toutes les informations récupérées précédemment :
* pour le fichier EXCEL, toutes les missions effectuées par l'intervenant au cours du mois. L'algorithme calcule automatiquement la distance parcourue sur le mois ;
* pour le fichier CSV, un simple report de toutes les indemnités non nulles.

Les fichiers PDF sont enregistrés dans le répertoire de sauvegarde indiqué par l'utilisateur.

## Visualisation des résultats <a id="resultats"></a>

Pour vérifier les résultats de l'algorithme, il faut se rendre dans l'onglet *Analyse Globale*. Pour chaque étape, un statut est indiqué :
* une pastille verte si tout s'est passé comme prévu ;
* une pastille rouge si un problème a été remonté.

Pour plus de simplicité, la ligne du total (la dernière) résume l'ensemble de l'algorithme.

### Distance

Toutes les requêtes de distance sont consultables dans l'onglet *Analyse de l'API Google*.

### Fichiers PDF

L'onglet *Analyse des fichiers PDF* permet de vérifier d'un simple coup d'œil, pour un matricule donné :
* le fichier PDF (accessible via le bouton prévu à cet effet) ;
* le nombre de missions (nombre de lignes sélectionnées dans le fichier EXCEL, plus la ligne de l'agence d'origine si elle n'existe pas déjà) ;
* le nombre d'indemnités (nombre d'indemnités non nulles trouvées dans le fichier CSV) ;
* le statut (rouge ou vert).

Si le statut est une pastille rouge, un bouton de régénération individuelle apparaît dans la dernière colonne. Il relance l'algorithme pour ce matricule.

## Bonus <a id="bonus"></a>

L'application propose d'autres fonctionnalités, liées à son développement. Elles sont « cachées » et peuvent être activées avec l'option *Mode développeur*.
On peut alors activer ou désactiver facilement les fonctionnalités suivantes :
* *Sauvegarder les fichiers temporaires* : après avoir modifié le fichier EXCEL ou CSV dans les onglets correspondants, on peut enregistrer le tableau dans un fichier portant le même nom. Attention, l'extension ne sera pas forcément la même.
* *Utiliser le multithreading* : deux méthodes ont été implémentées pour la création des fichiers PDF :
  + les fichiers sont créés les uns après les autres (un seul thread) ;
  + les fichiers sont créés en parallèle, avec au maximum 20 threads simultanés (multithread).

  La deuxième méthode est recommandée, car elle est environ 25 % plus rapide que la première.
* *Écraser PDF* : lors de la création des fichiers PDF, l'application ne demande pas de confirmation à l'utilisateur si un fichier du même nom existe déjà. Si l'on décoche cette option, l'algorithme ne crée pas le fichier et passe au suivant.
* *Utiliser la DB* : on peut désactiver la recherche dans la base de données, prévue pour éviter d'appeler l'API pour des requêtes déjà effectuées. Son utilisation est recommandée, mais pas obligatoire.
* *Utiliser le CACHE* : l'utilisation du cache est recommandée et cette option ne doit pas être décochée sans bonne raison. Le cache est bien plus performant que l'API Google ou la base de données : la récupération de la donnée est quasi instantanée.
* *Utiliser l'API* : cette option a été ajoutée pour le développement et ne doit pas être désactivée.

On peut aussi afficher ou masquer tous les onglets. En particulier, les onglets « DB » permettent de visualiser tout ce qui a été ajouté dans la base de données.
Le mode développeur ajoute également la durée de chaque tâche et son statut dans les onglets d'analyse.
