class Fireball
{
    float x;
    float y;
    float speed = 4;
    float width = 70;

    Fireball(float xpos, float ypos){
        this.x = xpos;
        this.y = ypos;
    }

    void update(){
        x += speed;
    }
    
    void show(){
        stroke(0,0,0);
        strokeWeight(2);
        imageMode(CORNER); 
        image(fireball_img, this.x, this.y, this.width, this.width);
    }
}