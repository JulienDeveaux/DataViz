FloatTable donnees;
float dmin, dmax;
int amin, amax;
int[] annees;
float traceX1, traceY1, traceX2, traceY2;
// La colonne de données actuellement utilisée.
int colonne = 0;
// Le nombre de colonnes.
int ncol;
// La police de caractères.
PFont police;
int intervalleAnnees = 10;
int intervalleVolume = 10;
int intervalleVolumeMineur = 5;

Integrator[] interp;

int displayMode = 0;

void setup() {
    size(800, 600);

    donnees = new FloatTable("ressources/lait-the-cafe.tsv");
    ncol = donnees.getColumnCount();
    dmin = 0;
    dmax = ceil(donnees.getTableMax() / intervalleVolume) * intervalleVolume;
    annees = int(donnees.getRowNames());
    amin = annees[0];
    amax = annees[annees.length - 1];
    
    interp = new Integrator[donnees.getRowCount()];
    for (int ligne = 0; ligne < donnees.getRowCount(); ligne++) {
      interp[ligne] = new Integrator(0, 0.5, 0.2);
      interp[ligne].target(donnees.getFloat(ligne, colonne));
    }

    traceX1 = 60;
    traceY1 = 40;
    traceX2 = width - 2*traceX1;
    traceY2 = height - 2*traceY1;    //le 2* est pour décaler / modifier la taille du rectangle du graph

    police = createFont("SansSerif", 20);
    textFont(police);

    smooth();
}

void draw() {
    background(224);
    translate(60, 0);              // le décallage se fait ici
    fill(255);
    rectMode(CORNERS);
    noStroke();
    rect(traceX1, traceY1, traceX2, traceY2);
    
    for(int i = 0; i < donnees.getRowCount(); i++) {
      interp[i].update();          // mise à jour de l'effet de mouvement
    }
    
    if(displayMode == 0) {         // séléction du mode d'affichage
      dessinNormal();
    } else if(displayMode == 1) {
      dessinAire();
    } else if(displayMode == 2) {
      dessinHistogramme();
    }
    
    
    textAlign(CENTER, CENTER);
    textSize(10);
    text("→ et ← pour changer les données \n" + 
         "n'importe quelle touche pour changer la vue"
         , 50, height - 40);
}

void dessinNormal() {
    strokeWeight(1);
    stroke(#5679C1);
    noFill();
    dessineLigneDonnees(colonne, true);
    strokeWeight(5);
    stroke(#5679C1);
    dessinePointsDonnees(colonne, false);
    

    dessineTitre();
    dessineAxeAnnees();
    dessineAxeVolume();
}

void dessinAire() {
    strokeWeight(1);
    stroke(#5679C1);
    noFill();
    dessineLigneDonnees(colonne, false);    //----
    vertex(traceX2, traceY2);               // Ici on ne ferme pas la shape commencé dans la fonction ligneDonnees
    vertex(traceX1, traceY2);               // et on rajoute les lignes qui composent le bas de notre diagrame avant de fermer la shape
    endShape(CLOSE);                        //-----    
    

    dessineTitre();
    dessineAxeAnnees();
    dessineAxeVolume();
}

void dessinHistogramme() {
    dessineTitre();
    dessineAxeAnnees();
    dessineAxeVolume();
    strokeWeight(1);
    stroke(#5679C1);
    noFill();
    strokeWeight(5);
    stroke(#5679C1);
    dessinePointsDonnees(colonne, true);
}

void dessineLigneDonnees(int col, boolean endShape) {    // le paramètre endShape doit être a true seulement pour la vue en aire
    beginShape();
    if(endShape)
      noFill();
    else
      fill(#5679C1);
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = interp[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            vertex(x, y);
        }
    }
    if(endShape)
      endShape();
}


void dessinePointsDonnees(int col, boolean toRect) {    // le paramètre toRect est à true si on veut un histogramme à la place de points
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = interp[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            if(toRect) {
              rectMode(CORNER);
              rect(x, y, 0, traceY2-y);
            } else {
              point(x, y);
            }
        }
    }
}

void dessineAxeAnnees() {
    fill(0);
    textSize(10);
    textAlign(CENTER, TOP);

    // Des lignes fines en gris clair.
    stroke(224);
    strokeWeight(1);

    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(annees[ligne] % intervalleAnnees == 0) {
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            text(annees[ligne], x, traceY2 + 10);
            // Dessine les lignes.
            line(x, traceY1, x, traceY2);
        }
    }
    
    textSize(15);
    text("Années", width / 2, traceY2 + 30);
    textAlign(BASELINE);
}

void dessineAxeVolume() {
    fill(0);
    textSize(10);
    stroke(128);
    strokeWeight(1);

    for(float v = dmin; v <= dmax; v+=intervalleVolumeMineur) {
        if(v % intervalleVolumeMineur == 0) {
            float y = map(v, dmin, dmax, traceY2, traceY1);
            if(v % intervalleVolume == 0) {
                if(v == dmin) {
                    textAlign(RIGHT, BOTTOM);
                } else if(v == dmax) {
                    textAlign(RIGHT, TOP);
                } else {
                    textAlign(RIGHT, CENTER);
                }
                text(floor(v), traceX1 - 10, y);
                line(traceX1 - 4, y, traceX1, y); // Tiret majeur.
            } else {
                line(traceX1 - 2, y, traceX1, y); // Tiret mineur.
            }
        }
    }
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Litres \n consommés \n par pers",  traceX1 - 70, height / 2);
}

void dessineTitre() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text(donnees.getColumnName(colonne), traceX1, traceY1 - 10); 
}

void keyPressed() {
  if(keyCode == LEFT) {
    if(colonne < 2)
      colonne++;
      for (int ligne = 0; ligne < donnees.getRowCount(); ligne++) {
        interp[ligne].target(donnees.getFloat(ligne, colonne));
      }
  } else if(keyCode == RIGHT) {
    if(colonne > 0)
      colonne--;
      for (int ligne = 0; ligne < donnees.getRowCount(); ligne++) {
        interp[ligne].target(donnees.getFloat(ligne, colonne));
      }
  } else {
    if(displayMode < 2) {
      displayMode++;
    } else {
      displayMode = 0;
    }
  }
}
