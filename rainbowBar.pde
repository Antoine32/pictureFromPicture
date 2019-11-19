void rainbowBar() {
  push();
  image(imgHB, 0, 0);
  image(imgS, 0, -imgS.height);

  PVector posLine = new PVector(map(saturation(cols[pos - MIN]), 0, 255, 0, imgHB.width - 1), map(255 - brightness(cols[pos - MIN]), 0, 255, 0, imgHB.height - 1), map(hue(cols[pos - MIN]), 0, 255, 0, imgS.width - 1));
  stroke(155);
  line(posLine.x, 0, posLine.x, imgHB.height);
  line(0, posLine.y, imgHB.width, posLine.y);
  stroke(0);
  if ((mouseY > (height - yWidth) - (imgS.height + 1) && mouseY < (height - yWidth) - 1) && abs(mouseX - posLine.z) <= 1) stroke(255, 0, 255); // on going change to make it able to find the picture with the color the closest to the selection
  line(posLine.z, -imgS.height - 1, posLine.z, -1);
  pop();
}
