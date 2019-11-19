import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

final int MIN = 1;
final String PATH[] = {"choiceLoad/", "choice/", "save/"};
final String NAME_WINDOW = "Picture out of picture";
final String EXTENTION = ".png";
File[] files, saves;
PVector posFullscreen;
float limitCol = 1;
float zoom = 1, treshold = 60, trueRendering = 10;
int rezLimitor = 16;
int circleSiz;
int pos = 1, graphPos = 0;
int section = 160, graphSection = section;
int sizW, sizH;
int gridW, gridH;
int caseW, caseH;
int mX, mY;
int amLoaded = 0;
int amCreated = 0;
int yWidth;
int time = millis();
int spikeLoad = 0;
int min, sec;
boolean showGrid = false;
boolean allLoaded = false;
boolean reload = true;
boolean creating = false;
boolean showGraph = false;
boolean naming = false;
boolean showFullScreen = true;
boolean toChange = false;
boolean nameValid = true;
boolean showImg = true;
boolean ramLight = false, needToChange = false;
PImage img;
color col[][], cols[];
PImage graph, previewFull, previewMain;
PImage imgHB, imgS;
ArrayList<String> name = new ArrayList<String>();
String nameS = "";
FileWriter output;
BufferedWriter buffWriter;
asignPict createArt;

void setup() {
  size(1920, 1001);
  surface.setResizable(true);
  surface.setLocation(0, 0);
  surface.setTitle(NAME_WINDOW + " | loading: 0% | 0 min and 0 sec left");
  files = listFiles("data/" + PATH[1]);
  saves = listFiles(PATH[2]);

  img = loadImage(PATH[1] + files[0].getName());
  gridW = width / 2;
  gridH = int(gridW * (float(3648)/float(5472)));
  circleSiz = width / 50;

  yWidth = int((2 * (height - gridH) / 3) * 0.9f);
  posFullscreen = new PVector(0, 0);

  graph = createImage(gridW * (section / 16), gridH * (section / 16), ARGB);
  int ySiz = int((height - ((height - gridH) / 3f)) * zoom);
  int xSiz = int(float(gridW)/float(gridH) * ySiz);
  previewFull = graph.copy();
  previewFull.resize(xSiz, ySiz);
  previewMain = graph.copy();
  previewMain.resize(gridW, gridH);
  caseW = graph.width / section;
  caseH = graph.height / section;

  cols = new color[files.length];
  BufferedReader reader;
  String cString;
  try {
    reader = createReader("cols.txt");
    while ((cString = reader.readLine()) != null && amLoaded <= cols.length) {
      if (amLoaded < cols.length) cols[amLoaded] = color(unhex(cString));
      amLoaded++;
    }
    reader.close();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  try {
    reader = createReader("rez.txt");
    if ((cString = reader.readLine()) != null) rezLimitor = int(cString);
    println("rezLimitor : " + rezLimitor + ". About : " + min(gridW * (section / rezLimitor), gridW * section) + "px / " + min(gridH * (section / rezLimitor), gridH * section) + "px if section is at 160");
    reader.close();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  loadPicInMass loadMass = new loadPicInMass();
  loadMass.start();
  loading();
  checking();
}

void draw() {
  background(0);

  if (reload && allLoaded) loading();

  if (showFullScreen) {
    fullScreenDraw();
  } else {
    mainDraw();
    nameBox();
  }

  textUI();

  if (!allLoaded) changeTitle(amLoaded, cols.length, spikeLoad, "loading");
  if (creating) changeTitle(amCreated, section * section, spikeLoad, "creating");
}

String timeEstimate(int at, int goal) {
  int timeIn = millis() - time;
  float perc = float(at) / float(goal);
  int timeLeft = int(timeIn / perc) - timeIn;

  int bufM = min, bufS = sec;
  min = int(timeLeft / 60000);
  timeLeft %= 60000;
  sec = timeLeft / 1000;
  if ((bufM * 60 + bufS) - (min * 60 + sec) > 10) {
    spikeLoad = at;
    time = millis();
  }

  return min + " min and " + sec + " sec left";
}

void changeTitle(int loaded, int objectif, int offset, String lBuf) {
  String windowName = NAME_WINDOW + " | ";
  String l = "";
  int goal = (int((loaded  / float(objectif)) * 500f) % (lBuf.length() + 1));
  for (int j = 0; j < lBuf.length(); j++) {
    if (j == goal) l += lBuf.toUpperCase().charAt(j);
    else l += lBuf.toLowerCase().charAt(j);
  }
  windowName += l;
  windowName += ": " + int((float(loaded) / float(objectif)) * 100f) + "% | " + timeEstimate(loaded - offset, objectif - offset);
  surface.setTitle(windowName);
}

void rectBottom(color c, String s) {
  noStroke();
  fill(0);
  rect(0, 0, width, yWidth);
  textSize(gridW / 10);
  textAlign(CENTER, CENTER);
  fill(c);
  text(s, width / 2, yWidth / 2);
}

void nameBox() {
  push();
  translate(0, height - yWidth);
  if (creating) rectBottom(color(255, 255, 0), amCreated + " / " + (section * section)); 
  else if (naming) {
    color c = color(255);
    if (!nameValid) c = color(255, 0, 0);
    rectBottom(c, nameS + EXTENTION);
  } else rainbowBar();
  pop();
}

void exit() {
  try {
    buffWriter.flush(); // Writes the remaining data to the file
    output.flush();
    buffWriter.close();
    output.close();
  }
  catch(Exception e) {
  } 

  stop();
}

File findFile(String path, String na) {
  int i = 0;
  boolean boucle = true;
  File[] fs = listFiles(path);
  while (i < fs.length && boucle) if (boucle = !fs[i].getName().equals(na)) i++; // NO I WONT MAKE IT IN MULTIPLE LINE I KNOW WHAT I AM DOING IT WORKS (to processing)

  if (boucle) {
    println("create file " + na);
    PrintWriter writer = createWriter(path + "/" + na);
    writer.flush();
    writer.close();
    return findFile(path, na);
  }

  return fs[i].getAbsoluteFile();
}
