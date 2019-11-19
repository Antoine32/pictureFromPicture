void setSiz() {
  sizW = img.width / section;
  sizH = img.height / section;
}

void sectionizing(int dif) {
  do {
    do {
      section = constrain(section + dif, 1, min(img.width, img.height));
      setSiz();
    } while ((sizW * section != img.width || sizH * section != img.height) && section < min(img.width, img.height));
    if (section >=  min(img.width, img.height)) dif *= -1;
  } while (section >=  min(img.width, img.height));
  checking();
}

void checking() {
  col = new color[section][section];
  img.loadPixels(); 

  for (int x = 0; x < section; x++) {
    for (int y = 0; y < section; y++) {
      col[x][y] = colorAverage(img.get(x * sizW, y * sizH, sizW, sizH).pixels);
    }
  }
}

color colorAverage(color pix[]) {
  float r = 0, g = 0, b = 0; 
  for (color c : pix) {
    r += c >> 16 & 0xFF; 
    g += c >> 8 & 0xFF; 
    b += c >> 0 & 0xFF;
  }
  r /= pix.length; 
  g /= pix.length; 
  b /= pix.length;

  return colorLimit(r, g, b);
}

color colorLimit(color col) {
  return colorLimit(col >> 16 & 0xFF, col >> 8 & 0xFF, col & 0xFF);
}

color colorLimit(float r, float g, float b) {
  return color(r - (r % limitCol), g - (g % limitCol), b - (b % limitCol));
}
