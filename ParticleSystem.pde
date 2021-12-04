// start code from Daniel Shiffman http://codingtra.in

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class Firework {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  Particle firework;
  float hu;
  int id;

  Firework(int givenId) {
    hu = random(255);
    firework = new Particle(random(-width/2, width/2), height/2, random(-800, 800), hu);
    //firework = new Particle(width/2, height/2, 800, hu);
    id = givenId;
    particles = new ArrayList<Particle>();   // Initialize the arraylist
  }

  boolean done() {
    if (firework == null && particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

  void run(ArrayList<PVector> locations) {
    if (firework != null) {

      boolean notDead = checkForCollusion();
      if (notDead) {
        fill(hu, 255, 255);
        firework.applyForce(gravity);
        firework.update(locations, id);
        firework.display();


        if (firework.explode()) {
          for (int i = 0; i < 50; i++) {
            particles.add(new Particle(firework.location, hu));    // Add "num" amount of particles to the arraylist
          }
          firework = null;
        }
      }
    }

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      //p.applyForce(gravity);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }


  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

  private boolean checkForCollusion() {
    println("compare for this firework " + firework.location);
    int usedSpace = 0;
    while (firework != null) {
      // checking if there are other fireworks at the same location as our firework
      for (int i = 0; i < locations.size()&& firework != null; i++ ) {

        println("we compare with location " + locations.get(i));

        if (firework.location != null && locations.get(i) == firework.location) {
          usedSpace += 1;
          // if there's more than 1 particle at that location -> explode it
          if (usedSpace > 2) {
            firework.forceExplode();
            for (int j = 0; j < 50; j++) {
              particles.add(new Particle(firework.location, hu));    // Add "num" amount of particles to the arraylist
            }
            firework = null;
            println("OMG");

            return false;
          }
        }
      }
    }
    return true;
  }
}
