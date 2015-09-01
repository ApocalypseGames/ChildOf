
--physics.setDrawMode( "hybrid" )
local composer = require( "composer" )
local mydata = require( "mydata" )
local score = require( "score" )
local scene = composer.newScene()
local physics = require "physics"
physics.start()
physics.setGravity( 0, 100 )
local zombie = require("zombie")
local boss = require("boss")
local Player = require("Player")

local music = audio.loadSound( "06 - Someone_Elses_Instrumental.mp3" )



local mydata = require( "mydata" )
	player = Player:new()
	player:spawn()


 zombies = {};
 y = 0
 i= 0
 zombieGroup = display.newGroup()
local gameStarted = false

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

function dieLittleMan( event )


	if event.other.tag == "baby" then
		
		
	
		if ( event.phase == "began" ) then

			time2 = system.getTimer( )
			composer.gotoScene( "restart" )
		
		end
	end
end

function zombieCreate()

	
		i = i+1
		local zId  = i
 		zombies[zId] = zombie:new()
		zombies[zId]:spawn()
		zombies[zId]:MovesRight()
		zombies[zId].shape.tid = timer.performWithDelay(100,function() chaseIt(zId) end, -1);
		
	
		zombies[zId].shape:addEventListener("collision",dieLittleMan)
		
	end



 function chaseIt (z)
	
		if zombies[z] ~= nil then
		  V = 0.05; -- V = D / T
		  t = math.sqrt ( (player.shape.x - zombies[z].shape.x)^2 + (player.shape.y - zombies[z].shape.y)^2 ) / V;
		 transition.to(zombies[z].shape, {time=t,x=player.shape.x, y=player.shape.y});
		end	 
	 
	

end

function onCollision( event )
	if ( event.phase == "began" ) then
		composer.gotoScene( "restart" )
		
	end
end
function justice()
	player:shoot()
end
function platformScroller(self,event)
	-- print(self.tag..self.x)
	
	--print(-display.contentWidth)
	if(self.tag=='2')then
		--print(self.tag..self.x.."platform--------------2")
		if self.x < (-1600 + (self.speed*2)) then
			self.x = 1200
		else 
			self.x = self.x - self.speed
		end
	end
	if(self.tag=='1')then
		--print(self.tag..self.x.."platform--------------1")
		if self.x < (-1600 + (self.speed*2)) then
			self.x = 1200
		else 
			self.x = self.x - self.speed
		end
	end
end
 


 function goRight(event)
	
 motionx = -player.speed;
 player:setDirection(0)
player:runLeft()

 end
 
	scrMoving = "false"
function leaveThisWorld(event)
		
		
			if event.phase == "began"then
			
				player.shape:applyForce(0, -5200, player.shape.x, player.shape.y)

			end
		
end

 motionx = 0








function moveColumns()
	--if a ~= nil then
	print(elements.numChildren)
		for a = elements.numChildren,1,-1  do
			
			if(elements[a].x > -100) then
				elements[a].x = elements[a].x - 1
			else 
				elements:remove(elements[a])
			end	
		end
--	end
end
 function stop (event)
 	if event.phase =="ended" then
 		motionx = 0;
 		player:stand()
 		Runtime:removeEventListener("enterFrame", platform)
 		Runtime:removeEventListener("enterFrame", platform2)
 		scrMoving = "false"
 	end

 	
 end
 function addColumns()
	local deathOrNaw = math.random(5)
	if deathOrNaw>=4 then 
		height = math.random(display.contentCenterY - 200, display.contentCenterY + 200)

		plank = display.newImageRect('spikes.png',100,54)
		plank.anchorX = 0.5
		plank.anchorY = 1
		plank.x = display.contentWidth + 100
		plank.y = math.random(150,450)
		plank.scoreAdded = false
   		
		physics.addBody(plank, "static", {density=1, bounce=0.1, friction=.2})
		plank.me = "spike"
		plank:addEventListener("collision",dieLittleMan)
		
		elements:insert(plank)
		
	else
		plank = display.newImageRect('platform2.png',200,54)
		plank.anchorX = 0.5
		plank.anchorY = 0
		
		plank.x = display.contentWidth + 100
		plank.y = math.random(150,450)
		physics.addBody(plank, "static", {density=1, bounce=0.1, friction=.2})
		plank.me = "plank"
		elements:insert(plank)
		
	 end
end	


function moveLvl(event)
	
	player.shape.x = player.shape.x + motionx			--move the play by some value

	if player.shape.x>display.contentWidth then			--stop the play at a point
		player.shape.x=display.contentWidth-5 			--move the player back
		if scrMoving=="false"then						--check to see if the map is scrolling
		platform.enterFrame = platformScroller 			--move the platform
		Runtime:addEventListener("enterFrame", platform)
		-- addColumnTimer = timer.performWithDelay(1000, addColumns, -1)
		-- moveColumnTimer = timer.performWithDelay(2, moveColumns, -1)
		platformsMoving = "true"
		platform2.enterFrame = platformScroller
		Runtime:addEventListener("enterFrame", platform2)
		scrMoving ="true"
	end
			
		elseif player.shape.x<0 then		--stop the player
			player.shape.x=1
			
		-- elseif player.shape.x-6<=display.contentWidth then	
		-- 	if platformsMoving == "true" then

		-- 	timer.cancel(addColumnTimer)
		-- 	timer.cancel(moveColumnTimer)
		-- 	platformsMoving = "false"
		--end
	end
 		
