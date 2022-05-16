import treemap.*;

Noeud[] rep = new Noeud[10];
int nrep;
int repIndex;
Treemap carte;

/*void setup() {
    size(400, 130, P2D);
    Noeud racine = new Noeud(new File("/home/julien/Documents/M1"));
    textFont(createFont("CharterBT-Bold", 11));
    racine.printList();
}

void draw() {
  background(200, 200, 200);
  for(int i = 0; i < 30; i++)
    repertoireSuivant();
  statut();
}*/

void setup() {
    size(1024, 768);
    strokeWeight(0.25f);
    textFont(createFont("Serif", 13));

    CarteDesMots mots = new CarteDesMots();

    String[] lignes = loadStrings("equator.txt");
    for(int i=0; i<lignes.length; i++) {
        mots.ajouter(lignes[i]);
    }
    mots.fin();
    carte = new Treemap(mots, 0, 0, width, height);

    // On ne va dessiner la carte qu'une fois.
    noLoop();
}

void draw() {
    background(255);
    carte.draw();
}


void ajoutRepertoire(Noeud repertoire) {
    if(nrep == rep.length) {
        rep = (Noeud[]) expand(rep);
    }
    rep[nrep++] = repertoire;
}

void repertoireSuivant() {
    if(repIndex != nrep) {
        Noeud n = rep[repIndex++];
        n.scanne();
    }
}

void statut() {
    float x = 30;
    float w = width - x*2;
    float y = 60;
    float h = 20;

    fill(0);
    if(repIndex != nrep) {
        text("Lecture du répertoire " + nfc(repIndex+1) + " sur " + nfc(nrep), x, y - 10);
    } else {
        text("Lecture terminée", x, y - 10);
    }

    fill(128);
    rect(x, y, w, h);
    float progres = map(repIndex+1, 0, nrep, 0, w);
    fill(255);
    rect(x, y, progres, h);
}
