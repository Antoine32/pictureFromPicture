void fullScreenDraw() {  
  push();
  int ySiz = int((height - ((height - gridH) / 3f)) * zoom);
  int xSiz = int(float(gridW)/float(gridH) * ySiz);
  if (mousePressed) posFullscreen.add((mouseX - mX) / zoom, (mouseY - mY) / zoom);
  posFullscreen.y = constrain(posFullscreen.y, min(-(ySiz - (height - ((height - gridH) / 3f))) / zoom, 0), 0);
  //float maxX = max((width - (float(gridW)/float(gridH) * ySiz)) / (zoom * 2), 0);
  //if (xSiz >= width) 
  float maxX = max(((xSiz ) - (float(width)/((height - ((height - gridH) / 3f))) * (ySiz / zoom))) / (zoom * 2), 0);
  posFullscreen.x = constrain(posFullscreen.x, -maxX, maxX);
  mX = mouseX;
  mY = mouseY;
  translate((width - xSiz) / 2f, (height - gridH) / 3f);
  translate(posFullscreen.x * zoom, posFullscreen.y * zoom);

  if (!((showGraph && pos == graphPos) || showImg) || creating) {
    for (int x = 0; x < section; x++) {
      for (int y = 0; y < section; y++) {
        fill(col[x][y]);
        float xExtend = float(xSiz) / float(section);
        float yExtend = float(ySiz) / float(section);
        if (x < section - 1) xExtend++;
        if (y < section - 1) yExtend++;
        rect(x * (float(xSiz) / float(section)), y * (float(ySiz) / float(section)), xExtend, yExtend);
      }
    }
  }

  if (showGraph && pos == graphPos) {
    if (!ramLight && !creating && zoom >= graphSection / trueRendering) {
      for (int x = 0; x < graphSection; x++) {
        for (int y = 0; y < graphSection; y++) {
          if (abs(((((float(width) / 2f) - ((float(width) - float(xSiz)) / 2f)) - posFullscreen.x * zoom) / (float(xSiz) / float(graphSection))) - (float(x) + 0.5f)) < float(gridW) / (zoom * 2f) && abs((((((float(height) + (float(height - gridH) / 3f)) / 2f) - ((float(height) - float(gridH)) / 3f)) - posFullscreen.y * zoom) / (float(ySiz) / float(graphSection))) - (float(y) + 0.5f)) < float(gridH) / (zoom * 2f)) 
            image(createArt.perm[createArt.place[x][y]], x * (float(xSiz) / float(graphSection)), y * (float(ySiz) / float(graphSection)), (float(xSiz) / float(graphSection)), (float(ySiz) / float(graphSection)));
        }
      }
    } else if (creating || zoom >= graphSection / treshold) image(graph, 0, 0, xSiz, ySiz);
    else image(previewFull, 0, 0, xSiz, ySiz);
  } else if (showImg) image(img, 0, 0, xSiz, ySiz);

  if (keyCode == 17 && keyPressed && allLoaded) {
    noFill();
    stroke(0, 0, 255);
    rect((xSiz / 2f) - ((xSiz / (zoom * 2f)) + posFullscreen.x * zoom), (ySiz / 2f) - ((ySiz / (2f)) + posFullscreen.y * zoom), xSiz / zoom, ySiz / zoom);
    stroke(255, 0, 0);
    float xPosRect = (mouseX - (width - xSiz) / 2f) - ((xSiz / (zoom * 2f)) + posFullscreen.x * zoom);
    float yPosRect = (mouseY - ((height - gridH) / 3f)) - ((ySiz / (zoom * 2f)) + posFullscreen.y * zoom);
    rect(xPosRect, yPosRect, xSiz / zoom, ySiz / zoom);
    line((width - (width - xSiz)) / 2f - (posFullscreen.x * zoom), (ySiz / (zoom * 2f)) - (posFullscreen.y * zoom), xPosRect + xSiz / (zoom * 2f), yPosRect + ySiz / (zoom * 2f));
  }

  pop();
}
