// Daniel Shiffman
// start code from Daniel Shiffman http://codingtra.in


import peasy.*;
import controlP5.*; 

ControlP5 cp5; 
PGraphics3D g3;
PMatrix3D currentCameraMatrix; 

ArrayList<Firework> fireworks;

PVector gravity = new PVector(0, 0.2);

PeasyCam cam;

float valueVelocity;
float targetVelocity = 1;

void setup() {
  cam = new PeasyCam(this, 1500);
  cp5 = new ControlP5(this); 
  g3 = new PGraphics3D();

  cp5.addSlider("value Velocity").hide(); 
  
  cp5.setAutoDraw(false);
  size(800, 600, P3D);


  fireworks = new ArrayList<Firework>();
  colorMode(HSB);
  background(0);
  frameRate(60);
}

void draw() {
  
  pushMatrix();
  hint(ENABLE_DEPTH_TEST);

  valueVelocity = 1;
  // 10% chance we'll have a firework
  if (random(1) < 0.1) {
    fireworks.add(new Firework());
  }

  background(0);
  translate(width/2, height, -1000);

  // Floor
  stroke(255);
  strokeWeight(1);
  fill(51);
  beginShape();
  vertex(-width, height/2, -800);
  vertex(width, height/2, -800);
  vertex(width, height/2, 800);
  vertex(-width, height/2, 800);
  endShape(CLOSE);


  for (int i = fireworks.size()-1; i >= 0; i--) {
    Firework f = fireworks.get(i);
    f.run();
    if (f.done()) {
      fireworks.remove(i);
    }
  }
  popMatrix();
  
  currentCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  cp5.getController("value Velocity").setVisible(valueVelocity != 0); 
  //if(cp5.getController("mySlider").getValue() != 0){
  //    targetVelocity = cp5.getController("mySlider").getValue();
  //    text("Target Velocity: " + targetVelocity, 10, 20);
  //}
  
  cp5.draw();
  
  fill(-1);
  text("Number of Fireworks: " + fireworks.size(), 10, 10);


  g3.camera = currentCameraMatrix;
  hint(DISABLE_DEPTH_TEST);
}
