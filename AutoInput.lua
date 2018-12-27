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
			 -- fs = emu.framecount()
			 ---- if autoUnpause
			  --then client.unpause()
			  --end
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
	local inp_ad = (math.atan2(inpY, inpX) *180/math.pi) % 360
	--print(inp_ad)
	
	--if true-- not (inp_ad == 0 or inp_ad < 26.745225 and inp_ad > 26.565051 or inp_ad == 45 or inp_ad < 90 and inp_ad > 89.548861
	--		or inp_ad == 90 or inp_ad < 116.745225 and inp_ad > 116.565051 or inp_ad == 135 or inp_ad < 180 and inp_ad > 179.552385
	--		or inp_ad == 180 or inp_ad < 206.745225 and inp_ad > 206.565051 or inp_ad == 225 or inp_ad == 270
	--		or inp_ad < 296.745225 and inp_ad > 296.565051)

	if inp_ad == 0 then Xbest = 127; Ybest = 1;
	elseif inp_ad < 26.745225 and inp_ad > 26.565051 then Xbest = 127; Ybest = 64; 
	elseif inp_ad == 45 then Xbest = 126; Ybest = 127;
	elseif inp_ad == 90 then Xbest = -1; Ybest = 127;
	elseif inp_ad < 116.745225 and inp_ad > 116.565051 then Xbest = -64; Ybest = 127;
	elseif inp_ad == 135 then Xbest = -128; Ybest = 127;
	elseif inp_ad == 180 then Xbest = -128; Ybest = -1;
	elseif inp_ad < 206.745225 and inp_ad > 206.565051 then Xbest = -127; Ybest = -64;
	elseif inp_ad == 225 then Xbest = -127; Ybest = -128
	elseif inp_ad == 270 then Xbest = 1; Ybest = -128
	elseif inp_ad < 296.745225 and inp_ad > 296.565051 then Xbest = 64; Ybest = -127
	elseif inp_ad == 315 then Xbest = 127; Ybest = -126	
	else local Points = Bresenham(0,0, inpX*182, inpY*182, "add", inpX, inpY)
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
			--print(tostring(X).."|"..tostring(Y)..":"..tostring((math.atan2(Y,X)*180/math.pi)%360))
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
	local inp_ad = (math.atan2(inpY, inpX) *180/math.pi) % 360

	--if not(inp_ad == 0 or inp_ad == 45 or inp_ad == 90 or inp_ad == 135 or inp_ad == 180 or inp_ad == 225 or inp_ad == 270 or inp_ad == 315)
	
	if inp_ad == 0 then Xbest = 127; Ybest = -1
	elseif inp_ad == 45 then Xbest = 127; Ybest = 126
	elseif inp_ad <63.434988 and inp_ad > 63.254775 then Xbest = 64; Ybest = 127
	elseif inp_ad == 90 then Xbest = 1; Ybest = 127
	elseif inp_ad == 135 then Xbest = -126; Ybest = 127
	elseif inp_ad < 153.434988 and inp_ad > 153.254775 then Xbest = -127; Ybest = 64
	elseif inp_ad == 180 then Xbest = -128; Ybest = 1
	elseif inp_ad < 180.447615 and inp_ad > 180 then Xbest = -128; Ybest = 0
	elseif inp_ad == 225 then Xbest = -128; Ybest = -127
	elseif inp_ad < 243.434988 and inp_ad > 243.254775 then Xbest = -64; Ybest = -127
	elseif inp_ad == 270 then Xbest = -1; Ybest = -128
	elseif inp_ad < 333.434988 and inp_ad > 333.254775 then Xbest = 127; Ybest = -64
	elseif inp_ad == 315 then Xbest = 127; Ybest = -128
	else local Points = Bresenham(0,0, inpX*182, inpY*182, "sub", inpX, inpY)
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
			--print(tostring(X).."|"..tostring(Y)..":"..tostring((math.atan2(Y,X)*180/math.pi)%360))
		 end
	end
	
	tastudio.applyinputchanges()
	
	-- if HasGameRotatingCam == "true"
	-- then FollowAngle = ((math.atan2(Ybest, Xbest) + camera.rotation.y + Offset) % Modulo)*Modulo/2/math.pi % Modulo --TODO:
	-- else FollowAngle = ((math.atan2(Ybest, Xbest) + Offset) % Modulo)*Modulo/2/math.pi % Modulo
	-- end 

	
	fromAddSub = true

end;

function SetIgnoreFrames()

	if tastudio.engaged()
	then local sel = tastudio.getselection()
		 for i in pairs(sel) do
			 ignoreFrames[sel[i]] = 1
		 end
	end

end

function UnsetIgnoreFrames()

	if tastudio.engaged()
	then local sel = tastudio.getselection()
		 for i in pairs(sel) do
			 ignoreFrames[sel[i]] = nil
		 end
	end

end

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

	local zx = mouseX
	local zy = mouseY
	
	if mouseY > 800 --hacky support for checking if clicked on status-strip item
	then zx = 400
		 zy = 400
	end
	
	
	if Zoom <= 100
	then local vx = xFollow+(zx-xDrawOffset)/Zoom
		 local vy = yFollow+(zy-yDrawOffset)/Zoom

		 Zoom = Zoom*1.05
	
		 xDrawOffset = xDrawOffset -(vx - (xFollow+(zx-xDrawOffset)/Zoom))*Zoom
		 yDrawOffset = yDrawOffset -(vy - (yFollow+(zy-yDrawOffset)/Zoom))*Zoom
	end

end

function ZoomOut()
	
	local zx = mouseX
	local zy = mouseY
	
	if mouseY > 800
	then zx = 400
		 zy = 400
	end

	if Zoom >= 0.005
	then local vx = xFollow+(zx-xDrawOffset)/Zoom
		 local vy = yFollow+(zy-yDrawOffset)/Zoom

		 
		 
		 Zoom = Zoom*0.95
	
		 xDrawOffset = xDrawOffset -(vx - (xFollow+(zx-xDrawOffset)/Zoom))*Zoom
		 yDrawOffset = yDrawOffset -(vy - (yFollow+(zy-yDrawOffset)/Zoom))*Zoom
	end
	
end

function ResetZoom()

	Zoom = 1
	
end

function ToggleFollow()

	if follow == "none"
	then follow = "player"
		 xDrawOffset = 400
		 yDrawOffset = 400
		 statusStripItems.toggleFollowItem.image = "ToggleFollowPlayerON.PNG"
	elseif follow == "player"
		then follow = "none"
			 xFollow = 0
			 yFollow = 0
			 statusStripItems.toggleFollowItem.image = "ToggleFollowPlayerOFF.PNG"
	end
	
end

function ToggleMapDisplay()

	if drawMap == "yes"
	then drawMap = "no"
		 statusStripItems.toggleMapDisplayItem.image = "ViewMapOFF.PNG"
	elseif drawMap == "no"
		then drawMap = "auto"
			 statusStripItems.toggleMapDisplayItem.image = "ViewMapAUTO.PNG"
		elseif drawMap == "auto"
			then drawMap = "yes"
				 statusStripItems.toggleMapDisplayItem.image = "ViewMapON.PNG"
	end

end

function ViewPlayer()

	xDrawOffset = (xFollow-player.position.x)*Zoom +400
	yDrawOffset = (yFollow-player.position.z)*Zoom +400

end

function ViewPreviousWaypoint()

	

end

function ViewCurrentWaypoint()

	

end

function ViewNextWaypoint()

	

end

function CancelAppendingWaypoint()

	appendWayPointFormActive = false
	forms.destroy(AWform)

end

