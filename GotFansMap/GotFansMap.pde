PImage carte;
Table pos;
int lignes;

Table dataFans;
Table dataMaisons;
float dmin = MAX_FLOAT;
float dmax = MIN_FLOAT;
Integrator[] interp;


void setup() {
  size(625, 600);
  carte = loadImage("ressources/map.png");
  pos = new Table("ressources/positions.tsv");
  lignes = pos.getRowCount();
  dataFans = new Table("ressources/fans.tsv");
  dataMaisons = new Table("ressources/maisons.tsv");
  trouverMinMax();

  // On charge les valeurs initiales dans les interpolateurs :
  interp = new Integrator[lignes];
  for (int ligne = 0; ligne < lignes; ligne++) {
    interp[ligne] = new Integrator(0, 0.9, 0.2);
    interp[ligne].target(dataFans.getFloat(ligne, 1));
  }
}

void draw() {
  square(100, 100, 1000);
  textAlign(CENTER);  // Spécifie que le texte est centré par rapport aux coordonnées de dessin.

  background(255);
  image(carte, 0, 0);

  smooth();
  fill(192, 0, 0);
  noStroke();

  for (int ligne = 0; ligne < lignes; ligne++) {
    interp[ligne].update();
    // La clé nous sera utile pour retrouver les valeurs dans l'autre
    // ensemble de données.
    String cle = dataFans.getRowName(ligne);
    float x = pos.getFloat(cle, 1);
    float y = pos.getFloat(cle, 2);
    dessinerdataFans(x, y, cle, ligne);
    
    if (dist(x, y, mouseX, mouseY) < 20) {
      String maison = "";
      if (dataMaisons.getFloat(cle, 1) == 1) {
        maison = "Baratheon";
      } else if (dataMaisons.getFloat(cle, 1) == 2) {
        maison = "Tragaryen";
      } else if (dataMaisons.getFloat(cle, 1) == 3) {
        maison = "Stark";
      } else {
        maison = "Lannister";
      }
      text(dataFans.getFloat(cle, 1) + "% " + maison + " (" + cle + ")", x, y-25);
    }
  }
}

void dessinerdataFans(float x, float y, String cle, int ligne) {
  float valeur = interp[ligne].value;
  float taille = map(valeur, 0, dmax, 5, 50);
  if (dataMaisons.getFloat(cle, 1) == 1) {          //Baratheon
    fill(255, 204, 0);
  } else if (dataMaisons.getFloat(cle, 1) == 2) {   //Targaryen
    fill(0, 0, 0);
  } else if (dataMaisons.getFloat(cle, 1) == 3) {   //Stark
    fill(102, 255, 102);
  } else {                                          //Lannister
    fill(255, 0, 0);
  }
  ellipse(x, y, taille, taille);
}


void trouverMinMax() {
  for (int ligne = 0; ligne < lignes; ligne++) {
    float valeur = dataFans.getFloat(ligne, 1);
    if (valeur > dmax) dmax = valeur;
    if (valeur < dmin) dmin = valeur;
  }
}

void keyPressed() {
  if (key == ' ') {
    majdataFans();
    majdataMaisons();
  }
}

void majdataFans() {
  for (int ligne = 0; ligne < lignes; ligne++) {
    float newData = random(0, 100);
    dataFans.setFloat(ligne, 1, newData);
    interp[ligne].target(newData);
  }
}

void majdataMaisons() {
  for (int ligne = 0; ligne < lignes; ligne++) {
    float newData = (int)random(1, 5);
    dataMaisons.setFloat(ligne, 1, newData);
  }
}
