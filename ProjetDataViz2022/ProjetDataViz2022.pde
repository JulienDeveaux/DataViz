PImage carte; //<>//
Table[] dataTable;
int displayMode = 0;
int tour = 1;
String[][] deptDataT1;
String[][] regDataT1;
color[] colorsT1;
String[] participantsT1;
String[][] deptDataT2;
String[][] regDataT2;
color[] colorsT2;
String[] participantsT2;
boolean drawLegend = true;
Cheese[] regCheeses;
Cheese[] deptCheeses;

void setup() {
  size(1138, 1080);

  colorsT1 = new color[12];
  colorsT1[0] = color(255, 0, 0);
  colorsT1[1] = color(0, 0, 255);
  colorsT1[2] = color(0, 255, 0);
  colorsT1[3] = color(255, 255, 0);
  colorsT1[4] = color(0, 255, 255);
  colorsT1[5] = color(255, 0, 255);
  colorsT1[6] = color(255, 100, 100);
  colorsT1[7] = color(100, 100, 255);
  colorsT1[8] = color(50, 255, 50);
  colorsT1[9] = color(255, 50, 50);
  colorsT1[10] = color(50, 50, 255);
  colorsT1[11] = color(100, 255, 0);
  colorsT2 = new color[2];
  colorsT2[0] = color(255, 100, 100);
  colorsT2[1] = color(100, 100, 255);
  participantsT1 = new String[12];
  participantsT1[0] = "Arthaud";
  participantsT1[1] = "Roussel";
  participantsT1[2] = "Macron";
  participantsT1[3] = "Lassalle";
  participantsT1[4] = "Le Pen";
  participantsT1[5] = "Zemmour";
  participantsT1[6] = "Melenchon";
  participantsT1[7] = "Hidalgo";
  participantsT1[8] = "Jadot";
  participantsT1[9] = "Pecresse";
  participantsT1[10] = "Poutou";
  participantsT1[11] = "Dupont-Aignan";
  participantsT2 = new String[2];
  participantsT2[0] = "Macron";
  participantsT2[1] = "Le Pen";

  carte = loadImage("France_départementale.png");

  Table regionTable = new Table("regions-francaises.tsv");
  Table deptTable = new Table("departements-francais.tsv");
  dataTable = new Table[2];
  dataTable[0] = deptTable;
  dataTable[1] = regionTable;

  getData();


  float[] initdataT1 = new float[12];
  initdataT1[0] = 0;
  initdataT1[1] = 0;
  initdataT1[2] = 0;
  initdataT1[3] = 0;
  initdataT1[4] = 0;
  initdataT1[5] = 0;
  initdataT1[6] = 0;
  initdataT1[7] = 0;
  initdataT1[8] = 0;
  initdataT1[9] = 0;
  initdataT1[10] = 0;
  initdataT1[11] = 0;
  deptCheeses = new Cheese[dataTable[0].getRowCount()];
  for (int i = 0; i < dataTable[0].getRowCount(); i++) {
    String nom = dataTable[0].getString(i, 1);
    int x = dataTable[0].getInt(i, 2);
    int y = dataTable[0].getInt(i, 3);
    int taille = dataTable[0].getInt(i, 4);

    deptCheeses[i] = new Cheese(x, y, taille, nom, participantsT1, colorsT1);
    deptCheeses[i].setData(initdataT1);
  }
  
  regCheeses = new Cheese[dataTable[1].getRowCount()];
  for (int i = 0; i < dataTable[1].getRowCount(); i++) {
    String nom = dataTable[1].getString(i, 0);
    int x = dataTable[1].getInt(i, 1);
    int y = dataTable[1].getInt(i, 2);
    int taille = int(dataTable[1].getInt(i, 3));

    regCheeses[i] = new Cheese(x, y, taille, nom, participantsT1, colorsT1);
    regCheeses[i].setData(initdataT1);
  }
  println("clic de souris pour changer de vue entre le 1er et 2ème tour et appui d'une touche pour changer de la vue entre région et département");
}

