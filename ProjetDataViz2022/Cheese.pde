class Cheese {
  float prevRadian = 0;
  int taille;
  int x;
  int y;
  color[] colors;
  String nom;
  String[] participants;
  float[] data;
  Integrator[] interp;

  public Cheese(int x, int y, int taille, String nom, String[] participants, color[] colors) {
    this.x = x;
    this.y = y;
    this.taille = taille;
    this.nom = nom;
    this.participants = participants;
    this.colors = colors;
  }

  public Cheese setParticipants(String[] participants) {
    this.participants = participants;
    return this;
  }

  public Cheese setData(float[] data) {
    if (this.data != null && data.length == this.data.length) {
      boolean isEqual = true;
      for (int i = 0; i < data.length; i++) {
        if (data[i] != this.data[i]) {
          isEqual = false;
        }
      }
      if (!isEqual) {
        this.interp = new Integrator[data.length];
        for (int ligne = 0; ligne < data.length; ligne++) {
          this.interp[ligne] = new Integrator(0.1, 0.9, 0.2);
          this.interp[ligne].target(data[ligne]);
        }
        this.data = data;
      }
    } else {
      this.interp = new Integrator[data.length];
      for (int ligne = 0; ligne < data.length; ligne++) {
        this.interp[ligne] = new Integrator(data[ligne]/2, 0.9, 0.4);
        this.interp[ligne].target(data[ligne]);
      }
      this.data = data;
    }

    return this;
  }

  public void drawCheese() {
    if (mouseX < x + taille/2 && mouseX > x - taille/2 && mouseY > y - taille/2 && mouseY < y + taille/2) {
      for (int i = 0; i < data.length; i++) {
        interp[i].update();
      }
      prevRadian = 0;
      fill(200, 200, 200);
      circle(x, y, taille);
      for (int i = 0; i < data.length; i++) {
        fill(0, 0, 0);
        text("résultats de " + nom + " : ", 75, 10);
        legende(participants, colors, 90, 30, data);
        float degre = interp[i].value*3.6;
        float radian = radians(degre) + prevRadian;
        fill(colors[i]);
        arc(x, y, taille, taille, prevRadian, radian, PIE);
        prevRadian = radian;
      }
    }
  }
}
