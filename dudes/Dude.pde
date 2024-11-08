class Dude {
  private float diam;
  PVector pos, vel, acc;
  boolean isRunner;
  
  public Dude(boolean isRunner) {
    this.isRunner = isRunner;
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D();
    acc = new PVector();
    
    if (isRunner) {
      diam = random(2, 4);
      maxSpeed = 2;
    } else {
      diam = random(4, 6);
      maxSpeed = 3;
    }
  }
  
  public void update() {
    if (isRunner) {
      PVector escape = avoidNearestChaser();
      escape.mult(1.2);
      acc.add(escape);
    } else {
      PVector chase = chaseNearestRunner();
      acc.add(chase);
    }
    
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    
    boundaryTest();
  }
  
  private PVector chaseNearestRunner() {
    float minDist = Float.POSITIVE_INFINITY;
    PVector target = new PVector();
    
    for (int i = 0; i < runDudes.length; i++) {
      Dude runner = runDudes[i];
      float d = PVector.dist(pos, runner.pos);
      if (d < minDist) {
        minDist = d;
        target = runner.pos.copy();
      }
    }
    
    PVector desired = PVector.sub(target, pos);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
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
      return steer;
    }
    return new PVector(0, 0);
  }
  
  public void display() {
    if (isRunner) {
        stroke(color(100, 255, 100)); 
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