function OkAppendingWaypoint()
	--TODO: Check if actual numbers are typed in
	if totalPoints == 0
	then table.insert(PointsX, totalPoints+1, (player.position.x)) --First point must be current player position
		 table.insert(PointsZ, totalPoints+1, (player.position.z))
		 table.insert(PointsFrame, totalPoints+1, emu.framecount()) -- save the frame to jump back when the user edits
		 totalPoints = totalPoints + 1
	end
	
	table.insert(PointsX, totalPoints+1, tonumber(forms.gettext(AWxTxt)))
	table.insert(PointsZ, totalPoints+1, tonumber(forms.gettext(AWzTxt)))
	table.insert(PointsFrame, totalPoints+1, nil)
			  
	totalPoints = totalPoints + 1
	
	appendWayPointFormActive = false
	forms.destroy(AWform)

end

function AppendWaypointForm()
	
	if not appendWayPointFormActive 
	then appendWayPointFormActive = true
		 AWform = forms.newform(175, 130, "Add Waypoint", CancelAppendingWaypoint)
		 local x = 0
		 local z = 0
		
		 forms.label(AWform, "x =", 5, 10, 25, 20)
		 AWxTxt = forms.textbox(AWform, tostring(x), 120, 23, nil, 30, 5)
		 forms.label(AWform, "z =", 5, 35, 25, 20)
		 AWzTxt = forms.textbox(AWform, tostring(z), 120, 23, nil, 30, 30)
		
		 forms.button(AWform, "Cancel", CancelAppendingWaypoint,5, 60)
		 forms.button(AWform, "OK", OkAppendingWaypoint, 80, 60)
	end
end

function CancelEditingWaypoint()

	setWaypointFormActive = false
	forms.destroy(EWform)

end

function OkEditingWaypoint()

	PointsX[editPt] = tonumber(forms.gettext(EWxTxt))
	PointsZ[editPt] = tonumber(forms.gettext(EWzTxt))
	
	for i = editPt, totalPoints, 1 do
		PointsFrame[i] = nil
	end

	setWaypointFormActive = false
	forms.destroy(EWform)

end

function EditWaypointForm()

	if not setWaypointFormActive and selectedPoint > 1
	then setWaypointFormActive = true
		 EWform = forms.newform(175, 130, "Edit Waypoint")
		 
		 editPt = selectedPoint
		 
		 forms.label(EWform, "x =", 5, 10, 25, 20)
		 EWxTxt = forms.textbox(EWform, tostring(PointsX[selectedPoint]), 120, 23, nil, 30, 5)
		 forms.label(EWform, "z =", 5, 35, 25, 20)
		 EWzTxt = forms.textbox(EWform, tostring(PointsZ[selectedPoint]), 120, 23, nil, 30, 30)
		
		 forms.button(EWform, "Cancel", CancelEditingWaypoint,5, 60)
		 forms.button(EWform, "OK", OkEditingWaypoint, 80, 60)
		 
	end

end

function SplitPathRCM()

	SplitPath(selectedPoint)

end

function DeleteWaypointRCM()

	DeleteWayPoint(selectedPoint)

end

function DeleteAllWaypoints()

	DeleteWayPoint(1)
	
end

--Removes the automatically set buttons from movie, but doesn't remove it from the list
function DeleteButtons(index)

	for k,v in pairs(IndexToInsert) do
		if IndexToInsert[k] >= index - 1 and InsertionFrame[k] ~= nil
		then for i = 1, AmountToInsert[k], 1 do
				tastudio.submitinputchange(InsertionFrame[k]+(i-1), ButtonToInsert[k], false)
			 end
			 tastudio.applyinputchanges()
			 InsertionFrame[k] = nil
		end
	 end

end

--Removes everything from the Button list and removes set buttons from movie
function DeleteAllButtonsFromList()

		DeleteButtons(1)
		
		--choose between deleting only waypoints/only buttons or both
		 for k,v in pairs(IndexToInsert) do
		 
			IndexToInsert[k] = nil
			LambdaToInsert[k] = nil
			ButtonToInsert[k] = nil
			AmountToInsert[k] = nil
			InsertionFrame[k] = nil
			
		 end

end


function DeleteEverything()

	DeleteAllWaypoints()
	DeleteAllButtonsFromList()

end


function OkInsertingButton()

	local pt = tonumber(forms.gettext(LineLabel))
	--table.insert(IndexToInsert, tonumber(forms.gettext(IndexText)))
	--table.insert(LambdaToInsert, tonumber(forms.gettext(LambdaText)))
	table.insert(IndexToInsert, tonumber(forms.gettext(LineLabel)))
	table.insert(LambdaToInsert, tonumber(forms.gettext(LambdaLabel)))
	table.insert(ButtonToInsert, tostring(forms.gettext(ButtonText)))
	table.insert(AmountToInsert, tonumber(forms.gettext(AmountText)))
	table.insert(InsertionFrame, nil)
	
	insertButtonFormActive = false
	forms.destroy(IBForm)
	

	print(pt)
	if pt < currentWaypoint
	then currentWaypoint = pt
		 tastudio.setplayback(PointsFrame[currentWaypoint])
		 ug = PointsFrame[currentWaypoint]
	end

end

function CancelInsertingButton()

	insertButtonFormActive = false
	forms.destroy(IBForm)

end

function InsertButtonForm()
	
	if not insertButtonFormActive
	then insertButtonFormActive = true
		 IBForm = forms.newform(180, 170, "Insert Button", CancelInsertingButton)
		 
		 forms.label(IBForm, "Line:", 5, 5, 40, 20)
		 LineLabel = forms.label(IBForm, tostring(selectedLine), 45, 5, 100, 20)
		 
		 forms.label(IBForm, "lambda:", 5, 30 , 40, 20)
		 LambdaLabel = forms.label(IBForm, tostring(lambdaOnLine), 45, 30, 100, 20)
		 
		 forms.label(IBForm, "Button:", 5, 55, 41, 20) 
		 ButtonText = forms.textbox(IBForm, "", 50, 20, nil, 52, 50)
		 
		 forms.label(IBForm, "Amount:", 5, 80, 46, 20)
		 AmountText =  forms.textbox(IBForm, "", 50, 20, nil, 52, 75)
		 
		 forms.button(IBForm, "OK", OkInsertingButton, 5, 100)
		 forms.button(IBForm, "Cancel", CancelInsertingButton, 80, 100)
	end
	
end

function InsertMacro(v)

	print(tostring(v))
	
	local pt = selectedLine
	
	table.insert(IndexToInsert, pt)
	table.insert(LambdaToInsert, lambdaOnLine)
	table.insert(ButtonToInsert, MacroList.Button[v])
	table.insert(AmountToInsert, MacroList.Amount[v])
	table.insert(InsertionFrame, nil)
	
	if pt < currentWaypoint
	then currentWaypoint = pt
		 tastudio.setplayback(PointsFrame[currentWaypoint])
		 ug = PointsFrame[currentWaypoint]
	end

end


function testfunc()
	xFollow = -900
	yFollow = 1800
end

-- This function creates the main window.
function WindowForm()

	local OptTable = {"1: Low", "2: Medium", "3: High"}--}
	
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
	
	forms.button(Window, "test",testfunc, 5, 330)
	
	

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
ignoreFrames = {}


--Canvas

Canvas = gui.createcanvas(800,820)

xDrawOffset = 400
yDrawOffset = 400
xFollow = 0
yFollow = 0
zooming = false

CPoints = {X, Z} --TODO
PointsX = {}
PointsZ = {}
PointsFrame = {}

--TODO: Make better table, use T[waypointindex][number] = {lambda, button,...}

