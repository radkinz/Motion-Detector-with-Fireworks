class Firework {
  Particle[] firework = new Particle[100];
  int explodetime, age;
  float x;

  Firework(float xx, float r, float g, float b) {
    x = xx;
    for (int i = 0; i < firework.length; i++) {
      firework[i] = new Particle(x, r, g, b);
    }
    explodetime = round(random(10, 60));
    age = 0;
  }

  void display() {
    //all explode at same time
    age += 1;
    if (age == explodetime) {
      for (int i = 0; i < firework.length; i++) {
        firework[i].explode = true;
      }
    }

    for (int i = 0; i < firework.length; i++) {
      firework[i].update();
      firework[i].show();
    }
  }
}
