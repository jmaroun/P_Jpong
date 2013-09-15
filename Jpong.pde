// Dimensions for my Android Phone HTC One
final int table_width = 540;
final int table_height = 940;
// Dimensions for Java
//final int table_width = 480;
//final int table_height = 620;
// Dimensions for Old Phone HTC slide
//final int table_width = 480;
//final int table_height = 820;

int paddle1_width = 20;
int paddle1_length = 540;
int paddle2_width = 20;
int paddle2_length = 80;

int boarder = 20;
int finger_space = 80;
int line_width = 4;

boolean xDirection;
boolean yDirection;
int ballx;
int bally;
int ballspeed;

int arg1 = 15;
int arg2 = 20;
int arg3 = 25;
int arg4 = 35;

int paddle2_left = table_width/2 - paddle2_length/2;
int paddle2_right = table_width/2 + paddle2_length/2;
int game_state;

Maxim maxim;
AudioPlayer paddle1_sound;
AudioPlayer paddle2_sound;
AudioPlayer wall_sound;

final int GAME_STATE_PLAY = 1;
final int GAME_STATE_GAME_OVER = 2;

//GAME_STATE game_state;

void setup()
{
  // Draw pong board paddles and starting position of ball
  size(540, 940);    // My Phone HTC One
  //size(480, 620);  // Simulator
  //size(480, 820);  // Old phone HTC Slide

  background(0, 255, 0);
  
  // Draw table lines
  stroke(255, 255, 0);
  strokeWeight(line_width);
  line(table_width/2, 0, table_width/2, table_height - finger_space);
  line(0, table_height/2 - finger_space/2, table_width, table_height/2 - finger_space/2);
  
  // Draw paddles
  stroke(255, 0, 0);
  fill(255, 0, 0);
  rect(table_width/2 - paddle1_length/2, boarder, paddle1_length, paddle1_width);
  
  stroke(255, 0, 0);
  fill(255, 0, 0);
  rect(table_width/2 - paddle2_length/2, table_height - (paddle2_width + boarder + finger_space), paddle2_length, paddle2_width);
  
  // Draw finger space
  stroke(255, 255, 255);
  fill(255, 255, 255);
  rect(0, table_height - finger_space, table_width, finger_space);
  
  // Draw ball
  stroke(255, 255, 255);
  fill(255, 255, 255);
  ballx = table_width/2;
  bally = table_height/2 - finger_space/2;
  arc(ballx, bally, arg1, arg2, arg3, arg4);
  
  // Load Sound Effects
  /*
  maxim = new Maxim(this);
  paddle1_sound = maxim.loadFile("paddle1_sound2.wav");
  paddle1_sound.setLooping(false);
  paddle2_sound = maxim.loadFile("paddle2_sound2.wav");
  paddle2_sound.setLooping(false);
  //wall_sound = maxim.loadFile("wall_sound.wav");
  //wall_sound.setLooping(false);
  */
  
  xDirection = true;
  yDirection = true;
  
  ballspeed = 3;
  game_state = GAME_STATE_PLAY;
}

void draw()
{
  switch (game_state)
  {
    case GAME_STATE_PLAY:
    {
      // Draw Game Action
      game_state = drawGamePlay();
      break;
    }
    case GAME_STATE_GAME_OVER:
    {
      // Draw Game Over Info
      game_state = drawGameOver();
      break;
    }
  }
}

void mouseDragged()
{
  if ( (mouseY < 100) )
  {
    game_state = GAME_STATE_GAME_OVER;
    setup();
  }
}

int drawGamePlay()
{
  int next_game_state = GAME_STATE_PLAY;
  
  // redraw the table area where the ball was;
  stroke(0, 255, 0);
  fill(0, 255, 0);
  arc(ballx, bally, arg1, arg2, arg3, arg4);
  
  // Re-draw table
  stroke(0, 255, 0);
  fill(0, 255, 0);
  rect(0, table_height - (finger_space + boarder + paddle2_width), table_width, paddle2_width);
  
  // Re-draw table lines
  stroke(255, 255, 0);
  strokeWeight(line_width);
  line(table_width/2, boarder*2 + paddle2_width, table_width/2, table_height - finger_space);
  line(0, table_height/2 - finger_space/2, table_width, table_height/2 - finger_space/2);

  if (bally < (paddle2_width + boarder + arg1) || bally > table_height - (finger_space + arg1 + paddle2_width + boarder))
  {
    if (bally > (finger_space + arg1 + paddle2_width + boarder))
    {
      // Check to see if the paddle is under the ball.
      // If it is, change its direction
      // If it isn't, game over.
      if ( (ballx > paddle2_left) && (ballx < paddle2_right) )
      {
        yDirection = !yDirection;
        ballspeed++;
        
        // We hit the ball.  Play paddle2 sound
        //paddle2_sound.cue(0);
        //paddle2_sound.play();
      }
      else
      {
        next_game_state = GAME_STATE_GAME_OVER;
      }
    }
    else
    {
      yDirection = !yDirection;
      
      // Ball hit upper wall.  Play paddle1 sound
      //paddle1_sound.cue(0);
      //paddle1_sound.play();
    }
  }
  
  if (yDirection == true)  
    bally += ballspeed;
  else
    bally -= ballspeed;

  if (ballx < 0 || ballx > table_width)
  {
    //change direction of x
    xDirection = !xDirection;
    
    // Side wall was hit.  Play wall sound.
    //wall_sound.cue(0);
    //wall_sound.play();
  }
  
  if (xDirection == true)  
    ballx += ballspeed;
  else
    ballx -= ballspeed;
  
  stroke(255, 255, 255);
  fill(255, 255, 255);
  arc(ballx, bally, arg1, arg2, arg3, arg4);

  stroke(255, 0, 0);
  fill(255, 0, 0);
  rect(table_width/2 - paddle1_length/2, boarder, paddle1_length, paddle1_width);
  rect(mouseX - paddle2_length/2, table_height - (paddle2_width + boarder + finger_space), paddle2_length, paddle2_width);

  paddle2_left = mouseX - (paddle2_length/2 + arg1);
  paddle2_right = mouseX + paddle2_length/2 + arg1;
      
  return next_game_state;
}

int drawGameOver()
{
  textSize(40);
  text("Your score: " + (ballspeed - 3), 20, table_height/8);
  text("\n\nSwipe red bar at top\nof screen to play again", 20, table_height/8);
  
  return GAME_STATE_GAME_OVER;
}

