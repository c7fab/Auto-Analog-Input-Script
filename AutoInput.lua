-- Auto analog input script written by TASeditor
-- Main window
-- This function runs after the user clicked on the Start button.
memory.usememorydomain("RDRAM")
require("AutoInputAPI")

function Start()

	if PauseFlag == false
	then if StartFlag == false
		 then if editMode == "Edit"
			  then ToggleCanvasEdit()
			  end
			  RadiusMin = forms.gettext(RadiusMinTxt)
			  RadiusMax = forms.gettext(RadiusMaxTxt)
              Optimisation = forms.gettext(OptDrop)
			  --TwoStep = forms.ischecked(TwoStepCheck)
			  StartFlag = true
			  forms.settext(StatLabel, "Started")
			  UseCanv = true
			 -- currentWaypoint = 1
		 end;
	end;
	
end;

-- This function runs after the user clicked on the Pause button.
function Pause()

	if StartFlag == true
	then if PauseFlag == false
		 then PauseFlag = true
			  forms.settext(StatLabel, "Paused")
			  forms.settext(PauseButton, "Continue")
			  client.pause()
		 else PauseFlag = false
			  forms.settext(StatLabel, "Started")
			  forms.settext(PauseButton, "Pause")
		 end;
	end;

end;

-- This function runs after the user clicked on the Stop button.
function Stop()

	if StartFlag == true
	then StartFlag = false
		 PauseFlag = false
		 forms.settext(StatLabel, "Stopped")
		 forms.settext(PauseButton, "Pause")
		 client.pause()
		 UseCanv = false
	end;

end;

-- These functions run after the user clicked the "+" or "-" button.
function IncrementAngle(inpX, inpY)
	
	local Xbest = inpX
	local Ybest = inpY
	local inp_a = math.atan2(inpY, inpX) % math.pi
	local inp_ad = (inp_a *180/math.pi) % 360

	if not(inp_ad == 0 or inp_ad == 45 or inp_ad == 90 or inp_ad == 135 or inp_ad == 180 or inp_ad == 225 or inp_ad == 270 or inp_ad == 315)-- or math.abs(inp["X Axis"])/math.abs(inp["Y Axis"]) == 2 or math.abs(inp["Y Axis"])/math.abs(inp["X Axis"]) == 2)
	then local Points = Bresenham(0,0, inpX*182, inpY*182, "add", inpX, inpY)
		 local bestDist = 9999999999;

		 for i, pt in pairs(Points) do
			local pt_a = math.atan2(pt.Y, pt.X) % math.pi
			local newDist = math.abs(pt_a - inp_a);

		 	if newDist < bestDist
		 	then if pt.X >= -128 and pt.Y >= -128 and pt.X <= 127 and pt.Y <= 127
		 		then bestDist = newDist
		 			Xbest = pt.X
		 			Ybest = pt.Y
		 		end
		 	end
		 end --TODO: Check user settings
	elseif inp_ad == 0 then Xbest = 127; Ybest = 1
	--elseif inp_ad < 26.745226 and inp_ad > 26.384308 then Xbest = 127; Ybest = 64
	elseif inp_ad == 45 then Xbest = 126; Ybest = 127
	--elseif inp_ad < 63.615692 and inp_ad > 63.254774 then Xbest = 64; Ybest = 127
	elseif inp_ad == 90 then Xbest = -1; Ybest = 127
	--elseif inp_ad < 116.745226 and inp_ad > 116.384308 then Xbest = -64; Ybest = 127
	elseif inp_ad == 135 then Xbest = -128; Ybest = 127
	--elseif inp_ad < 153.615692 and inp_ad > 254774 then Xbest = -127; Ybest = 63
	elseif inp_ad == 180 then Xbest = -128; Ybest = -1
	
	elseif inp_ad == 225 then Xbest = -127; Ybest = -128
	elseif inp_ad == 270 then Xbest = 1; Ybest = -128
	elseif inp_ad == 315 then Xbest = 127; Ybest = -126	
	end
	
	return Xbest, Ybest
	
end

function Add()
	
	if tastudio.engaged()
	then local sel = tastudio.getselection()
		 
		for i in pairs(sel) do
			local inp = movie.getinput(sel[i])		
			local X, Y = IncrementAngle(inp["P1 X Axis"], inp["P1 Y Axis"])
			
			tastudio.submitanalogchange(sel[i], "P1 X Axis", X)
			tastudio.submitanalogchange(sel[i], "P1 Y Axis", Y)
		end
	end
	
	tastudio.applyinputchanges()
	
	-- if HasGameRotatingCam == "true"
	-- then FollowAngle = ((math.atan2(Ybest, Xbest) + camera.rotation.y + Offset) % Modulo)*Modulo/2/math.pi % Modulo --TODO:
	-- else FollowAngle = ((math.atan2(Ybest, Xbest) + Offset) % Modulo)*Modulo/2/math.pi % Modulo
	-- end 
	-- forms.settext(AngFollowTxt, tonumber(FollowAngle))
	
	fromAddSub = true
	
end;

function DecrementAngle(inpX, inpY)
	
	local Xbest = inpX
	local Ybest = inpY
	local inp_a = math.atan2(inpY, inpX) % math.pi
	local inp_ad = (inp_a *180/math.pi) % 360

	if not(inp_ad == 0 or inp_ad == 45 or inp_ad == 90 or inp_ad == 135 or inp_ad == 180 or inp_ad == 225 or inp_ad == 270 or inp_ad == 315)
	then local Points = Bresenham(0,0, inpX*182, inpY*182, "sub", inpX, inpY)
		 local bestDist = 9999999999
		 
		 for i, pt in pairs(Points) do
			 local pt_a = math.atan2(pt.Y, pt.X) % math.pi
			 local newDist = math.abs(pt_a - inp_a)
			 
			 if newDist < bestDist
			 then if pt.X >= -128 and pt.Y >= -128 and pt.X <= 127 and pt.Y <= 127
				  then bestDist = newDist
					   Xbest = pt.X
					   Ybest = pt.Y
				 end
			 end
		 end
	elseif inp_ad == 0 then Xbest = 127; Ybest = -1
	elseif inp_ad == 45 then Xbest = 127; Ybest = 126
	elseif inp_ad == 90 then Xbest = 1; Ybest = 127
	elseif inp_ad == 135 then Xbest = -126; Ybest = 127
	elseif inp_ad == 180 then Xbest = -128; Ybest = 1
	elseif inp_ad == 225 then Xbest = -128; Ybest = -127
	elseif inp_ad == 270 then Xbest = -1; Ybest = -128
	elseif inp_ad == 315 then Xbest = 127; Ybest = -128
	end
	
	return Xbest, Ybest

end

function Sub()

	if tastudio.engaged()
	then local sel = tastudio.getselection()
		 
		 for i in pairs(sel) do
			local inp = movie.getinput(sel[i])		
			local X, Y = DecrementAngle(inp["P1 X Axis"], inp["P1 Y Axis"])
			tastudio.submitanalogchange(sel[i], "P1 X Axis", X)
			tastudio.submitanalogchange(sel[i], "P1 Y Axis", Y)
		 end
	end
	
	tastudio.applyinputchanges()
	
	-- if HasGameRotatingCam == "true"
	-- then FollowAngle = ((math.atan2(Ybest, Xbest) + camera.rotation.y + Offset) % Modulo)*Modulo/2/math.pi % Modulo --TODO:
	-- else FollowAngle = ((math.atan2(Ybest, Xbest) + Offset) % Modulo)*Modulo/2/math.pi % Modulo
	-- end 

	
	fromAddSub = true

end;

