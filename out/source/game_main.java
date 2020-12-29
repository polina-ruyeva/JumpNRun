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
PImage tree_img;
PImage background_img;
PImage img;

String audioName = "Winds Of Stories.mp3";
String path;




SoundFile backgroundSound;

Gif myAnimation;
Gif enemyAnimation;

PVector gravity = new PVector(0, 0.25f);

ArrayList <Enemy> enemies = new ArrayList<Enemy>();  

boolean running = false;
boolean gameOver = false;

int score = 0;
int highScore = 0;

int widthScreen = 1200;

// 
//int xStep;
//float backgroundMove = 0;

public void setup()
{
  
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
      } else gameOverScreen();
    }   
}

public void startScreen()
{
    background (255,255,255);
    textSize (70);
    fill(0);
    text("Start game?", width/3, 200);
    fill(0);
    textSize (20);
    text("Press s to begin", width/3, 250);

    text("High Score: ", width/1.5f, 50);
    text(highScore, width/1.2f, 50);

    if (keyPressed){
      if (key == 's' || key == 'S'){
        running = true;
      }
    }
    
}

public void game(){

  if (running){
    if(random(1) < 0.5f && frameCount % 80 == 0) // Speed and distance
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


  /*for(int i=0; i<4; i++){
    image(platform_img, platform_img.width*i + backgroundMove, height-platform_img.height);
    backgroundMove = backgroundMove  -1;
    if (backgroundMove < (-1*platform_img.width)){ 
      backgroundMove = 0;
    }
  }*/


  int x = frameCount % img.width;
  for (int i = -2*x ; i < width ; i += img.width) {
    copy(img, 0, 0, img.width, height, i, 0, img.width, height);
  }
  text("High Score: ", width/1.5f, 50);
  text(highScore, width/1.2f, 50);
  text("Score: ", width/3, 50);
  text(score, width/2.5f, 50);

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

  public void gameOverScreen(){
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
class Enemy
{
  float bottom;
  
  float width = 70;
  float x; 
  float speed = 4;
  
  Enemy()
  {
    bottom = random(140, 160); 
    x = widthScreen + width; 
  }
  
  public boolean hits(Player player)
  {
    return ((player.pos.x > x) && (player.pos.x < (x + width))) &&  (player.pos.y > (height - bottom - player.r));
  }
  
  public void update(){
    if(running){
     x -= speed; 
    }
  }
  
  public void show(){
    if (running){
      stroke(0,0,0);
      strokeWeight(2);
      imageMode(CORNER); 
      //image(tree_img, x, height - bottom, width, bottom - 80);
      image(enemyAnimation, x, height - bottom, width, bottom - 80);
    }
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
    //image(player_img, pos.x,pos.y,r*2,r*2);
    //image(platform_img, 20, height-100,500,100);
    image(myAnimation,pos.x,pos.y,r*2,r*2);
    //image(myAnimation,20,20);
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
  public void settings() {  size(1200,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "game_main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
