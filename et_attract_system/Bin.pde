int buffer = 200;   //buffer on sides of screen
int binSize = 50;   //size of Bins
int bw = 3000, bh = 3000, bd = 3000;        //boundary dimentions
int bw2 = bw/2, bh2 = bh/2, bd2 = bd/2; //boundary dimentions divided by 2 because it came up so frequently
int binWidth = ceil(bw/binSize);
int binHeight = ceil(bh/binSize);
int binDepth = ceil(bd/binSize);
Bin[] bins = new Bin[binWidth*binHeight*binDepth];

class Bin {

  ArrayList<Agent> list; // List holds the list of ptNums within the Bin
  int binNum;
  int[] binRef = new int[27]; //References to surrounding bins

  Bin(int binNum) {

    this.binNum = binNum;
    
    int binStart = (binNum-1)-binWidth-(binWidth*binHeight);

    for (int x = 0; x < 3; ++x) {
      for (int y = 0; y < 3; ++y) {
        for (int z = 0; z < 3; ++z) {


          if ((binStart+x+binWidth*y+binWidth*binHeight*z)<bins.length-1&&(binStart+x+binWidth*y+binWidth*binHeight*z)>0) {
            binRef[x+y*3+9*z] = binStart+x+binWidth*y+binWidth*binHeight*z;
          }
        }
      }
    }

    list = new ArrayList<Agent>();
  }
}

void drawBins() {
  pushStyle();
  stroke(150, 150, 150, 10);
  strokeWeight(1);
  fill(150, 150, 150);

  for (int x = 0; x < binWidth; ++x) {
    for (int y = 0; y < binHeight; ++y) {
      for (int z = 0; z < binDepth; ++z) {
        line(x*binSize-bw2, y*binSize-bh2, 0-bd2, x*binSize-bw2, y*binSize-bh2, binDepth*binSize-bd2);
        line(x*binSize-bw2, 0-bh2, z*binSize-bd2, x*binSize-bw2, binHeight*binSize-bh2, z*binSize-bd2);
        line(0-bw2, y*binSize-bh2, z*binSize-bd2, binWidth*binSize-bw2, y*binSize-bh2, z*binSize-bd2);

        text(x+binWidth*y+binWidth*binHeight*z, x*binSize-bw2, y*binSize-bh2, z*binSize-bd2);
      }
    }
  }
  popStyle();
}