function CalcAngle(Xstart, Zstart, Xgoal, Zgoal)

	local DeltaX = Xgoal - Xstart
	local DeltaZ = Zgoal - Zstart
		--TODO: Games require different formula???
	local NewAngle = ((math.atan2(-DeltaZ , DeltaX) * (settings.angle.modulo/2) / math.pi) ) % settings.angle.modulo

	return NewAngle
		
end;

function ToggleCanvasEdit()

	if CanvasMode == "view"
	then CanvasMode = "edit"
		 forms.settext(CanvasButton, "View Mode")

		 --if PointsFrame[2] == nil --TODO: Better method of jumping to a previous waypoint when editing
		 --then PointsFrame[1] = emu.framecount() 
		 --end	
		 
		 if PointsFrame[1] ~= nil
		then ug = PointsFrame[1] -- reenable assigning input
			 -- tastudio.setplayback(PointsFrame[1])
			 -- currentWaypoint = 1
		 end
		 
	elseif CanvasMode == "edit"
		then CanvasMode = "view"
			 forms.settext(CanvasButton, "Edit Mode")
	end

end

function ZoomIn()

	Zoom = Zoom*1.01
	
end

function ZoomOut()

	Zoom = Zoom*0.99
	
end

function ResetZoom()

	Zoom = 1
	
end

function ToggleFollow()

	if follow == "none"
	then follow = "player"
		 xDrawOffset = 400
		 yDrawOffset = 400
	elseif follow == "player"
		then follow = "none"
		
	end
	
end

function ViewPlayer()

	xDrawOffset = (xFollow-player.position.x)*Zoom +400
	yDrawOffset = (yFollow-player.position.z)*Zoom +400

end

function ViewWaypoint()

	

end

-- This function creates the main window.
function WindowForm()

	local OptTable = {"Low"}--, "Medium", "High"}
	
	Window = forms.newform(300, 500, "Auto analog input")
	
	--PosCheck = forms.checkbox(Window, "Go to position:", 5, 20)
	--forms.label(Window, "X =", 110, 10, 30, 20)
	--XPosGotoTxt = forms.textbox(Window, "0", 120, 20, nil, 140, 5)
	--forms.label(Window, "Y =", 110, 40, 30, 20)
	--YPosGotoTxt = forms.textbox(Window, "0", 120, 20, nil, 140, 35)
	
	--AngCheck = forms.checkbox(Window, "Follow angle:", 5, 75)
	--forms.label(Window, "a =", 110, 80, 30, 20)
	--AngFollowTxt = forms.textbox(Window, "0", 120, 20, nil, 140, 75)
	
	forms.label(Window, "Radius: min =", 5, 120, 75, 20)
	RadiusMinTxt = forms.textbox(Window, "67", 30, 20, nil, 80, 115)
	forms.label(Window, "max =", 115, 120, 35, 20)
	RadiusMaxTxt = forms.textbox(Window, "182", 30, 20, nil, 155, 115)
	
	forms.label(Window, "Increment/decrement input angle:", 5, 150, 170, 20)
	forms.button(Window, "+", Add, 200, 145, 23, 23)
	forms.button(Window, "-", Sub, 175, 145, 23, 23)
	
	forms.label(Window, "Optimisation:", 5, 180, 70, 20)
	OptDrop = forms.dropdown(Window, OptTable, 80, 175, 100, 20)
	--TwoStepCheck = forms.checkbox(Window, "Two stepping", 190, 175)
	
	forms.label(Window, "Status:", 5, 210, 40, 15)
	StatLabel = forms.label(Window, "Stopped", 45, 210, 200, 20)
	
	
	
	forms.button(Window, "Start", Start, 5, 230)
	PauseButton = forms.button(Window, "Pause", Pause, 105, 230)
	forms.button(Window, "Stop", Stop, 205, 230)
	
	CanvasButton = forms.button(Window, "Edit Mode", ToggleCanvasEdit, 5, 270)
	forms.button(Window, "Toggle Follow", ToggleFollow, 100, 270, 50, 23)
	--forms.button(Window, "Zoom -", ZoomOut, 150, 270, 50, 23)
	--forms.button(Window, "Zoom 1", ResetZoom, 200, 270, 50, 23)
	
	
	autoUnpauseCheck = forms.checkbox(Window, "Auto Unpause:", 10, 300)
	
	

end

 -- Address window
-- This function checks wheter the user has typed in the memory addresses or not.
-- It doesn't check if the typed address is the correct one.
-- The "0x" should not be deleted.
function Check()
	
	success = false;
	XPosAddr = forms.gettext(XPosAddrTxt)
	ZPosAddr = forms.gettext(ZPosAddrTxt)
	MovAngAddr = forms.gettext(MovAngAddrTxt)
	CamAngAddr = forms.gettext(CamAngAddrTxt)
	Offset = forms.gettext(OffsetTxt)
	Type = forms.gettext(TypeDrop)
	Modulo = forms.gettext(ModTxt)
	DeadzoneMin = forms.gettext(MinTxt)
	DeadzoneMax = forms.gettext(MaxTxt)
	
	
	if XPosAddr ~= "0x" and ZPosAddr ~= "0x" and MovAngAddr ~= "0x" and Offset ~= ""
	then success = true
	end
	
	if CamAngAddr == "0x"
	then HasGameRotatingCam = false
		 CamAngAddr = 0
	else HasGameRotatingCam = true
	end
		 
	
	if (Type == "Byte" and Modulo == "")
	then Modulo = 256
	elseif (Type == "Word" and Modulo == "")
	then Modulo = 65536
	elseif (Type == "DWord" and Modulo == "")
	then Modulo = 4294967296
	elseif (Type == "Float" and Modulo == "")
	then success = false
	end
	
	if DeadzoneMin == ""
	then DeadzoneMin = 0
	else DeadzoneMin = tonumber(DeadzoneMin)
	end
	
	if DeadzoneMax == ""
	then DeadzoneMax = 129
	else DeadzoneMax = tonumber(DeadzoneMax)
	end
	
	if DeadzoneMin > DeadzoneMax 
	then success = false
	end
	
	if forms.ischecked(useAPICheck)
	then success = true
	end
	
	if success == true
	then -- Writes the addresses into a text file.
		 -- The user doesn't have to type in the addresses everytime.
		 SettingsFile = io.open(ROMname, "a")
		 SettingsFile:write(tostring(forms.ischecked(useAPICheck)), "\n",
						tonumber(XPosAddr), "\n", 
						tonumber(ZPosAddr), "\n", 
						tonumber(MovAngAddr), "\n", 
						tostring(HasGameRotatingCam), "\n", 
						tonumber(CamAngAddr), "\n",
						tonumber(Offset), "\n",
						tostring(Type), "\n",
						tonumber(Modulo), "\n",
						DeadzoneMin, "\n",
						DeadzoneMax)
		 SettingsFile:close()
		 
		 -- Closes the form where the user typed in the addresses.
		 forms.destroy(Settings)
		 WindowForm()
	end;
	
end;

