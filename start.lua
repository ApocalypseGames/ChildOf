local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------


local physics = require "physics"
physics.start()
local mydata = require( "mydata" )

-------------------------------------------------------------------------------------

function startGame(event)
     if event.phase == "ended" then
		composer.gotoScene("game")
     end
end

function groundScroller(self,event)
	
	if self.x < (-900 + (self.speed*2)) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
	
end

function titleTransitionDown()
	downTransition = transition.to(titleGroup,{time=400, y=titleGroup.y+20,onComplete=titleTransitionUp})
	
end

function titleTransitionUp()
	upTransition = transition.to(titleGroup,{time=400, y=titleGroup.y-20, onComplete=titleTransitionDown})
	
end

function titleAnimation()
	titleTransitionDown()
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
    background = display.newImageRect("bg.png",1850,900)
	background.anchorX = 0.5
	background.anchorY = 1
	background.x = display.contentCenterX
	background.y = display.contentHeight
	sceneGroup:insert(background)
	
	title = display.newImageRect("title.png",500,100)
	title.anchorX = 0.5
	title.anchorY = 0.5
	title.x = display.contentCenterX - 80
	title.y = display.contentCenterY 
	sceneGroup:insert(title)
	

	
	start = display.newImageRect("start_btn.png",300,65)
	start.anchorX = 0.5
	start.anchorY = 1
	start.x = display.contentCenterX
	start.y = display.contentHeight - 400
	sceneGroup:insert(start)
	
	p_options = 
	{
		-- Required params
     width = 49, -- 297/6 width of each sprite 
     height = 62, --248/4 height of each sprite
     numFrames = 20 --frames in the image
       
		-- content scaling

	}

	playerSheet = graphics.newImageSheet( "Baby.png", p_options )
	player = display.newSprite( playerSheet, { name="player", start=1, count=2, time=500 } )
	player.anchorX = 0.5
	player.anchorY = 0.5
	player.x = display.contentCenterX + 240
	player.y = display.contentCenterY 
	player:play()
	sceneGroup:insert(player)
	
	titleGroup = display.newGroup()
	titleGroup.anchorChildren = true
	titleGroup.anchorX = 0.5
	titleGroup.anchorY = 0.5
	titleGroup.x = display.contentCenterX
	titleGroup.y = display.contentCenterY - 250
	titleGroup:insert(title)
	titleGroup:insert(player)
	sceneGroup:insert(titleGroup)
	titleAnimation()
   
   
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
      -- Example: start timers, begin animation, play audio, etc.
		composer.removeScene("restart")
		start:addEventListener("touch", startGame)

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
	    start:removeEventListener("touch", startGame)
		Runtime:removeEventListener("enterFrame", platform)
		Runtime:removeEventListener("enterFrame", platform2)
		transition.cancel(downTransition)
		transition.cancel(upTransition)
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
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










