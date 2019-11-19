void mouseWheel(MouseEvent e) {
  if (allLoaded) {
    if (showFullScreen && keyCode == 17 && keyPressed) {
      int ySiz = int((height - ((height - gridH) / 3f)) * zoom);
      int xSiz = int(float(gridW)/float(gridH) * ySiz);
      float xPosRect = ((mouseX - (width - xSiz) / 2f) - ((xSiz / (1 * 2f)))) / zoom;
      float yPosRect = ((mouseY - ((height - gridH) / 3f)) - ((ySiz / (1 * 2f)))) / zoom;

      zoom = constrain(zoom - (e.getCount() / 10f) * zoom, 1, section);

      ySiz = int((height - ((height - gridH) / 3f)) * zoom);
      xSiz = int(float(gridW)/float(gridH) * ySiz);
      float xPosRectB = ((mouseX - (width - xSiz) / 2f) - ((xSiz / (1 * 2f)))) / zoom;
      float yPosRectB = ((mouseY - ((height - gridH) / 3f)) - ((ySiz / (1 * 2f)))) / zoom;

      posFullscreen.add(xPosRectB - xPosRect, yPosRectB - yPosRect);
    } else if (!creating && !naming) {
      pos -= e.getCount();
      if (pos > amLoaded) pos = MIN;
      else if (pos < MIN) pos = amLoaded;
      reload = true;
    }
  }
}

void mousePressed() {
  if (showFullScreen && keyCode == 17 && keyPressed && allLoaded) {
    int ySiz = int((height - ((height - gridH) / 3f)));
    int xSiz = int(float(gridW)/float(gridH) * ySiz);
    float xPosRect = ((mouseX - (width - xSiz) / 2f) - ((xSiz / (1 * 2f)))) / zoom;
    float yPosRect = ((mouseY - ((height - gridH) / 3f)) - ((ySiz / (1 * 2f)))) / zoom;
    posFullscreen.add(-xPosRect, -yPosRect);
  }
}
