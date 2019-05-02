ArrayList<CenterSphere> spheres = new ArrayList<CenterSphere>();
int sphereCount = 5; //number of center spheres

class CenterSphere {
  PVector pos;
  PVector vel;
  PVector acc;
  float friction = 0.4;
  float size;

  CenterSphere() {
    float amp = 50;
    pos = new PVector(random(-amp, amp), random(-amp, amp), random(-amp, amp));
    vel = new PVector();
    acc = new PVector();
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    PVector temp = new PVector();
    applyForce(spin(temp));
    separate();

    float t = frameCount * 0.001;
    float ex = 0.001;
    size = noise(t + pos.x * ex, t + pos.y * ex, t + pos.z * ex) * 250 + 50;
  }
  void render() {
    push();
    translate(pos.x, pos.y, pos.z);
    fill(50, 50, 200);
    noStroke();
    sphereDetail(20);
    sphere(size);
    pop();
  }

  void physics() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    vel.mult(friction);
  }

  void separate() {
    PVector desired = new PVector();
    for ( CenterSphere s : spheres ) {
      float dist = PVector.dist(pos, s.pos);
      if ( dist < (size + s.size) / 2 && s != this ) {
        PVector temp = PVector.sub(s.pos, pos);
        temp.mult(1 / dist);
        desired.add(temp);
      }
    }
    applyForce(desired.mult(-1));
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);  // A vector pointing from the position to the target

    // Scale to maximum speed
    desired.setMag(10);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(1);  // Limit to maximum steering force
    return steer;
  }

  PVector spin(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(300);
    PVector n = new PVector(
      noise(frameCount*.01, pos.y*.02, pos.z*.02)-.5, 
      noise(pos.x*.02, frameCount*.01, pos.z*.02)-.5
      );

    n.z = -(desired.x*n.x+desired.y*n.y)/desired.z;
    n.setMag(.5);

    return n;
  }
}
