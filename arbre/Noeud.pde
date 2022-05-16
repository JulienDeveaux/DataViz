class Noeud {
  File fichier;
  Noeud[] enfants;
  int nEnfants;

  /*Noeud(File fichier) {
    this.fichier = fichier;

    if (fichier.isDirectory()) {
      String[] contenus = fichier.list();
      if (contenus != null) {
        // Trie les fichiers dans ordre insensible à la case.
        contenus = sort(contenus);

        enfants = new Noeud[contenus.length];
        for (int i=0; i<contenus.length; i++) {
          if (contenus[i].equals(".") || contenus[i].equals("..")) {
            continue;
          }
          File enfant = new File(fichier, contenus[i]);
          try {
            String cheminAbs = enfant.getAbsolutePath();
            String cheminCan = enfant.getCanonicalPath();
            if (!cheminAbs.equals(cheminCan)) {
              continue;
            }
          }
          catch (IOException e) {
          }
          enfants[nEnfants++] = new Noeud(enfant);
        }
      }
    }
  }*/

  Noeud(File fichier) {
    this.fichier = fichier;
    if (fichier.isDirectory()) {
      ajoutRepertoire(this);
    }
  }

  void scanne() {
    String[] contenus = fichier.list();
    if (contenus != null) {
      contenus = sort(contenus);
      enfants = new Noeud[contenus.length];
      for (int i=0; i<contenus.length; i++) {
        if (contenus[i].equals(".") || contenus[i].equals("..")) {
          continue;
        }
        File enfant = new File(fichier, contenus[i]);
        try {
          String cheminAbs = enfant.getAbsolutePath();
          String cheminCan = enfant.getCanonicalPath();
          if (!cheminAbs.equals(cheminCan)) {
            continue;
          }
        }
        catch (IOException e) {
        }
        enfants[nEnfants++] = new Noeud(enfant);
      }
    }
  }



  void printList() {
    printList(0);
  }

  void printList(int profondeur) {
    for (int i=0; i<profondeur; i++) println(" ");
    println(fichier.getName());
    for (int i=0; i<nEnfants; i++) enfants[i].printList(profondeur+1);
  }
}
