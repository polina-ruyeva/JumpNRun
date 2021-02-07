import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import gifAnimation.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class game_main extends PApplet {

Player player_var;
PImage player_img;
PImage platform_img;
PImage img;
PImage background_intro;
PImage fireball_img; 
PImage highScore_img;




SoundFile backgroundSound;

Gif santaAnimation;
Gif enemyAnimation;
Gif santaIntroAnimation;
Gif enemyDeathAnimation;

PVector gravity = new PVector(0, 0.25f);

ArrayList <Enemy> enemies = new ArrayList<Enemy>();  
ArrayList <Bullet> bullets = new ArrayList<Bullet>();  

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

public void setup()
{
  
  preload();

  time = millis();
  
  strokeWeight(3);
}

public void draw()
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

public void startScreen()
{   
    background(background_intro);
    textSize (70);
    fill(255,255,255);
    text("Start game?", width/12, 150);
    textSize (20);
    text("Press s to begin", width/12, 190);

    showHighScore();

    imageMode(CORNER);
    image(santaIntroAnimation, width/1.5f, 200, 400, 400);


    if (keyPressed){
      if (key == 's' || key == 'S'){
        running = true;
        startCountdownTime = millis();
      }
    }
}

public void game(){
  if(random(1) < 0.5f && frameCount % 80 == 0) 
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
      bullets.add(new Bullet(player_var.pos.x, player_var.pos.y + 40));
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
  
  for(int i= bullets.size() - 1; i >= 0; i--){
    Bullet bllt = bullets.get(i);
    
    bllt.update();
    bllt.show();

    if(bllt.x <-bllt.width)
    {
      bullets.remove(i);
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
            currentSpeedEnemy = currentSpeedEnemy * 1.10f;
            scoreTillNextLevelUp = 10;
          }
        }
      }    
    } catch (Exception e) {
      
    } finally {
      
    }

  }
}

public void checkForEnemyHitsBullet(Enemy enemy, int currentEnemyInArray){
  for(int h= bullets.size() - 1; h >= 0; h--){
    if (enemy.hitsBullet(bullets.get(h))){
      bullets.remove(h);
      enemies.remove(currentEnemyInArray);
      score++;
    }
  } 
}

public void gameOverScreen(){
  for(int i= enemies.size() - 1; i >= 0; i--){
      enemies.remove(i);
  }
  timeTillCooldown = 15;
  time = 0;
  currentSpeedEnemy = 4;

  background(0xffbf2020);
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
    image(highScore_img, width/1.4f, 0, 250, 250);
  }

  text("Your current score: ", width/3, 250);
  text(score, width/1.6f, 250);
  text("Your high score: ", width/3, 300);
  text(highScore, width/1.6f, 300);

  text("Press any button to try it again", width/3.3f, 400);
  
  if (keyPressed){
    gameOver = false;
    running = false;
    score = 0;
    newHighScore = false;
  }
}

public void showScores(){
  showScore();
  showHighScore();
}

public void showScore(){
  text("Score: ", width/3, 50);
  text(score, width/2.5f, 50);
}

public void showHighScore(){
  text("High Score: ", width/1.5f, 50);
  text(highScore, width/1.2f, 50);
}

public void preload(){
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
  backgroundSound.amp(0.1f);
  backgroundSound.play();

  santaIntroAnimation = new Gif(this, "texture\\santa_intro.gif");
  santaIntroAnimation.play();

  enemyDeathAnimation = new Gif(this, "texture\\enemy_death.gif");
  enemyDeathAnimation.play();
}
class Bullet
{
    float x;
    float y;
    float speed = 4;
    float width = 70;

    Bullet(float xpos, float ypos){
        this.x = xpos;
        this.y = ypos;
    }

    public void update(){
        x += speed;
    }
    
    public void show(){
        stroke(0,0,0);
        strokeWeight(2);
        imageMode(CORNER); 
        image(fireball_img, this.x, this.y, this.width, this.width);
    }
}
class Enemy
{
  float bottom;

  float width = 70;
  float x; 
  float speed;

  Enemy(){
    bottom = 140;
    x = widthScreen + width; 
    speed = currentSpeedEnemy;
  }
  
  public boolean hits(Player player)
  {
    return ((player.pos.x > x) && (player.pos.x < (x + width))) &&  (player.pos.y > (height - bottom - player.r));
  }

  public boolean hitsBullet(Bullet bullet)
  {
    return ((bullet.x > x) && (bullet.x < (x + width))) &&  (bullet.y > (height - bottom - bullet.width));
  }
  
  public void update(){
    speed = currentSpeedEnemy;
    x -= speed;
  }
  
  public void show(){
      stroke(0,0,0);
      strokeWeight(2);
      imageMode(CORNER); 
      image(enemyAnimation, x, height - bottom, width, bottom - 80);
  } 

  public void death(){
    imageMode(CORNER);
    image(enemyDeathAnimation, x, height - bottom, width, bottom - 80);
  }
}
class Player{
  PVector pos; 
  PVector acc;
  PVector vel; 

  float r=100; 
  
  Player()
  {
    pos = new PVector(50,(height-350));
    vel = new PVector(0, 20);
    acc = new PVector();
  }
      
  public void show()
  {
    fill(255,0,34);
    stroke(0,0,0);
    strokeWeight(2);
    imageMode(CORNER); 
    image(santaAnimation,pos.x,pos.y,r*2,r*2);
  }
  
  public void applyAcc(PVector acceleration) 
  {
    acc.add(acceleration); 
  }
  
  public void update()
  {
    applyAcc(gravity);
    pos.add(vel);

    if(pos.y >= height-210) 
      {
          pos.y=height-210;
          vel.mult(0);
      }
   
    vel.add(acc);
    vel.limit(7); 
   
    acc.mult(0);
  }  
}
  public void settings() {  size(1200,500);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "game_main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
