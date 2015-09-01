local physics = require("physics");
physics.start();

local zombie = {tag="zombie", HP=1, xPos=0, yPos=0};
local Player = require("Player")

local x = display.contentWidth;
local y = display.contentHeight;

--SPRITE SHEET OPTIONS
zombiesheetOpts =
{
	-- zombie spritesheet is 390x260 pixels, 12x8 characters
     width = 32,
     height = 32, 
     numFrames = 96,--frames in the image
     yScale=34
  
}

--BRING IN SPRITE SHEET
zombieSheet = graphics.newImageSheet( "ZombieSheet.png", zombiesheetOpts )

------------------------------------------------------------------------------
--------------------------- ZOMBIE SEQUENCES- ---------------------------------
------------------------------------------------------------------------------
sequences_zombiewalk = 
{
	--Bald Zombie Left Walk
	 {
        name = "BaldL",
       	start = 13,
       	count = 3,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    },
 
    --Bald Zombie Right Walk
    {
        name = "BaldR",
       	start = 25,
       	count = 3,
        time = 300,
        loopCount = 0,
        loopDirection = "forward"
    },
    
    --White Zombie Left Walk
    {
        name = "WhiteL",
       	start = 61,
       	count = 3,
        time = 300,
        loopCount = 0,
        loopDirection = "forward"
    },

    --White Zombie Right Walk
    {
        name = "WhiteR",
        start = 73,
        count= 3,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },

   	-- Patchy Zombie Left Walk
    {
        name = "PatchyL",
        start = 16,
        count = 3,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },

    -- Patchy Zombie Right Walk
    {
        name = "PatchyR",
        start = 28,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

    --Grey Zombie Left Walk
    {
        name = "GreyL",
        start = 64,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },
    --Grey Zombie Right Walk
     {
        name = "GreyR",
        start = 76,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

     --Arrow Zombie Left Walk
     {
        name = "ArrowL",
        start = 19,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

     --Arrow Zombie Right Walk
     {
        name = "ArrowR",
        start = 31,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

         --Ax Zombie Left Walk
     {
        name = "AxL",
        start = 67,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

     --Ax Zombie Right Walk
     {
        name = "AxR",
        start = 79,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

    --Priest Zombie Left Walk
     {
        name = "PriestL",
        start = 22,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },
    --Priest Zombie Right Walk
        {
        name = "PriestR",
        start = 35,
        count = 3,
        time = 250,
        loopCount = 0,
        loopDirection = "forward"
    },

}




function zombie:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end


function zombie:spawn()
	self.shape = display.newSprite( zombieSheet, sequences_zombiewalk)
  	self.shape.pp = self;
  	self.shape.tag = self.tag;
  	self.shape.x = 350;
  	self.shape.y = -25;
	physics.addBody(self.shape, "dynamic", {density = 0.5, friction = 0.3, bounce = 0});
end


------------------------------------------------------------------------------
----------------------------- ZOMBIE FUNCTIONS -------------------------------
------------------------------------------------------------------------------

function zombie:MovesLeft()
	local x = math.random(1, 7);
  if x==1 then
   self.shape:setSequence("BaldL");
  elseif x==2 then
   self.shape:setSequence("WhiteL");
  elseif x==3 then
   self.shape:setSequence("PatchyL");
  elseif x==4 then
   self.shape:setSequence("GreyL");
  elseif x==5 then
   self.shape:setSequence("ArrowL");
  elseif x==6 then
   self.shape:setSequence("AxL");
  elseif x==7 then
   self.shape:setSequence("PriestL");
  end

    self.shape:play();

end

function zombie:MovesRight()
  local x = math.random(1, 7);
  if x==1 then
   self.shape:setSequence("BaldR");
  elseif x==2 then
   self.shape:setSequence("WhiteR");
  elseif x==3 then
   self.shape:setSequence("PatchyR");
  elseif x==4 then
   self.shape:setSequence("GreyR");
  elseif x==5 then
   self.shape:setSequence("ArrowR");
  elseif x==6 then
   self.shape:setSequence("AxR");
  elseif x==7 then
   self.shape:setSequence("PriestR");
  end

    self.shape:play();
end


return zombie