-- This function creates the form where the user needs to type in memory addresses.
function SettingsForm()
	
	local TypeTable = {"Byte","Word","DWord", "Float"}
	
	Settings = forms.newform(280, 370, "Settings")
	
	forms.label(Settings, "Horizontal position addresses:", 5, 5, 280, 20)
	forms.label(Settings, "X:",5, 30, 20, 20)
	XPosAddrTxt = forms.textbox(Settings, "0x", 70, 20, nil, 25, 25)
	forms.label(Settings, "Z:",105, 30, 20, 20)
	ZPosAddrTxt = forms.textbox(Settings, "0x", 70, 20, nil, 125, 25)
	
	forms.label(Settings, "Horizontal movement angle address:", 5, 55, 350, 20)
	MovAngAddrTxt = forms.textbox(Settings, "0x", 70, 20, nil, 10, 75)
	--FloatCheck = forms.checkbox(Settings, "Float?", 120, 75)
	
	forms.label(Settings, "Horizontal camera angle address:", 5, 105, 340, 20)
	CamAngAddrTxt = forms.textbox(Settings, "0x", 70, 20, nil, 10, 125)
	
	forms.label(Settings, "Offset for the analog stick angle:", 5, 155, 360, 20)
	OffsetTxt = forms.textbox(Settings, "", 70, 20, nil, 10, 175)
	
	forms.label(Settings, "Unit system for angles:", 5, 205, 300, 20)
	forms.label(Settings, "Type:", 5, 230, 40, 20)
	TypeDrop = forms.dropdown(Settings, TypeTable , 45, 225, 80, 20)
	forms.label(Settings, "modulo:", 130, 230, 45, 20)
	ModTxt = forms.textbox(Settings, "", 60, 20, nil, 180, 225)
	
	forms.label(Settings, "Deadzone:", 5, 255, 100, 20)
	forms.label(Settings, "min:", 5, 280, 30, 20)
	MinTxt = forms.textbox(Settings, "", 30, 20, nil, 35, 275)
	forms.label(Settings, "max:", 70, 280, 30, 20)
	MaxTxt = forms.textbox(Settings, "", 30, 20, nil, 105, 275)
	
	--forms.label(Settings, "Use API:", 5 , 300, 90, 20)
	useAPICheck = forms.checkbox(Settings, "Uses API:", 5, 300)
	
	forms.button(Settings, "Done", Check, 150, 300)

end;

-- Reads out the memory addresses from the file, if there's content in the file.
-- The memory addresses are saved in decimal numbers.
-- The file is in the main BizHawk folder and is called "<romname>.txt".
-- The main window will open.

--useAPI = nil
--XPosAddr = nil
--ZPosAddr = nil
--MovAngAddr = nil
--HasGameRotatingCam = nil
--CamAngAddr = nil
--CamAngAddr = nil
--Offset = nil
--Type = nil
--Modulo = nil
--DeadzoneMin = nil
--DeadzoneMax = nil

SettingsFile = nil

ROMname = gameinfo.getromname()..".ais"
SettingsFile = io.open(ROMname, "r")

if SettingsFile ~= nil
then useAPI = tostring(SettingsFile:read("*line"))
	 
	 if useAPI == "false"
	 then XPosAddr = tonumber(SettingsFile:read("*line"))
		  ZPosAddr = tonumber(SettingsFile:read("*line"))
		  MovAngAddr = tonumber(SettingsFile:read("*line"))
		  HasGameRotatingCam = tostring(SettingsFile:read("*line"))
		  CamAngAddr = tonumber(SettingsFile:read("*line"))
		  settings.angle.offset = tonumber(SettingsFile:read("*line"))
		  Type = tostring(SettingsFile:read("*line"))
		  settings.angle.modulo = tonumber(SettingsFile:read("*line"))
		  settings.deadzone.minimum = tonumber(SettingsFile:read("*line"))
		  settings.deadzone.maximum = tonumber(SettingsFile:read("*line"))
	 else 
	 end
	 
	 WindowForm()
	 SettingsFile:close()
end;
 
-- If there's no content in the file a window will open, where the user types in the memory addresses once.
if SettingsFile == nil
then SettingsForm()
end



--**************************************************************************************************--
--Brute force script																				--
--**************************************************************************************************--

Xinput = {}
Yinput = {}


--Canvas

Canvas = gui.createcanvas(800,820)

xDrawOffset = 400
yDrawOffset = 400

CPoints = {X, Z} --TODO
PointsX = {}
PointsZ = {}
PointsFrame = {}
totalPoints = 0
selected = false
ind = nil

CanvasMode = "view"
Zoom = 1
dmx = 0
dmy = 0
currentWaypoint = 1
UseCanv = false
followPlayer = true
follow = "none"

statusStripItems = {toggleFollowItem = {x = 1, y = 801, toolTip = "Toggle Follow Player", clickFunction = ToggleFollow, singleclick = true},
					viewPlayerItem = {x = 21, y = 801, toolTip = "Reset View to Player", clickFunction = ViewPlayer, singleclick = true}, 
					viewWaypointItem = {x = 41, y = 801, toolTip = "Set View next Waypoint", clickFunction = ViewWaypoint, singleclick = true}, 
					ZoomInItem = {x = 61, y = 801, toolTip = "Zoom In", clickFunction = ZoomIn, singleclick = false}, 
					ZoomOutItem = {x = 81, y = 801, toolTip = "Zoom Out", clickFunction = ZoomOut, singleclick = false}, 
					ResetZoomItem = {x = 101, y = 801, toolTip = "Reset Zoom", clickFunction = ResetZoom, singleclick = true} 
				   }

rightClickItems = {editMode = {mouseOverPoint = {setPosition = {text = "Set new position", clickEvent = nil }, 
												 splitPath = {text = "Split Path", clickEvent = SplitPath}
												}
							  }

				  }
				  
					
--Canvas end

askSave = ""
StartFlag = false
PauseFlag = false
X = 0; Y = 0
FollowAngle = 0
InputAngle = 0
Radius = 0
steps = 0
done = false
f=0
f_old=0
frameEdit = 0
ug = 0
autoUnpause = false

firstStep = true


tastudio.clearinputchanges()


function sgn(x)

	if x > 0
	then return 1
	elseif x < 0
	then return -1
	else return 0
	end
	
end;

function Bresenham(xStart, yStart, xEnd, yEnd, mode, xCurrent, yCurrent)

	local Points = {}
	local i = 0
	
	local dx = xEnd - xStart
	local dy = yEnd - yStart
	
	local incx = sgn(dx)
	local incy = sgn(dy)
	
	if mode ~= nil
	then angleCurr = math.atan2(yCurrent, xCurrent)
	end
	
	if dx < 0 then dx = -dx; end
	if dy < 0 then dy = -dy; end
	
	if dx > dy
	then pdx = incx -- parallel step
		 pdy = 0
		 ddx = incx -- diagonal step
		 ddy = incy
		 ef = dy -- error steps fast, slow
		 es = dx
	else pdx = 0
		 pdy = incy
		 ddx = incx
		 ddy = incy
		 ef = dx
		 es = dy
	end;
	
	local x = xStart
	local y = yStart
	
	local err = es/2
	
	--Points[0] = {X = x, Y = y}
	
	local RadiusMin = forms.gettext(RadiusMinTxt)
	local RadiusMax = forms.gettext(RadiusMaxTxt)
	local bestDist = 9999999999
		 
	for t = 0, es, 1 do
		
		err = err - ef
		
		if err < 0
		then err = err + es
			 x = x + ddx
			 y = y + ddy
		else x = x + pdx
			 y = y + pdy
		end
			
		local radius = math.sqrt(x^2+y^2)
		
		if (math.abs(x) >= settings.deadzone.minimum and math.abs(y) >= settings.deadzone.minimum and 
			math.abs(x) <= settings.deadzone.maximum and math.abs(y) <= settings.deadzone.maximum and 
			radius >= tonumber(RadiusMin) and radius <= tonumber(RadiusMax))
		then local pt_a = math.atan2(y, x)
			 if mode == "add"
			 then local pt_a = math.atan2(y, x)
				  local newDist = math.abs(pt_a - angleCurr)
				  if pt_a > angleCurr and newDist < bestDist
				  then Points[i] = {X = x, Y = y}
					   bestDist = newDist
					   i = i + 1
				  end
			elseif mode == "sub"
				then local pt_a = math.atan2(y, x)
					 local newDist = math.abs(pt_a - angleCurr)
					 if pt_a < angleCurr and newDist < bestDist
					 then Points[i] = {X = x, Y = y}
						  bestDist = newDist
						  i = i + 1
					 end
			else Points[i] = {X = x, Y = y}
				 i = i + 1
			end
		end	
	end
	
	return Points

