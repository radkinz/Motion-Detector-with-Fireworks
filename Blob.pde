class Blob {
  float minx, miny, maxx, maxy, cx, cy;

  Blob(float xx, float yy) {
    minx = xx;
    miny = yy;
    maxx = xx;
    maxy = yy;
    cx = (minx+maxx)/2;
    cy = (miny+maxy)/2;
  }

  void update(float xx, float yy) {
    minx = min(minx, xx);
    miny = min(miny, yy);
    maxx = max(maxx, xx);
    maxy = max(maxy, yy);
  }

  void show() {
    if (touch) {
      fill(255, 0, 255);
    } else {
      fill(255);
    }
    circle(cx, cy, 50);
  }

  boolean newBlob(float xx, float yy) {
    cx = (minx+maxx)/2;
    cy = (miny+maxy)/2;

    if (dist(xx, yy, cx, cy) < 150) {
      return false;
    } else {
      return true;
    }
  }
}
