PImage imageLoad(int n) {
  PImage buf;

  buf = loadImage("choiceLoad/" + n + ".png");
  if (buf == null || buf.height != gridH || buf.width != gridW) {
    if (!toChange) {
      time = millis();
      spikeLoad = amLoaded;
    }
    toChange = true;
    println("resize and rename of " + files[n - MIN].getName() + " to " + n + ".png");
    buf = loadImage("choice/" + files[n - MIN].getName());
    if (buf.width * gridH < buf.height * gridW) {
      buf.resize(gridW, int(gridW * (float(buf.height) / float(buf.width))));
    } else if (buf.width * gridH > buf.height * gridW) {
      buf.resize(int(gridH * (float(buf.width) / float(buf.height))), gridH);
    }
    buf.loadPixels();
    buf = buf.get(0, 0, gridW, gridH).copy();
    buf.updatePixels();
    buf.save("data/choiceLoad/" + n + ".png");
  } else { 
    if (toChange) {
      time = millis();
      spikeLoad = amLoaded;
    }
    toChange = false;
  }

  return buf;
}

void loading() {
  if (allLoaded) {
    reload = false;
    img = imageLoad(pos);
    img.loadPixels();
    if (limitCol == 1) {
      color c = cols[pos - MIN];
      cols[pos - MIN] = colorAverage(img.pixels.clone()); // if  something fuck up relating color this is likely the issu, but you can't see the average color before all is load in otherwise
      if (!hex(cols[pos - MIN]).equals(hex(c))) {
        String message = "You need to change the content of \"data/cols.txt\" if it's writen " + hex(c) + " and not " + hex(cols[pos - MIN]) + " at the line " + pos + ". \n";
        errorLog(message);
      }
    }
    setSiz();
    checking();

    push();
    colorMode(HSB);
    imgHB = createImage(width, yWidth, HSB);
    imgS = createImage(imgHB.width, (2 * (height - gridH) / 3) - imgHB.height, HSB);
    for (int w = 0; w < imgHB.width; w++) {
      for (int h = 0; h < imgHB.height; h++) {
        imgHB.pixels[w + h * imgHB.width] = color(hue(cols[pos - MIN]), map(w, 0, imgHB.width - 1, 0, 255), map(imgHB.height - h, 1, imgHB.height, 0, 255));
      }
      for (int h = 0; h < imgS.height; h++) {
        imgS.pixels[w + h * imgS.width] = color(map(w, 0, imgS.width - 1, 0, 255), 255, 255);
      }
    }
    pop();
  }
}

public class loadPicInMass extends Thread {
  void run() {
    min = 60; 
    sec = 60;
    spikeLoad = 0;
    time = millis();

    if (cols.length < amLoaded) amLoaded = 0;

    if (amLoaded < cols.length) {
      try {
        File colsTxt = findFile("data", "cols.txt");
        output = new FileWriter(colsTxt, amLoaded > 0);
        buffWriter = new BufferedWriter(output);

        while (amLoaded < cols.length) {
          color c;
          int tm = 0;
          pos = amLoaded + MIN;
          do {
            tm++;
            img = imageLoad(pos);
            img.updatePixels();
            img.loadPixels();
            c = cols[amLoaded];
            cols[amLoaded] = colorAverage(img.pixels);
            if (((cols[amLoaded] >> 16 & 0xFF) != (c >> 16 & 0xFF)) || ((cols[amLoaded] >> 8 & 0xFF) != (c >> 8 & 0xFF)) || ((cols[amLoaded] & 0xFF) != (c & 0xFF))) tm = 0;
          } while (tm < 10 && (hex(cols[amLoaded]).equals("FF000000") || ((cols[amLoaded] >> 16 & 0xFF) != (c >> 16 & 0xFF)) || ((cols[amLoaded] >> 8 & 0xFF) != (c >> 8 & 0xFF)) || ((cols[amLoaded] & 0xFF) != (c & 0xFF))));
          if (amLoaded > 0)buffWriter.write('\n');
          buffWriter.write(hex(cols[amLoaded]));
          amLoaded++;

          if (amLoaded % 100 == 0) {
            println(amLoaded);
            buffWriter.flush();
            output.flush();
          }
        }
        println("All picture loaded");
        toChange = false;
        spikeLoad = 0;
        time = millis();
        buffWriter.flush(); // Writes the remaining data to the file
        output.flush();
        buffWriter.close();
        output.close();
      }
      catch(Exception e) {
        e.printStackTrace();
        exit();
      }
    }

    System.gc();
    allLoaded = true;
    showFullScreen = false;
    showImg = false;
    surface.setTitle(NAME_WINDOW);
    pos = int(random(MIN, amLoaded));
  }
}
