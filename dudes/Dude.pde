class Dude {
  
  private float diam;
  PVector pos, pPos, vel, acc;
  
  public Dude(float x, float y) {
    pos = new PVector(x, y);
    pPos = new PVector(x, y);
    diam = random(2, 5);
    vel = PVector.random2D();
    acc = new PVector();
  }
  
  public void update(){
    vel.add(acc);
    pos.add(vel);
    boundaryTest();
  }
  
  public void display(){
    stroke(255);
    strokeWeight(diam);
    point(pos.x, pos.y);
  }
  
  public void boundaryTest(){
    if(pos.x<diam*.5){//Left Boundary
      pos.x = diam*.5;
      vel.x *= -1;
    }else if(pos.x>width-diam*.5){//Right Boundary
      pos.x = width-diam*.5;
      vel.x *= -1;
    }
    
    if(pos.y<diam*.5){//Top Boundary
      pos.y = diam*.5;
      vel.y *= -1;
    }else if(pos.y>height-diam*.5){//Bottom Boundary
      pos.y = height-diam*.5;
      vel.y *= -1;
    }
  }
  
  
}
