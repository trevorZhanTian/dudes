class Dude {
  private float diam;
  PVector pos, vel, acc;
  boolean isRunner;
  boolean isCaught;
  
  //Dude Constructor
  public Dude(boolean isRunner) {
    this.isRunner = isRunner;
    this.isCaught = false;
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D();
    acc = new PVector();
    
    //Uses a boolean variable to differentiate to type of dudes
    if (isRunner) {
      diam = random(4, 6);
      maxSpeed = 2;
    } else {
      diam = random(6, 8);
      maxSpeed = 4;
    }
  }

  
  public void update() {  
    // Determine and apply behavior to different dudes
    if (isRunner && !isCaught) {
      PVector escape = avoidNearestChaser();
      escape.mult(1.2);
      acc.add(escape);
      checkIfCaught();
    } else if (!isRunner) {
      PVector chase = chaseNearestRunner();
      acc.add(chase);
    }
    
    // Only move if dude is not caught
    if (!isCaught || !isRunner) {
      vel.add(acc);
      vel.limit(maxSpeed);
      pos.add(vel);
      acc.mult(0);
      boundaryTest();
    }
  }
 
  
  private void checkIfCaught() {
    for (int i = 0; i < chaseDudes.length; i++) {
      Dude chaser = chaseDudes[i];
      float d = PVector.dist(pos, chaser.pos);
      if (d < catchDistance) {
        isCaught = true;
        vel.mult(0);
        acc.mult(0);
      }
    }
  }
  
  
  private PVector chaseNearestRunner() {
    Dude nearestRunner = findNearestRunner();
    if (nearestRunner == null) {
      return new PVector(0, 0);
    }
    return calculateChaseForce(nearestRunner);
  }


  // Find the nearest uncaught runner
  private Dude findNearestRunner() {
    float minDist = Float.POSITIVE_INFINITY;
    Dude nearestRunner = null;
    
    for (int i = 0; i < runDudes.length; i++) {
      Dude runner = runDudes[i];
      if (!runner.isCaught) {
        float d = PVector.dist(pos, runner.pos);
        if (d < minDist) {
          minDist = d;
          nearestRunner = runner;
        }
      }
    }
    return nearestRunner;
  }


  // Calculate steering force towards target
  private PVector calculateChaseForce(Dude target) {
    PVector desired = PVector.sub(target.pos, pos);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }
  
   // Calculate the force of runners if encountering a chaser within certain distance
  private PVector avoidNearestChaser() {
    float detectionRadius = 100;
    PVector escape = new PVector();
    for (int i = 0; i < chaseDudes.length; i++) {
      Dude chaser = chaseDudes[i];
      float d = PVector.dist(pos, chaser.pos);
      if (d < detectionRadius) {
        
        PVector diff = PVector.sub(pos, chaser.pos);
        escape.add(diff);
      }
    }
    
    return finalizeEscapeForce(escape);
  }
  
    
  private PVector finalizeEscapeForce(PVector escape) {
    if (escape.mag() > 0) {
      escape.normalize();
      escape.mult(maxSpeed);
      PVector steer = PVector.sub(escape, vel);
      steer.limit(maxForce);
      return steer;
    }
    return new PVector(0, 0);
  }
  
  
  public void display() {
    // Set color based on dudes' state
    if (isRunner) {
      if (isCaught) {
        stroke(color(128, 128, 128)); 
      } else {
        stroke(color(100, 255, 100)); 
      }
    } else {
      stroke(color(255, 100, 100)); 
    }
    strokeWeight(diam);
    point(pos.x, pos.y);
  }
  
  
  public void boundaryTest() {
    if (pos.x < diam*.5) {
      pos.x = diam*.5;
      vel.x *= -1;
    } else if (pos.x > width-diam*.5) {
      pos.x = width-diam*.5;
      vel.x *= -1;
    }
    
    if (pos.y < diam*.5) {
      pos.y = diam*.5;
      vel.y *= -1;
    } else if (pos.y > height-diam*.5) {
      pos.y = height-diam*.5;
      vel.y *= -1;
    }
  }
}
