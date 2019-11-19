void createNewArt() {
  if (needToChange) ramLight = !ramLight;
  needToChange = false;
  saves = listFiles(PATH[2]);
  graphPos = pos;
  graphSection = section;
  reload = false;
  createArt = new asignPict();
  creating = true;
  showGraph = true;
  amCreated = 0;
  System.gc();
  graph = createImage(min(gridW * (graphSection / rezLimitor), gridW * graphSection), min(gridH * (graphSection / rezLimitor), gridH * graphSection), ARGB);
  caseW = graph.width / section;
  caseH = graph.height / section;
  graph.updatePixels();
  graph.loadPixels();
  caseW = graph.width / section;
  caseH = graph.height / section;
  System.gc();
  createArt.start();
}

public class asignPict extends Thread {
  int best = 0;
  float diff = 1000, diffBuf;
  PImage imgs[] = new PImage[cols.length], perm[];
  int place[][] = new int[section][section];
  color ca, cb;

  asignPict() {
    if (!ramLight) perm = new PImage[cols.length];
  }

  void run() {
    min = 60; 
    sec = 60;
    spikeLoad = 0;
    time = millis();
    imgs = new PImage[cols.length];
    if (!ramLight) perm = new PImage[cols.length];
    else perm = null;
    place = new int[section][section];
    System.gc();

    for (int pX = 0; pX < section; pX++) {
      if (!creating) break;
      for (int pY = 0; pY < section; pY++) {
        if (!creating) break;
        ca = col[pX][pY];
        diff = 1000;
        for (int i = 0; i < cols.length; i++) {
          if (!creating) break;
          cb = cols[i];
          diffBuf = (abs(hue(ca) - hue(cb)) + abs(saturation(ca) - saturation(cb)) + abs(brightness(ca) - brightness(cb)) + abs((ca >> 16 & 0xFF) - (cb >> 16 & 0xFF)) + abs((ca >> 8 & 0xFF) - (cb >> 8 & 0xFF)) + abs((ca & 0xFF) - (cb & 0xFF))); // go on if you want to try to weight those, might get better result I don't know
          if (diffBuf < diff) {
            diff = diffBuf;
            best = i;
          }
        }

        place[pX][pY] = best;

        if (!creating) break;

        if (imgs[best] == null) {
          if (!ramLight) perm[best] = imageLoad(best + MIN);
          imgs[best] = imageLoad(best + MIN);     
          if (!creating) break;   
          imgs[best].resize(graph.width / section, graph.height / section);
          if (!creating) break;
          imgs[best].loadPixels();
        }

        if (!creating) break;

        for (int x = 0; x < imgs[best].width; x++) {
          if (!creating) break;
          for (int y = 0; y < imgs[best].height; y++) {
            if (!creating) break;
            graph.pixels[x + (pX * caseW) + (y + (pY * caseH)) * graph.width] = imgs[best].pixels[x + y * imgs[best].width];
          }
        }

        graph.updatePixels();
        amCreated++;
        println(amCreated + " / " + (section * section));
      }
    }

    if (creating) {
      println("All frame created");
      showFullScreen = false;
      naming = true;
      nameValid = true;
      name = new ArrayList<String>();
      nameS = "";

      int ySiz = int((height - ((height - gridH) / 3f)) * zoom);
      int xSiz = int(float(gridW)/float(gridH) * ySiz);
      previewFull = graph.copy();
      if (xSiz < previewFull.width) previewFull.resize(xSiz, ySiz);
      previewMain = graph.copy();
      if (gridW < previewMain.width) previewMain.resize(gridW, gridH);
    } else {
      naming = false; 
      showGraph = false;
      graph = createImage(gridW * (section / 16), gridH * (section / 16), ARGB);
      graphPos = 0;
    }

    imgs = null;
    creating = false;
    System.gc();
    graph.loadPixels();
    time = millis();
    surface.setTitle(NAME_WINDOW);
  }
}
