import pKinect.PKinect; 
import pKinect.SkeletonData; 
import processing.video.*; 
import processing.core.*;

public class KinectOn{
PKinect kinect; 
ArrayList<SkeletonData> bodies; 
PImage img;
PImage prevFrame; 
float headX = 0.0; 
float headZ = 0.0; 
float handRX =0.0; 
float handRY = 0.0; 
float handLX = 0.0; 
float handLY = 0.0; 
PApplet p; 

boolean near = false; 
SkeletonData closest; 
boolean hasPersonEntered = false;

  //contstruct
  public KinectOn(PApplet p_){
    p = p_; 
    bodies = new ArrayList<SkeletonData>(); 
    img = createImage(320,240, ARGB); 
    init();
    println("init");
  } 
  
  public void init() {
    
    kinect = new PKinect(p);  
    println(kinect); 
    prevFrame = createImage(320,240,ARGB); 
  
  }
  
  //kinect body stuff 
  void checkPlayer(){
    // //this function checks if bodies that have left the scene, removes them. 
    for (int i = bodies.size()-1; i>=0; i--){
        SkeletonData check = bodies.get(i); 
        //if there is a body that's not moving delete it from the array 
        if(check.position.x == 0.0){
          bodies.remove(i);
        }
      println("num of bodies now: "+bodies.size());
      }
  } 
  
  void getClosest(){
    //this function gets the closest player to the camera and filers everything else out 
    
     SkeletonData testbody = bodies.get(0);
  
    for(int i = 0; i <= bodies.size()-1; i++){
    //if there is more than one player, figure out which to track
    if(bodies.size() > 1){
    drawPosition(bodies.get(i)); 
      //see who is closer 
          if(testbody.position.z < bodies.get(i).position.z)
          {
              //println("the 0 body is nearer"); 
                closest = testbody; 
                headX = testbody.position.x; 
                headZ = testbody.position.z; 
                drawPosition(testbody);
           }   
  
        }else{
          closest = bodies.get(i); 
          headX = bodies.get(i).position.x; 
          headZ = bodies.get(i).position.z;  
          drawPosition(bodies.get(i)); 
          //println("the body in position" + i + " is closest");
        }     
        //println("bodyz: "+ closest.position.z);     
      } 
  }
  
  //sets a z axis trigger if a body is detected 
  void zAxis(){
    if(bodies.size() >= 1) {
      if(closest.position.x < 13500){
        near = true;      
      }
      else 
       near = false; 
    }
  } 
  
  public void update(){
      /**** KINECT SETUP *********/ 
  
    if (bodies.size() >=1) {
      img =kinect.GetDepth();
      image(img, 320, 240, 320, 240);
       
      prevFrame.copy(img, 0,0, 320, 240, 0,0,320,240); 
      prevFrame.updatePixels(); 
      
      img =kinect.GetDepth();
      //only perform core logic if we have a body to work with 
      //get the closest player and set all in game values
       getClosest(); 
     
       //z axis addition? 
      // if(closest.position.z > 12499.0){
      //    gameState = "attract";
        hasPersonEntered = true; 
      }
      
  
     ///checkk if there are no bodies  
      if(bodies.size()==0)
      {
        hasPersonEntered = false; 
           // if(gameState = "follow"){
  
       // }
      } 
    /**** KINECT SETUP END *********/ 
  
    // println(headX + "i  am head x");  
  
  }
  
  /////////////////////////
  //debug test function to draw the player number. not used currently
  void drawPosition(SkeletonData _s) {
    noStroke();
    fill(0, 100, 255); 
    String s1 = str(_s.dwTrackingID); 
    text(s1, _s.position.x*width/2, _s.position.y*height/2);
  }
  
  
  ///default sdk kinect requirements 
  void appearEvent(SkeletonData _s)
  {
    println("event started"); 
    if (_s.trackingState == PKinect.NUI_SKELETON_POSITION_NOT_TRACKED)
    {
      return;
    }
  
    synchronized(bodies)
    {
      bodies.add(_s);
    }
  }
  
  void disappearEvent(SkeletonData _s) {
    synchronized(bodies)
    {
      for (int i = bodies.size()-1; i>=0; i--) {
        if (_s.dwTrackingID==bodies.get(i).dwTrackingID)
        {
          bodies.remove(i);
        }
      }
    }
  }
  
  }

