import pKinect.PKinect; 
import pKinect.SkeletonData; 
import processing.video.*; 


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


boolean near = false; 
SkeletonData closest; 

float threshold = 50; 
boolean hasPersonEntered = false; 
void setup() {

  size(960, 540);
  bodies = new ArrayList<SkeletonData>(); 
  img = createImage(320,240, ARGB); 
  kinect = new PKinect(this);
  prevFrame = createImage(320,240,ARGB); 
} 
//kinect body stuff 
void checkPlayer(){
  // //this function checks if bodies that have left the scene, removes them. 
  // if(timePast + interval > millis()){
  for (int i = bodies.size()-1; i>=0; i--){
      SkeletonData check = bodies.get(i); 
      //if there is a body that's not moving delete it from the array 
      if(check.position.x == 0.0){
        bodies.remove(i);
      }

    //println("num of bodies now: "+bodies.size());
    }
    //reset the timer -- if this gets cranky, we can throtle it later
   // timePast=millis(); 
  //}   
} 

void getClosest(){
  //this function gets the closest player to the camera and filers everything else out 

   SkeletonData testbody = bodies.get(0);
//    println("z of player: in arraylist "+testbody.position.z); 

  for(int i = 0; i <= bodies.size()-1; i++){
  //if there is more than one player, figure out which to track
  if(bodies.size() > 1){
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

void draw() {
  println(frameRate);
  background(0);
  /**** KINECT SETUP *********/ 

  if (bodies.size() >=1) {
    img =kinect.GetDepth();
    image(img, 320, 240, 320, 240);
     
    prevFrame.copy(img, 0,0, 320, 240, 0,0,320,240); 
    prevFrame.updatePixels(); 
    
    img =kinect.GetDepth();
    //only perform core logic if we have a body to work with 
  if(bodies.size() >=1) {

    //get the closest player and set all in game values
      getClosest(); 
    // if(closest.position.z > 12499.0){
    //    gameState = "attract";
      hasPersonEntered = true; 
    }
//     else{
// //      gameState = "follow";
//       hasPersonEntered = true; 
//     }

  //}
   if(bodies.size()==0)
    {
      hasPersonEntered = false; 
         // if(gameState = "follow"){

     // }
    } 
  /**** KINECT SETUP END *********/ 

   println(headX + "i  am head x");
   
   loadPixels(); 
   img.loadPixels(); 
   prevFrame.loadPixels();  
   
   float totalMotion = 0; 
   for(int i = 0; i < img.pixels.length; i++) {
//     color current = video.pixels[i]; 
 //    color previous = prevFrame.pixels[i]; 
      
      
   } 
      
  }
} 



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

