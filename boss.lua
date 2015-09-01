------------------------------------------------------------------------------
------------------------------------------------------------------------------
----------------------------- BOSS CLASS -------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------



local boss = {tag="boss", HP=5, xPos=0, yPos=0};



local soundTable = {
    shootSound = audio.loadSound( "shoot.wav" ),
    hitSound = audio.loadSound( "hit.wav" ),
    explodeSound = audio.loadSound( "explode.wav" ),
}

------------------------------------------------------------------------------
------------------------- BOSS SHEET OPTIONS ---------------------------------
------------------------------------------------------------------------------

local BossSheetOpts =
{
    frames =
    {       
    --Jump Back/Dodge Animation Frames
      --FRAME 1
       {
            x = 0,
            y = 0,
            width = 70,
            height = 95
        },
       --FRAME 2
        {    
            x = 70,
            y = 0,
            width = 70,
            height = 95
        },
      --FRAME 3
       {
            x = 140,
            y = 0,
            width = 55,
            height = 95
        },
       --FRAME 4
        {    
            x = 190,
            y = 0,
            width = 61,
            height = 95
        }
    }
}

local sheet_Boss = graphics.newImageSheet( "Ninja.png", BossSheetOpts );


------------------------------------------------------------------------------
----------------------------- BOSS SEQUENCES ---------------------------------
------------------------------------------------------------------------------

sequences_BossMoves = 
{
  --JumpBack/Dogde
   {
        name = "Dodge",
        start = 1,
        count = 4,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    },
   
}


------------------------------------------------------------------------------
--------------------------- BOSS CONSTRUCTOR ---------------------------------
------------------------------------------------------------------------------
function boss:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end


function boss:spawn()
  self.shape = display.newSprite(sheet_Boss, sequences_BossMoves);

  self.shape.pp = self;  -- parent object
  self.shape.x = 850
  self.shape.y = 150

  self.shape.tag = self.tag; -- â€œenemyâ€

  physics.addBody(self.shape, "kinematic"); 
end


------------------------------------------------------------------------------
---------------------------- BOSS ANIMATIONS ---------------------------------
------------------------------------------------------------------------------

function boss:dodge()
  if self.shape ~= nil then
   self.shape:setSequence("Dodge");
   self.shape:play();
   end
end

------------------------------------------------------------------------------
--------------------------- BOSS TRANSITIONS ---------------------------------
------------------------------------------------------------------------------

function boss:back ()
  if self.shape ~= nil then
  self:dodge();
  transition.to(self.shape, {x=self.shape.x+50, y=50,  
  time=self.fB, rotation=self.bR, 
  onComplete=function (obj) self:forward() end} );
end
end

function boss:side ()   
  if self.shape ~= nil then
   transition.to(self.shape, {x=self.shape.x-50, 
   time=self.fS, rotation=self.sR, 
   onComplete=function (obj) self:back() end } );
   end
end

function boss:forward ()  
if self.shape ~= nil then 
   transition.to(self.shape, {x=self.shape.x+0, y=500, 
   time=self.fT, rotation=self.fR, 
   onComplete= function (obj) self:side() end } );
   end
end

function boss:move ()	
  if self.shape ~= nil then
	self:forward();
  end
end


------------------------------------------------------------------------------
------------------------------ BOSS ATTACKS ----------------------------------
------------------------------------------------------------------------------

function boss:hit () 
	self.HP = self.HP - 1;
  print("ouch")
	if (self.HP > 0) then 
		audio.play( soundTable["hitSound"] );
		self.shape:setFillColor(0.5,0.5,0.5);
	else 
		audio.play( soundTable["explodeSound"] );
		transition.cancel( self.shape );
		
		if (self.timerRef ~= nil) then
			timer.cancel ( self.timerRef );
		end
    print("imdead")
		-- die
		self.shape:removeSelf();
		self.shape=nil;	
		self = nil;  
	end		
end



function boss:shoot (interval)
  interval = interval or 1000;
  local function createShot(obj)
  --  obj.shap.x =1
   -- if obj.shape.x ~= nil then
    local p = display.newRect (obj.shape.x-50, obj.shape.y, 
                               10,10);
    p:setFillColor(1,0,0);
    p.anchorY=0;
    physics.addBody (p, "dynamic");
    p:applyForce(-5,math.random(-3,0),p.x, p.y);
    p.isSensor = true;
		
	p.tag = "enemyProjectie";
--	 p:addEventListener("collision", shotHandler); 
--  end--end if
    local function shotHandler (event)
    --	print("projetile:".. event.other.tag);
      if (event.phase == "began") then
      	
          if event.other.tag == "baby" then
           
            -- event.target:removeSelf();

            -- event.target = nil;                           -----Baby is dead, go to game over
          end
	  	
   	  	
      end
    end
   -- p:addEventListener("collision", shotHandler);		
  
  end

  
  self.timerRef = timer.performWithDelay(interval, 
	function (event) createShot(self) end, -1);






  --end --endif
end




return boss