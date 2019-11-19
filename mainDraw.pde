void mainDraw() {
  push();
  translate((width - (gridW * 2)) / 2, (height - gridH) / 3);
  image(img, 0, 0);

  if (showGrid) {
    noFill();
    strokeWeight(map(1f / section, 0, 1, 1, 10));
    for (int x = 0; x < section; x++) {
      for (int y = 0; y < section; y++) {
        stroke(255, 255, 255, 150);
        rect(x * sizW, y * sizH, sizW, sizH);
      }
    }
  }

  push();
  translate(img.width, 0);
  noStroke();
  for (int x = 0; x < section; x++) {
    for (int y = 0; y < section; y++) {
      fill(col[x][y]);
      rect(x * sizW, y * sizH, sizW, sizH);
    }
  }

  if (showGraph && pos == graphPos) {
    if (creating) image(graph, 0, 0, gridW, gridH);
    else image(previewMain, 0, 0, gridW, gridH);
  }
  pop();
  pop();
}
