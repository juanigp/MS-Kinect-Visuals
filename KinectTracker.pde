class KinectTracker {
  int threshold = 100; 
  PImage depth;
  PImage display;
  
  KinectTracker() {
    context.enableDepth();
    context.enableRGB();
    context.setMirror(false);
    display = createImage(context.rgbImage().width, context.rgbImage().height, RGB);
  }

  void track() {
    depth = context.depthImage();
  }

  void display() {
    PImage img = context.rgbImage();
    if (depth == null || img == null) return;

    display.loadPixels();
    depth.loadPixels();
    for (int x = 0; x < context.rgbImage().width; x++) {
      for (int y = 0; y < context.rgbImage().height; y++) {
        int pix = x + y * context.rgbImage().width;

          if (brightness(depth.pixels[pix]) < threshold) {
            display.pixels[pix] = color(100,100,100);
          } else {
            display.pixels[pix] = color(80,236,53);
          }
        }
      }
    depth.updatePixels();
    display.updatePixels();
    image(display, 0, 0, displayWidth, displayHeight);
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}
