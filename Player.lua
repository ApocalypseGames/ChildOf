local physics = require("physics");
physics.start();
local boss = require("boss")
local mydata = require( "mydata" )
local score = require( "score" )


local Player = {tag="baby", HP=1, xPos=100, yPos=100};

local x = display.contentWidth;
local y = display.contentHeight;

local airborn = false;

--SPRITE SHEET OPTIONS
babysheetOpts =
{
	-- baby spritesheet is 297 x 248
     width = 49, -- 297/6 width of each sprite 
     height = 62, --248/4 height of each sprite
     numFrames = 20 --frames in the image
       
  
}

local soundTable = {
    shootSound = audio.loadSound( "shoot.wav" ),
    hitSound = audio.loadSound( "hit.wav" ),
    explodeSound = audio.loadSound( "explode.wav" ),
}

--BRING IN SPRITE SHEET
sheet_babysteps = graphics.newImageSheet( "Baby.png", babysheetOpts )

------------------------------------------------------------------------------
--------------------------- BABY SEQUENCES- ---------------------------------
------------------------------------------------------------------------------
sequences_babysteps = 
{
	--Crouch
	 {
        name = "crouch",
       	start = 13,
       	count = 3,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    },
 
    --Run Right
    {
        name = "runR",
       	start = 10,
       	count = 3,
        time = 300,
        loopCount = 0,
        loopDirection = "forward"
    },
    
    --Run Left
    {
        name = "runL",
       	start = 22,
       	count = 3,
        time = 300,
        loopCount = 0,
        loopDirection = "forward"
    },

    -- Sneak Right
    {
        name = "sneakR",
        start = 7,
        count= 3,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },

   	-- Sneak Left
    {
        name = "sneakL",
        start = 19,
        count = 3,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },

       	-- Jump Right
    {
        name = "jumpR",
        frames = {12, 11},
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

    -- Jump Left
    {
        name = "jumpL",
        frames = {24, 23},
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    }
   
}


------------------------------------------------------------------------------
--------------------------- BABY CONSTRUCTOR ---------------------------------
------------------------------------------------------------------------------

function Player:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end
    

------------------------------------------------------------------------------
--------------------------- BABY SPRITE OBJECT -------------------------------
------------------------------------------------------------------------------
function Player:spawn()
	self.shape = display.newSprite(sheet_babysteps, sequences_babysteps);
	self.shape.pp = self;
    self.shape.tag = self.tag;
    self.shape.x = 150;
    self.shape.y = 150;
    self.speed = 6
    self.direction = 1
	physics.addBody(self.shape, "dynamic", {density = 0.5, friction = 0.3, bounce = 0});
    self.shape.isFixedRotation = true
end


------------------------------------------------------------------------------
----------------------------- BABY FUNCTIONS ---------------------------------
------------------------------------------------------------------------------
function die(event)
	self:killMe(event)
	print("assssddaadad")
end

function Player:killMe(  )
	print(self.HP)
	self.HP= self.HP-1
	--display.remove(self.PlayerType)
end

function Player:runLeft()
    self.shape:setSequence("runL");
    self.shape:play();
end

function Player:runRight()
    self.shape:setSequence("runR");
    self.shape:play();
end

function Player:sneakLeft()
    self.shape:setSequence("sneakL");
    self.shape:play();
end

function Player:sneakRight()
    self.shape:setSequence("sneakR");
    self.shape:play();
end

function Player:jumpLeft()
    self.shape:setSequence("jumpL");
    self.shape:play();
end

function Player:jumpRight()
    self.shape:setSequence("jumpR");
    self.shape:play();
end

function Player:crouch()
    self.shape:setSequence("crouch");
    self.shape:play();
end

function Player:stand()
    self.shape:pause();
    self.shape:setFrame(2);
end
function Player:getDirection()
    return self.direction
end
function Player:setDirection(direction)
        self.direction = direction 
end

function Player:shoot()
  local function createShot(obj)
    local p = display.newCircle (obj.shape.x, obj.shape.y-40,5);
    p:setFillColor(0,1,0);
    p.anchorY=0;
    physics.addBody (p, "dynamic");
    
if obj.direction== 1 then
    audio.play( soundTable["hitSound"] );
    p:applyForce(5,math.random(-1,1), p.x, p.y);
else
audio.play( soundTable["hitSound"] );
    p:applyForce(-5,math.random(-1,1), p.x, p.y);
end
    p.isSensor = true;
        
    p.tag = "playerProjectie";
    
    local function shotHandler (event)
    --  print("projetile:".. event.other.tag);
      
        if (event.other.tag == "zombie") then
        timer.cancel( event.other.tid )
           display.remove( event.other ) 
            mydata.score= mydata.score+1
            

        end

      
    end
    p:addEventListener("collision", shotHandler);       
  
end
self.timerRef = timer.performWithDelay(1, 
    function (event) createShot(self) end);
end

return Player