Player player_var;
PImage player_img;
PImage platform_img;
PImage tree_img;
PImage background_img;
PImage img;
PImage background_intro;
PImage fireball_img; 

import processing.sound.*;
import gifAnimation.*;

SoundFile backgroundSound;

Gif myAnimation;
Gif enemyAnimation;
Gif santaIntroAnimation;

PVector gravity = new PVector(0, 0.25);

ArrayList <Enemy> enemies = new ArrayList<Enemy>();  
ArrayList <Bullet> bullets = new ArrayList<Bullet>();  

boolean running = false;
boolean gameOver = false;

int score = 0;
int highScore = 0;
int coolDown = 0;

int time;
int timeTillCooldown = 15;
int wait = 1000;
int startCountdownTime;
boolean tick;

int widthScreen = 1200;

void setup()
{
  size(1200,500);
  preload();

  time = millis(); //store the current time
  smooth();
  strokeWeight(3);
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
      } else gameOverScreen();
    }   
}

void startScreen()
{
    background (255,255,255);
    
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


  if (running){
    if(random(1) < 0.5 && frameCount % 80 == 0) // Speed and distance
        {
          enemies.add(new Enemy()); 
        }
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
  //------
  if (mousePressed){
    if (timeTillCooldown == 0){ 
      bullets.add(new Bullet(player_var.pos.x, player_var.pos.y + 40));
      timeTillCooldown = 15;
      startCountdownTime = millis();
      time = 0;
    }
  }
  //----
  background(153,50,204);

  int x = frameCount % img.width;
  for (int i = -2*x ; i < width ; i += img.width) {
    copy(img, 0, 0, img.width, height, i, 0, img.width, height);
  }

  // ----
   //(if(millis() - time >= 1000){
   //also update the stored time
    //timeTillCooldown = 15 - time/1000;
   if(((millis() -startCountdownTime) - time >= 1000) && (timeTillCooldown > 0)) {
    time = millis() - startCountdownTime;
    timeTillCooldown = 15 - time/1000;
  }

  text(timeTillCooldown, width/7, 50);
  // ------

  showScores();

  player_var.update();
  player_var.show();
  
  //------
  for(int i= bullets.size() - 1; i >= 0; i--){
    Bullet bllt = bullets.get(i);
    
    bllt.update();
    bllt.show();

    if(bllt.x <-bllt.width)
    {
      bullets.remove(i);
    }
  }
  //-------

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
        if (coolDown > 0){
          coolDown --;
        }
      }    
    } catch (Exception e) {
      
    } finally {
      
    }

  }
}

void checkForEnemyHitsBullet(Enemy enemy, int currentEnemyInArray){
  for(int h= bullets.size() - 1; h >= 0; h--){
    if (enemy.hitsBullet(bullets.get(h))){
      bullets.remove(h);
      enemies.remove(currentEnemyInArray);
    }
  } 
}

void gameOverScreen(){
  for(int i= enemies.size() - 1; i >= 0; i--){
      enemies.remove(i);
  }
  timeTillCooldown = 15;
  time = 0;

  background(255,0,0);
  textSize (70);
  fill(0);
  text("Game Over", width/3, 200);
  
  if (keyPressed){
    gameOver = false;
    running = false;
    if (score > highScore){
      highScore = score;
    };
    score = 0;
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
  player_img = loadImage("texture\\player_img.jpg");
  platform_img = loadImage("texture\\platform_v1.png");
  tree_img = loadImage("texture\\tree.png");
  img = loadImage("texture\\background_v3.png");
  background_intro = loadImage("texture\\background_intro_v2.jpg");
  fireball_img = loadImage("texture\\Fireball.png");

  myAnimation = new Gif(this, "texture\\run_v2.gif");
  myAnimation.play();

  enemyAnimation = new Gif(this, "texture\\enemy_run.gif");
  enemyAnimation.play();

  backgroundSound = new SoundFile(this, "sound\\Winds Of Stories.wav");
  backgroundSound.play();

  santaIntroAnimation = new Gif(this, "texture\\santa_intro.gif");
  santaIntroAnimation.play();
}