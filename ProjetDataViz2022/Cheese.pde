class Cheese {
  float prevRadian = 0;
  
  Cheese(float[] data, int x, int y, color[] colors, int taille) {
    for(int i = 0; i < data.length; i++) {
      float degre = data[i]*3.6;
      float radian = radians(degre) + prevRadian;
      fill(colors[i]);
      arc(x, y, taille, taille, prevRadian, radian, PIE);
      prevRadian = radian;
    }
  }
}
