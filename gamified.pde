import pKinect.PKinect; 
import pKinect.SkeletonData; 

/************kinect vars **********************/
PKinect kinect; 
ArrayList<SkeletonData> bodies; 
PImage img;
PImage prevFrame; 

boolean near = false; 
SkeletonData closest; 
boolean hasPersonEntered = false;
int player1Head; 
PVector player1RightHand; 
PVector player1LeftHand; 

PVector player2Head;
PVector player2RightHand; 
PVector player2LeftHand; 

float headX, headY, headZ; 
//switch me on and off 
boolean kinectRun = true;  

/*end kinect vars*/ 


void setup() {
  
  size(960, 540);
  //test for kinect 
  if(kinectRun)
  { 
    bodies = new ArrayList<SkeletonData>(); 
    img = createImage(320,240, ARGB); 
    kinectInit();
    println("init");
   } 

}
void draw() {
//  println(frameRate);
  background(0);
 if(kinectRun) kinectUpdate(); 

} 


//KINECT CODE HERE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void kinectInit() {
    
    kinect = new PKinect(this);  
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
    drawSkeleton(bodies.get(i));

//    player1Head = PKinect.NUI_SKELETON_POSITION_HAND_LEFT; 
//    player1LeftHand = PKinect.NUI_SKELETON_POSITION_HAND_LEFT;
//    player1RightHand = PKinect.NUI_SKELETON_POSITION_HAND_RIGHT;
      //playerLeftHand.add(  PKinect.NUI_SKELETON_POSITION_HAND_LEFT);
      //playerRightHand.add(  PKinect.NUI_SKELETON_POSITION_HAND_RIGHT);  
 
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
  
  public void kinectUpdate(){
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
  
  void drawSkeleton(SkeletonData _s) 
{
  // Body
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_HEAD, 
  PKinect.NUI_SKELETON_POSITION_SHOULDER_CENTER); 
  
  // Left Arm
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  PKinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_ELBOW_LEFT, 
  PKinect.NUI_SKELETON_POSITION_WRIST_LEFT);
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
  PKinect.NUI_SKELETON_POSITION_HAND_LEFT);
 
  // Right Arm
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  PKinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_ELBOW_RIGHT, 
  PKinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
  DrawBone(_s, 
  PKinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
  PKinect.NUI_SKELETON_POSITION_HAND_RIGHT);
 

}
 
void DrawBone(SkeletonData _s, int _j1, int _j2) 
{
  noFill();
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != PKinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != PKinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
    line(_s.skeletonPositions[_j1].x*width/2, 
    _s.skeletonPositions[_j1].y*height/2, 
    _s.skeletonPositions[_j2].x*width/2, 
    _s.skeletonPositions[_j2].y*height/2);
  }
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
