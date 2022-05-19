PImage carte; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
Table[] dataTable;
int displayMode = 0;
int tour = 1;
String[][] deptDataT1;
String[][] regDataT1;
color[] colorsT1;
String[][] deptDataT2;
String[][] regDataT2;
color[] colorsT2;
float prevRadian = 0;    //for partyMode -> to Delete

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
    if (displayMode == 0) {    //départements
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 1);
        int x = dataTable[displayMode].getInt(i, 2);
        int y = dataTable[displayMode].getInt(i, 3);
        int taille = dataTable[displayMode].getInt(i, 4);
        float[] pourcentages = new float[12];
        for (int j = 0, iterator = 0; j < deptDataT1[i+1].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(deptDataT1[i+1][22+j].replace(",", "."));
        }
        cheese(pourcentages, x, y, colorsT1, taille, nom);
      }
    } else {                  //régions
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 0);
        int x = dataTable[displayMode].getInt(i, 1);
        int y = dataTable[displayMode].getInt(i, 2);
        int taille = int(dataTable[displayMode].getInt(i, 3) *1);
        float[] pourcentages = new float[12];
        for (int j = 0, iterator = 0; j < regDataT1[i+1].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(regDataT1[i+1][22+j].replace(",", "."));
        }
        cheese(pourcentages, x, y, colorsT1, taille, nom);
      }
    }
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
  } else {
    if (displayMode == 0) {    //départements
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 1);
        int x = dataTable[displayMode].getInt(i, 2);
        int y = dataTable[displayMode].getInt(i, 3);
        int taille = dataTable[displayMode].getInt(i, 4);
        float[] pourcentages = new float[2];
        for (int j = 0, iterator = 0; j < deptDataT2[i+1].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(deptDataT2[i+1][22+j].replace(",", "."));
        }
        cheese(pourcentages, x, y, colorsT2, taille, nom);
      }
    } else {                  //régions
      for (int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
        String nom = dataTable[displayMode].getString(i, 0);
        int x = dataTable[displayMode].getInt(i, 1);
        int y = dataTable[displayMode].getInt(i, 2);
        int taille = int(dataTable[displayMode].getInt(i, 3) *1);
        float[] pourcentages = new float[2];
        for (int j = 0, iterator = 0; j < regDataT2[i+1].length - 22; j+=6, iterator++) {
          pourcentages[iterator] = float(regDataT2[i+1][22+j].replace(",", "."));
        }
        cheese(pourcentages, x, y, colorsT2, taille, nom);
      }
    }
    String[] participants = new String[2];
    participants[0] = "Macron";
    participants[1] = "Le Pen";
    legende(participants, colorsT2, 65, 30);
  }
}

void legende(String[] participants, color[] colors, int startingX, int startingY) {
  rectMode(CENTER);
  fill(200, 200, 200);
  for (int i = 0, j = 0; i < participants.length; i++, j+=20) {    //Draw grey rects first
    rect(startingX, startingY+j, 100, 25);
  }
  fill(0, 0, 0);
  float[] pourcentage = new float[1];
  pourcentage[0] = 100;
  for (int i = 0, j = 2; i < participants.length; i++, j+=20) {
    color[] currentColor = new color[1];
    currentColor[0] = colors[i];
    cheese(pourcentage, startingX-25, startingY+j-4, currentColor, 8, "");
    text(participants[i], startingX + 8, startingY+j);
  }
}

void cheese(float[] data, int x, int y, color[] colorsT1, int taille, String nom) {
  float prevRadian = 0;      //remove to engage partyMode
  for (int i = 0; i < data.length; i++) {
    float degre = data[i]*3.6;
    float radian = radians(degre) + prevRadian;
    fill(colorsT1[i]);
    arc(x, y, taille, taille, prevRadian, radian, PIE);
    prevRadian = radian;
    if (mouseX < x + taille/2 && mouseX > x - taille/2 && mouseY > y - taille/2 && mouseY < y + taille/2) {
      fill(0, 0, 0);
      text(nom, x, y + taille/2 + 10);
    }
  }
}

void getData() {
  File dataPremier = new File("data/permierTour.txt");
  File dataSecond = new File("data/secondTour.txt");
  if (!dataPremier.exists() || !dataSecond.exists()) {
    PrintWriter writerOne = createWriter(dataPath("permierTour.txt"));
    PrintWriter writerTwo = createWriter(dataPath("secondTour.txt"));

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
    writerOne.flush();          //TODO écrire dans les fichiers (on a les données que du premier tour la
    writerOne.close();
    writerTwo.flush();
    writerTwo.close();
  } else {
    //read files
  }
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
