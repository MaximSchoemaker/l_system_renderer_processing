PImage prevBF;
GifMaker gifMaker;
//PImage bitmap;
int recordFps = 30;

boolean recording = false;

float renderStartTime = 0;
float recordStartTime = 0;
float recordTime = 1;

void record() {
  if (globalTime > recordStartTime) {
    if (globalTime < recordStartTime + recordTime) {
      println(globalTime - recordStartTime);
      
      //if (globalTime > 0)
          //gifMaker.setDelay(1000/recordFps);
      //gifMaker.addFrame();
      saveFrame("data/recording/frame####.png");
    }else{
      stopRecording();
    }
  }
}

void startRecording() {
  /*gifMaker = new GifMaker(this, "export.gif");
  gifMaker.setRepeat(0);        // make it an "endless" animation
  gifMaker.setQuality(0);*/
  //gifMaker.setTransparent(0);  // black is transparent

  deleteDir(new File(dataPath("recording")));
  
  globalTime = renderStartTime;
  prevBF = null;
  ticks = 0;
  
  println("start recording!");
}

void stopRecording() {
  //gifMaker.finish();
  ding();
  println("stop recording!");
  recording = false;
}

