PFont defaultFont;

PImage moth01, moth02, moth03;
int scene = 1; // Default scene
boolean invertFlash = false;
boolean glitchEffect = false;
boolean circleOutlineEffect = false;
boolean tileEffect = false;
boolean pixelMothEffect = false;
int radarRadius = 0; // For radar effect

float cubeRotationX = 0; // Rotation for 3D cube
float cubeRotationY = 0;

void setup() {
  size(800, 800, P3D); // Canvas size with P3D renderer for 3D scenes
  noCursor();  // Hide the cursor
  frameRate(60); // Smooth frame rate
  moth01 = loadImage("moth01.png");  // Load moth01 image
  moth02 = loadImage("moth02.png");  // Load moth02 image
  moth03 = loadImage("moth03.png");  // Load moth03 image

  // Load fonts
  defaultFont = createFont("Arial", 70);  // Default font
  
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
    if (mouseX == 0 && mouseY == 0) {
      image(moth01, width / 2, height / 2, random(400, 420), random(400, 420)); // Moth01 centered
    } else {
      image(moth01, mouseX, mouseY, random(400, 420), random(400, 420)); // Follow the mouse
    }
  } else if (scene == 2) {
    imageMode(CORNER);
    image(moth02, width - 400, 0, 400, 400);  // Moth02 in top-right corner (400x400)
  } else if (scene == 3) {
    imageMode(CORNER);
    image(moth03, 0, height - 400, 400, 400);  // Moth03 in bottom-left corner (400x400)
  } else if (scene == 4) {
    // 3D scene with a rotating cube
    background(0); // Clear the screen with black background

    lights();  // Add 3D lights for better visibility of the cube
    directionalLight(150, 150, 150, 1, 0, -1); // Light from the right
    pointLight(255, 255, 255, width / 2, height / 2, 200); // Point light at the center
    
    translate(width / 2, height / 2);  // Move to the center of the canvas
    rotateX(cubeRotationX);  // Rotate around the X axis
    rotateY(cubeRotationY);  // Rotate around the Y axis
    
    // Draw the 3D cube and apply the image to all six sides
    textureMode(NORMAL);  // Use texture mode for image mapping
    beginShape(QUADS);
    
    // Front face
    texture(moth02);
    vertex(-150, -150, 150, 0, 0);
    vertex(150, -150, 150, 1, 0);
    vertex(150, 150, 150, 1, 1);
    vertex(-150, 150, 150, 0, 1);
    
    // Right face
    texture(moth03);
    vertex(150, -150, 150, 0, 0);
    vertex(150, -150, -150, 1, 0);
    vertex(150, 150, -150, 1, 1);
    vertex(150, 150, 150, 0, 1);
    
    // Back face
    texture(moth02);
    vertex(150, -150, -150, 0, 0);
    vertex(-150, -150, -150, 1, 0);
    vertex(-150, 150, -150, 1, 1);
    vertex(150, 150, -150, 0, 1);
    
    // Left face
    texture(moth03);
    vertex(-150, -150, -150, 0, 0);
    vertex(-150, -150, 150, 1, 0);
    vertex(-150, 150, 150, 1, 1);
    vertex(-150, 150, -150, 0, 1);

    // Top face
    texture(moth02);
    vertex(-150, -150, -150, 0, 0);
    vertex(150, -150, -150, 1, 0);
    vertex(150, -150, 150, 1, 1);
    vertex(-150, -150, 150, 0, 1);

    // Bottom face
    texture(moth03);
    vertex(-150, 150, -150, 0, 0);
    vertex(150, 150, -150, 1, 0);
    vertex(150, 150, 150, 1, 1);
    vertex(-150, 150, 150, 0, 1);
    
    endShape();
    
    // Update cube rotations
    cubeRotationX += 0.01;
    cubeRotationY += 0.01;
  } 

  // Apply effects globally across all scenes
  if (invertFlash) {
    filter(INVERT);  // Flash and invert effect
  }

  // Radar effect: Neon circle outline growing from the center ('o' key)
  if (circleOutlineEffect) {
    stroke(0, 255, 0);
    noFill();
    radarRadius += 10; // Faster expansion for radar effect
    ellipse(width / 2, height / 2, radarRadius, radarRadius); // Draw expanding circles from the center
    if (radarRadius > width) radarRadius = 0; // Reset radius when it reaches the edge
  }

  // Glitch effect: Ripple-like lines with more space between them ('g' key)
  if (glitchEffect) {
    int numLines = 100; // Number of ripple lines
    stroke(0, 255, 0); // Neon green for ripple effect
    noFill();
    for (int i = 0; i < numLines; i += 4) { // Increased spacing between lines
      float x = random(width);
      float y = random(height);
      float lineLength = width * random(0.4, 0.7);
      float noiseFactor = noise(i * 0.1, millis() * 0.0005);
      line(x, y, x + lineLength * noiseFactor, y + lineLength * noiseFactor); // Random ripple lines
    }
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
    // Randomly choose between default font and gothic font
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
    scene = 1;  // Scene 1 with Moth01
  }

  if (key == '2') {
    scene = 2;  // Scene 2 with Moth02
  }

  if (key == '3') {
    scene = 3;  // Scene 3 with Moth03
  }

  if (key == '4') {
    scene = 4;  // Scene 4 with 3D cube
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

  // Glitch effect with ripple-like lines ('g' key)
  if (key == 'g') {
    glitchEffect = !glitchEffect;  // Toggle ripple effect
  }

  // Tiling effect of Moth02 and Moth03 (fills the whole screen) ('t' key)
  if (key == 't') {
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