end
function goLeft(event)
	if event.phase == "ended"then
		-- if platformsMoving == "true" then

 	-- 		timer.cancel(addColumnTimer)
		-- 	timer.cancel(moveColumnTimer)
		-- 	print("called")

 	
 	-- 	end
	end
	motionx = player.speed;
	player:setDirection(1)
	
 	player:runRight()

end
local function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end


-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   
   gameStarted = false
   mydata.score = 0

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   local background = display.newImage("bg.png")
	sceneGroup:insert(background)

        background = display.newImageRect("bg.png",1850,900)
	background.anchorX = 0.5
	background.anchorY = 1
	background.x = display.contentCenterX
	background.y = display.contentHeight
	
	sceneGroup:insert(background)
    
    elements = display.newGroup()
	elements.anchorChildren = true
	elements.anchorX = 0
	elements.anchorY = 1
	elements.x = 0
	elements.y = 0
	sceneGroup:insert(elements)


	platform = display.newImageRect('platform2.png',1400,53)
	platform.anchorX = 0
	platform.anchorY = 1
	platform.tag='1'
	platform.x = -190
	platform.y = 615
	physics.addBody(platform, "static", {density=.1, bounce=0.1, friction=.2})
	platform.speed = 4
	sceneGroup:insert(platform)

	platform2 = display.newImageRect('platform2.png',1400,53)
	platform2.anchorX = 0
	platform2.anchorY = 1
	platform2.tag='2'
	platform2.x = platform.x+1400
	platform2.y = platform.y
	physics.addBody(platform2, "static", {density=.1, bounce=0.1, friction=.2})
	platform2.speed = 4
	sceneGroup:insert(platform2)

function remGun(event)
		if event.other.tag == "baby" then
			fire.isVisible = true
			
			display.remove( gun )
		end
end
addColumnTimer = timer.performWithDelay(5000, addColumns, -1)
moveColumnTimer = timer.performWithDelay(2, moveColumns, -1)
function createGun()	
gun = display.newImageRect("ak.png",20,20)
physics.addBody(gun, "dynamic", {density=1, bounce=0.1, friction=.2})
gun:addEventListener("collision",remGun)

end

gunTimer = timer.performWithDelay(math.random(5000,10000),createGun)

-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------


 up = display.newRect(display.contentWidth-500,display.contentHeight-629,display.contentWidth*2,180)
 fire = display.newImageRect("ak.png",display.contentWidth-1000,display.contentHeight-620)
 	fire.anchorX = 100
	fire.anchorY = 200
	fire.x = display.contentCenterX-500
	fire.y = display.contentHeight
	fire.isVisible = false
 left = display.newRect(display.contentWidth-64,display.contentHeight-265,display.contentWidth/2+360,display.contentWidth-350)
 right = display.newRect(display.contentWidth-840,display.contentHeight-340,display.contentWidth/2+250,display.contentWidth-520)
up:setFillColor(0,0,0,.005)
left:setFillColor(1,0,0,.005)
right:setFillColor(0,1,0,.005)
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
-------------------------------------------------------controls----------------------------------------------------------------------------------
	
   
end

-- "scene:show()"


function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.\
    time1 = system.getTimer( )

local options =
{
    channel = 1,
    loops = -1,
    onComplete = callbackListener
}


	audio.play( music,options )
	composer.removeScene("start")

	right:addEventListener("touch",goRight)
	fire:addEventListener("tap",justice)
	left:addEventListener("touch", goLeft)
	up:addEventListener("touch", leaveThisWorld)
	Runtime:addEventListener("enterFrame",moveLvl)
	 Runtime:addEventListener("touch", stop )
	zSpwn = timer.performWithDelay(3000, zombieCreate , -1 ) 
    memTimer = timer.performWithDelay( 1000, checkMemory, 0 )


  			function imHit(event)
  				if event.other.tag == "playerProjectie" then
				boss:hit()
			end
			end
function bossKill(event)
	if event.other.tag == "enemyProjectie" then 
		composer.gotoScene( "restart" )
	end

end
player.shape:addEventListener( "collision", bossKill )
function makeBoss()
	

			boss = boss:new()

			boss:spawn()
			boss:move()
			boss:shoot(350)
			sceneGroup:insert(boss.shape)
			boss.shape:addEventListener( "collision", imHit )
end

	bossTimer = timer.performWithDelay( math.random( 20000,30000 ), makeBoss )

	  
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
	  up:removeEventListener("touch", leaveThisWorld)
	  left:removeEventListener("touch", goLeft)
	  right:removeEventListener("touch", goRight)
	  	timer.cancel(addColumnTimer)
			timer.cancel(moveColumnTimer)
	

	 -- timer.cancel(addColumnTimer)
	 -- timer.cancel(moveColumnTimer)
	timer.cancel(memTimer)
	  
	  
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      fire.isVisible = false
 		if boss.timerRef ~= nil then
    	 	timer.cancel( boss.timerRef )
   		end
  -- timer.cancel( moveColumnTimer )
   --timer.cancel(addColumnTimer)
   timer.cancel( bossTimer )
   timer.cancel( gunTimer )
    	timer.cancel( zSpwn )
   --   display.remove( boss.shape )

       audio.pause( music )
     -- boss.shape.isVisible = false

   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene













