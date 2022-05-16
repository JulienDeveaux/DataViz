import treemap.*;

Repertoire racine;
PFont font;
Fichier courant;

void setup() {
  size(1024, 768);
  rectMode(CORNERS);
  font = createFont("SansSerif", 13);
  changerRacine(new File("/home/julien/Documents/M1"));
  cursor(CROSS);
  noStroke();
}

void changerRacine(File rep) {
  Repertoire r = new Repertoire(null, rep, 0, 0);
  r.setBounds(0, 0, width-1, height-1);
  r.contenuVisible = true;
  racine = r;
}

void draw() {
  background(255);
  textFont(font);
  courant = null;
  if (racine != null) {
    racine.draw();
  }
  if (courant != null) {
    courant.dessineTitre();
  }
}

void mousePressed() {
  if (racine != null) {
    racine.mousePressed();
  }
}
