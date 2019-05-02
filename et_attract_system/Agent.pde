Agent[] agents = new Agent[agentCount];

class Agent {

  PVector pos;
  PVector vel;
  PVector acc;
  float friction = 0.7;
  float size = 5;
  
  int index;              // Point index number
  int binIndex = 0;       // I'm in this bin
  float sphereSize = 0;   // center sphere size
  int bor;                // Polarity
  color col;

  Agent(int index) {
    this.index = index;
    bor = index % 2;
    col = (bor == 0) ? color(255, 0, 0) : color(0, 0, 255);                                                                                              //point index number
    pos = new PVector(random(-bw2+buffer, bw2-buffer), random(-bh2+buffer, bh2-buffer), random(-bd2+buffer, bd2-buffer));
    vel = new PVector();
    acc = new PVector();
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    this.physics();

    int xBinNum, yBinNum, zBinNum, tempBinIndex;

    xBinNum = floor((pos.x + bw2) / binSize);     // because p.x can range between -bw2 and bw2 and the bins must be positive we add +bw2 to shift the range from (-bw2,bw2) to (0,bw)
    yBinNum = floor((pos.y + bh2) / binSize);
    zBinNum = floor((pos.z + bd2) / binSize);
    tempBinIndex = xBinNum + (yBinNum * binWidth) + (binWidth * binHeight * zBinNum);

    PVector temp = new PVector(10000, 10000, 10000);

    for ( CenterSphere s : spheres ) {
      float distA = dist(pos.x, pos.y, pos.z, s.pos.x, s.pos.y, s.pos.z);
      float distB = dist(pos.x, pos.y, pos.z, temp.x, temp.y, temp.z);

      if ( distA <= distB ) {
        temp = s.pos.copy();
        sphereSize = s.size;
      }
    }

    if ( tempBinIndex != binIndex ) {
      bins[tempBinIndex].list.add(agents[index]);
      bins[binIndex].list.remove(agents[index]);

      binIndex = tempBinIndex;
    }
    
    this.boundaries();
    
    PVector ct = new PVector();
    ct = pos.copy();
    ct.mult(-1);
    ct.setMag(.1);

    this.applyForce(ct);
  }

  void render() {
    push();
    translate(pos.x, pos.y, pos.z);   
    noStroke();
    fill(col);
    sphereDetail(3, 3);
    sphere(15);
    pop();
  }

  void physics() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    vel.mult(friction);
  }

  void separate() {
    PVector desired = new PVector(0, 0, 0);

    for (int i = 0; i < bins[binIndex].binRef.length; ++i) {
      int cbinNum = bins[binIndex].binRef[i];   //current binNum

      for (int k = 0; k < bins[cbinNum].list.size(); ++k) {
        float dist = dist(pos.x, pos.y, pos.z, bins[cbinNum].list.get(k).pos.x, bins[cbinNum].list.get(k).pos.y, bins[cbinNum].list.get(k).pos.z);
        if ( dist < 40 && dist != 0 ) {
          PVector temp = PVector.sub(bins[cbinNum].list.get(k).pos, pos);
          if ( bins[cbinNum].list.get(k).bor != bor ) {
            temp.mult(-1/dist);
          } else {
            temp.mult(1/dist);
          }
          stroke(255, 50);
          strokeWeight(1);
          if ( bins[cbinNum].list.get(k).index < index ) {
            line(pos.x, pos.y, pos.z, bins[cbinNum].list.get(k).pos.x, bins[cbinNum].list.get(k).pos.y, bins[cbinNum].list.get(k).pos.z);
          }
          desired.add(temp);
        }
      }
    }
    applyForce(desired.mult(-1));
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);  // A vector pointing from the position to the target
    
    // Scale to maximum speed
    desired.setMag(200);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(.5);  // Limit to maximum steering force
    if ( dist(target.x, target.y, target.z, pos.x, pos.y, pos.z) <= sphereSize ) {
      vel.sub(steer);
      steer = desired.mult(0);
    }
    return steer;
  }
  
  void boundaries() {
    if (pos.x<-bw2+buffer) {
      vel.x*=-1;
      pos.x=-bw2+buffer;
    }

    if (pos.x>bw2-buffer) {
      vel.x*=-1;
      pos.x=bw2-buffer;
    }
    if (pos.y<-bh2+buffer) {
      vel.y*=-1;
      pos.y=-bh2+buffer;
    }

    if (pos.y>bh2-buffer) {
      vel.y*=-1;
      pos.y=bh2-buffer;
    }
    if (pos.z<(-bd2+buffer)) {
      vel.z*=-1;
      pos.z=-bd2+buffer;
    }

    if (pos.z>(bd2-buffer)) {
      vel.z*=-1;
      pos.z=bd2-buffer;
    }
  }
}
