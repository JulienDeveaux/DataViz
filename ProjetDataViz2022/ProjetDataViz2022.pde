PImage carte;
Table[] dataTable;
int displayMode = 0;

void setup() {
  size(1138, 1080);
  carte = loadImage("France_départementale.png");
  Table regionTable = new Table("regions-francaises.tsv");
  Table deptTable = new Table("departements-francais.tsv");
  dataTable = new Table[2];
  dataTable[0] = deptTable;
  dataTable[1] = regionTable;
  //getData();
}

void draw() {
  noLoop();
  textAlign(CENTER);  // Spécifie que le texte est centré par rapport aux coordonnées de dessin.

  background(255);
  carte.resize(1138,1080);
  image(carte, 0, 0);

  smooth();
  fill(192, 0, 0);
  noStroke();
  if(displayMode == 0) {
    for(int i = 1; i < dataTable[displayMode].getRowCount(); i++) {
      String nom = dataTable[displayMode].getString(i, 1);
      int x = dataTable[displayMode].getInt(i, 2);
      int y = dataTable[displayMode].getInt(i, 3);
      int taille = dataTable[displayMode].getInt(i, 4);
      float[] pourcentages = new float[3];
      pourcentages[0] = 40;
      pourcentages[1] = 30;
      pourcentages[2] = 30;
      println(nom);
      color[] colors = new color[3];
      colors[0] = color(255, 0, 0);
      colors[1] = color(0, 0, 255);
      colors[2] = color(0, 255, 0);
      new Cheese(pourcentages, x, y, colors, taille);
    }
  } else {
    //concaténer les données par région ici
  }
}

void getData() {
  File dataPremier = new File("data/permierTour.txt");
  File dataSecond = new File("data/secondTour.txt");
  if(!dataPremier.exists() || !dataSecond.exists()) {
    PrintWriter writerOne = createWriter(dataPath("permierTour.txt"));
    PrintWriter writerTwo = createWriter(dataPath("secondTour.txt"));
    String[] dataDept = loadStrings("https://www.data.gouv.fr/fr/datasets/r/8b4d68f6-4490-4afc-b632-6c259073a4b9");
    String[] dataRegion = loadStrings("https://www.data.gouv.fr/fr/datasets/r/cbf026c5-e0bf-4ff8-b1cd-eb994cd26290"); //<>//
    
    Table regionTable = new Table();
    Table deptTable = new Table();//les tables sont pour les fichiers du prof c'est limité a leur format -> pourri
    for(int i = 0; i < dataDept.length; i++) {
      String[][] data = matchAll(dataDept[0], ";(.*?);");
      if(i == 0) {
        //deptTable.setRowName(rownum, data[rownum][1]);
        println(deptTable);
      } else {
        
      }
    }
    writerOne.flush();
    writerOne.close();
    writerTwo.flush();
    writerTwo.close();
  }
}
