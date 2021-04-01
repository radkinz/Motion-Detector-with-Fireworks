class Particle {
  float x, y, Vx, Vy, r, varR, varG, varB;
  boolean explode;

  Particle(float xx, float rr, float gg, float bb) {
    x = xx;
    y = height+5;
    Vx = random(-1.5, 1.5);
    Vy = random(-3, 3);
    r = random(5);
    varR = rr;
    varG = gg;
    varB = bb;
    explode = false;
  }

  void update() {
    //apply gravity and velocity
    if (explode) {
      x += Vx;
      y += Vy;
      Vy += random(0.1, 0.2);
    } else {
      y += -7;
    }
  }

  void show() {
    noStroke();
    fill(varR, varG, varB);
    circle(x, y, r*2);
  }
}
