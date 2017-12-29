boolean start = false;
PImage background;
PImage button;
PImage backgroundStart;

Box[][] boxes;
int rowOfBoxDisplay = 6 ;//宣告共有七列的球
int numOfBoxes = 2 ;//每列最多幾個球
int count = 0;//算現在出現到第幾列的球
int current =0;
void setup(){
  size(404,700);
  background = loadImage("background.png");
  button = loadImage("button.png");
  backgroundStart = loadImage("background_start.png");
  
  boxes = new Box[rowOfBoxDisplay][numOfBoxes];
  
  for(int j = 0; j<rowOfBoxDisplay;j++){
    for(int i = 0; i<numOfBoxes;i++){
      boxes[j][i] = new Box(); // Create each object  
      boxes[j][i].start();
      
      boxes[j][i].y = j*(-200);//每個球的y
    }
   }
}

void draw(){
  
  if(start){
    image(backgroundStart,0,0,404,700);
    stroke(255);
    line(101,0,101,700);
    line(202,0,202,700);
    line(303,0,303,700);
    line(404,0,404,700);
    
    
    for(int j = 0; j<rowOfBoxDisplay;j++){
      for(int i = 0; i<numOfBoxes;i++){
           boxes[j][i].changePosition();
           boxes[j][i].display();
           
           print("ball x:"+boxes[j][i].x+"  , y:"+boxes[j][i].y+"\n");
       
      }
      if(boxes[j][numOfBoxes-1].y>=700){
        current=j;//記錄哪一層的球消失
        updateBoxes(current);//renew the ball
      }
    }
    
  }else{
    image(background,0,0,404,700);
    image(button,92,470,220,70);
    
    if(mousePressed==true && mouseX>=92 && mouseX<=312 && mouseY>=470 && mouseY<=540){
      start = true;
    }
    
    
    
  }

}

class Box{
  float x,y;
  int row ;//記錄球有幾顆
  boolean on  = false;
  
  void start(){
    x =(round(random(0,3)))*101;
    y  = 0;
    row = int(random(1,4));
    on = true;
    
  }
  void display(){
    if(on == true){
      fill(0);
      rect(x, y, 100, 100);
    }
  }
  
  void changePosition(){
    y = y+10;
    if(y>=700){
      on  = false;   
    }
  }
  void turn(){
    on  = true;
  }

}
void updateBoxes(int row){
  for(int i = 0; i<numOfBoxes;i++){
      //balls[row][i] = new Ball(); // Create each object 
      boxes[row][i].start();
      boxes[row][i].y = -200;
    }
}