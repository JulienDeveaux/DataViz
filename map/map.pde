PImage carte;
Table pos;
int lignes;

Table donnees;
/*float dmin = MAX_FLOAT;
float dmax = MIN_FLOAT;*/
float dmin = -10;
float dmax = 10;
Integrator[] interp;


void setup() {
  size(640, 400);
  carte = loadImage("ressources/map.png");
  pos = new Table("ressources/positions.tsv");
  lignes = pos.getRowCount();
  donnees = new Table("ressources/hasard.tsv");
  //trouverMinMax();
  
  // On charge les valeurs initiales dans les interpolateurs :
  interp = new Integrator[lignes];
  for(int ligne = 0; ligne < lignes; ligne++) {
      interp[ligne] = new Integrator(donnees.getFloat(ligne, 1));
  }
}

void draw() {
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
    String cle = donnees.getRowName(ligne);
    float x = pos.getFloat(cle, 1);
    float y = pos.getFloat(cle, 2);
    dessinerDonnees2(x, y, cle, ligne);
    if(dist(x, y, mouseX, mouseY) < 20) {
      text(donnees.getFloat(cle, 1) + " (" + cle + ")", x, y-10);
    }
  }
}

void dessinerDonnees3(float x, float y, String cle) {    // couleurs transparence
  float valeur = donnees.getFloat(cle, 1);
  if (valeur > 0) {
    fill(0, 0, 255, map(valeur, 0, dmax, 0, 255));
  } else {
    fill(255, 0, 0, map(valeur, 0, dmin, 0, 255));
  }
  ellipse(x, y, 15, 15);
}

void dessinerDonnees2(float x, float y, String cle, int ligne) {    //changement de taille
  float valeur = interp[ligne].value;
  float taille = 0;
  if (valeur > 0) {
    fill(0, 0, 255);
    taille = map(valeur, 0, dmax, 3, 30);
  } else {
    fill(255, 0, 0);
    taille = map(valeur, 0, dmin, 3, 30);
  }
  ellipse(x, y, taille, taille);
}

void dessinerDonnees(float x, float y, String cle) {    //couleurs claires
  // Croise la donnée avec la position.
  float valeur = donnees.getFloat(cle, 1);
  float pourcent = norm(valeur, dmin, dmax);
  color couleur = lerpColor(#296F34, #61E2F0, pourcent, HSB);
  fill(couleur);
  // On transforme la valeur de son intervalle de définition vers l'intervalle [2,40].
  // La fonction map est prédéfinie par Processing.
  float taille = map(valeur, dmin, dmax, 2, 40);
  // Enfin on dessine une ellipse dont la taille varie en fonction de la valeur.
  ellipse(x, y, taille, taille);
}


void trouverMinMax() {
  for (int ligne = 0; ligne < lignes; ligne++) {
    float valeur = donnees.getFloat(ligne, 1);
    if (valeur > dmax) dmax = valeur;
    if (valeur < dmin) dmin = valeur;
  }
}

void keyPressed() {
  if(key == ' ') {
    majDonnees();
  }
}

void majDonnees() {
    for(int ligne = 0; ligne < lignes; ligne++) {
      interp[ligne].target(random(dmin, dmax));
    }
}
