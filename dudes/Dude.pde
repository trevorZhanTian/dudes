class Dude {
  private float diam;
  PVector pos, vel, acc;
  boolean isRunner;
  boolean isCaught;
  
  public Dude(boolean isRunner) {
    this.isRunner = isRunner;
    this.isCaught = false;
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D();
    acc = new PVector();
    
    if (isRunner) {
      diam = random(4, 6);
      maxSpeed = 2;
    } else {
      diam = random(6, 8);
      maxSpeed = 4;
    }
  }
  
  public void update() {
    if (isRunner && !isCaught) {
      PVector escape = avoidNearestChaser();
      escape.mult(1.2);
      acc.add(escape);
      checkIfCaught();
    } else if (!isRunner) {
      PVector chase = chaseNearestRunner();
      acc.add(chase);
    }
    
    
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
        break;
      }
    }
  }
  
  private PVector chaseNearestRunner() {
    float minDist = Float.POSITIVE_INFINITY;
    PVector target = new PVector();
    Dude nearestRunner = null;
    
    for (int i = 0; i < runDudes.length; i++) {
      Dude runner = runDudes[i];
      if (!runner.isCaught) {
        float d = PVector.dist(pos, runner.pos);
        if (d < minDist) {
          minDist = d;
          target = runner.pos.copy();
          nearestRunner = runner;
        }
      }
    }
    
    if (nearestRunner == null) {
      return new PVector(0, 0);
    }
    
    PVector desired = PVector.sub(target, pos);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }
  
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
