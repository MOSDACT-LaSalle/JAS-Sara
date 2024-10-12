import ddf.minim.*;
import oscP5.*;
import netP5.*;
Minim minim;
AudioPlayer player;
PImage moth01, moth02, moth03;
PFont defaultFont;  // Declarar defaultFont globalmente
int scene = 1; // Default scene
boolean invertFlash = false;
boolean glitchEffect = false;
boolean circleOutlineEffect = false;
boolean tileEffect = false;
boolean pixelMothEffect = false;
int radarRadius = 0; // For radar effect
float filtro = 0.0; // Variable OSC para controlar el filtro
OscP5 oscP5;
NetAddress myRemoteLocation;

// Variables for circular motion in Scene 1
float angle = 0; // Initialize the angle for circular motion
float radius = 200; // Set the radius for the circular path

// Variables for dynamic radial ellipses in Scene 4
int numEllipses = 10;  // Number of smaller ellipses
float[] ellipseAngles = new float[numEllipses];  // Array for the angles of the smaller ellipses
float[] ellipseSpeeds = new float[numEllipses];  // Array for the speeds of the smaller ellipses
float[] ellipseDistances = new float[numEllipses];   // Distances of each ellipse from the center

void setup() {
  size(800, 800);
  
    
  // Inicializa Minim y carga el archivo de audio
  minim = new Minim(this);
  player = minim.loadFile("audio.mp3");  // Asegúrate de que el archivo esté en la carpeta "data"

  // Reproducir el audio
  player.play();
  
  noCursor();  // Hide the cursor
  fullScreen(); // Full screen
  frameRate(60); // Smooth frame rate
  moth01 = loadImage("moth01.png");  // Load moth01 image
  moth02 = loadImage("moth02.png");  // Load moth02 image
  moth03 = loadImage("moth03.png");  // Load moth03 image

  // Load fonts
  defaultFont = createFont("Arial", 100);  // Inicializar defaultFont
  
  background(0); // Start with black background

  // Setup OSC
  oscP5 = new OscP5(this, 12000); // Puerto 12000 para recibir OSC
  
  // Initialize ellipse angles and speeds for Scene 4
  for (int i = 0; i < numEllipses; i++) {
    ellipseAngles[i] = random(TWO_PI);  // Random angle for each ellipse
    ellipseSpeeds[i] = random(1, 3);  // Random speed for each ellipse
    ellipseDistances[i] = 0;  // Start each ellipse at the center
  }
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
  } else if (scene == 4) {
    // Efecto principal: elipse central
    noFill();
    stroke(255 * filtro, 0, 255 * (1 - filtro), 150); // Color del borde controlado por el filtro
    strokeWeight(2);
    ellipse(width / 2, height / 2, 300 * filtro, 300 * filtro); // Tamaño de la elipse principal controlado por el filtro
    
    // Dibujar las elipses más pequeñas que se expanden radialmente desde el centro
    for (int i = 0; i < numEllipses; i++) {
      // Calcular la posición de cada elipse en su trayectoria radial
      float x = width / 2 + cos(ellipseAngles[i]) * ellipseDistances[i];
      float y = height / 2 + sin(ellipseAngles[i]) * ellipseDistances[i];
      
      stroke(255 * (1 - filtro), 255 * filtro, 150, 200); // Color del borde inverso al de la elipse principal
      ellipse(x, y, 100 * filtro, 100 * filtro);  // Tamaño controlado por el filtro

      // Actualizar la distancia de las elipses desde el centro
      ellipseDistances[i] += ellipseSpeeds[i] * filtro;  // Controlar la velocidad de expansión con el filtro

      // Si la elipse se sale de los límites de la pantalla, resetearla
      if (ellipseDistances[i] > width / 2) {  // Si la elipse está fuera del área visible
        ellipseDistances[i] = 0;  // Reiniciar la distancia
        ellipseAngles[i] = random(TWO_PI);  // Asignar un nuevo ángulo aleatorio
      }
    }
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
void stop() {
  // Detener la reproducción cuando se cierre el sketch
  player.close();
  minim.stop();
  super.stop();
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

  if (key == '4') {
    scene = 4;  // Activar escena 4
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

// Recibir mensajes OSC
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/Filtro")) {
    filtro = theOscMessage.get(0).floatValue();  // Actualiza la variable filtro con el valor recibido
  }
}
