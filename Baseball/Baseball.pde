import java.text.*;
import java.util.*;

int nequipes = 30;
String[] noms;
String[] codes;
HashMap indices;
ListeSalaires salaires;
ListeClassements classements;
PImage[] logos;
float logow;
float logoh;
PFont font;
static final int HLIGNE = 23;
static final float DEMI_HLIGNE = HLIGNE / 2.0;
static final int BORDS = 30;
long selectedDate;
Integrator[] interpClassement;


void setup() {
    size(480, 750);
    
    SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
    Date date = null;
    try{date = format.parse("20070502");}catch(Exception e){}
    selectedDate = date.getTime();

    interpClassement = new Integrator[nequipes];
    for (int ligne = 0; ligne < nequipes; ligne++) {
      interpClassement[ligne] = new Integrator(0, 0.5, 0.3);
    }

    setupEquipes();
    setupSalaires();
    setupClassements();
    setupLogos();
    
    

    font = createFont("SansSerif", 11);
    textFont(font);
}

void draw() {

  background(255);
  smooth();
  float gaucheX = 160;
  float droiteX = 335;
  String hoverDateTxt = "";
  int hoverDateX = 0;
  int hoverDateY = 0;
  int hoverRectPos = -500;                      // -500 : mets le rectangle loin caché si on l'utilise pas
  color hoverColor = color(0, 0, 0);
  
  for(int i = 0; i < nequipes; i++) {
    interpClassement[i].update();
  }
  
  stroke(0);
  int interval = 2;
  int startPos = width/10;
  int endPos = startPos + (182*interval);    //182 jours entre début avril et fin septembre 2007
  DateFormat formatJour = new SimpleDateFormat("EEEE");
  long dateStart = 11753784;
  long dateEnd = 11911032;
  for(int i = startPos; i < endPos; i+=interval) {
    String txtJour = formatJour.format(map(i, startPos, endPos, dateStart, dateEnd)*100000);    // récupère  le texte a afficher
      DateFormat niceDate = new SimpleDateFormat("d MMM yyyy");
    
    if(selectedDate == (long)map(i, startPos, endPos, dateStart, dateEnd)*100000) {              // affichage texte de la date sélectionné
      fill(0, 0, 0);
      strokeWeight(2);
      line(i, 10, i, 25);
      text(txtJour + " " + niceDate.format(map(i, startPos, endPos, dateStart, dateEnd)*100000), i-20, 30);  //20070401, 20070931 début avril à fin septembre en millisecondes
    }
    
    if(mouseY < 20 && mouseY > 10 && mouseX > i - interval && mouseX < i + (interval/2)) {        // affichage texte quand la souris est au dessus de la timeline
      strokeWeight(2);
      hoverRectPos = i-25;                                                                                // en bleu pour le reste
      fill(0, 0, 255);
      hoverColor = color(0, 0, 255);
        if(mousePressed) {                                                                      // s'occupe de set la data cliquée
        selectedDate = (long)map(i, startPos, endPos, dateStart, dateEnd)*100000;
        setupClassements();
      }
      line(i, 10, i, 25);
      hoverDateTxt = txtJour + " " + niceDate.format(map(i, startPos, endPos, dateStart, dateEnd)*100000);    //20070401, 20070931 début avril à fin septembre en millisecondes
      hoverDateX = i-20;
      hoverDateY = 30;
  } else {
      strokeWeight(0.5);
      line(i, 10, i, 20);
    }
  }
  noStroke();
  fill(255, 255, 255);
  rect(hoverRectPos, 21, 110, 20);             // rectangle pour éviter que les textes se chevauchent
  stroke(1);
  fill(hoverColor);                            // remets la couleur bleu ou rouge du texte
  text(hoverDateTxt, hoverDateX, hoverDateY);  //et l'affiche
  
  
  translate(BORDS, BORDS);
  font = loadFont("Courier10PitchBT-Bold-14.vlw");
  textFont(font);
  textAlign(LEFT, CENTER);
  for(int i=0; i<nequipes; i++) {
    fill(0);
    float classementY = interpClassement[i].value * HLIGNE + DEMI_HLIGNE;
    image(logos[i], 0, classementY - logoh/2, logow, logoh);
    text(noms[i], 28, classementY);
    fill(0, 100, 255);
    text(classements.getTitle(i), 115, classementY);
    float salaireY = salaires.getRank(i) * HLIGNE + DEMI_HLIGNE;
    stroke(0);
    if(classementY >= salaireY) {
      stroke(0, 0, 255);
    } else {
      stroke(255, 0, 0);
    }
    fill(0);
    strokeWeight(map(i, salaires.getCount(), 0, 0.25, 6));
    line(gaucheX, classementY, droiteX, salaireY);
    text(salaires.getTitle(i), droiteX + 10, salaireY);
  }
}