void draw() {
  textAlign(CENTER);  // Spécifie que le texte est centré par rapport aux coordonnées de dessin.

  background(255);
  carte.resize(1138, 1080);
  image(carte, 0, 0);

  smooth();
  fill(192, 0, 0);
  noStroke();
  if (tour == 1) {
    legende(participantsT1, colorsT1, 65, 30);
    if (displayMode == 0) {    //départements
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String code = dataTable[displayMode].getString(i, 0);
        if (int(code) <= 9 && !code.equals("2A") && !code.equals("2B")) {
          code = "0" + code;
        }
        if (code.equals("971")) {      //cas Gadeloupe
          code = "ZA";
        } else if (code.equals("972")) {  //cas Martinique
          code = "ZB";
        } else if (code.equals("973")) {  //cas Guyanne
          code = "ZC";
        } else if (code.equals("974")) {  //cas La Réunion
          code = "ZD";
        } else if (code.equals("976")) {  //cas Mayotte
          code = "ZM";
        }
        String[] resRow = new String[deptDataT1[0].length];
        for (int j = 0; j < deptDataT1.length; j++) {
          if (deptDataT1[j][0].equals(code)) {
            resRow = deptDataT1[j];
          }
        }
        float[] pourcentages = new float[12];
        for (int j = 0, iterator = 0; j < deptDataT1[i+1].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(resRow[22+j].replace(",", "."));
        }
        deptCheeses[i].setParticipants(participantsT1).setData(pourcentages).drawCheese();
      }
    } else {                  //régions
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        float[] pourcentages = new float[12];
        for (int j = 0, iterator = 0; j < regDataT1[i].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(regDataT1[i][22+j].replace(",", "."));
        }
        regCheeses[i].setParticipants(participantsT1).setData(pourcentages).drawCheese();
      }
    }
  } else {
    legende(participantsT2, colorsT2, 65, 30);
    if (displayMode == 0) {    //départements
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String code = dataTable[displayMode].getString(i, 0);
        if (int(code) <= 9 && !code.equals("2A") && !code.equals("2B")) {
          code = "0" + code;
        }
        if (code.equals("971")) {         //cas Gadeloupe
          code = "ZA";
        } else if (code.equals("972")) {  //cas Martinique
          code = "ZB";
        } else if (code.equals("973")) {  //cas Guyanne
          code = "ZC";
        } else if (code.equals("974")) {  //cas La Réunion
          code = "ZD";
        } else if (code.equals("976")) {  //cas Mayotte
          code = "ZM";
        }
        String[] resRow = new String[deptDataT2[0].length];
        for (int j = 0; j < deptDataT1.length; j++) {
          if (deptDataT2[j][0].equals(code)) {
            resRow = deptDataT2[j];
          }
        }
        float[] pourcentages = new float[2];
        for (int j = 0, iterator = 0; j < deptDataT2[i+1].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(resRow[22+j].replace(",", "."));
        }
        deptCheeses[i].setParticipants(participantsT2).setData(pourcentages).drawCheese();
      }
    } else {                  //régions
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        float[] pourcentages = new float[2];
        for (int j = 0, iterator = 0; j < regDataT2[i].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(regDataT2[i][22+j].replace(",", "."));
        }
        regCheeses[i].setParticipants(participantsT2).setData(pourcentages).drawCheese();
      }
    }
  }
  rectMode(CENTER);
  fill(200, 200, 200);
  if(displayMode == 0) {        // on affiche un indicateur département
    rect(width/2, height/25, 150, 25);
    fill(0, 0, 0);
    text("Affichage par départements", width/2+5, height/25+5);
  } else {                      // on affiche un indicateur région
    rect(width/2, height/25, 150, 25);
    fill(0, 0, 0);
    text("Affichage par régions", width/2+5, height/25+5);
  }
}

