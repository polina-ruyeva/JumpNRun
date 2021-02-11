Player player_var;
PImage player_img;
PImage platform_img;
PImage img;
PImage background_intro;
PImage fireball_img; 
PImage highScore_img;

import processing.sound.*;
import gifAnimation.*;

SoundFile backgroundSound;

Gif santaAnimation;
Gif enemyAnimation;
Gif santaIntroAnimation;
Gif enemyDeathAnimation;

PVector gravity = new PVector(0, 0.25);

ArrayList <Enemy> enemies = new ArrayList<Enemy>();  
ArrayList <Fireball> fireballs = new ArrayList<Fireball>();  

boolean running = false;
boolean gameOver = false;

int score = 0;
int highScore = 0;
int scoreTillNextLevelUp = 10;

int time;
int timeTillCooldown = 15;
int wait = 1000;
int startCountdownTime;

float currentSpeedEnemy = 4;

boolean newHighScore = false;

Delay delay;

int widthScreen = 1200;

void setup()
{
  size(1200,500);
  preload();

  time = millis();
  surface.setTitle("King Santa vs Little Red Devils");
  smooth();
  strokeWeight(2);
}

void draw()
{
    if(running == false) 
    {
      startScreen();
    }
    else if(running == true)
    {
      if (gameOver == false){
        game();
      } else 
        gameOverScreen();
    }   
}

void startScreen()
{   
    background(background_intro);
    textSize (70);
    fill(255,255,255);
    text("Start game?", width/12, 150);
    textSize (20);
    text("Press s to begin", width/12, 190);

    showHighScore();

    imageMode(CORNER);
    image(santaIntroAnimation, width/1.5, 200, 400, 400);


    if (keyPressed){
      if (key == 's' || key == 'S'){
        running = true;
        startCountdownTime = millis();
      }
    }
}

void game(){
  if(random(1) < 0.5 && frameCount % 80 == 0) 
  {
    enemies.add(new Enemy()); 
  }

  if(keyPressed)
  {
    if (key == ' '){
      if(player_var.pos.y == height-210)
        {
          PVector up = new PVector(0,-100);
          player_var.applyAcc(up); 
        }
    }
  }

  if (mousePressed){
    if (timeTillCooldown == 0){ 
      fireballs.add(new Fireball(player_var.pos.x, player_var.pos.y + 40));
      timeTillCooldown = 15;
      startCountdownTime = millis();
      time = 0;
    }
  }

  background(153,50,204);

  int x = frameCount % img.width;
  for (int i = -2*x ; i < width ; i += img.width) {
    copy(img, 0, 0, img.width, height, i, 0, img.width, height);
  }

  if(((millis() -startCountdownTime) - time >= 1000) && (timeTillCooldown > 0)) {
    time = millis() - startCountdownTime;
    timeTillCooldown = 15 - time/1000;
  }

  text("Countdown: ", width/25, 50);
  text(timeTillCooldown, width/7, 50);

  showScores();

  player_var.update();
  player_var.show();
  
  for(int i= fireballs.size() - 1; i >= 0; i--){
    Fireball bllt = fireballs.get(i);
    
    bllt.update();
    bllt.show();

    if(bllt.x <-bllt.width)
    {
      fireballs.remove(i);
    }
  }

  for(int i= enemies.size() - 1; i >= 0; i--)
  {
    try {
      Enemy blk = enemies.get(i);
      blk.update();
      blk.show();

      if (blk.hits(player_var)){
        gameOver = true;
      }

      checkForEnemyHitsBullet(blk, i); 

      if(blk.x < -blk.width){
        enemies.remove(i);
        score++;
        if (scoreTillNextLevelUp > 0){
          scoreTillNextLevelUp--;
        } else{
          if (currentSpeedEnemy < 8){
            currentSpeedEnemy = currentSpeedEnemy * 1.10;
            scoreTillNextLevelUp = 10;
          }
        }
      }    
    } catch (Exception e) {
    } finally {
    }

  }
}

void checkForEnemyHitsBullet(Enemy enemy, int currentEnemyInArray){
  for(int h= fireballs.size() - 1; h >= 0; h--){
    if (enemy.hitsFireball(fireballs.get(h))){
      fireballs.remove(h);
      enemies.remove(currentEnemyInArray);
      score++;
    }
  } 
}

void gameOverScreen(){
  for(int i= enemies.size() - 1; i >= 0; i--){
      enemies.remove(i);
  }
  timeTillCooldown = 15;
  time = 0;
  currentSpeedEnemy = 4;

  background(#bf2020);
  textSize (70);
  fill(255,255,255);
  text("Game Over", width/3, 200);
  textSize(30);

  if (score > highScore){
    highScore = score;
    newHighScore = true;
  }

  if (newHighScore == true){
    imageMode(CORNER); 
    image(highScore_img, width/1.4, 0, 250, 250);
  }

  text("Your current score: ", width/3, 250);
  text(score, width/1.6, 250);
  text("Your high score: ", width/3, 300);
  text(highScore, width/1.6, 300);

  text("Press any button to try it again", width/3.3, 400);
  
  if (keyPressed){
    gameOver = false;
    running = false;
    score = 0;
    newHighScore = false;
  }
}

void showScores(){
  showScore();
  showHighScore();
}

void showScore(){
  text("Score: ", width/3, 50);
  text(score, width/2.5, 50);
}

void showHighScore(){
  text("High Score: ", width/1.5, 50);
  text(highScore, width/1.2, 50);
}

void preload(){
  player_var = new Player();
  img = loadImage("texture\\background_v4.png");
  background_intro = loadImage("texture\\background_intro_v2.jpg");
  fireball_img = loadImage("texture\\Fireball.png");
  highScore_img = loadImage("texture\\high_score_v3.png");

  santaAnimation = new Gif(this, "texture\\run_v2.gif");
  santaAnimation.play();

  enemyAnimation = new Gif(this, "texture\\enemy_run.gif");
  enemyAnimation.play();

  backgroundSound = new SoundFile(this, "sound\\Winds Of Stories.wav");
  backgroundSound.amp(0.05);
  backgroundSound.play();

  santaIntroAnimation = new Gif(this, "texture\\santa_intro.gif");
  santaIntroAnimation.play();

  enemyDeathAnimation = new Gif(this, "texture\\enemy_death.gif");
  enemyDeathAnimation.play();
}