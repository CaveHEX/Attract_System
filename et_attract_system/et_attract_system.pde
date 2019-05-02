import peasy.*;

PeasyCam cam;

int agentCount = 1000;    //total number of Points

void setup() {
  size(1280, 720, P3D);
  frameRate(60);

  for (int i = 0; i < sphereCount; i++) {
    spheres.add(new CenterSphere());
  }

  for (int i = 0; i < agents.length; i++) {
    agents[i] = new Agent(i);
  }

  for (int i = 0; i < bins.length; ++i) {
    bins[i] = new Bin(i);
  }

  cam = new PeasyCam(this, 400);
}

void draw() {
  background(10);

  lights();

  for ( Agent a : agents ) {  //update and draw points
    a.separate();
    a.update();
    a.render();
  }

  surface.setTitle("FPS : " + int(frameRate));
}
