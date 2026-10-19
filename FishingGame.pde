// Import sound for background music
import processing.sound.*;
SoundFile file;

// Fishing variables
boolean lineCast = false;
boolean fishBiting = false;
boolean casting = false;
boolean gotLocation = false;
boolean upKeyWasPressed = false;

// Varaibles for player
float velocityY = 0;
float gravity = 0.2;
float miniY = 325;

// Character Animation
float idleY = 275;
float idleSpeed = 0.1;

//Bob Animation
float bobbingSpeed = 0.1;

// Fish
String[] fish = {"Bass", "Carp", "Trout", ""};
int[] price = {10, 20, 50, 0};
String[] rarity = {"50%", "30%", "20%", ""};
int lastCatch = 3;

// Fish Variables
float location = 0;
float fishY = 285;
int biteDelay = 3000;

// Time to catch fish
int castStartTime = 0;

// Player Fishing Sore
int score = 40;

// Player's Stats
int fishCaught = 0;
int money = 0;

// Fishing line position
float lineX = 500;
float lineY = 350;

// Set Up Game
void setup() {
  size(900, 650);
  noSmooth();
  frameRate(30);
  textFont(createFont("Serif", 24, true));
  
  // Load the MP3 from data folder
  file = new SoundFile(this, "music.mp3");
  file.play();
}

// Draw Function
void draw() {
  drawWater();
  drawShore();
  drawDock();
  drawFisherman();
  drawHUD();
  animation();
  
  // line is casted start fishing
  if (lineCast) fishing();
}

// ---------------- WATER ----------------

void drawWater() {
  background(25, 105, 160);
  noStroke();
  
  
  
  //  water patches
  for (int i = 0; i < 90; i++) {
    float x = (i * 97) % width;
    float y = (i * 61) % height;

    fill(35, 120, 175);
    rect(x, y, 5, 22);

    fill(55, 140, 190);
    rect(x + 5, y, 3, 15);
  }

  // Lily pads
  fill(55, 145, 65);
  rect(680, 150, 30, 15);
  rect(700, 160, 20, 12);
  rect(760, 380, 26, 15);
  rect(625, 480, 30, 15);
  rect(850, 250, 25, 14);

  fill(95, 180, 75);
  rect(687, 153, 12, 4);
  rect(766, 383, 10, 4);
}

// ---------------- SHORE ----------------

void drawShore() {
  noStroke();

  // Grass
  fill(65, 145, 55);
  rect(0, 0, 190, height);

  // Sand
  fill(205, 175, 110);
  rect(175, 0, 15, height);


  // Bushes
  fill(35, 105, 45);
  rect(15, 80, 55, 40);
  rect(70, 100, 45, 35);
  rect(25, 400, 65, 45);
  rect(95, 520, 55, 40);

  fill(45, 125, 50);
  rect(25, 70, 40, 30);
  rect(80, 90, 35, 25);
  rect(35, 390, 45, 30);
}

// ---------------- DOCK ----------------

void drawDock() {
  noStroke();

  // Dock shadow
  fill(20, 65, 85);
  rect(180, 260, 240, 165);

  // Wooden dock
  fill(125, 75, 40);
  rect(180, 245, 225, 165);

  fill(165, 105, 60);
  rect(185, 250, 215, 155);

  // Wooden Plank Lines
  for (int y = 250; y < 405; y += 25) {
    stroke(105, 65, 35);
    strokeWeight(2);
    line(185, y, 400, y);
  }

  noStroke();

  // Dock posts
  fill(90, 50, 28);
  rect(180, 245, 16, 16);
  rect(389, 245, 16, 16);
  rect(180, 394, 16, 16);
  rect(389, 394, 16, 16);
}

// ---------------- FISHERMAN ----------------

void drawFisherman() {
  noStroke();

  // Pants
  fill(45, 65, 105);
  rect(278, 305, 32, 28);
  stroke(0, 0, 50);
  strokeWeight(2);
  line(294, 310, 294, 332);
  noStroke();

  // Boots
  fill(70, 45, 30);
  rect(274, 333, 15, 12);
  rect(299, 333, 15, 12);

  //idle animation speed
  idleY += idleSpeed;
  
  // Shirt
  fill(175, 55, 45);
  rect(273, 275, 42, 32);
  rect(265, idleY + 7, 10, 20);
  rect(313, idleY + 7, 10, 20);

  // Head
  fill(230, idleY - 100, 125);
  rect(280, idleY - 22, 28, 24);

  // Hair
  fill(85, 50, 30);
  rect(277, idleY - 25, 34, 10);

  // Straw hat
  fill(220, 175, 65);
  rect(270, idleY - 35, 48, 15);
  rect(278, idleY - 45, 32, 10);

  stroke(255, 0, 0);
  strokeWeight(3);
  line(279, idleY - 37, 310, idleY - 37);

  // draw the rod
  drawRod();

  noStroke();
}

