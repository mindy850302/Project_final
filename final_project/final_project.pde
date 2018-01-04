import processing.serial.*;

import processing.sound.*;

    SoundFile[] soundfile = new SoundFile[14];
  
    String mp3[] = new String[14];
    String path[] = new String[14];

    int state=0;
Serial port; // Create object from Serial class
int val; // Data received from the serial port

int val_1;
int val_2;
int val_3;
int val_4;

String piano[] = {
                  "4","-1","3","-1","4","1","-3","4","-1","3","-1","4","6","-3",
                  "13","-1","6","-1","5","-1","4","13","-1","6","5","4","-1","4","-1","5","5","-3",
                  "4","-1","3","-1","4","1","-3","4","-1","3","-1","4","8","-3",
                  "13","13","13","13","13","6","5","13","-2",
                  "5","6","13","6","6","6","6","5","4","6","-2",
                  "2","-1","3","-1","4","-1","5","2","-2","2","3","4","5","4","8","-3",
                  "4","5","6","13","8","-1","6","4","-1","8","-1","13","-1","5","-3",
                  "13","-1","5","3","-1","13","-1","6","-1","4","-2",
                  "2","-1","4","-1","13","-1","6","-1","8","4","-1",
                  "6","13","6","13","6","13","6","4","5","-2",
                  "4","5","6","13","8","-1","6","4","-1","8","-1","13","-1","5","-3",
                  "13","-1","5","3","-1","13","-1","6","-1","4","-3",
                  "2","14","8","13","6","13","8","-1","4","4","-2",
                  "6","13","6","4","13","6","4","14","8","-2",
                  "1","1","13","6","5","6","4","-3"
                  };

int piano_pointer;

boolean start = false;
boolean gameOver = false;
PImage background;
PImage button;
PImage backgroundStart;
PImage gameOverImage;
PImage bar;
int score = 0;
int time = 6000;

int bounsDisplay;
int distance = 0;

Box[][] boxes;
int rowOfBoxDisplay = 3 ;//宣告共有6列的Box
int numOfBoxes = 1 ;//每列最多幾個Box
int count = 0;//算現在出現到第幾列的Box
int current =0;
void setup(){
  size(404,700);
 
  for(int i=0;i<14;i++){
    String filename=str(i+1)+".mp3";
    println(filename);
    mp3[i] = filename;
    path[i] = sketchPath(mp3[i]);
    soundfile[i] = new SoundFile(this,path[i]);
  }
  
    int now=1;

  for(int i=0;i<piano.length;i++){
    delay(50);
    soundfile[now-1].stop();
    int delaytime=250;
    int counts=0;
     print(piano[i]);
      now=Integer.parseInt(String.valueOf(piano[i]));
      int next=1;
     if(i!=piano.length-1){
       next=Integer.parseInt(String.valueOf(piano[i+1]));
       if(next<0 && next >-10){
         counts=next*(-1);
         delaytime=250+counts*200;
         i++;
       }
       if(next==-10){
         delaytime=230;
         i++;
         }
     }
     println(delaytime);
     soundfile[now-1].play();
     delay(delaytime);
  }

  background = loadImage("background.png");
  button = loadImage("button.png");
  backgroundStart = loadImage("background_start.png");
  bar = loadImage("bar.png");
  gameOverImage = loadImage("gameOver.png");
  
  boxes = new Box[rowOfBoxDisplay][numOfBoxes];
  
  for(int j = 0; j<rowOfBoxDisplay;j++){
    for(int i = 0; i<numOfBoxes;i++){
      boxes[j][i] = new Box(); // Create each object  
      boxes[j][i].start();
      boxes[j][i].y = j*(-200);//每個Box的y
    }
   }
   
   println(Serial.list()); 
   String portName = Serial.list()[1];
   port = new Serial(this, portName, 9600);
}

