import gifAnimation.*;
import static java.awt.event.KeyEvent.*;
import java.util.*;
import java.awt.Color;

void setup() {
  size(1080, 1080, P3D);
  smooth(0);

  blendMode(BLEND);
  imageMode(CORNER);
  colorMode(HSB);
  
  frameRate(60);
  loadParameters();
  loadLSystem();
}

StringDict lSystemRules = new StringDict();
String lSystemStart = "";
long lastModified;
float lSystemAngle;
String[] lSystemDrawTokens;

void loadLSystem() {
  String filename = "l-system.txt";
  if (!fileExists(filename))
   return;
  
  File file = new File(dataPath(filename));
  if (file.lastModified() == lastModified)
    return;
  lastModified = file.lastModified();
  println("lastModified: " + lastModified);

  lSystemRules = new StringDict();

  BufferedReader reader = createReader(filename);
  String line = readLine(reader);
  String[] rules = split(line, ", ");
  for (String rule : rules) {
    String[] parts = split(rule, " -> ");
    if (parts.length >= 2)
      lSystemRules.set(parts[0], parts[1]);
  }
  
  lSystemStart = readLine(reader);
  
  line = readLine(reader);
  lSystemDrawTokens = line.split(" ");
  
  lSystemAngle = float(readLine(reader));
  par("z").x = lSystemAngle / 360f;

  println(lSystemRules);
  println(lSystemStart);
  println(lSystemDrawTokens);
  println(lSystemAngle + "°");

  try {
    reader.close();
  } catch (IOException e) {
    println(e);
  }
}

StringDict rules;

int ticks;
float globalTime;
float speed;

boolean spiral = false;

int renderSkip = 1;
float testQuality;

float depth, maxDepth;

void draw() {
  ticks++;
  loadLSystem();

  speed = 0.0018;
  if (recording)
    speed /= renderSkip;
  
  background(0);

  maxDepth = max(1, floor(par("c").z));
  if (par("c").click)
    depth = min(maxDepth + 0.99, (1 - cosineSig(globalTime)) * (maxDepth - 1) + 1);
  else
    depth = maxDepth + 0.0001;

  ArrayList<PVector> fract = new ArrayList<PVector>();
  float angle =  par("z").x * TWO_PI;
  fract = computeFract(lSystemRules, lSystemStart, depth, angle, fract);
  if (fract.size() > 0) {
    drawFract(fract);
  }
  
  prevBF = get(); 
  
  if (recording && ticks % renderSkip == 0)
    record();
  
  drawParameters();
  
  if (!paused && !searching) {
    globalTime += speed;
  }
}

PVector fractPos, fractDir;
ArrayList<PVector> computeFract(StringDict rules, String line, float n, float angle, ArrayList<PVector> fract) {
  if (n == depth) {
    fractPos = new PVector(0, 0);
    fractDir = new PVector(1, 0);
    fract.add(fractPos.copy());
  }  
  
  float anim = n < 1 ? n : 1;

  String lineSegments = line;
  try {
    lineSegments = lineSegments.replaceAll("\\+", "").replaceAll("\\-", "");
  }catch (Exception e) {
    println(e);
  }

  int segments = lineSegments.length();
  float segmentFraction = 1f / segments;

  for (char letter : line.toCharArray())
  {
    switch (letter) {
      case '+':
        fractDir.rotate(-angle * anim);
        break;
      case '-':
        fractDir.rotate(angle * anim);
        break;
      default:
        String newLine = rules.get(str(letter));
        if (n >= 1 && newLine != null) {
            fract = computeFract(rules, newLine, n - 1, angle, fract);
        }else{
          for (String token : lSystemDrawTokens) {
            if (str(letter).equals(token)) {
              fractPos.add(PVector.mult(fractDir, anim));
              fract.add(fractPos.copy());
            }
          }
        }
        break;
    }
    
  }

  return fract;
}

float colorTime;

void drawFract(ArrayList<PVector> fract) {
  PVector max = new PVector(MIN_FLOAT, MIN_FLOAT);
  PVector min = new PVector(MAX_FLOAT, MAX_FLOAT);
  
  for (PVector point : fract) {
    max.x = max(point.x , max.x);
    min.x = min(point.x , min.x);
    max.y = max(point.y , max.y);
    min.y = min(point.y , min.y);
  }
  
  PVector dimensions = PVector.sub(max, min);
  PVector middle = PVector.mult(dimensions, 0.5).add(min);  

  float minDimension = max(dimensions.x, dimensions.y);

  float fov = PI/3;
  float cameraZ = (minDimension /  2.0) / tan(fov/2.0);
  perspective(fov, 1, cameraZ/10.0, cameraZ*10.0);

  float dist = minDimension / 1.5 / tan(PI/6);
  camera(
    middle.x, middle.y, dist, 
    middle.x, middle.y,  0, 
    0, 1, 0
  );

  // ortho(min.x, max.x, max.y, min.y);
  // camera(
  //   0, middle.y * 2, 1, 
  //   0, middle.y * 2,  0, 
  //   0, 1, 0
  // );

  strokeWeight((maxDepth + par("v").z - depth) * par("v").x);
  strokeJoin(MITER);
  strokeCap(SQUARE);
  noFill();

  beginShape();
  fractPos = fract.get(1);

  for (int f=0; f<fract.size(); f++) {
    float fraction = (float)f / (fract.size() - 1);
    PVector pos = fract.get(f);
    
    stroke(
      255 * fmod((triangle(fraction + globalTime * (1 - cosine(globalTime))) * par("a").x + par("a").y), 1),
      255,
      255
    );
    vertex(pos.x,  pos.y);
    
    if (par("w").click) {
      fill(
        255 * fmod((fraction * par("a").x + par("a").y), 1),
        255,
        255
      );
      noStroke();

      float rad = PVector.sub(pos, fractPos).mag() * 1;
      ellipse(
        pos.x,
        pos.y,
        rad,
        rad
      );
    }

    fractPos = pos.copy();
  }

  endShape();
}