void drawRod(){
  if (casting){
    // Fishing rod
    stroke(80, 45, 25);
    strokeWeight(5);
    line(315, idleY + 9, idleY + 5, idleY - 60);
  
    // Small rod tip
    stroke(45, 30, 20);
    strokeWeight(3);
    line(280, idleY - 60, idleY - 2, idleY - 73);
    
  } else{
    // Fishing rod
    stroke(80, 45, 25);
    strokeWeight(5);
    line(315, idleY + 9, idleY + 75, idleY - 60);
  
    // Small rod tip
    stroke(45, 30, 20);
    strokeWeight(3);
    line(350, idleY - 60, idleY + 82, idleY - 73);
    
    // Bobbing Animation speed
    lineY += bobbingSpeed;
    
    //fishing line
    if (lineCast){
      stroke(255);
      strokeWeight(2);
      line(357, idleY - 73, lineX, lineY);
      
      noStroke();
      
      // Bob
      fill (200,0,0);
      circle(lineX, lineY, 10);
      if (lineY > 350) fill(25, 105, 160, 200);
      circle(lineX, lineY, 10);
      
        
    }
  }
}

// ---------------- GAME HUD ----------------

void drawHUD() {
  // Top left information panel
  stroke(0);
  strokeWeight(3);
  fill(15, 40, 60, 220);
  rect(15, 15, 225, 160);

  fill(255);
  textSize(22);
  text("FISHING SIMULATOR", 25, 42);

  textSize(16);
  text("Money: $" + money, 25, 66);
  text("Fish caught: " + fishCaught, 25, 84);
  
  textSize(18);
  text("Last Catch:", 25, 110);
  textSize(16);
  text("Fish Caught: " + fish[lastCatch], 25, 128);
  text("Value: $" + price[lastCatch], 25, 146);
  text("Rarity: " + rarity[lastCatch], 25, 164);

  // Bottom right controls
  
  fill(15, 40, 60, 220);
  rect(680, 550, 200, 86);

  fill(255);
  textSize(16);
  text("Controls: \nWind Up Rod: LEFT \nCast Rod: RIGHT \nCatch Fish(TAP): UP", 690, 568);
  noStroke();
}


//------------ KEY PRESSED -----------
void keyPressed() {
  // Wind up the rod
  if (keyCode == LEFT && !lineCast) {
    casting = true;
  }
  // Cast the rod
  else if (casting && keyCode == RIGHT) {
    lineCast = true;
    casting = false;

    castStartTime = millis();
    biteDelay = 3000;
  }

  // Apply upward force once per tap
  if (keyCode == UP && !upKeyWasPressed) {
    if (fishBiting) {
      velocityY -= 3;
    }
    upKeyWasPressed = true;
  }
}

void keyReleased() {
  if (keyCode == UP) {
    upKeyWasPressed = false;
  }
}


//------------ FISHING --------------
void fishing() {

  // Wait until enough time has passed
  if (!fishBiting) {
    fill(255, 255, 0);
    textSize(20);
    text("Waiting for a bite...", 500, 150);
    if (millis() - castStartTime >= biteDelay) {
      fishBiting = true;
    }
  }

  // When fish is biting
  if (fishBiting) {
    
    //create box for game
    stroke(0);
    strokeWeight(2);
    fill(15, 40, 60, 220);
    rect(740, 190, 20, 270);
    
    
    // show fish biting text and score
    fill(255, 255, 0);
    textSize(20);
    text("A FISH IS BITING!", 500, 150);
    text("SCORE: " + score / 2 + "%", 700, 500);
    
    // -- FISH MECHANICS --
    
    // fish display
    fill(0, 255, 0 ,200);
    stroke(0,150,0);
    rect(745, fishY, 10, 80);
    noStroke();
    
    // random movement generator
    if (!gotLocation) {
      location = random(180) + 195;
      gotLocation = true;
    }
    if (gotLocation){
      if (fishY > location + 1) fishY -= 2;
      else if (fishY < location - 1) fishY += 2;
      else gotLocation = false;
    }
    
    // -- PLAYER MECHANICS --
    
    // catching fish minigame
    velocityY += gravity;
    miniY += velocityY;
    
    // upper bound
    if(miniY < 200){ 
      velocityY = 0;  
      miniY = 200;
    }
    
    // lower bound
    if(miniY > 450){ 
      velocityY = 0;  
      miniY = 450;
    }
    // velocity cap
    if(velocityY > 5) velocityY = 5;
    if(velocityY < -3) velocityY = -3;
    
    // draw player
    fill(255,255,0);
    circle(750, miniY, 10);
    
    // SCORE MECHANIC
    
    if (miniY > fishY && miniY < fishY + 80) score++;
    else score -= 0.5;
    
    // catch fish and end game
    if (score >= 200) {
      gameEnd();
      fishCaught();
    }
    
    // end game if score = 0
    if (score == 0) gameEnd();
  }
}

// end the game and reset the games variables
void gameEnd(){
  lineCast = false;
  fishBiting = false;
  casting = false;
  gotLocation = false;
  score = 40;
  miniY = 325;
  fishY = 285;
  velocityY = 0;
}


// Fish Caught Handler
void fishCaught(){
  // drop rate for three kinds of fish
  int x = (int)random(10);
  fishCaught++;
  if (x < 5) {
    lastCatch = 0;
    money += price[lastCatch];
  } else if (x > 7){
    lastCatch = 2;
    money += price[lastCatch];
  } else {
    lastCatch = 1;
    money += price[lastCatch];
  }
}

// ------- ANIMATIONS ------
void animation(){
  // character idle animation
  if(idleY >= 276) idleSpeed = -0.1;
  else if (idleY <=273) idleSpeed = 0.1;
  
  // bob bobbing animation
  if (lineY >= 352) bobbingSpeed = -0.1;
  else if (lineY <= 348) bobbingSpeed = 0.1;
}