IndexToInsert = {}
LambdaToInsert = {}
ButtonToInsert = {}
AmountToInsert = {}
InsertionFrame = {}

totalPoints = 0
selected = false
ind = nil
mouseMoved = false
CanvasMode = "view"
Zoom = 1
dmx = 0
dmy = 0
currentWaypoint = 1
UseCanv = false
followPlayer = true
follow = "none"
drawMap = "yes"

selectedLine = nil
selectedPoint = nil
selectedButton = nil --TODO: Better name

clickedButton = nil
clickedPoint = nil

statusStripItems = {toggleFollowItem = {x = 1, toolTip = "Toggle Follow Player", clickFunction = ToggleFollow, singleclick = true, image = "ToggleFollowPlayerOFF.PNG"},
					viewPlayerItem = {x = 21, toolTip = "Reset View to Player", clickFunction = ViewPlayer, singleclick = true, image = "ResetViewToPlayer.PNG"}, 
					viewPreviousWaypointItem = {x = 41, toolTip = "Set View previous Waypoint", clickFunction = ViewPreviousWaypoint, singleclick = true, image = "SetViewToPreviousWaypoint.PNG"}, 
					viewCurrentWaypointItem = {x = 61, toolTip = "Set View current Waypoint", clickFunction = ViewCurrentWaypoint, singleclick = true, image = "SetViewToCurrentWaypoint.PNG"}, 
					viewNextWaypointItem = {x = 81, toolTip = "Set View next Waypoint", clickFunction = ViewNextWaypoint, singleclick = true, image = "SetViewToNextWaypoint.PNG"}, 
					zoomInItem = {x = 101, toolTip = "Zoom In", clickFunction = ZoomIn, singleclick = false, image = "ZoomIn.PNG"}, 
					zoomOutItem = {x = 121, toolTip = "Zoom Out", clickFunction = ZoomOut, singleclick = false, image = "ZoomOut.PNG"}, 
					resetZoomItem = {x = 141, toolTip = "Reset Zoom", clickFunction = ResetZoom, singleclick = true, image = "ResetZoom.PNG"},
					toggleMapDisplayItem = {x = 161, toolTip = "Toggle Map Display", clickFunction = ToggleMapDisplay, singleclick = true, image = "ViewMapON.PNG"}
				   }

rightClickItems = {editMode = {mouseOverPoint = {setPosition = {y = 0, text = "Set new position", clickFunction = EditWaypointForm}, 
												 splitPath = {y = 15, text = "Split Path", clickFunction = SplitPathRCM},
												 deleteWaypoint = {y = 30, text = "Delete waypoint", clickFunction = DeleteWaypointRCM}
												},
							   notOverPoint = {addWaypoint = {y = 0, text = "Add new waypoint", clickFunction = AppendWaypointForm},
											   deleteAllWaypoints = {y = 15, text = "Delete all waypoints", clickFunction = DeleteAllWaypoints},
											   deleteAllButtons = {y = 30, text = "Delete all buttons", clickFunction = DeleteAllButtonsFromList},
											   deleteEverything = {y = 45, text = "Delete everything", clickFunction = DeleteEverything}
											  },
							   mouseOverLine = {_insertMacro = {y = 0, text = "Insert Macro >", submenu = {} },
															   
												insertButton = {y = 15, text = "Insert button", clickFunction = InsertButtonForm},				
											   },				   
							   mouseOverObject = {goToObject = {y = 0, text = "Go to object", clickFunction = nil}
												 }
							  }

				  }
				  
MacroList = { Name = {}, Text = {}, Button = {}, Amount = {} }


MacroFile = io.open(gameinfo.getromname()..".mcl", "r")

if MacroFile ~= nil
then 
	print("MAcro file found")
	for i in MacroFile:lines(1) do
		 
		 local str = {}
		 
		 str = bizstring.split(i, ";")
		 
		 table.insert(MacroList.Name, tostring(str[1]))
		 table.insert(MacroList.Text, tostring(str[2]))
		 table.insert(MacroList.Button, tostring(str[3]))
		 table.insert(MacroList.Amount, tonumber(str[4]))
		 
	 end
	 local i = 0
	 for k,v in pairs(MacroList.Name) do
		
		local t = {y = i*15, text = MacroList.Text[k], clickFunction = InsertMacro}
		
		table.insert(rightClickItems.editMode.mouseOverLine._insertMacro.submenu, t) --TODO: insert the table by name and not by index
		--table.insert(rightClickItems.editMode.mouseOverLine._insertMacro.submenu.t.y,  i*15)
		--table.insert(rightClickItems.editMode.mouseOverLine._insertMacro.submenu.t.text, v)
		--table.insert(rightClickItems.editMode.mouseOverLine._insertMacro.submenu.k.clickFunction, nil)
		
		
	  i = i+1
	 end
	 
end

for k,v in pairs(rightClickItems.editMode.mouseOverLine._insertMacro.submenu) do

	print(tostring(k))
			  
end			  
RCListWidth = 150
RCListHeight = 50
--Canvas end

askSave = ""
StartFlag = false
PauseFlag = false
X = 0; Y = 0
FollowAngle = 0
InputAngle = 0
Radius = 0

f=0
f_old=0
ug = 0
autoUnpause = false

firstStep = true

appendWayPointFormActive = false
insertButtonFormActive = false
setWaypointFormActive = false

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