void legende(String[] participants, color[] colors, int startingX, int startingY) {
  if (drawLegend) {
    rectMode(CENTER);
    fill(200, 200, 200);
    for (int i = 0, j = 0; i < participants.length; i++, j+=20) {    //Draw grey rects first
      rect(startingX, startingY+j, 110, 25);
    }
    for (int i = 0, j = 2; i < participants.length; i++, j+=20) {    //Draw participants
      color currentColor = colors[i];
      drawCircle(startingX-35, startingY+j-4, currentColor, 8);
      fill(0, 0, 0);
      text(participants[i], startingX + 15, startingY+j);
    }
  }
}

void drawCircle(int x, int y, color colors, int taille) {    //small circle with some data
    fill(colors);
    circle(x, y, taille);
}


void legende(String[] participants, color[] colors, int startingX, int startingY, float[] pourcentages) {
  rectMode(CENTER);
  fill(200, 200, 200);
  for (int i = 0, j = 0; i < participants.length; i++, j+=20) {    //Draw grey rects first
    rect(startingX, startingY+j, 120, 25);
  }
  for (int i = 0, j = 2; i < participants.length; i++, j+=20) {    //Draw participants + pourcentages
    color currentColor = colors[i];
    drawCircle(startingX-65, startingY+j-4, currentColor, 8);
    fill(0, 0, 0);
    text(participants[i] + " " + pourcentages[i] + " %", startingX + 0, startingY+j);
  }
}

void getData() {
  //Tour 1

  String[] dataDeptT1 = loadStrings("https://www.data.gouv.fr/fr/datasets/r/8b4d68f6-4490-4afc-b632-6c259073a4b9");
  ArrayList<String[]> linesDeptT1 = new ArrayList<String[]>();
  for (int i = 0; i < dataDeptT1.length; i++) {
    linesDeptT1.add(dataDeptT1[i].split(";"));
  }
  deptDataT1 = new String[linesDeptT1.size()][0];
  linesDeptT1.toArray(deptDataT1);

  String[] dataRegtT1 = loadStrings("https://www.data.gouv.fr/fr/datasets/r/cbf026c5-e0bf-4ff8-b1cd-eb994cd26290");
  ArrayList<String[]> linesRegtT1 = new ArrayList<String[]>();
  for (int i = 0; i < dataRegtT1.length; i++) {
    linesRegtT1.add(dataRegtT1[i].split(";"));
  }
  regDataT1 = new String[linesRegtT1.size()][0];
  linesRegtT1.toArray(regDataT1);

  //Tour 2

  String[] dataDeptT2 = loadStrings("https://www.data.gouv.fr/fr/datasets/r/8986f174-d47e-46e5-a499-5d352d9422b3");
  ArrayList<String[]> linesDeptT2 = new ArrayList<String[]>();
  for (int i = 0; i < dataDeptT2.length; i++) {
    linesDeptT2.add(dataDeptT2[i].split(";"));
  }
  deptDataT2 = new String[linesDeptT2.size()][0];
  linesDeptT2.toArray(deptDataT2);

  String[] dataRegtT2 = loadStrings("https://www.data.gouv.fr/fr/datasets/r/1b508d3b-997a-4f7f-95ce-e4ada06d97ff");
  ArrayList<String[]> linesRegtT2 = new ArrayList<String[]>();
  for (int i = 0; i < dataRegtT2.length; i++) {
    linesRegtT2.add(dataRegtT2[i].split(";"));
  }
  regDataT2 = new String[linesRegtT2.size()][0];
  linesRegtT2.toArray(regDataT2);
}

void keyPressed() {
  if (displayMode == 0) {
    displayMode = 1;
  } else {
    displayMode = 0;
  }
}

void mousePressed() {
  if (tour == 1) {
    tour = 2;
  } else {
    tour = 1;
  }
}
