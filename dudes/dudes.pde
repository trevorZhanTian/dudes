int runAmt = 100;// Number of runners
int chaseAmt = 5;// Number of chasers
Dude[] runDudes;
Dude[] chaseDudes;
float maxSpeed = 2;// Ensuring the dudes don't keep accelerating
float maxForce = 0.1;// Setting a max force for attraction of runner to chaser so the motion is smoother
float catchDistance = 5;

void setup() {
  size(720, 720);
  
  runDudes = new Dude[runAmt];
  for (int i=0; i<runAmt; i++) {
    runDudes[i] = new Dude(true);
  }
  
  chaseDudes = new Dude[chaseAmt];
  for (int i=0; i<chaseAmt; i++) {
    chaseDudes[i] = new Dude(false);
  }
}

void draw() {
  background(0);
  
  for (int i=0; i<runAmt; i++) {
    runDudes[i].update();
    runDudes[i].display();
  }
  
  for (int i=0; i<chaseAmt; i++) {
    chaseDudes[i].update();
    chaseDudes[i].display();
  }
}