function LineDrawing(angle)
	
	
	local Points = Bresenham(0,0, math.cos(angle)*182, math.sin(angle)*182, nil, nil, nil)
	
	local bestDist = 9999999999
	
	local newPoint = { X, Y }
	
	for i, pt in pairs(Points) do
		newDist = math.abs(math.atan2(pt.Y, pt.X) - angle)
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
	
	local Steps = 0
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
	then lambdax = (player.position.x - PointsX[currentWaypoint])/(PointsX[currentWaypoint+1]-PointsX[currentWaypoint])
		 lambdaz = (player.position.z - PointsZ[currentWaypoint])/(PointsZ[currentWaypoint+1]-PointsZ[currentWaypoint])
		 
		 local l = ((player.position.x-PointsX[currentWaypoint])*(PointsX[currentWaypoint+1]-PointsX[currentWaypoint])+
					 (player.position.z-PointsZ[currentWaypoint])*(PointsZ[currentWaypoint+1]-PointsZ[currentWaypoint]))/
					 ((PointsX[currentWaypoint+1]-PointsX[currentWaypoint])^2+
								(PointsZ[currentWaypoint+1]-PointsZ[currentWaypoint])^2)
					

		 local p_x = PointsX[currentWaypoint] + l*(PointsX[currentWaypoint+1]-PointsX[currentWaypoint])
		 local p_z = PointsZ[currentWaypoint] + l*(PointsZ[currentWaypoint+1]-PointsZ[currentWaypoint])
		 
		 local d = math.sqrt((player.position.x-p_x)^2+(player.position.z-p_z)^2)
		 
		-- print(tostring(l).."; "..tostring(d))
		 
		 
		 --TODO: This is broken
		 if (lambdax >= 1 and lambdaz >= 0.9) or (lambdax >= 0.9 and lambdaz >= 1)-- Check if current waypoint has been reached. Set frame number for current one and set next waypoint as destination goal
		 then currentWaypoint = currentWaypoint + 1
			  --print("tp:"..totalPoints.."\ncwp:"..currentWaypoint)
			  PointsFrame[currentWaypoint] = emu.framecount()  
		 end
		 --print("lx:"..tostring(lambdax)..";lz:"..tostring(lambdaz))
		 if currentWaypoint < totalPoints
		 then FollowAngle = CalcAngle(player.position.x, player.position.z, PointsX[currentWaypoint+1], PointsZ[currentWaypoint+1])
		 end
		 --TODO: move down
		 
	else
	end
	

	
	if ignoreFrames[emu.framecount()] == nil
	then 
		 if Optimisation == "1: Low" 
		 then if HasGameRotatingCam == "true"
			 then InputAngle = ((FollowAngle - camera.rotation.y - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
			 else InputAngle = ((FollowAngle - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
			 end
			 Point = LineDrawing(InputAngle)
			 if emu.framecount() >= ug
			 then if emu.islagged()
				 then tastudio.submitanalogchange(emu.framecount(), "P1 X Axis", Point.X)
					  tastudio.submitanalogchange(emu.framecount(), "P1 Y Axis", Point.Y)
					 
					 --Button Insertion
					  for k,v in pairs(IndexToInsert) do
							--print("JKLLJJ")
						  if IndexToInsert[k] == currentWaypoint
						  then if (lambdax >= LambdaToInsert[k] and lambdaz >= LambdaToInsert[k] and InsertionFrame[k] == nil)
							   then for i = 1, AmountToInsert[k], 1 do
									tastudio.submitinputchange(emu.framecount()+(i-1), ButtonToInsert[k], true)
									--print("ASDFDSAFSDF")
									end
									InsertionFrame[k] = emu.framecount()
							   end
				  
						  end
					  end
				 else tastudio.submitanalogchange(emu.framecount(), "P1 X Axis", 0)
					  tastudio.submitanalogchange(emu.framecount(), "P1 Y Axis", 0)
				 end
				 
			 end
		 tastudio.applyinputchanges()
		 elseif Optimisation == "2: Medium" --TODO: This should check angle error and adjust accordingly
			 then fs = emu.framecount()
				 if firstStep == true 
				 then if HasGameRotatingCam == "true"
					 then InputAngle = ((FollowAngle - camera.rotation.y - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
					 else InputAngle = ((FollowAngle - settings.angle.offset) % settings.angle.modulo)*math.pi/(settings.angle.modulo/2);
					 end
					 
					 Point = LineDrawing(InputAngle)
					 print("1st i:"..InputAngle.." X: ".. Point.X.." Y:"..Point.Y)
					 if emu.framecount() >= ug
					 then 
						 if emu.islagged()
						 then tastudio.submitanalogchange(fs, "P1 X Axis", Point.X)
								 tastudio.submitanalogchange(fs, "P1 Y Axis", Point.Y)
						 else tastudio.submitanalogchange(fs, "P1 X Axis", 0)
								 tastudio.submitanalogchange(fs, "P1 Y Axis", 0)
						 end
					 end
					 tastudio.applyinputchanges()
					 
					 fn = fs
					 --repeat 
						 fn = fn + 2
					 --until not tastudio.islag(fn) or tastudio.islag(fn) == nil
					 tastudio.setplayback(fn)
					 firstStep = false
					 
					 end
				if firstStep == false
					 then 
					 
					 if emu.framecount() == fn
					 then 	 MovAngle = memory.readfloat(MovAngAddr, true)
							mov = (MovAngle) % (settings.angle.modulo)*math.pi/(settings.angle.modulo/2)
							fol = (FollowAngle) % (settings.angle.modulo)*math.pi/(settings.angle.modulo/2)
							 print("2nd mov:"..mov)
							 print("2nd fol:"..fol)
							 
							 err = (fol-mov)%2*math.pi
							 print("2nd e:"..err)
							 if err ~= 0
							 then 
							-- 
							 InputAngle = (InputAngle - err)
							 
					 
							 Point = LineDrawing(InputAngle)
							 print("2nd i:"..InputAngle.." X: ".. Point.X.." Y:"..Point.Y)
							 
							 --tastudio.setplayback(fs)
							 if true --emu.framecount() >= ug
							 then --fs = emu.framecount()
								 if emu.islagged()
								 then tastudio.submitanalogchange(fs, "P1 X Axis", Point.X)
									 tastudio.submitanalogchange(fs, "P1 Y Axis", Point.Y)
								 else tastudio.submitanalogchange(fs, "P1 X Axis", 0)
									 tastudio.submitanalogchange(fs, "P1 Y Axis", 0)
								 end
							 end
							  
							 tastudio.applyinputchanges()
							 
							 end
							 fs = fn 
							 firstStep = true
							 
							 tastudio.setplayback(fn)
	 end
				 end
		 elseif Optimisation == "3: High" 
			 then 
		 end
		  
		 
		 
	end
	
end





------------------------------
--Waypoint Editing Functions--
------------------------------
--Adds a new waypoint continuing from the last one.
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

--Deletes one or all waypoints.
function DeleteWayPoint(index)
	
	--TODO: fix bug. if deleted waypoint doesn't have PointsFrame movie won't be rewind.
	
	if PointsFrame[index-1] ~= nil
	then if currentWaypoint > index-1
		 then tastudio.setplayback(PointsFrame[index-1])
			  currentWaypoint = index-1
			  ug = PointsFrame[index-1]		  
		 end
	elseif currentWaypoint > index-1
		then tastudio.setplayback(PointsFrame[1])
			 currentWaypoint = 1
			 ug = PointsFrame[1]
	end
	
	for i = index, totalPoints, 1 do 
			PointsFrame[i] = nil
	end
	
	DeleteButtons(index)

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

--Splits the path between two waypoints in the middle. A new waypoint is added.
function SplitPath(index)
	--TODO: insert the new point to the yellow colored line segment (inserting at index crashes the script )
	table.insert(PointsX, index+1, (PointsX[index]+(PointsX[index+1]-PointsX[index])/2))
	table.insert(PointsZ, index+1, (PointsZ[index]+(PointsZ[index+1]-PointsZ[index])/2))
	table.insert(PointsFrame, index+1, nil)
	totalPoints = totalPoints + 1
	

	
	if PointsFrame[index] ~= nil
	then if currentWaypoint > index
		 then tastudio.setplayback(PointsFrame[index])
			  currentWaypoint = index
			  ug = PointsFrame[index]
		 end
	elseif currentWaypoint > index
	    then tastudio.setplayback(PointsFrame[1])
			 currentWaypoint = 1
			 ug = PointsFrame[1]
	end
	
	for i = index, totalPoints, 1 do 
		PointsFrame[i] = nil
	end
	
	--TODO: Readjust button insertion
	DeleteButtons(index)
end

----------------------------
--Canvas Drawing Functions--
----------------------------
--Draws and arrow from (x1, y1) to (x2, y2) with the corresponding color on the canvas
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

--Draws the player on the canvas.
function DrawPlayer(x, y, radius)

	--Player coordinate lines
	Canvas.DrawLine(xDrawOffset-(xFollow-player.position.x)*Zoom, 0, xDrawOffset-(xFollow-player.position.x)*Zoom, 800, 0x55FF0000)
	Canvas.DrawLine(0, yDrawOffset-(yFollow-player.position.z)*Zoom, 800, yDrawOffset-(yFollow-player.position.z)*Zoom, 0x55FF0000)

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
	
	
	
	Canvas.DrawText(xDrawOffset-(xFollow-player.position.x)*Zoom+1, 785, player.position.x)
	Canvas.DrawText(0, yDrawOffset-(yFollow-player.position.z)*Zoom+1, player.position.z)
	
	
	
 end

 --Draws the camera on the canvas.
function DrawCamera()

	if camera.position.x ~= nil and camera.position.z ~= nil
	then if camera.position.target.x ~= nil and camera.position.target.z ~= nil
		 then local dx = xFollow-camera.position.target.x
			  local dz = yFollow-camera.position.target.z
		 
			  Canvas.DrawAxis(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 5, 0xFF008888)
							  
			  DrawArrow(xDrawOffset-(xFollow-camera.position.x)*Zoom,
						yDrawOffset-(yFollow-camera.position.z)*Zoom, 
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

--Draws objects on the canvas.
function DrawObject()	
	local mouseOverObject = false
	local rx = nil
	local ry = nil
	local rz = nil
	
	for k in pairs(objects) do
		if objects[k].active ~= nil
		then local dx = xFollow - objects[k].position.x
			 local dz = yFollow - objects[k].position.z
			 
			 
		
			 if math.sqrt((xDrawOffset-dx*Zoom-mouseX)^2+(yDrawOffset-dz*Zoom-mouseY)^2) >= 5
			 then Canvas.DrawEllipse(xDrawOffset-(dx+objects[k].collision.radius)*Zoom, yDrawOffset-(dz+objects[k].collision.radius)*Zoom,
									 2*objects[k].collision.radius*Zoom, 2*objects[k].collision.radius*Zoom, 0xFF005500, 0x5500FF00)
				  Canvas.DrawAxis(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 5, 0x5500FF00)		 
			 else Canvas.DrawEllipse(xDrawOffset-(dx+objects[k].collision.radius)*Zoom, yDrawOffset-(dz+objects[k].collision.radius)*Zoom,
									 2*objects[k].collision.radius*Zoom, 2*objects[k].collision.radius*Zoom, 0xFF00AA00, 0x5500FF00)
				 Canvas.DrawAxis(xDrawOffset-dx*Zoom, yDrawOffset-dz*Zoom, 5, 0x5500FF00)
			
				 Canvas.DrawText(xDrawOffset-dx*Zoom+16, yDrawOffset-dz*Zoom+16, 
								 "Position:\n	X:"..tostring(objects[k].position.x).."\n	Y:"..tostring(objects[k].position.y).."\n	Z:"..tostring(objects[k].position.z),
								 0xFF000000, 0xEEDDDDDD)
				 mouseOverObject = true
				 rx = objects[k].position.x
				 ry = objects[k].position.y
				 rz = objects[k].position.z
				-- Canvas.DrawText(0, 140, tostring(rx)..";"..tostring(rz))
			 end
		end
	end
	
	return mouseOverObject, rx, ry, rz

end

function ShouldMapBeDisplayed()

	if drawMap == "yes"
	then return true
	elseif drawMap == "no"
		then return false
	elseif drawMap == "auto"
		then if client.ispaused()
			 then return true
			 else return false
			 end
	else return false
	end

end

--Draws level maps on the canvas.
function DrawMap()

	for k in pairs(maps) do

		local x = maps[k].position.x
		local y = maps[k].position.y
		local z = maps[k].position.z
		
		for l in pairs(maps[k].polygons) do
		
			local _dx1 = xDrawOffset-(xFollow-(x+maps[k].polygons[l].dx1))*Zoom
			local _y1 = y+maps[k].polygons[l].dy1
			local _dz1 = yDrawOffset-(yFollow-(z+maps[k].polygons[l].dz1))*Zoom
			
			local _dx2 = xDrawOffset-(xFollow-(x+maps[k].polygons[l].dx2))*Zoom
			local _y2 = y+maps[k].polygons[l].dy2
			local _dz2 = yDrawOffset-(yFollow-(z+maps[k].polygons[l].dz2))*Zoom
			
			local _dx3 = xDrawOffset-(xFollow-(x+maps[k].polygons[l].dx3))*Zoom
			local _y3 = y+maps[k].polygons[l].dy3
			local _dz3 = yDrawOffset-(yFollow-(z+maps[k].polygons[l].dz3))*Zoom
			
			local _mx = xDrawOffset-(xFollow-maps[k].polygons[l].mx)*Zoom
			local _mz = yDrawOffset-(yFollow-maps[k].polygons[l].mz)*Zoom
			
			local color = maps[k].polygons[l].color
			
			--if (_dx1 > 0 and _dx1 < 800) or (_dz1 > 0 and _dz1 < 800) or (_dx2 > 0 and _dx2 < 800) or (_dz2 > 0 and _dz2 < 800) or (_dx3 > 0 and _dx3 < 800) or (_dz3 > 0 and _dz3 < 800)
			--then
			
			--end
			
			--if _mx > 0 and _mx < 800 and _mz > 0 and _mz < 800
			--then Canvas.DrawAxis(_mx, _mz, 2, 0xFF005555)
			--end
			
			--x_ = dx2 x= dx1
			
			Canvas.DrawPolygon({{_dx1, _dz1},{_dx2, _dz2},{_dx3, _dz3}}, 0xFF444444, maps[k].polygons[l].color)
			
			--local a = ((_dz2 - _dz3)*(mouseX - _dx3) + (_dx3 - _dx2)*(mouseY - _dz3)) / ((_dz2 - _dz3)*(_dx1 - _dx3) + (_dx3 - _dx2)*(_dz1 - _dz3))
			--local b = ((_dz3 - _dz1)*(mouseX - _dx3) + (_dx1 - _dx3)*(mouseY - _dz3)) / ((_dz2 - _dz3)*(_dx1 - _dx3) + (_dx3 - _dx2)*(_dz1 - _dz3))
			--local c = 1 - a - b
			
			--if (a >= 0 and a <= 1) and (b >= 0 and b <= 1) and (c >= 0 and c <= 1)
			--then Canvas.DrawPolygon({{_dx1, _dz1},{_dx2, _dz2},{_dx3, _dz3}}, 0xFF444444, 0x44005555)
					--TODO: Display height
				 --Canvas.DrawText(mouseX, mouseY, tostring(_y1))
			
			--else 
			--end
		end
	end

end

--Draws the waypoints on the canvas and handles editing them. Return value is the selected waypoint.
function DrawWaypoints()
	
	if not fireRCM
	then mouseOverLine = false
		 selectedLine = nil
		 lambdaOnLine = nil
		 
		 mouseOverPoint = false
		 selectedPoint = nil
	end
	selected = false
	
	
		for k,v in pairs(PointsX) do
	
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
			then local x_ = (xDrawOffset-(xFollow-PointsX[k-1])*Zoom)
				 local z_ = (yDrawOffset-(yFollow-PointsZ[k-1])*Zoom)
			
				 DrawArrow(x_, z_, x, z, 0xFF000000)

				 l = -(((x_-mouseX)*(x-x_)+(z_-mouseY)*(z-z_))/((x-x_)^2+(z-z_)^2))
				 
				 local p_x = x_ + l*(x-x_)
				 local p_z = z_ + l*(z-z_)
				 
				 if math.sqrt((p_x-mouseX)^2+(p_z-mouseY)^2) < 3 and l < 1 and l > 0 and not mouseOverLine and not mouseOverPoint and not mouseOverButton
				 then Canvas.DrawAxis(p_x, p_z, 10, 0xFFFF0000)	
					  DrawArrow(x_, z_, x, z, 0xFFFF00FF)
					  mouseOverLine = true
					  selectedLine = k - 1 
					  lambdaOnLine = l
				 elseif not mouseOverLine
					 then mouseOverLine = false
						  selectedLine = nil
						  lambdaOnLine = nil
				 end
				--Canvas.DrawText(0,500+14*k, tostring(mouseOverLine)..", "..tostring(selectedLine)..", "..tostring(lambdaOnLine))
			end
			
			
			
			if math.sqrt((x-mouseX)^2+(z-mouseY)^2) < 5 and not mouseOverPoint and not mouseOverLine and not mouseOverButton
			then selected = true
				-- Canvas.DrawText(0, 500, "ASSDAFSDF")
				 mouseOverPoint = true
				 selectedPoint = k
				 
				 local angle = 0
				 if PointsX[k-1] ~= nil 
				 then angle = math.atan2(-(PointsZ[k]-PointsZ[k-1]),(PointsX[k]-PointsX[k-1])) * (180/math.pi)
				 end
				 
				 Canvas.DrawText(x+16, z+16, ""..k.."\n"..PointsX[k].."\n"..PointsZ[k].."\n"..tostring(PointsFrame[k]).."\n"..tostring(angle))
				 Canvas.DrawEllipse(x-5, z-5, 10, 10, 0xFF000000, 0xFFFFFF00)
				 
				 if k > 1
				 then DrawArrow((xDrawOffset-(xFollow-PointsX[k-1])*Zoom), (yDrawOffset-(yFollow-PointsZ[k-1])*Zoom), x, z, 0xFFFFFF00)
				 end
				 
				 if CanvasMode == "edit"
				 then if mouseButt["Left"] and k > 1 and clickedPoint == nil and clickedButton == nil
					  then clickedPoint = selectedPoint
							--TODO: move this ***
						   if PointsFrame[k-1] ~= nil
						   then if currentWaypoint > k-2
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
						   --
					  elseif not mouseButt["Left"] 
						  then clickedPoint = nil
								if autoUnpause --and selected
								then --client.unpause()
								end
					  end
					  
					  
					  if mouseButt["Right"]
					  then --DeleteWayPoint(k)
					  elseif mouseButt["Middle"] and k > 0 and k < totalPoints and not wasMouseButtM
					  then SplitPath(k)   
					  end
					  
					  
				 elseif CanvasMode == "view"
					 then if mouseButt["Left"]
						  then if PointsFrame[k] ~= nil
							   then tastudio.setplayback(PointsFrame[k])
								    currentWaypoint = k
							   end
						  end
					  
				 end
			elseif not mouseOverPoint 
				then mouseOverPoint = false
					 selectedPoint = nil
			else

			end
		--Canvas.DrawText(500, 100+14*k, tostring(mouseOverPoint)..", "..tostring(selectedPoint))
			--Canvas.DrawText(x, z+36, tostring(Pselection[k]).."\n"..tostring(ind))
			--Canvas.DrawText(500, 300+14*k, tostring(clickedPoint))
		end
		
		
		
	end

	--Canvas.DrawText(500, 100+14, tostring(mouseOverPoint)..", "..tostring(selectedPoint)..", "..tostring(clickedPoint))
	--moving the selected point
	if clickedPoint ~= nil and clickedButton == nil--and not mouseButt["Right"]-- and Pselection[ind]
	then 
	
		 local dmx = mouseX - oldMouseX
		 local dmy = mouseY - oldMouseY
		 
		 PointsX[clickedPoint] = PointsX[clickedPoint] + dmx/Zoom --TODO: Left+Right mouse click bug
		 PointsZ[clickedPoint] = PointsZ[clickedPoint] + dmy/Zoom
		 
		 if math.abs(dmx) > 0 or math.abs(dmx) > 0 --TODO:Only run this once
		 then for i = clickedPoint, totalPoints, 1 do
					PointsFrame[i] = nil
			  end
			  --*** here
			  --deleting button presses
			  DeleteButtons(clickedPoint)
			  
		 end
		 selected = true
		 client.pause()
	else selected = false
	end

	
	if not mouseButt["Left"]
	then clickedPoint = nil
	end
	
	return selected
	
end

function DrawButtons()
	
	if not fireRCM
	then mouseOverButton = false
		 selectedButton = nil
	end
	
	for k,v in pairs(IndexToInsert) do
	
		local i = IndexToInsert[k]
		
		if PointsX[i] ~= nil and PointsX[i+1] ~= nil
		then local l = LambdaToInsert[k]
		
			 local x = xDrawOffset-(xFollow-(PointsX[i] + l*(PointsX[i+1]-PointsX[i])))*Zoom
			 local z = yDrawOffset-(yFollow-(PointsZ[i] + l*(PointsZ[i+1]-PointsZ[i])))*Zoom
		 
			 Canvas.DrawEllipse(x-3, z-3, 6, 6,  0xFF000000, 0xFFFF0000)
		
			 if math.sqrt((x-mouseX)^2+(z-mouseY)^2) < 3 and not mouseOverButton
			 then Canvas.DrawEllipse(x-3, z-3, 6, 6,  0xFF000000, 0xFFFFFF00)
				  mouseOverButton = true
				  selectedButton = k
					
				  Canvas.DrawText(x+16, z+16, "i: "..tostring(i).."\nl: "..tostring(l)..
				  "\nb: "..tostring(ButtonToInsert[k])..", "..tostring(AmountToInsert[k]).."\nf: "..tostring(InsertionFrame[k]))
					
					
				  if CanvasMode == "edit"
				  then if mouseButt["Left"] and clickedButton == nil and clickedPoint == nil
					   then clickedButton = selectedButton

					
					
					
					   elseif not mouseButt["Left"]
						   then clickedButton = nil
					   end 
				  end
			 
			 elseif not mouseOverButton
				then mouseOverButton = false
					 selectedButton = nil
			 end
		end
	end
	
	if clickedButton ~= nil and clickedPoint == nil
	then local x = (xDrawOffset-(xFollow-PointsX[IndexToInsert[clickedButton]+1])*Zoom)
		 local z = (yDrawOffset-(yFollow-PointsZ[IndexToInsert[clickedButton]+1])*Zoom)
		 local x_ = (xDrawOffset-(xFollow-PointsX[IndexToInsert[clickedButton]])*Zoom)
		 local z_ = (yDrawOffset-(yFollow-PointsZ[IndexToInsert[clickedButton]])*Zoom)
			
				

		 local l = -(((x_-mouseX)*(x-x_)+(z_-mouseY)*(z-z_))/((x-x_)^2+(z-z_)^2))
		 
		 if l < 1 and l >= 0
		 then if LambdaToInsert[clickedButton] ~= l
			  then 
				   
				if PointsFrame[IndexToInsert[clickedButton]] ~= nil
				then if currentWaypoint >= IndexToInsert[clickedButton]
				  then --print("ASDFSDFSADFASDFSADFSF")
				  
					-- if LambdaToInsert[clickedButton] >= l
					    -- then 
						 tastudio.setplayback(PointsFrame[IndexToInsert[clickedButton]])
							  currentWaypoint = IndexToInsert[clickedButton]
							  ug = PointsFrame[IndexToInsert[clickedButton]]
					--	 end
				end
				 elseif currentWaypoint >= IndexToInsert[clickedButton]
				  then tastudio.setplayback(PointsFrame[1])
					currentWaypoint = 1
					ug = PointsFrame[1]
				end
				
				DeleteButtons(IndexToInsert[clickedButton])
				  LambdaToInsert[clickedButton] = l
					
				 client.pause()
				   
			  end
		 end
		 
	end
	
	if not mouseButt["Left"]
	then clickedButton = nil
	end

end

function RightClickMenu(menu)

	local x = mX
	local y = mY
	
	--local showsubmenu 
	
	if 800 - x < RCListWidth 
	then x = x - RCListWidth
	end
	
	if 800 - y < RCListHeight
	then y = y - RCListHeight
	end

	for k, v in pairs(menu) do
		local _y = menu[k].y
		
		if mouseY > y+_y and mouseY < y+_y + 15 and mouseX > x and mouseX < x + RCListWidth
		then Canvas.DrawText(x,y+_y, menu[k].text, 0xFF000000, 0xFFAAAAAA)
			if mouseButt["Left"] and menu[k].clickFunction ~= nil
			then menu[k].clickFunction()
				 fireRCM = false
			end
			if menu[k].submenu ~= nil
			then showsubmenu = k
			else showsubmenu = nil
			end
			
		else Canvas.DrawText(x,y+_y, menu[k].text, 0xFF000000, 0xFF666666)
			if mouseButt["Left"]
			then fireRCM = false
			end
		end
		
		if menu[k].submenu ~= nil and showsubmenu == k
				 then for l, m in pairs(menu[k].submenu) do
						local _y2 = menu[k].submenu[l].y
			
						if mouseY > y+_y+_y2 and mouseY < y+_y+_y2 + 15 and mouseX > x +RCListWidth and mouseX < x + RCListWidth*2
						then Canvas.DrawText(x+RCListWidth,y+_y+_y2, menu[k].submenu[l].text, 0xFF000000, 0xFFAAAAAA)
							 if mouseButt["Left"] and menu[k].submenu[l].clickFunction ~= nil
							 then menu[k].submenu[l].clickFunction(l)
								  fireRCM = false
							 end
						else Canvas.DrawText(x+RCListWidth,y+_y+_y2, menu[k].submenu[l].text, 0xFF000000, 0xFF666666)
							 if mouseButt["Left"]
							 then fireRCM = false
							 end
						end
					 end
				end

	end
	
	--fireRCM = false

end

--Handles mouse events on the canvas
function CanvasMouse(mouseOverObject, mouseOverPoint)

	if mouseX >= 0 and mouseX <= 800 and mouseY >= 0 and mouseY <= 800
	then if mouseButt["Left"] and not wasMouseButtL and clickedPoint == nil and CanvasMode == "edit" and not fireRCM and not mouseOverButton-- adding a new waypoint
		 then AppendWayPoint(mouseX, mouseY)
			  if PointsFrame[totalPoints-1] ~= nil
			  then if emu.framecount() > PointsFrame[totalPoints-1]
				   then tastudio.setplayback(PointsFrame[totalPoints-1])
						currentWaypoint = totalPoints-1
						ug = PointsFrame[totalPoints-1]
				   end--TODO:Be more smart here. Don't jump back to fisrt waypoint when appending multiple new waypoints
			  else --tastudio.setplayback(PointsFrame[1])
						--currentWaypoint = 1
						--ug = PointsFrame[1]
						
			  end
		 elseif mouseButt["Left"] and CanvasMode == "view"
		 then --fireRCM = false
				--xFollow = (mouseX-xDrawOffset)--/Zoom
				--yFollow = (mouseY-yDrawOffset)--/Zoom
		 elseif mouseButt["Right"] -- dragging the canvas
		 then local dmx = mouseX - oldMouseX
			  local dmy = mouseY - oldMouseY
			  
			  xDrawOffset = xDrawOffset + dmx--/Zoom
			  yDrawOffset = yDrawOffset + dmy--/Zoom+
			  
			 -- xFollow = (mouseX-xDrawOffset)/Zoom
			--  yFollow = (mouseY-yDrawOffset)/Zoom
			  
			  if dmx == 0 and dmy == 0 and not mouseMoved
			  then fireRCM = true
				   mX = mouseX
				   mY = mouseY
			  else mouseMoved = true
				   fireRCM = false
			  end
		 elseif mouseButt["XButton1"]
		 then ZoomIn()
		 elseif mouseButt["XButton2"]
		 then ZoomOut()
		 elseif not mouseButt["XButton1"] and not mouseButt["XButton2"]
			 then zooming = false
		 end
		 		
		if not mouseButt["Right"]
		then mouseMoved = false
			 if fireRCM
			 then if CanvasMode == "edit"
				  then if mouseOverObject
					   then RightClickMenu(rightClickItems.editMode.mouseOverObject)		
					   elseif mouseOverLine and not mouseOverPoint
						   then RightClickMenu(rightClickItems.editMode.mouseOverLine)
					   elseif selectedPoint ~= nil and not mouseOverLine
						   then RightClickMenu(rightClickItems.editMode.mouseOverPoint)
					   else RightClickMenu(rightClickItems.editMode.notOverPoint)
					   end
					   
					   --if selectedPoint ~=nil then RightClickMenu(rightClickItems.editMode.mouseOverPoint) end
				  end
				  
			 end
		end
				
		 --print(tostring(mouseButt[Wheel]))
		 Canvas.DrawText(0,0, " "..xFollow+(mouseX-xDrawOffset)/Zoom.."\n"..yFollow+(mouseY-yDrawOffset)/Zoom.."\n"..Zoom)
		 
	else fireRCM = false
	end
	--Canvas.DrawText(0, 700, tostring(fireRCM))
end

--Draws the status-strip items and handles their functions.
function StatusStrip()

	Canvas.DrawRectangle(0, 800, 800, 20, 0x00000000, 0xFF999999)
	
	for k in pairs(statusStripItems) do
	
		local x = statusStripItems[k].x
		local y = 801
		
		if mouseX > x and mouseX < x+15 and mouseY > y and mouseY < y+15
		then Canvas.DrawRectangle(x, y, 17, 17, 0xFFBBBBBB, 0xFFAAAAAA)
			 Canvas.DrawImage(statusStripItems[k].image, x+2, y+2)
			 Canvas.DrawText(x+8, y-18, statusStripItems[k].toolTip, 0xFF000000, 0xFFFFFFFF)
			 
			 
			 if mouseButt["Left"] and (not statusStripItems[k].singleclick or not wasMouseButtL)
			 then statusStripItems[k].clickFunction()
			 end
		
		else Canvas.DrawRectangle(x, y, 17, 17, 0xFFBBBBBB, 0xFFDDDDDD)
			 Canvas.DrawImage(statusStripItems[k].image, x+2, y+2)
		end

	end
	
end

-------------------------
--Main Canvas Functions--
-------------------------
function UpdateCanvas()

	Canvas.Clear(0xFFFFFFFF)
	
	--selected = false
	--TODO:resizable canvas
	--TODO:fix Zooming
	
	if follow == "none"
	then --xFollow = 0
		 --yFollow = 0
	elseif follow == "player"
		then xFollow = player.position.x
			 yFollow = player.position.z
	end
	
	--Origin lines
	Canvas.DrawLine((xDrawOffset-xFollow*Zoom), 0, (xDrawOffset-xFollow*Zoom), 800, 0x55000000)
	Canvas.DrawLine(0, (yDrawOffset-yFollow*Zoom), 800, (yDrawOffset-yFollow*Zoom), 0x55000000)
	Canvas.DrawText((xDrawOffset-xFollow*Zoom), (yDrawOffset-yFollow*Zoom), "(0;0)")
	
	mouseX = Canvas.GetMouseX()
	mouseY = Canvas.GetMouseY()
	
	mouseButt = input.getmouse()
	
	if ShouldMapBeDisplayed()
	then DrawMap()
	end
	
	--local mouseOverObject = false
	--local selectedObject = {x = nil, y = nil, z = nil}
	
	local object = {DrawObject()}
	--mouseOverObject, selectedObject = 
	--
	--Canvas.DrawText(0, 120, tostring(selectedObject.x)..","..tostring(selectedObject.z)..","..tostring(mouseOverObject))
	--Canvas.DrawText(0, 120, tostring(object[2])..","..tostring(object[4])..","..tostring(object[1]))
	
	DrawCamera()
	
	--keyb = input.get() FUCK doesn't work on Canvas
	--print(tostring(keyb["K"]))
		 -- if keyb["K"] == true
		 -- then xDrawOffset = 400
			  -- yDrawOffset = 400
		 -- end

	local waypoint = DrawWaypoints()
	DrawButtons()
	
	--Canvas.DrawText(0, 64, "draw:"..tostring(xDrawOffset)..";"..tostring(yDrawOffset).."\nmouse:"..tostring(mouseX)..","..tostring(mouseY).."\nfollow:"..tostring(xFollow)..","..tostring(yFollow))
	
	if player.collision.radius == nil
	then DrawPlayer(xDrawOffset, yDrawOffset, 10)
	else DrawPlayer(xDrawOffset, yDrawOffset, player.collision.radius)
	end	
	
	StatusStrip()
		
	CanvasMouse(object[1], waypoint)
	--Canvas.DrawText(0, 140, tostring(mouseOverPoint)..", "..tostring(mouseOverLine))
	Canvas.DrawText(0,100, "c wp: "..tostring(currentWaypoint))
	
	wasMouseButtL = mouseButt["Left"]
	wasMouseButtR = mouseButt["Right"]
	wasMouseButtM = mouseButt["Middle"]
	oldMouseX = mouseX
	oldMouseY = mouseY

	Canvas.Refresh()
end

----------------------
--TAStudio Functions--
----------------------
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

function TAStudioColor(index, column)

	if (column == "P1 X Axis" or column == "P1 Y Axis") and ignoreFrames[index] ~= nil
	then return 0xEDB7FF
	end

end

function UnGreen(index)

	local frame = emu.framecount()
	
	if ug > index
	then ug = index
	 	if CheckMarkers(ug)
		then ResetCurrentWaypoint(ug)
		end
	end

end

function SaveFiles(index)

	--Save waypoint list
	local file = io.open(movie.filename()..tostring(index)..".ptl", "w+")
	
	file:write(tostring(currentWaypoint.."\n"))
	
	for k,v in pairs(PointsX) do
		file:write(tostring(PointsX[k])..";"..tostring(PointsZ[k])..";"..tostring(PointsFrame[k]).."\n")
	end
	
	file:close()
	
	--Save ignore frames
	file = io.open(movie.filename()..tostring(index)..".igf", "w+")
	
	for i = 0, movie.length(), 1 do
		file:write(tostring(ignoreFrames[i]).."\n")
	end
	
	--Save button list
	file = io.open(movie.filename()..tostring(index)..".btl", "w+")
	for k,v in pairs(IndexToInsert) do
		file:write(tostring(IndexToInsert[k])..";"..
					tostring(LambdaToInsert[k])..";"..
					tostring(ButtonToInsert[k])..";"..
					tostring(AmountToInsert[k])..";"..
					tostring(InsertionFrame[k]).."\n")
	end

end

function LoadFiles(index)
	
	--Save backup files
	if index > -1
	then local backup = io.open(movie.filename().."-1.ptl", "w+")
		 
		 backup:write(tostring(currentWaypoint.."\n"))	
		 for k,v in pairs(PointsX) do
			backup:write(tostring(PointsX[k])..";"..tostring(PointsZ[k])..";"..tostring(PointsFrame[k]).."\n")
		 end
		 
		 backup = io.open(movie.filename().."-1.igf", "w+") 
		 for i = 0, movie.length(), 1 do
			backup:write(tostring(ignoreFrames[i]).."\n")
		 end
		 
		 backup = io.open(movie.filename().."-1.btl", "w+")
		 for k,v in pairs(IndexToInsert) do
			backup:write(tostring(IndexToInsert)..";"..
						tostring(LambdaToInsert)..";"..
						tostring(ButtonToInsert)..";"..
						tostring(AmountToInsert)..";"..
						tostring(InsertionFrame).."\n")
		 end
	end
	
	--Remove old waypoint list
	for k,v in pairs(PointsX) do
		
		PointsX[k] = nil
		PointsZ[k] = nil
		PointsFrame[k] = nil
		totalPoints = totalPoints - 1
	
	end
	
	--Load waypoint list
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
	
	--Remove old ignore frames
	for i = 0, movie.length(), 1 do
	
		ignoreFrames[i] = nil
		
	end
	
	--Load ignore frames
	file = io.open(movie.filename()..tostring(index)..".igf", "r")
	
	if file ~= nil
	then local k = 0
		 for i in file:lines(1) do
			
			ignoreFrames[k] = tonumber(i)
			
			k = k + 1
		 end
	end
	
	--Remove old button list
	for k,v in pairs(IndexToInsert) do
		IndexToInsert[k] = nil
		LambdaToInsert[k] = nil
		ButtonToInsert[k] = nil
		AmountToInsert[k] = nil
		InsertionFrame[k] = nil
	end
	
	--Load button list
	file = io.open(movie.filename()..tostring(index)..".btl", "r")
	
	if file ~= nil
	then for i in file:lines(1) do
			local str = {}
			
			str = bizstring.split(i, ";")
			
			table.insert(IndexToInsert, tonumber(str[1]))
			table.insert(LambdaToInsert, tonumber(str[2]))
			table.insert(ButtonToInsert, tostring(str[3]))
			table.insert(AmountToInsert, tonumber(str[4]))
			table.insert(InsertionFrame, tonumber(str[5]))
		 end
	end

end

function BranchSaved(index)
	
	SaveFiles(index)

end

function BranchLoaded(index)
	
	LoadFiles(index)
	
end

function BranchRemoved(index)
	
	local branches = tastudio.getbranches()
	
	os.remove(movie.filename()..tostring(index)..".ptl")

	for i = index, table.getn(branches), 1 do
		os.rename(movie.filename()..tostring(i+1)..".ptl", movie.filename()..tostring(i)..".ptl")
	end

end

function Exit()
	
	SaveFiles(-2)
	
	forms.destroyall()
	
end

function FE()

	if StartFlag and not PauseFlag-- and not done
	then CreateInput()
	end
	f_old = f;
	done = true

end

if tastudio.engaged()
then tastudio.ongreenzoneinvalidated(UnGreen)
	 tastudio.onqueryitembg(TAStudioColor)
	 tastudio.onbranchsave(BranchSaved)
	 tastudio.onbranchload(BranchLoaded)
	 tastudio.onbranchremove(BranchRemoved)

	 event.onexit(Exit)
	 event.onframeend(FE)


	 LoadFiles(-2)
	


while true do

	f = emu.framecount()
	autoUnpause = forms.ischecked(autoUnpauseCheck)
	
	if f > ug
	then ug = f
	end
	
	
	--if f_old ~= f then done = false; end;
	
	
	
	--MarkerControl()
	
	if StartFlag and not PauseFlag-- and not done
	then 	
	if currentWaypoint < totalPoints
	then if  autoUnpause
		 then client.unpause()
		 end
	else client.pause()
	end
	end
	
	if not client.isturbo()
	then UpdateCanvas()
	end


	
	f_old = f;
	--done = true
	
	inget = input.get()
	
	--TODO: tap: just once. hold for long time: continue with incrementing/decrementing
	if inget.R == true and wasR == nil
	then Add()
	elseif inget.E == true and wasE == nil
	then Sub()
	elseif inget.Y == true
	then Sub()
	elseif inget.U == true
	then Add()
	elseif inget.I == true and wasI == nil
	then SetIgnoreFrames()
	elseif inget.O == true and wasO == nil
	then UnsetIgnoreFrames()
	end
	
	wasR = inget.R
	wasE = inget.E
	wasP = inget.P
	wasI = inget.I
	wasO = inget.O

	emu.yield()

end
end

