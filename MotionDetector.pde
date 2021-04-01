import processing.video.*;
Capture cam;
PImage screenshot;
ArrayList<Blob> blobs = new ArrayList<Blob>();
ArrayList<Firework> f;
int xx, yy; //should be named startX and startY but these are here to track the places or origin for the screenshots for when the user initially begins to seellect an objeect
int blobcounter, fireworkCounter;
color c;
boolean addBlob, touch, firework, nullScreenshot;

void setup() {
  size(1200, 480);
  cam = new Capture(this, Capture.list()[1]);
  cam.start();
  screenshot = createImage(100, 100, RGB);
  noStroke();
  f = new ArrayList<Firework>();
  addBlob = true;
  touch = false;
  firework = false;
  nullScreenshot = true;
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }

  background(0);
  image(cam, 0, 0);
  if (nullScreenshot) { //if there is a screenshot with an objeect to track, display it, otherwise ddisplay the default screensshoot wiith directioonss
    defaultScreenshot();
  } else {
    screenshot.resize(100, 0);
    image(screenshot, 0, 0);
  }
  
  //directions
  textAlign(LEFT);
  fill(255);
  text("If the tracked objects get close together, a firework will appear in the canvas below", cam.width+10, 20);
  text("HINT: If your objects are not tracked efficiently, then try re-selecting the object :)", cam.width+10, 40);

//firework good stufff
  if (firework) {
    fireworkCounter += 1; //doesn't spawn a ton of fireworks at a time
    if (fireworkCounter == 5) {
      f.add(new Firework(random(730, width), random(255), random(255), random(255)));
      fireworkCounter = 0;
    }
  }

  if (f.size() > 30) {
    f.remove(0);
  }

  for (Firework i : f) {
    i.display();
  }

  if (touch && !nullScreenshot) {
    firework = true;
  } else {
    firework = false;
  }
  
  //blob aka object stuff
  blobs.clear();
  addBlob = true;

  if (!nullScreenshot) {
    for (int col = 0; col < cam.width; col++) {
      for (int row = 0; row < cam.height; row++) {
        if (cam.get(col, row) >= c-400 && cam.get(col, row) <= c+400) {
          //for every pixel found that is within the same color threshold as the desired object, check to see if that pixel is near any other "found object pixels" 
          for (int i = 0; i < blobs.size(); i++) { 
            if (blobs.get(i).newBlob(col, row)) { //checks the distance to see if the pixel is a new blob or part of an existing blob
              addBlob = true;
            } else {
              blobs.get(i).update(col, row); //if the pixel is a part of an existing blob then update that blob's min and max values <- this allows for blobs to know their size so if you are tracking hands then the computer can roughly tell the different between two sseparate hands
              addBlob = false;
              break;
            }
          }

          if (addBlob) {
            blobs.add(new Blob(col, row));
          }
        }
      }
    }
  }
  
  //check to see if the majority of the blobs are touching
  for (int i = 0; i < blobs.size(); i++) {
    for (int j = 0; j < blobs.size(); j++) {
      if (j != i) {
        if (dist(blobs.get(i).cx, blobs.get(i).cy, blobs.get(j).cx, blobs.get(j).cy) < 200) {
          touch = true;
        } else {
          touch = false;
          blobcounter += 1;
          if (blobcounter > blobs.size()*.8) {
            break;
          }
        }
      }
    }
  }
  
  for (int i = 0; i < blobs.size(); i++) {
    blobs.get(i).show();
  }

  if (mousePressed) {
    drawRect();
  }
}

void drawRect() {
  stroke(255);
  noFill();
  rect(xx, yy, mouseX-xx, mouseY-yy);
}

color avgC(int w, int h, PImage img) {
  float r = 0;
  float g = 0;
  float b = 0;
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      r +=  red(img.get(x, y));
      g += green(img.get(x, y));
      b += blue(img.get(x, y));
    }
  }

  return color(r/(w*h), g/(w*h), b/(w*h));
}

void mousePressed() {
  xx = mouseX;
  yy = mouseY;
}

void mouseReleased() {
  if (xx == mouseX && yy == mouseY) {
    nullScreenshot = true;
  } else {
    nullScreenshot = false;
    screenshot();
    c = avgC(screenshot.width, screenshot.height, screenshot);
  }
}

void screenshot() {
  //these if statements are to prevent negative img width so tthe usser can selectt an object by drawing the rect in any direction
  if (xx < mouseX && yy < mouseY) {
    screenshot = createImage(mouseX-xx, mouseY-yy, RGB);
    translate(xx, yy);
    for (int col = 0; col < screenshot.width; col++) {
      for (int row = 0; row < screenshot.height; row++) {
        screenshot.set(col, row, cam.get(xx+col, yy+row));
      }
    }
  }

  if (xx > mouseX && yy > mouseY) {
    screenshot = createImage(xx-mouseX, yy-mouseY, RGB);
    translate(mouseX, mouseY);
    for (int col = 0; col < screenshot.width; col++) {
      for (int row = 0; row < screenshot.height; row++) {
        screenshot.set(col, row, cam.get(mouseX+col, mouseY+row));
      }
    }
  }

  if (xx < mouseX && yy > mouseY) {
    screenshot = createImage(mouseX-xx, yy-mouseY, RGB);
    translate(xx, mouseY);
    for (int col = 0; col < screenshot.width; col++) {
      for (int row = 0; row < screenshot.height; row++) {
        screenshot.set(col, row, cam.get(col+xx, row+mouseY));
      }
    }
  }

  if (xx > mouseX && yy < mouseY) {
    screenshot = createImage(xx-mouseX, mouseY-yy, RGB);
    translate(mouseX, yy);
    for (int col = 0; col < screenshot.width; col++) {
      for (int row = 0; row < screenshot.height; row++) {
        screenshot.set(col, row, cam.get(col+mouseX, row+yy));
      }
    }
  }
}

void defaultScreenshot() {
  screenshot = createImage(100, 100, RGB);
  for (int col = 0; col < screenshot.width; col++) {
    for (int row = 0; row < screenshot.height; row++) {
      screenshot.set(col, row, 0);
    }
  }
  image(screenshot, 0, 0);

  textAlign(CENTER);
  fill(255);
  textSize(13);
  text("Drag and Press", 50, 15);
  text("the Mouse", 50, 40);
  text("to select an", 50, 65);
  text("Object to Track", 50, 90);
}
