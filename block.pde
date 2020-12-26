class Block
{
  float bottom;
  
  float width = 45;
  float x; 
  float speed = 4;
  
  Block()
  {
    bottom = random(140, 150); 
    x = widthScreen + width; 
  }
  
  boolean hits(Player player)
  {
    return ((player.pos.x > x) && (player.pos.x < (x + width))) &&  (player.pos.y > (height - bottom - player.r));
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
      image(tree_img, x, height - bottom, width, bottom - 80);
    }
}
}
