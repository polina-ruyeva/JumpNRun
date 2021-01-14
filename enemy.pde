class Enemy
{
  float bottom;

  float width = 70;
  float x; 
  float speed = 4;

  Enemy(){
    bottom = random(140, 145); 
    x = widthScreen + width; 
  }
  
  boolean hits(Player player)
  {
    return ((player.pos.x > x) && (player.pos.x < (x + width))) &&  (player.pos.y > (height - bottom - player.r));
  }

  boolean hitsBullet(Bullet bullet)
  {
    return ((bullet.x > x) && (bullet.x < (x + width))) &&  (bullet.y > (height - bottom - bullet.width));
  }
  
  void update(){
    if(running){
     x -= speed; 
    }
  }
  
  void show(){
    if (running){
      stroke(0,0,0);
      strokeWeight(2);
      imageMode(CORNER); 
      image(enemyAnimation, x, height - bottom, width, bottom - 80);
    }
  } 

  void death(){
    imageMode(CORNER);
    image(enemyDeathAnimation, x, height - bottom, width, bottom - 80);
  }
}
