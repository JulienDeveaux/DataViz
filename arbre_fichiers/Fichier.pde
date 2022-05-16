class Fichier extends SimpleMapItem {
  Repertoire parent;
  File fichier;
  String nom;
  int niveau;
  color c;
  float teinte;
  float valeur;


  float sp;
  float gauche, haut, droite, bas;

  Fichier(Repertoire parent, File fichier, int niveau, int ordre) {
    this.parent = parent;
    this.fichier = fichier;
    this.order = ordre;
    this.niveau = niveau;
    nom = fichier.getName();
    size = fichier.length();
  }

  void calcBoite() {
    gauche = x;
    haut = y;
    droite = x + w;
    bas = y + h;
  }

  void draw() {
    calcBoite();
    fill(c);
    rect(gauche, haut, droite, bas);
    if (assezGrand()) {
      dessineTitre();
    } else if (contientSouris()) {
      courant = this;
    }
  }

  boolean contientSouris() {
    return (mouseX > gauche && mouseX < droite && mouseY > haut && mouseY < bas);
  }

  void dessineTitre() {
    fill(255, 200);
    textAlign(LEFT);
    text(nom, gauche + sp, bas + sp);
  }

  boolean assezGrand() {
    float largeur = textWidth(nom) + sp*2;
    float hauteur = textAscent() + textDescent() + sp*2;
    return ((droite - gauche) > largeur) && ((bas-haut) > hauteur);
  }

  boolean mousePressed() {
    if (contientSouris()) {
      if (mouseButton == RIGHT) {
        parent.cacheLeContenu();
        return true;
      }
    }
    return false;
  }

  void majCouleurs(long oldestFileDate, long newestFileDate) {
    if (parent != null) {
      teinte = map(order, 0, parent.getItemCount(), 0, 360);
    }
    valeur = random(20, 90);
    
    //print(fichier.lastModified() + " " + oldestFileDate + " " + newestFileDate + " " + 0 + " " + 255 + " " + map(fichier.lastModified(), oldestFileDate, newestFileDate, 0, 255) + "\n");
    //colorMode(HSB, map(fichier.lastModified(), oldestFileDate, log(newestFileDate), 0, 255), 100, 100);
    colorMode(HSB, 360, 50, valeur);
    
    if (parent == racine) {
      c = color(teinte, 80, 80);
    } else if (parent != null) {
      if(oldestFileDate == newestFileDate) {
        c = color(parent.teinte, 80, map(log(fichier.lastModified()), log(oldestFileDate)+100, log(newestFileDate), 20, 80));
      } else {
        c = color(parent.teinte - valeur, 80, 20);  //TODO le 20 est au pif faut voir ce qu'il faut mettre a la place
      }
  }
    colorMode(RGB, 255);
  }
}
