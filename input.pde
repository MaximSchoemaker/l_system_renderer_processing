import gifAnimation.*;
import static java.awt.event.KeyEvent.*;
import java.util.*;
import java.awt.Color;
import java.io.FileWriter;
import java.io.*;

String keyDown;
boolean searching, paused;

void keyPressed(){
  if (key == CODED) {
      if (keyCode == SHIFT) {
        if (!recording) {
          searching = true;
        }
      }
      return;
  }

  if (keyCode == ENTER || keyCode == RETURN) {
    searching = false;
    paused = false;
      recording = !recording;
    if (recording) {
      startRecording();
    }else
      stopRecording();
    return;
  }

  if (keyCode == BACKSPACE) {
    globalTime = 0;
    println("restart!");
    return;
  }
    
  if(key == ' ') {
      paused = !paused;
      println("paused: ", paused);
      if (recording) {
        paused = false;
      }
      return;
  }

  
  println(key);
  
  String keyStr = str(key);
  Parameter keyPar = keyParameters.get(keyStr);

  if (keyPar == null) 
    keyPar = createParameter(keyStr);
  else {
      keyPar.on = !keyPar.on;    
      println(keyStr + " on:" + keyPar.on);
  }
    
  keyDown = keyStr;
}

void keyReleased(){
  if (key == CODED) {
    if (keyCode == SHIFT) {
      searching = false;
    }
  }

  keyDown = null;
}

float fx, fy;
 
void mouseMoved() {
  if (searching) {
    globalTime = ((float)mouseX / width) * recordTime + renderStartTime;
    //println(globalTime);
  }
    
  fx = (float)mouseX / width;
  fy = (float)mouseY / width;

  int dx = mouseX - pmouseX;
  int dy = mouseY - pmouseY;

  if (keyDown != null) {
    Parameter keyPar = keyParameters.get(keyDown);
    keyPar.x += (float)dx / width;
    keyPar.y += (float)dy / height;
    println(keyDown + " x:" + keyPar.x + " y:" + keyPar.y);
  }
}

boolean mouseDown;

void mousePressed() {
  mouseDown = true;

  if (keyDown != null) {
    Parameter keyPar = keyParameters.get(keyDown);
    keyPar.click = !keyPar.click;    
    println(keyDown + " click:" + keyPar.click);
  }
}

void mouseReleased() {
  mouseDown = false;
}

void mouseWheel(MouseEvent event) {
  if (keyDown != null) {
    float e = event.getCount();
    Parameter keyPar = keyParameters.get(keyDown);
    keyPar.z =  keyPar.z - e;
    println(keyDown + " z:" + keyPar.z);
  }
}

void exit() {
  if (recording)
    stopRecording();

  saveParameters();

  super.exit();
}

