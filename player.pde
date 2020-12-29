class Player{
  PVector pos; 
  PVector acc;
  PVector vel; 

  float r=100; 
  
  Player()
      {
        pos = new PVector(50,(height-100));
        vel = new PVector(0, 20);
        acc = new PVector();
      }
      
  void show()
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
  
  void applyAcc(PVector acceleration) 
  {
    acc.add(acceleration); 
  }
  
  void update()
  {
    applyAcc(gravity);
    pos.add(vel);

    if(pos.y >= height-170) 
      {
          pos.y=height-170;
          vel.mult(0);
      }
   
    vel.add(acc);
    vel.limit(7); 
   
    acc.mult(0);
  }  
}
