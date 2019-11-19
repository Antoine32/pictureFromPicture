void textUI() {
  noStroke();
  if (!ramLight && zoom >= graphSection / trueRendering && pos == graphPos && showGraph && showFullScreen && !creating) fill(0, 0, 55);
  else if (zoom >= graphSection / treshold && pos == graphPos && showGraph && showFullScreen || creating) fill(55, 0, 0);
  else fill(0);
  rect(0, 0, width, (height - gridH) / 3);

  if (ramLight) fill(0, 255, 0);
  else fill(255, 255, 0);
  circle(circleSiz, circleSiz, circleSiz);
  fill(0);
  textAlign(CENTER, CENTER);
  if (needToChange) {
    if (!ramLight) fill(0, 255, 0);
    else fill(255, 255, 0);
    circle(circleSiz, circleSiz, circleSiz * 0.5f);
  }

  push();
  fill(255);
  textSize(width / 64);
  textAlign(CENTER, CENTER);

  translate(gridW / 4, (height - gridH) / 12);
  float memoryUse = (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / 1000000f;
  push();
  if (memoryUse >= 6000) {
    fill(255, 0, 255);
    System.gc();
  } else if (memoryUse >= 4000) {
    fill(255, 0, 0);
  } else if (memoryUse >= 2000) { 
    fill(255, 255, 0);
  } else if (memoryUse >= 1000) {
    fill(0, 255, 0);
  } else {
    fill(255);
  }
  textAlign(RIGHT, CENTER);
  text(nf(memoryUse, 0, 2), 0, 0);

  fill(255);
  textAlign(LEFT, CENTER);
  text(" Mb", 0, 0);
  pop();

  translate(0, (height - gridH) / 8);
  text(PATH[0] + pos + ".png", 0, 0);

  translate(gridW / 2, (height - gridH) / -8);
  text(section + " sections", 0, 0);

  translate(0, (height - gridH) / 8);
  float ans = 255f / limitCol;
  String lim = nf(ans, 1, 3 - min(str((ans / 10)).length(), 3)) + " colors";
  push();
  fill(map(ans, 0, 255, 0, 155) + 100);
  text(lim, 0, 0);
  pop();

  translate(gridW / 2, (height - gridH) / -8);
  push();
  textAlign(RIGHT, CENTER);
  text("Show graph : ", 0, 0);
  textAlign(LEFT, CENTER);  
  if (showGraph && pos == graphPos) fill(0, 255, 0);
  else fill(255, 0, 0);
  text(str(showGraph && pos == graphPos), 0, 0);
  pop();

  translate(0, (height - gridH) / 8);
  push();
  textAlign(RIGHT, CENTER);
  text("Can create : ", 0, 0);
  textAlign(LEFT, CENTER);  
  if (allLoaded && img != null && !reload && !naming && !creating) fill(0, 255, 0);
  else fill(255, 0, 0);
  text(str(allLoaded && img != null && !reload && !naming && !creating), 0, 0);
  pop();

  translate(gridW / 2, (height - gridH) / -8);
  push();
  if (!allLoaded) {
    if (toChange) fill(255, 0, 0);
    else fill(255, 255, 0);
  }
  text(amLoaded + " / " + cols.length, 0, 0);
  pop();

  translate(0, (height - gridH) / 8);
  if (brightness(cols[pos - MIN]) > 25) fill(cols[pos - MIN]);
  else fill(255);
  text("#" + hex(cols[pos - MIN]), 0, 0);
  pop();
}
