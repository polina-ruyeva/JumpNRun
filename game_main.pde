Player player_var;
PImage player_img;
PImage platform_img;
PImage tree_img;
PImage background_img;
PImage img;

import processing.sound.*;
import gifAnimation.*;

SoundFile backgroundSound;

Gif myAnimation;
Gif enemyAnimation;
Gif santaIntroAnimation;

PVector gravity = new PVector(0, 0.25);

ArrayList <Enemy> enemies = new ArrayList<Enemy>();  

boolean running = false;
boolean gameOver = false;

int score = 0;
int highScore = 0;

int widthScreen = 1200;

void setup()
{
  size(1200,500);
  player_var = new Player();
  player_img = loadImage("texture\\player_img.jpg");
  platform_img = loadImage("texture\\platform_v1.png");
  tree_img = loadImage("texture\\tree.png");
  img = loadImage("texture\\background_v3.png");

  myAnimation = new Gif(this, "texture\\run_v2.gif");
  myAnimation.play();

  enemyAnimation = new Gif(this, "texture\\enemy_run.gif");
  enemyAnimation.play();

  backgroundSound = new SoundFile(this, "sound\\Winds Of Stories.wav");
  backgroundSound.play();

  santaIntroAnimation = new Gif(this, "texture\\santa_intro.gif");
  santaIntroAnimation.play();
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
    textSize (70);
    fill(0);
    text("Start game?", width/3, 200);
    fill(0);
    textSize (20);
    text("Press s to begin", width/3, 250);

    text("High Score: ", width/1.5, 50);
    text(highScore, width/1.2, 50);

    imageMode(CORNER);
    image(santaIntroAnimation, width/1.5, 200, 400, 400);

    if (keyPressed){
      if (key == 's' || key == 'S'){
        running = true;
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
    if(player_var.pos.y == height-210)
      {
        PVector up = new PVector(0,-100);
        player_var.applyAcc(up); 
      }
  }
  
  background(153,50,204);

  int x = frameCount % img.width;
  for (int i = -2*x ; i < width ; i += img.width) {
    copy(img, 0, 0, img.width, height, i, 0, img.width, height);
  }

  showScores();

  player_var.update();
  player_var.show();

  for(int i= enemies.size() - 1; i >= 0; i--)
  {
    Enemy blk = enemies.get(i);
    blk.update();
    blk.show();

    if (blk.hits(player_var)){
      gameOver = true;
    }

    if(blk.x < -blk.width)
    {
      enemies.remove(i);
      score++;
    }
  }
}

void gameOverScreen(){
  for(int i= enemies.size() - 1; i >= 0; i--){
      enemies.remove(i);
  }
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