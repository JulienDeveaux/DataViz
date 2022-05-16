class Repertoire extends Fichier implements MapModel {
  MapLayout algo = new PivotBySplitSize();
  Mappable[] items;
  boolean contenuVisible;
  boolean layoutValide;
  long oldestFileDate = 0;
  long newestFileDate = 0;

  public Repertoire(Repertoire parent, File fichier, int niveau, int ordre) {
    super(parent, fichier, niveau, ordre);
    if (oldestFileDate == 0) {
      oldestFileDate = fichier.lastModified();
      newestFileDate = fichier.lastModified();
    }

    String[] contenus = fichier.list();
    if (contenus != null) {
      contenus = sort(contenus);
      items = new Mappable[contenus.length];
      int n = 0;
      for (int i=0; i<contenus.length; i++) {
        if (contenus[i].equals(".") || contenus[i].equals("..")) {
          continue;
        }
        File enfant = new File(fichier, contenus[i]);
        if (enfant.lastModified() > newestFileDate) {
          newestFileDate = enfant.lastModified();
        }
        if (enfant.lastModified() < oldestFileDate) {
          oldestFileDate = enfant.lastModified();
        }
        try {
          String abs = enfant.getAbsolutePath();
          String can = enfant.getCanonicalPath();
        }
        catch(IOException e) {
        }
        if (enfant.isDirectory()) {
          items[n++] = new Repertoire(this, enfant, niveau+1, n);
        } else {
          items[n++] = new Fichier(this, enfant, niveau+1, n);
        }
        size += items[n-1].getSize();
      }
      if (n != items.length) {
        items = (Mappable[]) subset(items, 0, n);
      }
    } else {
      items = new Mappable[0];
    }
    majCouleurs();
  }

  long getOldestFileDate() {
    return oldestFileDate;
  }

  long getnewestFileDate() {
    return newestFileDate;
  }

  void verifieLayout() {
    if (!layoutValide) {
      if (getItemCount() != 0) {
        algo.layout(this, bounds);
      }
      layoutValide = true;
    }
  }

  void draw() {
    if (contientSouris()) {
      stroke(5);
    } else {
      noStroke();
    }
    verifieLayout();
    calcBoite();
    if (contenuVisible) {
      for (int i=0; i<items.length; i++) {
        items[i].draw();
      }
    } else {
      super.draw();
    }
  }

  Mappable[] getItems() {
    return items;
  }

  int getItemCount() {
    return items.length;
  }

  boolean mousePressed() {
    if (contientSouris()) {
      if (contenuVisible) {
        for (int i = 0; i < items.length; i++) {
          if (((Fichier)items[i]).mousePressed()) {
            return true;
          }
        }
      } else { // not opened
        if (mouseButton == LEFT) {
          montreLeContenu();
        } else if (mouseButton == RIGHT) {
          if (parent != racine)
            parent.cacheLeContenu();
        }
        return true;
      }
    }
    return false;
  }

  void cacheLeContenu() {
    contenuVisible = false;
    for (int i = 0; i < items.length; i++) {
      ((Fichier)items[i]).majCouleurs(oldestFileDate, newestFileDate);
    }
  }

  void montreLeContenu() {
    if (parent != null)
      contenuVisible = true;
  }

  void majCouleurs() {
    super.majCouleurs(oldestFileDate, newestFileDate);
    for (int i = 0; i < items.length; i++) {
      ((Fichier)items[i]).majCouleurs(oldestFileDate, newestFileDate);
    }
  }
}
