class Mot extends SimpleMapItem {
    String mot;

    Mot(String mot) {
        this.mot = mot;
    }

    void draw() {
        fill(255);
        rect(x, y, w, h);
        fill(0);
        if(w > textWidth(mot) + 6) {
            if(h > textAscent() + 6) {
                textAlign(CENTER, CENTER);
                text(mot, x + w/2, y + h/2);
            }
        }
    }
}
