PImage carte; //<>//
Table[] dataTable;
int displayMode = 0;
int tour = 1;
String[][] deptDataT1;
String[][] regDataT1;
color[] colorsT1;
String[][] deptDataT2;
String[][] regDataT2;
color[] colorsT2;
boolean drawLegend = true;
float prevRadian = 0;    //for partyMode -> to Delete
Integrator[] interpDept;
Integrator[] interpReg;

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

  carte = loadImage("France_départementale.png");

  Table regionTable = new Table("regions-francaises.tsv");
  Table deptTable = new Table("departements-francais.tsv");
  dataTable = new Table[2];
  dataTable[0] = deptTable;
  dataTable[1] = regionTable;

  getData();
  
  interpDept = new Integrator[deptTable.getRowCount()];
  for (int ligne = 0; ligne < deptTable.getRowCount(); ligne++) {
    interpDept[ligne] = new Integrator(0, 0.9, 0.2);
    interpDept[ligne].target(0);
  }
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
    String[] participants = new String[12];
    participants[0] = "Arthaud";
    participants[1] = "Roussel";
    participants[2] = "Macron";
    participants[3] = "Lassalle";
    participants[4] = "Le Pen";
    participants[5] = "Zemmour";
    participants[6] = "Melenchon";
    participants[7] = "Hidalgo";
    participants[8] = "Jadot";
    participants[9] = "Pecresse";
    participants[10] = "Poutou";
    participants[11] = "Dupont-Aignan";
    legende(participants, colorsT1, 65, 30);
    if (displayMode == 0) {    //départements
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 1);
        int x = dataTable[displayMode].getInt(i, 2);
        int y = dataTable[displayMode].getInt(i, 3);
        int taille = dataTable[displayMode].getInt(i, 4);

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
        cheese(pourcentages, x, y, colorsT1, taille, nom, participants);
      }
    } else {                  //régions
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 0);
        int x = dataTable[displayMode].getInt(i, 1);
        int y = dataTable[displayMode].getInt(i, 2);
        int taille = int(dataTable[displayMode].getInt(i, 3));

        float[] pourcentages = new float[12];
        for (int j = 0, iterator = 0; j < regDataT1[i].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(regDataT1[i][22+j].replace(",", "."));
        }
        cheese(pourcentages, x, y, colorsT1, taille, nom, participants);
      }
    }
  } else {
    String[] participants = new String[2];
    participants[0] = "Macron";
    participants[1] = "Le Pen";
    legende(participants, colorsT2, 65, 30);
    if (displayMode == 0) {    //départements
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 1);
        int x = dataTable[displayMode].getInt(i, 2);
        int y = dataTable[displayMode].getInt(i, 3);
        int taille = dataTable[displayMode].getInt(i, 4);

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
        cheese(pourcentages, x, y, colorsT2, taille, nom, participants);
      }
    } else {                  //régions
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 0);
        int x = dataTable[displayMode].getInt(i, 1);
        int y = dataTable[displayMode].getInt(i, 2);
        int taille = int(dataTable[displayMode].getInt(i, 3) *1);
        float[] pourcentages = new float[2];
        for (int j = 0, iterator = 0; j < regDataT2[i].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(regDataT2[i][22+j].replace(",", "."));
        }
        cheese(pourcentages, x, y, colorsT2, taille, nom, participants);
      }
    }
  }
}

void legende(String[] participants, color[] colors, int startingX, int startingY) {
  if (drawLegend) {
    rectMode(CENTER);
    fill(200, 200, 200);
    for (int i = 0, j = 0; i < participants.length; i++, j+=20) {    //Draw grey rects first
      rect(startingX, startingY+j, 110, 25);
    }
    float[] pourcentage = new float[1];
    pourcentage[0] = 100;
    String[] participantNone = new String[0];
    for (int i = 0, j = 2; i < participants.length; i++, j+=20) {    //Draw participants
      color[] currentColor = new color[1];
      currentColor[0] = colors[i];
      cheese(pourcentage, startingX-35, startingY+j-4, currentColor, 8, "", participantNone);
      fill(0, 0, 0);
      text(participants[i], startingX + 15, startingY+j);
    }
  }
}

void legende(String[] participants, color[] colors, int startingX, int startingY, float[] pourcentages) {
  rectMode(CENTER);
  fill(200, 200, 200);
  for (int i = 0, j = 0; i < participants.length; i++, j+=20) {    //Draw grey rects first
    rect(startingX, startingY+j, 120, 25);
  }

  float[] pourcentage = new float[1];
  pourcentage[0] = 100;
  String[] participantNone = new String[0];
  for (int i = 0, j = 2; i < participants.length; i++, j+=20) {    //Draw participants + pourcentages
    color[] currentColor = new color[1];
    currentColor[0] = colors[i];
    cheese(pourcentage, startingX-65, startingY+j-4, currentColor, 8, "", participantNone);
    fill(0, 0, 0);
    text(participants[i] + " " + pourcentages[i] + " %", startingX + 0, startingY+j);
  }
}

void cheese(float[] data, int x, int y, color[] colors, int taille, String nom, String[] participants) {
  float prevRadian = 0;      //remove to engage partyMode
  for (int i = 0; i < data.length; i++) {
    float degre = data[i]*3.6;
    float radian = radians(degre) + prevRadian;
    fill(colors[i]);
    arc(x, y, taille, taille, prevRadian, radian, PIE);
    prevRadian = radian;
    if (mouseX < x + taille/2 && mouseX > x - taille/2 && mouseY > y - taille/2 && mouseY < y + taille/2) {  //TODO legende jolie avec détails au dessus de l'autre en haut à gauche
      drawLegend = false;
      fill(0, 0, 0);
      text("résultats de " + nom + " : ", 75, 10);
      legende(participants, colors, 90, 30, data);
    } else {
      drawLegend = true;
    }
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
