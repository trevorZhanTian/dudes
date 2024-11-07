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
  }
  
  public void display(){
    stroke(255);
    strokeWeight(diam);
    point(pos.x, pos.y);
  }
  
  
}