void setupLogos() {
    logos = new PImage[nequipes];
    for(int i=0; i<nequipes; i++) {
        logos[i] = loadImage("ressources/small/" + codes[i] + ".gif");
    }
    logow = logos[0].width / 2.0;
    logoh = logos[0].height / 2.0;
}

void setupClassements() {
    DateFormat joli = new SimpleDateFormat("yyyy MM dd");
    String[] date = joli.format(selectedDate).split(" ");
    classements = new ListeClassements(chargerClassements(Integer.parseInt(date[0]),
                                                          Integer.parseInt(date[1]),
                                                          Integer.parseInt(date[2])));
    
    for (int ligne = 0; ligne < classements.getCount(); ligne++) {
      interpClassement[ligne].target(classements.getRank(ligne));
    }
}

void setupSalaires() {
    salaires = new ListeSalaires(loadStrings("ressources/salaires.tsv"));
}

void setupEquipes() {
  String[] lignes = loadStrings("ressources/equipes.tsv");
  nequipes = lignes.length;
  codes = new String[nequipes];
  noms = new String[nequipes];
  indices = new HashMap();
  
  for(int i = 0; i < nequipes; i++) {
    String[] parties = split(lignes[i], TAB);
    codes[i] = parties[0];
    noms[i] = parties[1];
    indices.put(codes[i], new Integer(i));
  }
}

int indexEquipe(String code) {
  return ((Integer) indices.get(code)).intValue();
}

String[] chargerClassements(int annee, int mois, int jour) {
    String nom = annee + nf(mois, 2) + nf(jour, 2) + ".tsv";
    String chemin = dataPath(nom);
    File fichier = new File(chemin);
    if((!fichier.exists()) || (fichier.length() == 0)) {
        // Si le fichier n'existe pas, on le crée à partir de données en ligne.
        // Attention pour cet exemple les années possibles sont entre 1999 et
        // 2011...
        println("on télécharge " + nom);
        PrintWriter writer = createWriter(chemin);
        String base = "http://mlb.mlb.com/components/game" +
           "/year_" + annee + "/month_" + nf(mois, 2) + "/day_" + nf(jour, 2) + "/";
        // American League
        lireClassements(base + "standings_rs_ale.js", writer);
        lireClassements(base + "standings_rs_alc.js", writer);
        lireClassements(base + "standings_rs_alw.js", writer);
        // National League
        lireClassements(base + "standings_rs_nle.js", writer);
        lireClassements(base + "standings_rs_nlc.js", writer);
        lireClassements(base + "standings_rs_nlw.js", writer);

        writer.flush();
        writer.close();
    }
    return loadStrings(chemin);
}

void lireClassements(String fichier, PrintWriter writer) {
    String[] lignes = loadStrings(fichier);
    println(lignes);
    println(lignes.length);
    String code = "";
    int wins = 0;
    int losses = 0;
    for(int i=0; i < lignes.length; i++) {
        String[] matches = match(lignes[i], "\\s+([\\w\\d]+):\\s'(.*)',?");
        if(matches != null) {
            String attr = matches[1];
            String valeur =  matches[2];

            if(attr.equals("code")) {
                code = valeur;
            } else if( attr.equals("w")) {
                wins = parseInt(valeur);
            } else if(attr.equals("l")) {
                losses = parseInt(valeur);
            }
        } else {
            if(lignes[i].startsWith("}")) {
                // Fin du groupe on écrit les valeurs.
                writer.println(code + TAB + wins + TAB + losses);
            }
        }
    }
}
