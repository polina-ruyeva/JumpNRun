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
  
  boolean hits(Player player)
  {
    return ((player.pos.x > x) && (player.pos.x < (x + width))) &&  (player.pos.y > (height - bottom - player.r));
  }

  boolean hitsFireball(Fireball fireball)
  {
    return ((fireball.x > x) && (fireball.x < (x + width))) &&  (fireball.y > (height - bottom - fireball.width));
  }
  
  void update(){
    speed = currentSpeedEnemy;
    x -= speed;
  }
  
  void show(){
      stroke(0,0,0);
      strokeWeight(2);
      imageMode(CORNER); 
      image(enemyAnimation, x, height - bottom, width, 70);
  } 
}
