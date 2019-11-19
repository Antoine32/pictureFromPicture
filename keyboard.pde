void keyPressed() { //println(key + " | " + keyCode);
  if (!creating && !naming && millis() - time >= 100 && allLoaded) {
    if (keyCode == UP) {
      pos++;
      if (pos > amLoaded) pos = MIN;
      reload = true;
    }
    if (keyCode == DOWN) { 
      pos--;
      if (pos < MIN) pos = amLoaded;
      reload = true;
    }

    if (keyCode == RIGHT || keyCode == 61) {
      sectionizing(1);
    }
    if (keyCode == LEFT || keyCode == 45) {
      sectionizing(-1);
    }

    time = millis();
  }
}

void keyReleased() { //println(key + " | " + keyCode);
  if (allLoaded) {
    if (!naming) {
      if (creating) {
        if (keyCode == 127) creating = false;
      } else {
        if (key == 's' && pos == graphPos) showGraph = !showGraph;

        if (key == 'i' && showFullScreen) showImg = !showImg;

        if (key == 'r' && allLoaded) {
          pos = int(random(MIN, amLoaded));
          reload = true;
        }

        if (key == 'l') {
          needToChange = !needToChange;
          if (needToChange) println("Going to use significantly more ram (about 2000Mb to 4000+Mb), but can zoom farther (might have to increase ram to use 320 section");
          else println("Going to use significantly less ram (about 500Mb to 1000Mb), but can't zoom as far");
        }

        if (key == 'g' && !reload) {
          cols[pos - MIN] = colorAverage(img.pixels.clone()); // here for debuging purpose no reason to stay, but no reason to take it off either
          System.gc();
          println("Garbage time!!! And correction also...");
        }

        if (allLoaded && img != null && !reload && !naming && !creating && key == 'c') {
          createNewArt();
          println("Start creating");
        }

        if (keyCode >= 48 && keyCode <= 57) {
          limitCol = keyCode - 48;
          if (limitCol == 0) limitCol = 10;
          limitCol += limitCol - 1;
          reload = true;
        }
      } 

      if (key == 'f') {
        showFullScreen = !showFullScreen;
      }
    } else if (naming && !creating) {
      if (keyCode == 8) {
        if (name.size() >= 1) {
          name.remove(name.size() - 1);
          nameS = "";
          for (String letter : name) nameS += letter;
        }
      } else if (keyCode == 10) {
        if (nameS.length() >= 1 && nameValid) {
          graph.save(PATH[2] + nameS + EXTENTION);
          naming = false;
          System.gc();
        }
      } else if (keyCode == 127) {
        showGraph = false;
        naming = false;
        System.gc();
      } else if (keyCode >= 32 && keyCode <= 126) {
        if (name.size() != 0 || keyCode != 32) {
          name.add(str(key));
          nameS += key;
        }
      } 

      nameValid = true;
      int i = 0;
      while (i < saves.length && nameValid) {
        if (saves[i].getName().equals(nameS + EXTENTION)) nameValid = false;
        i++;
      }
    }
  }
}
