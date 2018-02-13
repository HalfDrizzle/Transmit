import java.util.List; //<>//
import java.util.*;
import com.hamoid.*; 
import javax.swing.JOptionPane;

VideoExport videoExport;
Man[][] man ;
List <Man> list1;
List <Man> list2,list3;
int manNumberX;
int manNumberY;
float rectX,rectY;
boolean bug = false,finish = false,video = false;

void setup(){
  size(1000,1000);
  background(255);
  manNumberX = 1000;
  manNumberY = 1000;
  rectX = (float)width/manNumberX;
  rectY = (float)height/manNumberY;
  
  list1 = Collections.synchronizedList(new ArrayList<Man>());
  list2 = Collections.synchronizedList(new ArrayList<Man>());
  list3 = Collections.synchronizedList(new ArrayList<Man>());
  
  man = new Man[manNumberX][manNumberY];
    for(int j = 0;j < manNumberY;j++){
      for(int i = 0;i < manNumberX;i++){
      man[i][j] = new Man(i,j);
    }
  }
  frameRate(30);
  if(video){
    videoExport = new VideoExport(this, "transmit.mp4");
    videoExport.setFrameRate(30);
    videoExport.setQuality(70,128);
    videoExport.startMovie();
  }
}

void draw(){
  if(frameCount%1 == 0){
    if(video)
      videoExport.saveFrame();
  }
  if(bug);
  else
    if(frameCount%1 == 0){
      if(!finish)
        background(255);
      for(int j = 0;j < manNumberY;j++){
        for(int i = 0;i < manNumberX;i++){
          if(man[i][j].state == 0){
            list3.add(man[i][j]);
          }else if(man[i][j].state == 1){
            list1.add(man[i][j]);
          }else if(man[i][j].state == 2){
            list2.add(man[i][j]);
          }
        }
      }
      Collections.shuffle(list1); 
      Iterator<Man> it = list1.iterator();
      while(it.hasNext()){
        Man m = it.next();
        m.judge();
        fill(0,0,0);
        rect(m.x*rectX,m.y*rectY,rectX,rectY);
      }
      it = list2.iterator();  
      while(it.hasNext()){
        Man m1 = it.next();
        fill(50);
        rect(m1.x*rectX,m1.y*rectY,rectX,rectY);
      }
      it = list3.iterator();
      if(list3.isEmpty())
        finish = true;
      list1.clear();
      list2.clear();
    }
}

class Man{
  int x,y;
  int state = 0;
  Man(int x,int y){
    this.x = x;
    this.y = y;
  }
  void transmit(Man a){
    a.state = 1;
  }
  
  void transmitY(int a){
    if(y != manNumberY-1&&y != 0){
      if(man[x][y+1].state==0 && a==1){
        transmit(man[x][y+1]);
      }
      if(man[x][y-1].state==0 && a==2){
        transmit(man[x][y-1]);
      }
    }
  }
  
  void transmitX(int a){
    if(x != manNumberX-1&&x != 0){
      if(man[x+1][y].state==0 && a == 1){
        transmit(man[x+1][y]);
      }
      if(man[x-1][y].state==0 && a == 2){
        transmit(man[x-1][y]);
      }
    }
  }
  
  void judge(){
    int a = parseInt(random(0,4));
    if(x == 0){
      if(man[x+1][y].state==0 && a == 0){
        transmit(man[x+1][y]);
      }
      transmitY(a);
    }
    if(y == 0){
      if(man[x][y+1].state==0 && a == 0){
        transmit(man[x][y+1]);
      }
      transmitX(a);
    }
    if(x == manNumberX-1){
      if(man[x-1][y].state==0 && a == 0){
        transmit(man[x-1][y]);
      }
      transmitY(a);
    }
    if(y == manNumberY-1){
      if(man[x][y-1].state==0 && a == 0){
        transmit(man[x][y-1]);
      }
      transmitX(a);
    }
    if(x > 0 && x < manNumberX-1 && y > 0 && y <manNumberY-1){
      Random rand = new Random();
      int z =  rand.nextInt();
      z = rand.nextInt(4);
      switch(z){
        case 0 :{
          if(man[x+1][y].state == 0){
            transmit(man[x+1][y]);
          }
          break;
        }
        case 1:{
          if(man[x-1][y].state == 0){
            transmit(man[x-1][y]);
          }
          break;
        }
        case 2:{
          if(man[x][y+1].state == 0){
            transmit(man[x][y+1]);
          }
          break;
        }
        case 3:{
          if(man[x][y-1].state == 0){
            transmit(man[x][y-1]);
          }
          break;
        }
      }
      if(man[x+1][y].state != 0 && man[x-1][y].state != 0&& man[x][y+1].state != 0 && man[x][y-1].state != 0){
        state = 2;
      }
    }
    
    /*if(man[x+1][y+1].state==0){
      transmit(man[x+1][y+1]);
    }
    if(man[x+1][y-1].state==0){
      transmit(man[x+1][y-1]);
    }
    if(man[x-1][y+1].state==0){
      transmit(man[x-1][y+1]);
    }
    if(man[x-1][y-1].state==0){
      transmit(man[x-1][y-1]);
    }*/
  }
}

void mouseClicked(){
  print(man[mouseX/(int)rectX][mouseY/(int)rectY].state);
  try{
  man[mouseX/(int)rectX][mouseY/(int)rectY].state = 1;
  }catch(ArithmeticException e){
    bug = true;
    println("界面宽度或长度除以人数不能小于1:" + e);
    Object[] c = {"Contirm"};
    if(JOptionPane.showOptionDialog(null, "Width/manNumberX or height/manNumberY can't be smaller than 1", "Error",JOptionPane.YES_OPTION,JOptionPane.ERROR_MESSAGE,null,c,c)==0){
      exit();
    }
  }
}

void mouseMoved(){
  fill(255,0,0);
  ellipse(mouseX,mouseY,5,5);
}
void keyPressed() {
  if (key == 'q') {
    if(video)
      videoExport.endMovie();
    exit();
  }
  if(key == 'f'){
    print(man[1][1].state);
  }
  if(key == 'c'){
    noCursor();
  }
}