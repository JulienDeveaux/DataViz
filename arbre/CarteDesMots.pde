class CarteDesMots extends SimpleMapModel {
    HashMap mots;

    CarteDesMots() {
        mots = new HashMap();
    }

    void ajouter(String mot) {
        Mot item = (Mot) mots.get(mot);
        if(item == null) {
            item = new Mot(mot);
            mots.put(mot, item);
        }
        item.incrementSize();
    }

    void fin() {
        items = new Mot[mots.size()];
        mots.values().toArray(items);
    }
}