void draw(){
  
  if (0 < port.available()) { // If data is available,
  String inString = port.readStringUntil('\n');
  inString = trim(inString);
  println(inString);
  if(inString==null||inString.equals("")){
    val = 2222;
  }else{
    val = Integer.parseInt(inString); // read it and store it in val
  }
  //val = Integer.parseInt(inString); // read it and store it in val
  //println(val);
  val_1=val/1000;
  //print(val_1);
  val_2 =(val%1000)/100;
  val_3=(val%100)/10;
  val_4=(val%10);
  }
  
  if(start){
    image(backgroundStart,0,0,404,700);
    stroke(255);
    strokeWeight(1);
    line(101,0,101,700);
    line(202,0,202,700);
    line(303,0,303,700);
    line(404,0,404,700);
    
    
    for(int j = 0; j<rowOfBoxDisplay;j++){
      for(int i = 0; i<numOfBoxes;i++){
           boxes[j][i].changePosition();
           boxes[j][i].display();
           if(boxes[j][i].y>=680 && boxes[j][i].on ==true){
             start = false;
             gameOver = true;
           }
           //print("ball x:"+boxes[j][i].x+"  , y:"+boxes[j][i].y+"\n");
      }
      if(boxes[j][numOfBoxes-1].y>=700){
        current=j;//記錄哪一層的方塊消失
        updateBoxes(current);//renew the ball
      }
    }
    //if(keyPressed == true){//消除方塊
        for(int j = 0; j<rowOfBoxDisplay;j++){
          for(int i = 0; i<numOfBoxes;i++){
              if(val_1 == 1){                
                  if(boxes[j][i].x==0 && boxes[j][i].y>=600 && boxes[j][i].y<= 710 && boxes[j][i].on ==true){
                    boxes[j][i].on = false;
                    score++;
                  }
              }
              if(val_2 == 1){
                  if(boxes[j][i].x==101 && boxes[j][i].y>=600 && boxes[j][i].y<= 710 && boxes[j][i].on ==true){
                    boxes[j][i].on = false;
                    score++;
                  }
              }
              if(val_3 == 1){
                  if(boxes[j][i].x==202 && boxes[j][i].y>=600 && boxes[j][i].y<= 710 && boxes[j][i].on ==true){
                    boxes[j][i].on = false;
                    score++;
                  }
              } 
              if(val_4 == 1){
                  if(boxes[j][i].x==303 && boxes[j][i].y>=600 && boxes[j][i].y<= 710 && boxes[j][i].on ==true){
                    boxes[j][i].on = false;
                    score++;
                  }
              } 
          }
        }
        
      //}
      
      noStroke();
      image(bar,0,0,404,60);//show bar
      fill(255);
      textSize(20);
      text(score,135,33);//show score
      time-=2;
      text(time/100,350,33);//show time
      if(time<=0){
        start=false;//遊戲時間結束
      }
  }else if(start==false && gameOver ==false){
    image(background,0,0,404,700);
    image(button,92,470,220,70);
    
    if(mousePressed==true && mouseX>=92 && mouseX<=312 && mouseY>=470 && mouseY<=540){
      start = true;
      score = 0;//renew score
      time = 6000;//renew time
      for(int j = 0; j<rowOfBoxDisplay;j++){
        for(int i = 0; i<numOfBoxes;i++){
          //boxes[j][i] = new Box(); // Create each object  
          boxes[j][i].start();
          boxes[j][i].y =0;//每個Box的y
        }
       }
    }  
  }
  else if(start==false && gameOver ==true){
    image(gameOverImage,0,0,404,700);
    fill(0);
    textSize(26);
    text(score,193,366);
    if(mousePressed==true && mouseX>=137 && mouseX<=267 && mouseY>=390 && mouseY<=429){
      start = true;
      score = 0;//renew score
      time = 6000;//renew time
      for(int j = 0; j<rowOfBoxDisplay;j++){
        for(int i = 0; i<numOfBoxes;i++){
          //boxes[j][i] = new Box(); // Create each object  
          boxes[j][i].start();
          boxes[j][i].y =0;//每個Box的y
        }
       }
    }  
  }

}

class Box{
  float x,y;
  int row ;//記錄球有幾顆
  boolean on  = false;
  int boxHeight;
  void start(){
    x =(round(random(0,3)))*101;
    y  = 0;
    row = int(random(1,4));
    on = true;
    boxHeight = int(random(1,3))*100;
    
  }
  void display(){
    if(on == true){
      fill(0);
      rect(x, y, 100, boxHeight);
      if(boxHeight==200){
          noFill();
          strokeWeight(3);
          ellipse(x+50,y+160,30,30);
          strokeWeight(1);
      }
    }
  }
  
  void changePosition(){
    y = y+5;
    if(y>=700){
      on  = false;   
    }
  }
  void turn(){
    on  = true;
  }

}

class BoxBouns{
  float x,y;
  int row ;//記錄球有幾顆
  boolean on  = false;
  
  void start(int number){
    x =(round(random(0,3)))*101;
    y  = 0;
    row = number;
    on = true;
    
  }
  void display(){
    if(on == true){
      fill(0);
      rect(x, y, 100, 200);
    }
  }
  
  void changePosition(){
    y = y+15;
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