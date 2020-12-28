Player player_var;
PImage player_img;
PImage platform_img;
PImage tree_img;
 PImage img;

PVector gravity = new PVector(0, 0.25);

ArrayList <Block> blocks = new ArrayList<Block>();  

boolean running = false;
boolean gameOver = false;

int score = 0;
int highScore = 0;

int widthScreen = 1200;

// 
//int xStep;
//float backgroundMove = 0;

void setup()
{
  size(1200,500);
  player_var = new Player();
  player_img = loadImage("texture\\player_img.jpg");
  platform_img = loadImage("texture\\platform_v1.png");
  tree_img = loadImage("texture\\tree.png");
  background_img = loadImage("texture\\background.jpg");
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
          blocks.add(new Block()); 
        }
  }
  
  if(keyPressed)
  {
    
      if(player_var.pos.y == height-170)
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

  text("High Score: ", width/1.5, 50);
  text(highScore, width/1.2, 50);
  text("Score: ", width/3, 50);
  text(score, width/2.5, 50);

  player_var.update();
  player_var.show();

  for(int i= blocks.size() - 1; i >= 0; i--)
  {
    Block blk = blocks.get(i);
    blk.update();
    blk.show();

    if (blk.hits(player_var)){
      gameOver = true;
    }

    if(blk.x < -blk.width)
    {
      blocks.remove(i);
      score++;
    }
  }


}

  void gameOverScreen(){
    for(int i= blocks.size() - 1; i >= 0; i--){
       blocks.remove(i);
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
