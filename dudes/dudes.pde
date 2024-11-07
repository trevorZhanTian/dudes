int amt = 1000;

Dude [] dudes;

void setup(){
  size(720, 720);
  
  dudes = new Dude[amt];
  for(int i=0; i<amt; i++){
    dudes[i] = new Dude(random(width), random(height));
  }
}

void draw(){
  for(int i=0; i<amt; i++){
    dudes[i].update();
  }
  
  background(0);
  for(int i=0; i<amt; i++){
    dudes[i].display();
  }
  
}