end

function LineDrawing()
	
	
	local Points = Bresenham(0,0, math.cos(InputAngle)*182, math.sin(InputAngle)*182, nil, nil, nil)
	
	local bestDist = 9999999999
	
	local newPoint = { X, Y }
	
	for i, pt in pairs(Points) do
		newDist = math.abs(math.atan2(pt.Y, pt.X) - InputAngle)
		--if math.atan2(pt.Y, pt.X) == InputAngle
		--then break
		--end;
		if newDist < bestDist
		then if pt.X >= -128 and pt.Y >= -128 and pt.X <= 127 and pt.Y <= 127
			 then bestDist = newDist
				  newPoint.X = pt.X
				  newPoint.Y = pt.Y
			 end
		end
	end
	
	return newPoint
	
end;

function RotateAround(radius)

	local Point = {X, Y}

	local Xbest = math.floor(math.cos(InputAngle)*radius+0.5)
	local Ybest = math.floor(math.sin(InputAngle)*radius+0.5)
	
	
	local x = Xbest
	local y = Ybest
	
	Steps = 0
	j = 0
	bestdiff = 9999999999
	InputAngleInt = math.atan2(y, x) --console.writeline(InputAngle.." "..InputAngleInt);
		
	if InputAngleInt == InputAngle
	then --console.writeline("perfect");
	else 	
		repeat
			if Steps % 2 == 0
			then for i = 1,Steps,1 do
					x = x - 1
					InputAngleInt = math.atan2(y, x)-- console.writeline(X.." "..Y.." "..Steps)
					diff = math.abs(InputAngleInt - InputAngle)
					if diff < bestdiff 
					then Xbest = x
						 Ybest = y
						 bestdiff = diff
					end
				 end
				 
				 if InputAngleInt == InputAngle 
				 then Xbest = x
					  Ybest = y
					  break 
				 end
				 
				 for i = 1,Steps,1 do
					 y = y - 1
					 InputAngleInt = math.atan2(y, x)--; console.writeline(X.." "..Y.." "..Steps)
					 diff = math.abs(InputAngleInt - InputAngle)
					 if diff < bestdiff 
					 then Xbest = x
						  Ybest = y
						  bestdiff = diff
					end
				 end
				 
				 if InputAngleInt == InputAngle 
				 then Xbest = x
					  Ybest = y
					  break
				 end	
			else for i = 1,Steps,1 do
					 x = x + 1
					 InputAngleInt = math.atan2(y, x)--; console.writeline(X.." "..Y.." "..Steps);
					 diff = math.abs(InputAngleInt - InputAngle)
					 if diff < bestdiff 
					 then Xbest = x
						  Ybest = y
						  bestdiff = diff
					 end
				 end
				 
				 if InputAngleInt == InputAngle 
				 then Xbest = x
					  Ybest = y
					  break
				 end
				
				 for i = 1,Steps,1 do
					 y = y + 1
					 InputAngleInt = math.atan2(y, x)--; console.writeline(X.." "..Y.." "..Steps);
					 diff = math.abs(InputAngleInt - InputAngle)
					 if diff < bestdiff 
					 then Xbest = x
						  Ybest = y
						  bestdiff = diff
					 end
				 end
				 
				 if InputAngleInt == InputAngle 
				 then Xbest = x
					  Ybest = y
					  break 
				 end	
			end
			Steps = Steps + 1
			j = j +1
		until j == 5 --how long does this need to run?
		
		--Steps = 1;
		
	end
	
	Point = {X = Xbest, Y = Ybest }
	
	return Point
	--done = true;
	--j = 0;
	--print(math.atan2(Ybest, Xbest).." ".. math.abs(math.atan2(Ybest, Xbest)-InputAngle));
end;

function NoOptimisation(radius)
	
	local Point = {X, Y}
		
	Point.X = math.floor(math.cos(InputAngle)*radius+0.5)
	Point.Y = math.floor(math.sin(InputAngle)*radius+0.5)
	
	return Point

end;

function TwoStepping()
	
	

end;

