// start code from Daniel Shiffman http://codingtra.in


import peasy.*;
import controlP5.*; 

ControlP5 cp5; 
PGraphics3D g3;
PMatrix3D currentCameraMatrix; 

ArrayList<Firework> fireworks;
ArrayList<PVector> locations = new ArrayList<PVector>(25);

PVector gravity = new PVector(0, 0.2);

int numberOfFireworks = 5;

PeasyCam cam;

float valueVelocity;
float targetVelocity = 1;

void setup() {
  cam = new PeasyCam(this, 1500);
  cp5 = new ControlP5(this); 
  g3 = new PGraphics3D();

  cp5.addSlider("value Velocity").hide(); 
  cp5.addSlider("size")
    .setPosition(10, 20)
    .setRange(1, 100) // values can range from big to small as well
    .setValue(2)
    .hide(); 


  cp5.setAutoDraw(false);
  size(800, 600, P3D);


  fireworks = new ArrayList<Firework>();
  locations = new ArrayList<PVector>();
  colorMode(HSB);
  background(0);
  frameRate(60);
}

void draw() {
  //initialise locations 
  for (int i = 0; i < numberOfFireworks; i++) {
    locations.add(i, new PVector(0, 0, 0));
  }

  pushMatrix();
  hint(ENABLE_DEPTH_TEST);

  valueVelocity = 1;
  // 10% chance we'll have a firework
  int nextIndex = findNextAvailable(locations); // each firework has an index
  if (random(1) < 0.1 && fireworks.size() < numberOfFireworks && nextIndex != -1) {
    Firework newFirework = new Firework(nextIndex);
    fireworks.add(newFirework);
    locations.add(nextIndex, newFirework.firework.returnLocation());
  }

  background(360);
  translate(width/2, height, -1000);

  for (int i = fireworks.size()-1; i >= 0; i--) {
    Firework f = fireworks.get(i);
    f.run(locations);
    if (f.done()) {
      PVector freeVector = new PVector(0, 0, 0);
      locations.add(fireworks.get(i).id, freeVector);
      fireworks.remove(i);
    }
  }

  popMatrix();

  currentCameraMatrix = new PMatrix3D(g3.camera);
  camera();

  drawControllers();
  drawTextLabels();

  fill(-1);

  g3.camera = currentCameraMatrix;
  hint(DISABLE_DEPTH_TEST);
}

private void drawControllers() {
  cp5.getController("value Velocity")
    .setVisible(valueVelocity != 0); 
  cp5.getController("size")
    .setVisible(valueVelocity != 0); 
  cp5.draw();
  // trying to get data from the slider (TO DO) 
  //targetVelocity = (cp5.getController("mySlider")).getValue();

  //cp5.getController("value Velocity");//.setPosition(100, 50);//.setRange(0, 255); 
  //if(cp5.getController("mySlider").getValue() != 0){
  //    targetVelocity = cp5.getController("mySlider").getValue();
  //    
  //}
}

private void drawTextLabels() {
  fill(-1);

  text("Target Velocity: " + targetVelocity, 10, height - 20);
  text("Number of Fireworks: " + fireworks.size(), 10, height - 10);
}

private int findNextAvailable(ArrayList<PVector> locations) {
  PVector freeVector = new PVector(0, 0, 0);
  for (int i = 0; i < locations.size(); i++) {
    if (locations.get(i).x == freeVector.x && locations.get(i).y == freeVector.y && locations.get(i).z == freeVector.z) {
      return i;
    }
  }
  return -1;
}
