PFont defaultFont;


PImage moth01, moth02, moth03;
int scene = 1; // Default scene
boolean invertFlash = false;
boolean glitchEffect = false;
boolean circleOutlineEffect = false;
boolean tileEffect = false;
boolean pixelMothEffect = false;
int radarRadius = 0; // For radar effect

// Variables for circular motion in Scene 1
float angle = 0; // Initialize the angle for circular motion
float radius = 200; // Set the radius for the circular path

void setup() {
  size(800, 800);
  noCursor();  // Hide the cursor
  fullScreen(); // Full screen
  frameRate(60); // Smooth frame rate
  moth01 = loadImage("moth01.png");  // Load moth01 image
  moth02 = loadImage("moth02.png");  // Load moth02 image
  moth03 = loadImage("moth03.png");  // Load moth03 image

  // Load fonts
  defaultFont = createFont("Arial", 100);  // Default font
  
  background(0); // Start with black background
}

void draw() {
  // Fading effect to give the illusion of trails
  fill(0, 0, 0, 10); // Slight transparency for fading
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height); // Cover the screen with fading black overlay

  // Display image based on the scene
  if (scene == 1) {
    imageMode(CENTER);
    
    // Circular motion for the moth
    float x = width / 2 + cos(angle) * radius; // X coordinate on the circular path
    float y = height / 2 + sin(angle) * radius; // Y coordinate on the circular path
    
    image(moth01, x, y, random(400, 420), random(400, 420)); // Moth01 moves in circular motion

    angle += 0.03; // Increment the angle for continuous motion (adjust speed by changing this value)
  } else if (scene == 2) {
    imageMode(CORNER);
    image(moth02, width - 400, 0, 400, 400);  // Moth02 in top-right corner (400x400)
  } else if (scene == 3) {
    imageMode(CORNER);
    image(moth03, 0, height - 400, 400, 400);  // Moth03 in bottom-left corner (400x400)
  }

  // Apply effects globally across all scenes
  if (invertFlash) {
    filter(INVERT);  // Flash and invert effect
  }

  // Radar effect: Neon circle outline growing from the center ('o' key)
  if (circleOutlineEffect) {
    stroke(0, 255, 0); // Neon green stroke
    noFill();
    strokeWeight(2); // Thinner lines
    radarRadius += 20; // Increment the circle size faster
    circle(width / 2, height / 2, radarRadius); // Draw expanding circles from the center
    if (radarRadius > 800) radarRadius = 0; // Reset the radius when it exceeds 800
  }

  // Tiling effect: Different grid sizes for Scene 2 and Scene 3 when 't' is pressed
  if (tileEffect) {
    if (scene == 2) {
      int imgSize = width / 3;  // Grid size for Scene 2 (remains the same)
      for (int x = 0; x < width; x += imgSize) {
        for (int y = 0; y < height; y += imgSize) {
          if (random(1) < 0.5) {
            image(moth02, x, y, imgSize, imgSize);  // Tile Moth02
          } else {
            image(moth03, x, y, imgSize, imgSize);  // Tile Moth03
          }
        }
      }
    } else if (scene == 3) {
      int imgSize = width / 6;  // Smaller grid size for Scene 3
      for (int x = 0; x < width; x += imgSize) {
        for (int y = 0; y < height; y += imgSize) {
          if (random(1) < 0.5) {
            image(moth02, x, y, imgSize, imgSize);  // Tile Moth02
          } else {
            image(moth03, x, y, imgSize, imgSize);  // Tile Moth03
          }
        }
      }
    }
  }

  // Pixel moths effect: Bigger neon green squares appear randomly across the screen ('m' key)
  if (pixelMothEffect) {
    for (int i = 0; i < 10; i++) {  // Draw 10 bigger pixel moths per frame
      fill(0, 255, 0);
      rect(random(width), random(height), 10, 10);  // Slightly bigger neon green squares
    }
  }
}

// Function to spell "LIKE A MOTH TO A FLAME" in random positions
void spellPhrase() {
  String phrase = "LIKE A MOTH TO A FLAME";
  textAlign(CENTER, CENTER);
  textSize(90);  // Bigger font size

  for (int i = 0; i < phrase.length(); i++) {

    if (random(1) > 0.5) {
      textFont(defaultFont);  // Default font
    }

    fill(random(1) > 0.5 ? 255 : color(0, 255, 0));  // Randomly pick between white or neon green
    float x = random(100, width - 100);
    float y = random(100, height - 100);
    text(phrase.charAt(i), x, y);  // Draw letters randomly on canvas
  }
}

// Keyboard controls for effects
void keyPressed() {
  if (key == '1') {
    scene = 1;  // Scene 1 with circular motion of Moth01
  }

  if (key == '2') {
    scene = 2;  // Scene 2 with Moth02
  }

  if (key == '3') {
    scene = 3;  // Scene 3 with Moth03
  }

  // Invert flash effect ('i' key)
  if (key == 'i') {
    invertFlash = !invertFlash;  // Toggle flash effect
  }

  // Spell "LIKE A MOTH TO A FLAME" in random positions ('s' key)
  if (key == 's') {
    spellPhrase();
  }

  // Neon green radar effect with circles from the center ('o' key)
  if (key == 'o') {
    circleOutlineEffect = !circleOutlineEffect;  // Toggle radar circle effect
  }

  // Tiling effect of Moth02 and Moth03 (fills the whole screen) ('t' key)
  if (key == 't' && scene != 1) { // Ensure 't' doesn't work in Scene 1
    tileEffect = !tileEffect;  // Toggle tiling effect
  }

  // Generate neon square in random places ('h' key)
  if (key == 'h') {
    fill(0, 255, 0);  // Neon green color
    noStroke();
    rect(random(width), random(height), 100, 100);  // Randomly generate a neon square
  }

  // Pixel moths in random places ('m' key)
  if (key == 'm') {
    pixelMothEffect = !pixelMothEffect;  // Toggle pixel moth effect
  }
}