function CreateInput()

	local Point = {}

	if useAPI == "false"
	then player.position.x = memory.readfloat(XPosAddr, true)
		 player.position.z = memory.readfloat(ZPosAddr, true)

		 if Type == "Byte" 
		 then MovAngle = memory.read_u8(MovAngAddr)
			  if HasGameRotatingCam == "true" 
			  then camera.rotation.y = memory.read_u8(CamAngAddr)
			  end
		 elseif Type == "Word"
			 then MovAngle = memory.read_u16_be(MovAngAddr)
				  if HasGameRotatingCam == "true" 
				  then camera.rotation.y = memory.read_u16_be(CamAngAddr)
				  end
		 elseif Type == "DWord"
			 then MovAngle = memory.read_u32_be(MovAngAddr)
				  if HasGameRotatingCam == "true" 
				  then camera.rotation.y = memory.read_u32_be(CamAngAddr)
				  end
		 elseif Type == "Float"
			 then MovAngle = memory.readfloat(MovAngAddr, true)
				  if HasGameRotatingCam == "true" 
				  then camera.rotation.y = memory.readfloat(CamAngAddr, true)
				  end
		 end
	end

	if totalPoints > 1 and UseCanv and currentWaypoint < totalPoints and currentWaypoint >= 1 --and PointsFrame[currentWaypoint+1] ~= nil
	then local lambdax = (player.position.x - PointsX[currentWaypoint])/(PointsX[currentWaypoint+1]-PointsX[currentWaypoint])
		 local lambdaz = (player.position.z - PointsZ[currentWaypoint])/(PointsZ[currentWaypoint+1]-PointsZ[currentWaypoint])
		 --TODO: This is broken
		 if (lambdax >= 1 and lambdaz >= 0.9 or lambdax >= 0.9 and lambdaz >= 1)-- Check if current waypoint has been reached. Set frame number for current one and set next waypoint as destination goal
		 then currentWaypoint = currentWaypoint + 1
			  --print("tp:"..totalPoints.."\ncwp:"..currentWaypoint)
			  PointsFrame[currentWaypoint] = emu.framecount()  
		 end
		 
		 if currentWaypoint < totalPoints
		 then FollowAngle = CalcAngle(player.position.x, player.position.z, PointsX[currentWaypoint+1], PointsZ[currentWaypoint+1])
		 end
	else
	end
	
	if currentWaypoint < totalPoints
	then autoUnpause = forms.ischecked(autoUnpauseCheck)
		 if CanvasMode == "view" and autoUnpause
		 then client.unpause()
		 end
	else client.pause()
	end
	
	if Optimisation == "Low" 
	then if HasGameRotatingCam == "true"
		 then InputAngle = ((FollowAngle - camera.rotation.y - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
		 else InputAngle = ((FollowAngle - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
		 end
		 Point = LineDrawing()
		 if emu.framecount() >= ug
		 then if emu.islagged()
			  then tastudio.submitanalogchange(emu.framecount(), "P1 X Axis", Point.X)
				   tastudio.submitanalogchange(emu.framecount(), "P1 Y Axis", Point.Y)
			  else tastudio.submitanalogchange(emu.framecount(), "P1 X Axis", 0)
				   tastudio.submitanalogchange(emu.framecount(), "P1 Y Axis", 0)
			  end
		 end
	
	elseif Optimisation == "Medium" --TODO: This should check angle error and adjust accordingly
		then if firstStep == true 
			 then if HasGameRotatingCam == "true"
				  then InputAngle = ((FollowAngle - camera.rotation.y - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
				  else InputAngle = ((FollowAngle - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
				  end
				  -- print("1st:"..InputAngle)
				  Point = LineDrawing()
		 
				  if emu.framecount() >= ug
				  then if emu.islagged()
					   then tastudio.submitanalogchange(emu.framecount(), "P1 X Axis", Point.X)
							tastudio.submitanalogchange(emu.framecount(), "P1 Y Axis", Point.Y)
							
					   else tastudio.submitanalogchange(emu.framecount(), "P1 X Axis", 0)
							tastudio.submitanalogchange(emu.framecount(), "P1 Y Axis", 0)
					   end
				  end
				  if f > f_old
				  then firstStep = false
				  end
			 elseif firstStep == false
				then local err = InputAngle - ((MovAngle % settings.angle.modulo)*math.pi/(settings.angle.modulo/2))
				
				  InputAngle = (InputAngle - err)
				 -- print("2nd:"..InputAngle)
			      Point = LineDrawing()
							--print(f..";"..f_old..";"..ug..";"..lastug)
							if f > f_old
							then tastudio.submitanalogchange(lastug, "P1 X Axis", Point.X)
								tastudio.submitanalogchange(lastug, "P1 Y Axis", Point.Y)
							end
					  --tastudio.submitanalogchange(emu.framecount()-1, "P1 X Axis", 0)
							--tastudio.submitanalogchange(emu.framecount()-1, "P1 Y Axis", 0)
					   firstStep = true
				  if f == f_old 
				then 
				  
				  --print("secondStep")
				  end
			 end
	elseif Optimisation == "High" 
		then 
	end
	
	
	
	
	
	tastudio.applyinputchanges()

end;

function MarkerControl()

	--marker = tastudio.getmarker(emu.framecount())
	
	--if bizstring.startswith(marker, "a=")
	--then s = bizstring.remove(marker, 0,2)
	--	 forms.settext(AngFollowTxt, s)
	--	 FollowAngle = tonumber(s);
	--end


end



function AppendWayPoint(MX, MY)
	
	if totalPoints == 0
	then table.insert(PointsX, totalPoints+1, (player.position.x)) --First point must be current player position
		 table.insert(PointsZ, totalPoints+1, (player.position.z))
		 table.insert(PointsFrame, totalPoints+1, emu.framecount()) -- save the frame to jump back when the user edits
		 totalPoints = totalPoints + 1
	end
	
	table.insert(PointsX, totalPoints+1, xFollow+(MX-xDrawOffset)/Zoom)
	table.insert(PointsZ, totalPoints+1, yFollow+(MY-yDrawOffset)/Zoom)
	table.insert(PointsFrame, totalPoints+1, nil)
			  
	totalPoints = totalPoints + 1
	
end

function DeleteWayPoint(index)
	
	if index == 1
	then for i = totalPoints, 1, -1 do
			
			table.remove(PointsX, i)--Delete every point if first one is clicked
			table.remove(PointsZ, i)
			table.remove(PointsFrame, i)
			totalPoints = totalPoints -1
			
		 end
	elseif totalPoints == 2 and index > 0 
		then table.remove(PointsX, index) --Delete the first one aswell if only two are remaining
			 table.remove(PointsZ, index)
			 table.remove(PointsFrame, index)
			 --print(tostring(k))
			 table.remove(PointsX, 1)
			 table.remove(PointsZ, 1)
			 table.remove(PointsFrame, 1)
			 totalPoints = totalPoints - 2
		else table.remove(PointsX, index)
			 table.remove(PointsZ, index)
			 table.remove(PointsFrame, index)
			 totalPoints = totalPoints - 1
	end

end

function SplitPath(index)
	--TODO: insert the new point to the yellow colored line segment (inserting at index crashes the script )
	table.insert(PointsX, index+1, (PointsX[index]+(PointsX[index+1]-PointsX[index])/2))
	table.insert(PointsZ, index+1, (PointsZ[index]+(PointsZ[index+1]-PointsZ[index])/2))
	table.insert(PointsFrame, index+1, nil)
	totalPoints = totalPoints + 1

end

function DrawArrow(x1, y1, x2, y2, color)

	local alpha = math.atan2(x2-x1, y2-y1)

	Canvas.DrawLine(x1, y1, x2, y2, color)
	
	--Canvas.DrawLine(x2, y2, x2+math.cos(alpha+math.pi/2.5)*20, y2-math.sin(alpha+math.pi/2.5)*20)
	--Canvas.DrawLine(x2, y2, x2+math.cos(alpha-math.pi/2.5+math.pi)*20, y2-math.sin(alpha-math.pi/2.5+math.pi)*20)
	
	if math.sqrt((x2-x1)^2+(y2-y1)^2) > 20
	then Canvas.DrawPolygon({{x2, y2}, 
							{x2+math.cos(alpha+math.pi/2.5)*15, y2-math.sin(alpha+math.pi/2.5)*15}, 
							{x2+math.cos(alpha-math.pi/2.5+math.pi)*15, y2-math.sin(alpha-math.pi/2.5+math.pi)*15}},
							color, color)
	end
	
end

function DrawPlayer(x, y, radius)

	local fullInfoDraw = false

	if player.position.previous.x ~= nil and player.position.previous.z ~= nil
	then local dx = xFollow-player.position.previous.x
		 local dz = yFollow-player.position.previous.z
	
		 Canvas.DrawEllipse(x-(dx+radius)*Zoom, y-(dz+radius)*Zoom,
							2*radius*Zoom, 2*radius*Zoom, 0x55FF0000, 0x22FF0000)
							
		 Canvas.DrawAxis(x-dx*Zoom, y-dz*Zoom, 5, 0x55FF0000)			

		 DrawArrow(x-dx*Zoom, y-dz*Zoom, x-(xFollow-player.position.x)*Zoom, y-(yFollow-player.position.z)*Zoom, 0x55FF0000)
		 
		 --TODO: Don't draw text below player hitbox
		 if math.sqrt((x-dx*Zoom-mouseX)^2+(y-dz*Zoom-mouseY)^2) < 5 and math.sqrt(dx^2+dz^2)*Zoom >= 20 and not fullInfoDraw
		 then Canvas.DrawText(x-dx*Zoom+16, y-dz*Zoom+16, 
						 "Previous Position:\nX:"..player.position.previous.x.."\nY:"..player.position.previous.y.."\nZ:"..player.position.previous.z,
							  0xFF000000, 0xEEDDDDDD)
		 elseif math.sqrt(dx^2+dz^2)*Zoom < 20
			 then fullInfoDraw = true
		 end
	end
	
	local dx = xFollow-player.position.x
	local dz = yFollow-player.position.z
	
	Canvas.DrawEllipse(x-(dx+radius)*Zoom, y-(dz+radius)*Zoom, 2*radius*Zoom, 2*radius*Zoom, 0xFFFF0000, 0x55FF0000)--Hitbox
	DrawArrow(x-dx*Zoom, y-dz*Zoom, 
			  (x-dx*Zoom)+math.cos(player.rotation.y*math.pi/(settings.angle.modulo/2))*radius*Zoom,
			  (y-dz*Zoom)-math.sin(player.rotation.y*math.pi/(settings.angle.modulo/2))*radius*Zoom, 0xFF880000)
	
	if player.velocity.x ~= nil and player.velocity.z ~= nil
	then local dx = xFollow-(player.position.x+player.velocity.x)
		 local dz = yFollow-(player.position.z+player.velocity.z)
	
		 DrawArrow(x-(xFollow-player.position.x)*Zoom, y-(yFollow-player.position.z)*Zoom, x-dx*Zoom, y-dz*Zoom, 0xFFFF0000)
						
		 if math.sqrt((x-dx*Zoom-mouseX)^2+(y-dz*Zoom-mouseY)^2) < 5 and math.sqrt(player.velocity.x^2+player.velocity.z^2)*Zoom >= 20 and not fullInfoDraw
		 then Canvas.DrawText(x-dx*Zoom+16, y-dz*Zoom+16, 
							  "Velocity:\nX:"..player.velocity.x.."\nY:"..player.velocity.y.."\nZ:"..player.velocity.z,
							  0xFF000000, 0xEEDDDDDD)
		 elseif math.sqrt(player.velocity.x^2+player.velocity.z^2)*Zoom < 20
			 then fullInfoDraw = true
		 end
	end
	--TODO: It doesn't draw the then condition
	if math.sqrt((x-dx*Zoom-mouseX)^2+(y-dz*Zoom-mouseY)^2) < 5 and not fullInfoDraw
	then Canvas.DrawText(x-dx*Zoom+16, y-dz*Zoom+16, 
						 "Position:\nX:"..player.position.x.."\nY:"..player.position.y.."\nZ:"..player.position.z,
							  0xFF000000, 0xEEDDDDDD)
	elseif math.sqrt((x-dx*Zoom-mouseX)^2+(y-dz*Zoom-mouseY)^2) < 5 and fullInfoDraw
		then Canvas.DrawText(x-dx*Zoom+16, y-dz*Zoom+16, 
						 "Position:\n	X:"..tostring(player.position.x).."\n	Y:"..tostring(player.position.y).."\n	Z:"..tostring(player.position.z)..
						 "\nPrevious Position:\n	X:"..tostring(player.position.previous.x).."\n	Y:"..tostring(player.position.previous.y).."\n	Z:"..tostring(player.position.previous.z)..
						 "\nVelocity:\n	X:"..tostring(player.velocity.x).."\n	Y:"..tostring(player.velocity.y).."\n	Z:"..tostring(player.velocity.z).."\n	H:"..tostring(player.velocity.horizontal).."\n	V:"..tostring(player.velocity.vertical),
						 0xFF000000, 0xEEDDDDDD)--TODO:Finish this
	end
	
	
	
	Canvas.DrawText(xDrawOffset+1, 785, player.position.x)
	Canvas.DrawText(0, yDrawOffset+1, player.position.z)
	
	
	
 end

function DrawCamera()

	if camera.position.x ~= nil and camera.position.z ~= nil
	then if camera.position.target.x ~= nil and camera.position.target.z ~= nil
		 then local dx = xFollow-camera.position.target.x
			  local dz = yFollow-camera.position.target.z
		 
			  Canvas.DrawAxis(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 5, 0xFF008888)
							  
			  DrawArrow(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 
						xDrawOffset-dx*Zoom,  yDrawOffset-dz*Zoom, 0xFF666666)
		 end
		 
		 if camera.focus.x ~= nil and camera.focus.z ~= nil
		 then if camera.focus.target.x ~= nil and camera.focus.target.z ~= nil
			  then local dx = xFollow-camera.focus.target.x
				   local dz = yFollow-camera.focus.target.z
			  
				   Canvas.DrawAxis(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 5, 0xFF008888)
								   
				   DrawArrow(xDrawOffset-(xFollow-camera.focus.x)*Zoom,
				             yDrawOffset-(yFollow-camera.focus.z)*Zoom,
							 xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 0xFF666666)			   
			  end
			  
			  local dx = xFollow-camera.focus.x
			  local dz = yFollow-camera.focus.z
			  Canvas.DrawAxis(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 5, 0xFF008888)
			   
			  DrawArrow(xDrawOffset-(xFollow-camera.position.x)*Zoom, 
						yDrawOffset-(yFollow-camera.position.z)*Zoom, 
						xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 0xFF666666)
		 end
		 
		 local dx = xFollow-camera.position.x
		 local dz = yFollow-camera.position.z
		 local ry = (camera.rotation.y+settings.angle.offset)* math.pi/(settings.angle.modulo/2)
		 
		 Canvas.DrawAxis(xDrawOffset-dx*Zoom, 
						 yDrawOffset-dz*Zoom, 5, 0xFF008888)
		
		 if math.sqrt((dx*Zoom)^2+(dz*Zoom)^2) > 60 
		 then Canvas.DrawPolygon({{xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom}, 
							 {xDrawOffset-dx*Zoom+math.cos(ry+math.pi/2.8)*30, yDrawOffset-dz*Zoom-math.sin(ry+math.pi/2.8)*30},
							 {xDrawOffset-dx*Zoom+math.cos(ry-math.pi/2.8+math.pi)*30, yDrawOffset-dz*Zoom-math.sin(ry-math.pi/2.8+math.pi)*30}},
							 0xFF002222, 0x22008888) 

			  Canvas.DrawLine(xDrawOffset-dx*Zoom+math.cos(ry+math.pi/2.8)*28, yDrawOffset-dz*Zoom-math.sin(ry+math.pi/2.8)*28,
							  xDrawOffset-dx*Zoom+math.cos(ry-math.pi/2.8+math.pi)*28, yDrawOffset-dz*Zoom-math.sin(ry-math.pi/2.8+math.pi)*28,
							  0xFF002222)
		 end
	else
	end

end

function DrawObject(x, y, radius)	

	--Canvas.DrawEllipse(x-10*Zoom, y-10*Zoom, 2*10*Zoom, 2*10*Zoom, 0xFF00FF00, 0x5500FF00)
	Canvas.DrawEllipse(xDrawOffset-(player.position.x-x+radius)*Zoom, 
						yDrawOffset-(player.position.z-y+radius)*Zoom,
						2*radius*Zoom, 2*radius*Zoom, 0xFF00FF00, 0x5500FF00)
	

	
			 Canvas.DrawAxis(xDrawOffset-(player.position.x-x)*Zoom, 
						 yDrawOffset-(player.position.z-y)*Zoom, 10, 0xFF000000)
						 
	--Canvas.DrawText(xDrawOffset-(player.position.x-x)*Zoom, yDrawOffset-(player.position.z-y)*Zoom, "obj")
	 
	

end



function UpdateCanvas()

	Canvas.Clear(0xFFFFFFFF)
	--XPosition = memory.readfloat(XPosAddr, true);
	--ZPosition = memory.readfloat(YPosAddr, true);
	Pselection = {}
	--selected = false
	--TODO:resizable canvas
	--TODO:Zooming
	--xDrawOffset = xDrawOffset
	--yDrawOffset = yDrawOffset
	
	if follow == "none"
	then xFollow = 0
		 yFollow = 0
	elseif follow == "player"
		then xFollow = player.position.x
			 yFollow = player.position.z
	end
	
	--Origin lines
	Canvas.DrawLine((xDrawOffset-xFollow*Zoom), 0, (xDrawOffset-xFollow*Zoom), 800, 0x55000000)
	Canvas.DrawLine(0, (yDrawOffset-yFollow*Zoom), 800, (yDrawOffset-yFollow*Zoom), 0x55000000)
	Canvas.DrawText((xDrawOffset-xFollow*Zoom), (yDrawOffset-yFollow*Zoom), "(0;0)")
	
	--Player coordinate lines
	Canvas.DrawLine(xDrawOffset-(xFollow-player.position.x)*Zoom, 0, xDrawOffset-(xFollow-player.position.x)*Zoom, 800, 0x55FF0000)
	Canvas.DrawLine(0, yDrawOffset-(yFollow-player.position.z)*Zoom, 800, yDrawOffset-(yFollow-player.position.z)*Zoom, 0x55FF0000)

			mouseX = Canvas.GetMouseX()
	mouseY = Canvas.GetMouseY()
	
	mouseButt = input.getmouse()
	
	
--	for k in pairs(objects) do
		--gui.drawText(100, 0+i*16, objects[i+1].active)
	--	if objects[k].active ~= 0 and objects[k].active ~= nil
	--	then --local x = (xDrawOffset-(player.position.x-objects[k].position.x)*Zoom)
		    --local z = (yDrawOffset-(player.position.z-objects[k].position.z)*Zoom)
			-- gui.drawText(100, 0+i*16, x..";"..z)
		--	print(x.."	"..z)
			---print(objects[k].active)
		--	DrawObject(objects[k].position.x, objects[k].position.z, objects[k].collision.radius)
	--	end
		--print(objects[k].position)
	--end
	
	--DrawObject(xDrawOffset-(player.position.x-object.position.x), 
				--yDrawOffset-(player.position.z-object.position.z),
				--object.collision.radius)
	

	
	if player.collision.radius == nil
	then DrawPlayer(xDrawOffset, yDrawOffset, 10)
	else DrawPlayer(xDrawOffset, yDrawOffset, player.collision.radius)
	end	
	
	
	DrawCamera()
	
	Canvas.DrawText(0, 64, tostring(xDrawOffset)..";"..tostring(yDrawOffset).."\n"..tostring(currentWaypoint))
	

	
	--keyb = input.get() FUCK doesn't work on Canvas
	--print(tostring(keyb["K"]))
		 -- if keyb["K"] == true
		 -- then xDrawOffset = 400
			  -- yDrawOffset = 400
		 -- end
	if mouseX >= 0 and mouseX <= 800 and mouseY >= 0 and mouseY <= 800
	then if mouseButt["Left"] and not wasMouseButtL and not selected and CanvasMode == "edit" -- adding a new waypoint
		 then AppendWayPoint(mouseX, mouseY)
			  if PointsFrame[totalPoints-1] ~= nil
			  then if emu.framecount() > PointsFrame[totalPoints-1]
				   then tastudio.setplayback(PointsFrame[totalPoints-1])
						currentWaypoint = totalPoints-1
						ug = PointsFrame[totalPoints-1]
				   end--TODO:Be more smart here. Don't jump back to fisrt waypoint when appending multiple new waypoints
			  else tastudio.setplayback(PointsFrame[1])
						currentWaypoint = 1
						ug = PointsFrame[1]
						
			  end
		 elseif mouseButt["Right"] -- dragging the canvas
		 then dmx = mouseX - oldMouseX
			  dmy = mouseY - oldMouseY
			  
			  xDrawOffset = xDrawOffset + dmx--/Zoom
			  yDrawOffset = yDrawOffset + dmy--/Zoom
			  
		 elseif mouseButt["XButton1"]
		 then ZoomIn()
		 elseif mouseButt["XButton2"]
		 then ZoomOut()
		 end
		 		 
		 --print(tostring(mouseButt[Wheel]))
		 Canvas.DrawText(0,0, " "..xFollow+(mouseX-xDrawOffset)/Zoom.."\n"..yFollow+(mouseY-yDrawOffset)/Zoom.."\n"..Zoom)
		
	else 
	end
	
	for k,v in pairs(PointsX) do
	
		--print(tostring(k).." "..tostring(v))
		
		--print("x "..tostring(PointsX[k]))
		--print("y "..tostring(PointsZ[k]))
		--print(k)
		if PointsX[k] ~= nil and PointsZ[k] ~= nil
		then local x = (xDrawOffset-(xFollow-PointsX[k])*Zoom)
			 local z = (yDrawOffset-(yFollow-PointsZ[k])*Zoom)
			 
			 
			 
			 if k == 1
			 then Canvas.DrawEllipse(x-5, z-5, 10, 10, 0xFF000000, 0xFFFF0000)--first one is red
			 else Canvas.DrawEllipse(x-5, z-5, 10, 10, 0xFF000000, 0xFF00FF00)
			 end
			 --Canvas.DrawText(x, z, ""..PointsX[k].."\n"..PointsZ[k])
			-- Canvas.DrawText(0, 16+16*k, ""..tostring(PointsX[k]).." , "..tostring(PointsZ[k]))
			
			if k > 1
			then Canvas.DrawLine((xDrawOffset-(xFollow-PointsX[k-1])*Zoom), (yDrawOffset-(yFollow-PointsZ[k-1])*Zoom), x, z)
			end
			
			if math.sqrt((x-mouseX)^2+(z-mouseY)^2) < 5
			then --selected = true
				 Pselection[k] = true
				 Canvas.DrawText(x+16, z+16, ""..k.."\n"..PointsX[k].."\n"..PointsZ[k].."\n"..tostring(PointsFrame[k]))
				 Canvas.DrawEllipse(x-5, z-5, 10, 10, 0xFF000000, 0xFFFFFF00)
				 
				 if k > 1
				 then Canvas.DrawLine((xDrawOffset-(xFollow-PointsX[k-1])*Zoom), (yDrawOffset-(yFollow-PointsZ[k-1])*Zoom), x, z, 0xFFFFFF00)
				 end
				 
				 if CanvasMode == "edit"
				 then if mouseButt["Left"] and k > 1
					  then ind = k
						   PointsXCopy = PointsX[ind]
						   PointsZCopy = PointsZ[ind]
						   if PointsFrame[k-1] ~= nil
						   then if currentWaypoint > k-1
								then tastudio.setplayback(PointsFrame[k-1])
									 currentWaypoint = k-1
									 ug = PointsFrame[k-1]
								end
						   elseif currentWaypoint > k-1
							   then tastudio.setplayback(PointsFrame[1])
									currentWaypoint = 1
									ug = PointsFrame[1]
						   end
						   client.pause()
					  else ind = nil
						   if autoUnpause
						   then client.unpause()
						   end
					  end
					  if mouseButt["Right"]
					  then DeleteWayPoint(k)
						   if PointsFrame[k-1] ~= nil
						   then if currentWaypoint > k-1
								then tastudio.setplayback(PointsFrame[k-1])
									 currentWaypoint = k-1
									 ug = PointsFrame[k-1]
								end
						   elseif currentWaypoint > k-1
							   then tastudio.setplayback(PointsFrame[1])
									currentWaypoint = 1
									ug = PointsFrame[1]
						   end
					  elseif mouseButt["Middle"] and k > 0 and k < totalPoints and not wasMouseButtM
					  then SplitPath(k)
						   if PointsFrame[k] ~= nil
						   then if currentWaypoint > k
								then tastudio.setplayback(PointsFrame[k])
									 currentWaypoint = k
									 ug = PointsFrame[k]
								end
						   elseif currentWaypoint > k
							   then tastudio.setplayback(PointsFrame[1])
									currentWaypoint = 1
									ug = PointsFrame[1]
						   end
					  end
				 elseif CanvasMode == "view"
					 then if mouseButt["Left"]
						  then if PointsFrame[k] ~= nil
							   then tastudio.setplayback(PointsFrame[k])
								    currentWaypoint = k
							   end
						  end
					  
				 end
			else --selected = false
				Pselection[k] = false
			end

			--Canvas.DrawText(x, z+36, tostring(Pselection[k]).."\n"..tostring(ind))
		end
		
		
		
	end
	selected = false
	for k,v in pairs(PointsX) do
		if Pselection[k]
		then selected = true
		end
	end 
	
	
	if ind ~= nil --and not mouseButt["Right"]-- and Pselection[ind]
	then dmx = mouseX - oldMouseX
		dmy = mouseY - oldMouseY
		PointsX[ind] = PointsX[ind] + dmx/Zoom --TODO: Left+Right mouse click bug
		PointsZ[ind] = PointsZ[ind] + dmy/Zoom
		--if PointsX[ind] ~= PointsXCopy or PointsZ[ind] ~= PointsYCopy
		--then print("changed "..tostring(ind)..", set "..tostring(ind-3).."as new frame")
		   --  pointsChanged = true
			-- if earliestChange == nil or earliestChange > ind
			-- then earliestChange = ind
			--		indCopy = ind
			 --end
			 
		--end
		selected = true
	else --selected = false
	
		--if not mouseButt["Left"] and pointsChanged and indCopy ~= nil
		--then tastudio.setplayback(PointsFrame[indCopy]); print("RESET FRAME")
			--pointsChanged = false
		--end
	
	end
	---print(tostring(PointsFrame[1]))
	--Canvas.DrawText(0,32, tostring(selected))
	--Canvas.DrawText(0,48, tostring(totalPoints))
	
	--StatusStrip
	Canvas.DrawRectangle(0, 800, 800, 20, 0x00000000, 0xFF999999)
	
	for k,v in pairs(statusStripItems) do
	
		local x = statusStripItems[k].x
		local y = statusStripItems[k].y
		
		if mouseX > x and mouseX < x+15 and mouseY > y and mouseY < y+15
		then Canvas.DrawRectangle(x, y, 17, 17, 0xFFBBBBBB, 0xFFAAAAAA)
			 Canvas.DrawText(x+8, y-18, statusStripItems[k].toolTip)
			 
			 if mouseButt["Left"] and (not statusStripItems[k].singleclick or not wasMouseButtL)
			 then statusStripItems[k].clickFunction()
			 end
		
		else Canvas.DrawRectangle(x, y, 17, 17, 0xFFBBBBBB, 0xFFDDDDDD)
		end
	end
	
	--Player Text

	
	
	wasMouseButtL = mouseButt["Left"]
	wasMouseButtM = mouseButt["Middle"]
	oldMouseX = mouseX
	oldMouseY = mouseY

	Canvas.Refresh()
end

function GetMarkerNoteAboveFrame(frame)

	local markerText
	local i = frame
	
	repeat 
	
		markerText = tastudio.getmarker(i)
		i = i - 1
	
	until i == 0 or markerText ~= ""
	
	return markerText

end

function CheckMarkers(frame)
	--TODO: Put a marker check when greenzone invalidates, return false if the frame is outside current segment/level
	--# as first char in marker note means new session
	--. as first char in marker note means end of session
	
--	local markerText = GetMarkerNoteAboveFrame(frame)
	--local i = frame
	--local test = bizstring.startswith(markerText, "#")
	

	
	--local markerFrame = i
	--print(tostring(i))
	
	--if i > frame
	--then print("outside")
	--	return false --frame is outside current segemet
	--e-lse print("inside")
		--return true
	--end
	
	 return true --for now
end

function ResetCurrentWaypoint(frame)

	--Check if user went back and edited a frame. Set new current waypoint according to ungreened frame number
	for k,v in pairs(PointsFrame) do
		if PointsFrame[k] ~= nil 
		then if frame < PointsFrame[k]
			 then PointsFrame[k] = nil 
				  currentWaypoint = currentWaypoint-1
			 end
		end

	end
end

function UnGreen(index)

	local frame = emu.framecount()
	
	if ug > index
	then ug = index
	 	if CheckMarkers(ug)
		then ResetCurrentWaypoint(ug)
		end
		--print("asdasdfdsf")
	end



	--print(tostring(ug))

	
	
	



end
--TODO: Save current waypoint in files instead of PointsFrame[1] twice
function BranchSaved(index)
	
	local file = io.open(movie.filename()..tostring(index)..".ptl", "w+")
	
	file:write(tostring(currentWaypoint.."\n"))
	
	for k,v in pairs(PointsX) do
		file:write(tostring(PointsX[k])..";"..tostring(PointsZ[k])..";"..tostring(PointsFrame[k]).."\n")
	end
	
	file:close()

end

function BranchLoaded(index)
	
	if index ~= -1
	then local backup = io.open(movie.filename().."-1.ptl", "w+")
		 
		 backup:write(tostring(currentWaypoint.."\n"))
	
		 for k,v in pairs(PointsX) do
			backup:write(tostring(PointsX[k])..";"..tostring(PointsZ[k])..";"..tostring(PointsFrame[k]).."\n")
		 end
	end
	
	for k,v in pairs(PointsX) do
		
		PointsX[k] = nil
		PointsZ[k] = nil
		PointsFrame[k] = nil
		totalPoints = totalPoints - 1
	
	end

	local file = io.open(movie.filename()..tostring(index)..".ptl", "r")
	
	if file ~= nil
	then currentWaypoint = tonumber(file:read("*line"))
	
		 for i in file:lines(1) do

			local str = {}
			str = bizstring.split(i, ";")
		
			table.insert(PointsX, totalPoints+1, tonumber(str[1]))
			table.insert(PointsZ, totalPoints+1, tonumber(str[2]))
			table.insert(PointsFrame, totalPoints+1, tonumber(str[3]))

			totalPoints = totalPoints + 1
		 end
		 file:close()
		 if PointsFrame[currentWaypoint] == nil
		 then currentWaypoint = 1
		 end
		 tastudio.setplayback(PointsFrame[currentWaypoint])
	end

end

function BranchRemoved(index)
	
	local br = tastudio.getbranches()
	
	for i = table.getn(br), index , -1 do
	
		--bla = os.rename(movie.filename()..tostring(i+1)..".ptl", movie.filename()..tostring(i)..".ptl.temp")
		--bla2 = os.rename(movie.filename()..tostring(i)..".ptl.temp", movie.filename()..tostring(i)..".ptl")
		--print(i)
		--print(tostring(bla))
		--print(tostring(bla2))
		--num branches 5
		--delete #2
		--new num branches 4
		-- #2 gets #3 filename
		-- #3 gets #4 filename
		-- #4 gets #5 filename
		
	end

end

function Exit()
	
	local file = io.open(movie.filename().."c.ptl", "w+")
	
	file:write(tostring(currentWaypoint.."\n"))
	
	for k,v in pairs(PointsX) do
		file:write(tostring(PointsX[k])..";"..tostring(PointsZ[k])..";"..tostring(PointsFrame[k]).."\n")
	end
	
	file:close()
	
	forms.destroyall()
	
end

tastudio.ongreenzoneinvalidated(UnGreen)
tastudio.onbranchsave(BranchSaved)
tastudio.onbranchload(BranchLoaded)
tastudio.onbranchremove(BranchRemoved)

event.onexit(Exit)

if tastudio.engaged()
then local file = io.open(movie.filename().."c.ptl", "r")
	 if file ~= nil
	 then currentWaypoint = tonumber(file:read("*line"))
	
		  for i in file:lines(1) do

			local str = {}
			str = bizstring.split(i, ";")
		
			table.insert(PointsX, totalPoints+1, tonumber(str[1]))
			table.insert(PointsZ, totalPoints+1, tonumber(str[2]))
			table.insert(PointsFrame, totalPoints+1, tonumber(str[3]))

			totalPoints = totalPoints + 1
		  end
		 file:close()
		 if PointsFrame[currentWaypoint] == nil
		 then currentWaypoint = 1
		 end
		 tastudio.setplayback(PointsFrame[currentWaypoint])
	 end
	


while true do

	f = emu.framecount()
	
	if f > ug
	then ug = f
	end
	
	
	--if f_old ~= f then done = false; end;
	
	
	
	--MarkerControl()
	
	if not client.isturbo()
	then UpdateCanvas()
	end

	if StartFlag and not PauseFlag-- and not done
	then CreateInput()
	end
f_old = f;
	done = true
	
	inget = input.get()
	
	if inget.R == true and wasR == nil
	then Add()
	elseif inget.E == true and wasE == nil
	then Sub()
	end
	
	wasR = inget.R
	wasE = inget.E
	wasP = inget.P

	emu.yield()

end
end

