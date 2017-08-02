-- Auto analog input script written by TASeditor
-- Main window
-- This function runs after the user clicked on the Start button.
memory.usememorydomain("RDRAM")
function Start()

	if PauseFlag == false
	then if StartFlag == false
		 then if forms.ischecked(PosCheck) and not forms.ischecked(AngCheck)
			  then --CalcAngle();
				   tastudio.setrecording(true)
				   FollowAngle = tonumber(forms.gettext(AngFollowTxt));
				   RadiusMin = forms.gettext(RadiusMinTxt);
				   RadiusMax = forms.gettext(RadiusMaxTxt);
				   XPosGoto = forms.gettext(XPosGotoTxt);
				   YPosGoto = forms.gettext(YPosGotoTxt);
				   Optimisation = forms.gettext(OptDrop);
				   TwoStep = forms.ischecked(TwoStepCheck);
				   StartFlag = true;
				   forms.settext(StatLabel, "Started");
			  elseif not forms.ischecked(PosCheck) and forms.ischecked(AngCheck)
				  then tastudio.setrecording(true)
					   FollowAngle = forms.gettext(AngFollowTxt);
					   RadiusMin = forms.gettext(RadiusMinTxt);
					   RadiusMax = forms.gettext(RadiusMaxTxt);
					   Optimisation = forms.gettext(OptDrop);
					   TwoStep = forms.ischecked(TwoStepCheck);
					   StartFlag = true;
					   forms.settext(StatLabel, "Started");
				  elseif forms.ischecked(PosCheck) and forms.ischecked(AngCheck)
					  then forms.settext(StatLabel, "Error: Uncheck one checkbox");
					  elseif not forms.ischecked(PosCheck) and not forms.ischecked(AngCheck) --Use this for the canvas right now
						  then tastudio.setplayback(firstPointFrame)
								tastudio.setrecording(true)
							   UseCanv = true
							   RadiusMin = forms.gettext(RadiusMinTxt);
					   RadiusMax = forms.gettext(RadiusMaxTxt);
						 Optimisation = forms.gettext(OptDrop);  
					  StartFlag = true;
					   forms.settext(StatLabel, "Started");
					   p = 1
			  end;
		 end;
	end;
	
end;

-- This function runs after the user clicked on the Pause button.
function Pause()

	if StartFlag == true
	then if PauseFlag == false
		 then PauseFlag = true;
			  forms.settext(StatLabel, "Paused");
			  forms.settext(PauseButton, "Continue");
			  tastudio.setrecording(false)
			  client.pause();
			  Xinput["P1 X Axis"] = 0;
			  Yinput["P1 Y Axis"] = 0;
			  joypad.setanalog(Xinput);
			  joypad.setanalog(Yinput);
		 else PauseFlag = false
			  forms.settext(StatLabel, "Started");
			  forms.settext(PauseButton, "Pause");
		 end;
	end;

end;

-- This function runs after the user clicked on the Stop button.
function Stop()

	if StartFlag == true
	then StartFlag = false;
		 PauseFlag = false;
		 forms.settext(StatLabel, "Stopped");
		 forms.settext(PauseButton, "Pause");
		 tastudio.setrecording(false)
		 client.pause();
		 Xinput["P1 X Axis"] = 0;
		 Yinput["P1 Y Axis"] = 0;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);
		 X = 0;
		 Y = 0;
		 UseCanv = false
	end;

end;

-- These functions run after the user clicked the "+" or "-" button.
function IncrementAngle(inpX, inpY)

	local inp_a = math.atan2(inp["Y Axis"], inp["X Axis"])
	local inp_ad = (inp_a *180/math.pi) % 360
	--print(tostring(inp_ad))
	if not(inp_ad == 0 or inp_ad == 45 or inp_ad == 90 or inp_ad == 135 or inp_ad == 180 or inp_ad == 225 or inp_ad == 270 or inp_ad == 315)-- or math.abs(inp["X Axis"])/math.abs(inp["Y Axis"]) == 2 or math.abs(inp["Y Axis"])/math.abs(inp["X Axis"]) == 2)
	then Bresenham(0,0, inpX*182, inpY*182)
		--print("b")
		 
		 local bestDist = 9999999999;
		 
		 
		 for i, pt in pairs(Points) do
			local pt_a = math.atan2(pt.Y, pt.X)
			local newDist = math.abs(pt_a - inp_a);
		 
		 	
		 	if newDist < bestDist and pt_a > inp_a
		 	then if Points[i].X >= -128 and Points[i].Y >= -128 and Points[i].X <= 127 and Points[i].Y <= 127
		 		then bestDist = newDist;
		 			Xbest = Points[i].X;
		 			Ybest = Points[i].Y;
		 		end
		 	end;
		 end; --TODO: Check user settings
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
	
end

function Add()
	
	movie.setrerecordcount(movie.getrerecordcount()+1)
	
	lastf = emu.framecount()
	sel = tastudio.getselection()
	
	if tastudio.engaged()
	then inp = movie.getinputasmnemonic(sel[0]);
		 inp = bizstring.remove(inp, 0, 5)
		 inp = bizstring.remove(inp, 5, 1)
		 inp = bizstring.split(inp, ",")
		 inp["X Axis"] = tonumber(inp[1])
		 inp["Y Axis"] = tonumber(inp[2])
	else inp = joypad.get(1);
	end
	
	
	IncrementAngle(inp["X Axis"], inp["Y Axis"])
	

	-- if HasGameRotatingCam == "true"
	-- then FollowAngle = ((math.atan2(Ybest, Xbest) + CamAngle + Offset) % Modulo)*Modulo/2/math.pi % Modulo --TODO:
	-- else FollowAngle = ((math.atan2(Ybest, Xbest) + Offset) % Modulo)*Modulo/2/math.pi % Modulo
	-- end 
	-- forms.settext(AngFollowTxt, tonumber(FollowAngle))
	
	
	--frameEdit = emu.framecount()-1;
	tastudio.setplayback(sel[0]);
	
	if tastudio.engaged()
	then forms.settext(xLabel, Xbest);
		 forms.settext(yLabel, Ybest);
		 Xinput["P1 X Axis"] = Xbest;
		 Yinput["P1 Y Axis"] = Ybest;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);
	else Xinput["P1 X Axis"] = Xbest;
		 Yinput["P1 Y Axis"] = Ybest;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);
	end;
	
	fromAddSub = true
	
end;

function DecrementAngle(inpX, inpY)

	local inp_a = math.atan2(inpX, inpY)
	local inp_ad = (inp_a *180/math.pi) % 360
	
	
	
	if not(inp_ad == 0 or inp_ad == 45 or inp_ad == 90 or inp_ad == 135 or inp_ad == 180 or inp_ad == 225 or inp_ad == 270 or inp_ad == 315)
	then Bresenham(0,0, inpX*182, inpY*182)

		 local bestDist = 9999999999;
		 
		 for i, pt in pairs(Points) do
			 local pt_a = math.atan2(pt.Y, pt.X)
			 local newDist = math.abs(pt_a - inp_a);
			 
			 if newDist < bestDist and pt_a < inp_a
			 then if Points[i].X >= -128 and Points[i].Y >= -128 and Points[i].X <= 127 and Points[i].Y <= 127
				 then bestDist = newDist;
					  Xbest = Points[i].X;
					  Ybest = Points[i].Y;
				 end
			 end;
		 end;	
	elseif inp_ad == 0 then Xbest = 127; Ybest = -1
	elseif inp_ad == 45 then Xbest = 127; Ybest = 126
	elseif inp_ad == 90 then Xbest = 1; Ybest = 127
	elseif inp_ad == 135 then Xbest = -126; Ybest = 127
	elseif inp_ad == 180 then Xbest = -128; Ybest = 1
	elseif inp_ad == 225 then Xbest = -128; Ybest = -127
	elseif inp_ad == 270 then Xbest = -1; Ybest = -128
	elseif inp_ad == 315 then Xbest = 127; Ybest = -128
	end
	

end

function Sub()

	movie.setrerecordcount(movie.getrerecordcount()+1)

	lastf = emu.framecount()

	sel = tastudio.getselection()

	if tastudio.engaged()
	then inp = movie.getinputasmnemonic(sel[0]);
		 inp = bizstring.remove(inp, 0, 5)
		 inp = bizstring.remove(inp, 5, 1)
		 inp = bizstring.split(inp, ",")
		 inp["X Axis"] = tonumber(inp[1])
		 inp["Y Axis"] = tonumber(inp[2])
	else inp = joypad.get(1);
	end
	
	DecrementAngle(inp["X Axis"], inp["Y Axis"])
	
	-- if HasGameRotatingCam == "true"
	-- then FollowAngle = ((math.atan2(Ybest, Xbest) + CamAngle + Offset) % Modulo)*Modulo/2/math.pi % Modulo --TODO:
	-- else FollowAngle = ((math.atan2(Ybest, Xbest) + Offset) % Modulo)*Modulo/2/math.pi % Modulo
	-- end 
	-- forms.settext(AngFollowTxt, tonumber(FollowAngle))

	--frameEdit = emu.framecount()-1;
	tastudio.setplayback(sel[0]);
	
	if tastudio.engaged()
	then forms.settext(xLabel, Xbest);
		 forms.settext(yLabel, Ybest);
		 Xinput["P1 X Axis"] = Xbest;
		 Yinput["P1 Y Axis"] = Ybest;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);		 
	else Xinput["P1 X Axis"] = Xbest;
		 Yinput["P1 Y Axis"] = Ybest;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);
	end;
	
	fromAddSub = true

end;

function CalcAngle(Xstart, Ystart, Xgoal, Ygoal)

	local DeltaX = Xgoal - Xstart		--memory.readfloat(XPosAddr, true);
	local DeltaY = Ygoal - Ystart		--memory.readfloat(YPosAddr, true);
	--Distance = math.sqrt(DeltaX^2 + DeltaY^2);
		--TODO: Games require different formula???
	local NewAngle = ((math.atan2(-DeltaY , DeltaX) * (Modulo/2) / math.pi) ) % Modulo;
	--print(tostring(NewAngle).."\n---------------------------")
	--forms.settext(AngFollowTxt, NewAngle);
	return NewAngle;
		
end;

function ToggleCanvasEdit()

	if CanvasMode == "view"
	then CanvasMode = "edit"
		 forms.settext(CanvasButton, "View Mode")
		 if firstPointFrame ~= nil
		 then tastudio.setplayback(firstPointFrame)
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

-- This function creates the main window.
function WindowForm()

	local OptTable = {"Line drawing"};--, "Rotate around""None", 
	
	Window = forms.newform(300, 500, "Auto analog input");

	PosCheck = forms.checkbox(Window, "Go to position:", 5, 20); 
	forms.label(Window, "X =", 110, 10, 30, 20);
	XPosGotoTxt = forms.textbox(Window, "0", 120, 20, nil, 140, 5);
	forms.label(Window, "Y =", 110, 40, 30, 20);
	YPosGotoTxt = forms.textbox(Window, "0", 120, 20, nil, 140, 35);
	
	AngCheck = forms.checkbox(Window, "Follow angle:", 5, 75);
	forms.label(Window, "a =", 110, 80, 30, 20);
	AngFollowTxt = forms.textbox(Window, "0", 120, 20, nil, 140, 75);
	
	forms.label(Window, "Radius: min =", 5, 120, 75, 20);
	RadiusMinTxt = forms.textbox(Window, "67", 30, 20, nil, 80, 115);
	forms.label(Window, "max =", 115, 120, 35, 20)
	RadiusMaxTxt = forms.textbox(Window, "182", 30, 20, nil, 155, 115);
	
	forms.label(Window, "Increment/decrement input angle:", 5, 150, 170, 20);
	forms.button(Window, "+", Add, 200, 145, 23, 23);
	forms.button(Window, "-", Sub, 175, 145, 23, 23);
	
	forms.label(Window, "Optimisation:", 5, 180, 70, 20);
	OptDrop = forms.dropdown(Window, OptTable, 80, 175, 100, 20);
	TwoStepCheck = forms.checkbox(Window, "Two stepping", 190, 175);
	
	forms.label(Window, "Status:", 5, 210, 40, 15);
	StatLabel = forms.label(Window, "Stopped", 45, 210, 200, 20);
	
	
	
	forms.button(Window, "Start", Start, 5, 230);
	PauseButton = forms.button(Window, "Pause", Pause, 105, 230);
	forms.button(Window, "Stop", Stop, 205, 230);
	
	CanvasButton = forms.button(Window, "Edit Mode", ToggleCanvasEdit, 5, 270)
	--forms.button(Window, "Zoom +", ZoomIn, 100, 270)
	--forms.button(Window, "Zoom -", ZoomOut, 150, 270)
	
	-- forms.label(Window, "Information:", 5, 270, 70, 20);
	
	-- forms.label(Window, "Current angle:", 5, 290, 73, 20);
	-- CurrAngLabel = forms.label(Window, "", 75, 290, 40, 20);
	-- forms.label(Window, "Error%:", 130, 290, 40, 20);
	-- ErrorLabel = forms.label(Window, "", 210, 290, 40, 20);
	
	-- forms.label(Window, "Total error:", 5, 310, 70, 20);
	-- TotErrLabel = forms.label(Window, "", 75, 310, 40, 20);
	-- forms.label(Window, "Average error%:", 130, 310, 83, 20);
	-- AvErrorLabel = forms.label(Window, "", 210, 310, 40, 20);
	
	-- forms.label(Window, "U Position:", 5, 330, 58, 20);
	-- UPosLabel = forms.label(Window, "", 75, 330, 80, 20);
	-- forms.label(Window, "Distance:", 5, 350, 52, 20);
	-- DistLabel = forms.label(Window, "", 75, 350, 80, 20);
	
	--OptCheck = forms.checkbox(Window, "Optimize", 5, 280);
	
	if tastudio.engaged()
	then xLabel = forms.label(Window, "X", 5, 400, 30, 20);
		 yLabel = forms.label(Window, "Y", 40, 400, 30, 20);
	end;

end;

 -- Address window
-- This function checks wheter the user has typed in the memory addresses or not.
-- It doesn't check if the typed address is the correct one.
-- The "0x" should not be deleted.
function Check()
	
	local success = false;
	local XPosAddr = forms.gettext(XPosAddrTxt);
	local YPosAddr = forms.gettext(YPosAddrTxt);
	local MovAngAddr = forms.gettext(MovAngAddrTxt);
	local CamAngAddr = forms.gettext(CamAngAddrTxt);
	local Offset = forms.gettext(OffsetTxt);
	local Type = forms.gettext(TypeDrop);
	local Modulo = forms.gettext(ModTxt);
	local DeadzoneMin = forms.gettext(MinTxt);
	local DeadzoneMax = forms.gettext(MaxTxt);
	
	if XPosAddr ~= "0x" and YPosAddr ~= "0x" and MovAngAddr ~= "0x" and Offset ~= ""
	then success = true;
	end;	 
	
	if CamAngAddr == "0x"
	then HasGameRotatingCam = false;
		 CamAngAddr = 0;
	else HasGameRotatingCam = true;
	end;
		 
	
	if (Type == "Byte" and Modulo == "")
	then Modulo = 256; 
	elseif (Type == "Word" and Modulo == "")
	then Modulo = 65536; 
	elseif (Type == "DWord" and Modulo == "")
	then Modulo = 4294967296; 
	elseif (Type == "Float" and Modulo == "")
	then Modulo = 360
	else success = false;
	end
	
	if DeadzoneMin == ""
	then DeadzoneMin = 0;
	else DeadzoneMin = tonumber(DeadzoneMin);
	end
	
	if DeadzoneMax == ""
	then DeadzoneMax = 129;
	else DeadzoneMax = tonumber(DeadzoneMax);
	end
	
	if DeadzoneMin > DeadzoneMax 
	then success = false;
	end;
	
	if success == true
	then -- Writes the addresses into a text file.
		 -- The user doesn't have to type in the addresses everytime.
		 AddrFile = io.open(ROMname, "a");
		 AddrFile:write(tonumber(XPosAddr), "\n", 
						tonumber(YPosAddr), "\n", 
						tonumber(MovAngAddr), "\n", 
						tostring(HasGameRotatingCam), "\n", 
						tonumber(CamAngAddr), "\n",
						tonumber(Offset), "\n",
						tostring(Type), "\n",
						tonumber(Modulo), "\n",
						DeadzoneMin, "\n",
						DeadzoneMax);
		 AddrFile:close();
		 
		 -- Closes the form where the user typed in the addresses.
		 forms.destroy(Addr);
		 WindowForm();
	end;
	
end;

-- This function creates the form where the user needs to type in memory addresses.
function AddrForm()
	
	local TypeTable = {"Byte","Word","DWord", "Float"};
	
	Addr = forms.newform(280, 370, "Settings");
	
	forms.label(Addr, "Horizontal position addresses:", 5, 5, 280, 20);
	forms.label(Addr, "X:",5, 30, 20, 20);
	XPosAddrTxt = forms.textbox(Addr, "0x", 70, 20, nil, 25, 25);
	forms.label(Addr, "Y:",105, 30, 20, 20); 
	YPosAddrTxt = forms.textbox(Addr, "0x", 70, 20, nil, 125, 25);
	
	forms.label(Addr, "Horizontal movement angle address:", 5, 55, 350, 20);
	MovAngAddrTxt = forms.textbox(Addr, "0x", 70, 20, nil, 10, 75);
	--FloatCheck = forms.checkbox(Addr, "Float?", 120, 75);
	
	forms.label(Addr, "Horizontal camera angle address:", 5, 105, 340, 20);
	CamAngAddrTxt = forms.textbox(Addr, "0x", 70, 20, nil, 10, 125);
	
	forms.label(Addr, "Offset for the analog stick angle:", 5, 155, 360, 20)
	OffsetTxt = forms.textbox(Addr, "", 70, 20, nil, 10, 175);
	
	forms.label(Addr, "Unit system for angles:", 5, 205, 300, 20);
	forms.label(Addr, "Type:", 5, 230, 40, 20);
	TypeDrop = forms.dropdown(Addr, TypeTable , 45, 225, 80, 20);
	forms.label(Addr, "modulo:", 130, 230, 45, 20);
	ModTxt = forms.textbox(Addr, "", 60, 20, nil, 180, 225);
	
	forms.label(Addr, "Deadzone:", 5, 255, 100, 20);
	forms.label(Addr, "min:", 5, 280, 30, 20);
	MinTxt = forms.textbox(Addr, "", 30, 20, nil, 35, 275);
	forms.label(Addr, "max:", 70, 280, 30, 20);
	MaxTxt = forms.textbox(Addr, "", 30, 20, nil, 105, 275);
	
	forms.button(Addr, "Done", Check, 5, 300);

end;

-- Reads out the memory addresses from the file, if there's content in the file.
-- The memory addresses are saved in decimal numbers.
-- The file is in the main BizHawk folder and is called "<romname>.txt".
-- The main window will open.

XPosAddr = nil;
YPosAddr = nil;
MovAngAddr = nil;
HasGameRotatingCam = nil;
CamAngAddr = nil;
CamAngAddr = nil;
Offset = nil;
Type = nil;
Modulo = nil;
DeadzoneMin = nil;
DeadzoneMax = nil;

AddrFile = nil;

ROMname = gameinfo.getromname()..".ais";
AddrFile = io.open(ROMname, "r");

if AddrFile ~= nil
then XPosAddr = tonumber(AddrFile:read("*line"));
     YPosAddr = tonumber(AddrFile:read("*line"));
     MovAngAddr = tonumber(AddrFile:read("*line"));
	 HasGameRotatingCam = tostring(AddrFile:read("*line"));
	 CamAngAddr = tonumber(AddrFile:read("*line"));
	 Offset = tonumber(AddrFile:read("*line"));
	 Type = tostring(AddrFile:read("*line"));
	 Modulo = tonumber(AddrFile:read("*line"));
	 DeadzoneMin = tonumber(AddrFile:read("*line"));
	 DeadzoneMax = tonumber(AddrFile:read("*line"));
	 
	 
	 WindowForm(); 
	 AddrFile:close();
else AddrForm();
--AddrFile == nil-- If there's no content in the file a window will open, where the user types in the memory addresses once.
--then 
---XPosAddr == nil and YPosAddr == nil and MovAngAddr == nil and HasGameRotatingCam == nil and CamAngAddr == nil
	--Prevents crash.
	-- XPosAddr = 0;
	 --YPosAddr = 0;
	 --MovAngAddr = 0;
	 --CamAngAddr = 0;
	
end



--**************************************************************************************************--
--Brute force script																				--
--**************************************************************************************************--

Xinput = {};
Yinput = {};

Canvas = gui.createcanvas(800,800)

XdrawPlayer = 400
YdrawPlayer = 400

--CPoints = {X, Y} --TODO
PointsX = {}
PointsY = {}
Pindex = 1
selected = false

CanvasMode = "view"
Zoom = 1
dmx = 0
dmy = 0
p = 1
UseCanv = false

--firstPointFrame = 0

StartFlag = false;
PauseFlag = false;
X = 0; Y = 0;
FollowAngle = 0
CamAngle = 0;
InputAngle = 0;
Radius = 0;
steps = 0;
done = false;
--j = 0;
--diff = 10;
--bestdiff = 10;
-- X_0=0; Y_0=0;
-- X_g=0; Y_g=0;
-- X_b=0; Y_b=0;
-- frame_start = 0;
f=0;
f_old=0;
frameEdit = 0

function sgn(x)

	if x > 0
	then return 1;
	elseif x < 0
	then return -1;
	else return 0;
	end;
	
end;

function Bresenham(xStart, yStart, xEnd, yEnd)

	Points = {};
	i = 0;
	
	dx = xEnd - xStart;
	dy = yEnd - yStart;
	
	incx = sgn(dx)
	incy = sgn(dy)
	
	if dx < 0 then dx = -dx; end;
	if dy < 0 then dy = -dy; end;
	
	if dx > dy
	then pdx = incx; -- parallel step
		 pdy = 0;
		 ddx = incx; -- diagonal step
		 ddy = incy;
		 ef = dy; -- error steps fast, slow
		 es = dx;
	else pdx = 0;
		 pdy = incy;
		 ddx = incx;
		 ddy = incy;
		 ef = dx;
		 es = dy;
	end;
	
	x = xStart;
	y = yStart;
	
	 err = es/2;
	
	--Points[0] = {X = x, Y = y}
	
	for t = 0, es, 1 do
		
		err = err - ef;
		
		if err < 0
		then err = err + es
			 x = x + ddx;
			 y = y + ddy;
		else x = x + pdx;
			 y = y + pdy;
		end
		
		
		radius = math.sqrt(x^2+y^2);
		RadiusMin = forms.gettext(RadiusMinTxt);
		RadiusMax = forms.gettext(RadiusMaxTxt);
		if (math.abs(x) >= DeadzoneMin and math.abs(y) >= DeadzoneMin and 
			math.abs(x) <= DeadzoneMax and math.abs(y) <= DeadzoneMax and 
			radius >= tonumber(RadiusMin) and radius <= tonumber(RadiusMax))
		then 
			
			 Points[i] = {X = x, Y = y}; 
			 i = i+1;
		end	
	
	end

end

function LineDrawing()
	
	Bresenham(0,0, math.cos(InputAngle)*182, math.sin(InputAngle)*182)
	
	bestDist = 9999999999;
	
	
	for i, pt in pairs(Points) do
		newDist = math.abs(math.atan2(pt.Y, pt.X) - InputAngle);
		--print("newDist"..newDist)
		--print(math.abs(((math.atan2(pt.Y, pt.X) * (Modulo/2)/math.pi) % Modulo)))
		--print(tostring(math.abs(math.atan2(pt.Y, pt.X) - InputAngle)))
		--print(pt)
		--print(pt.X.." "..pt.Y.." "..(math.atan2(pt.Y, pt.X) % Modulo).." "..newDist.." ".. math.abs(math.atan2(Ybest, Xbest)-InputAngle));
		--if math.atan2(pt.Y, pt.X) == InputAngle
		--then break;
		--end;
		if newDist < bestDist
		then if Points[i].X >= -128 and Points[i].Y >= -128 and Points[i].X <= 127 and Points[i].Y <= 127
			 then bestDist = newDist;
				  Xbest = Points[i].X;
				  Ybest = Points[i].Y;
			 end
		end;
	end;
	
end;

function RotateAround(radius)

	Xbest = math.floor(math.cos(InputAngle)*radius+0.5);
	Ybest = math.floor(math.sin(InputAngle)*radius+0.5);
	
	
	X = Xbest;
	Y = Ybest;
	
	Steps = 0;
	j = 0;
	bestdiff = 9999999999;
	InputAngleInt = math.atan2(Y, X); console.writeline(InputAngle.." "..InputAngleInt);
		
	if InputAngleInt == InputAngle
	then console.writeline("perfect");
	else 	
		repeat
		
			if Steps % 2 == 0
			then for i = 1,Steps,1 do
					X = X - 1;
					InputAngleInt = math.atan2(Y, X); console.writeline(X.." "..Y.." "..Steps);
					diff = math.abs(InputAngleInt - InputAngle);
					if diff < bestdiff then Xbest = X; Ybest = Y; bestdiff = diff; end;
				 end;
				 if InputAngleInt == InputAngle then Xbest = X; Ybest = Y; break; end; 
				 for i = 1,Steps,1 do
					 Y = Y - 1;
					 InputAngleInt = math.atan2(Y, X); console.writeline(X.." "..Y.." "..Steps);
					 diff = math.abs(InputAngleInt - InputAngle);
					if diff < bestdiff then Xbest = X; Ybest = Y; bestdiff = diff; end;
				 end;
				 if InputAngleInt == InputAngle then Xbest = X; Ybest = Y; break; end;	
			else for i = 1,Steps,1 do
					 X = X + 1;
					 InputAngleInt = math.atan2(Y, X); console.writeline(X.." "..Y.." "..Steps);
					 diff = math.abs(InputAngleInt - InputAngle);
					 if diff < bestdiff then Xbest = X; Ybest = Y; bestdiff = diff; end;
				 end;
				 if InputAngleInt == InputAngle then Xbest = X; Ybest = Y; break; end;
				
				 for i = 1,Steps,1 do
					 Y = Y + 1;
					 InputAngleInt = math.atan2(Y, X); console.writeline(X.." "..Y.." "..Steps);
					 diff = math.abs(InputAngleInt - InputAngle);
					 if diff < bestdiff then Xbest = X; Ybest = Y; bestdiff = diff; end;
				 end;
				 if InputAngleInt == InputAngle then Xbest = X; Ybest = Y; break; end;
				
			end;
			Steps = Steps + 1;
			j = j +1;
		until j == 5 --how long does this need to run?
		
		--Steps = 1;
		
	end
	--done = true;
	--j = 0;
	--print(math.atan2(Ybest, Xbest).." ".. math.abs(math.atan2(Ybest, Xbest)-InputAngle));
end;

function NoOptimisation(radius)
	
	Xbest = math.floor(math.cos(InputAngle)*radius+0.5);
	Ybest = math.floor(math.sin(InputAngle)*radius+0.5);
	
	--print(math.atan2(Ybest, Xbest).." ".. math.abs(math.atan2(Ybest, Xbest)-InputAngle));

end;

function TwoStepping()
	

end;

function CreateInput()

	XPosition = memory.readfloat(XPosAddr, true);
	YPosition = memory.readfloat(YPosAddr, true);
	
	if Type == "Byte" 
	then MovAngle = memory.read_u8(MovAngAddr);
		 if HasGameRotatingCam == "true" then CamAngle = memory.read_u8(CamAngAddr); end;
	elseif Type == "Word"
	then MovAngle = memory.read_u16_be(MovAngAddr); 
		 if HasGameRotatingCam == "true" then CamAngle = memory.read_u16_be(CamAngAddr); end;
	elseif Type == "DWord"
	then MovAngle = memory.read_u32_be(MovAngAddr);
		 if HasGameRotatingCam == "true" then CamAngle = memory.read_u32_be(CamAngAddr); end;
	elseif Type == "Float"
	then MovAngle = memory.readfloat(MovAngAddr, true);
		 if HasGameRotatingCam == "true" then CamAngle = memory.readfloat(CamAngAddr, true);end;
	end;
	
	if forms.ischecked(PosCheck)
	then --CalcAngle();
	end
	
	if Pindex > 1 and UseCanv and p < Pindex - 1
	then --gui.text(100, 100, "UseCanv"..tostring(UseCanv))
		 lambdax = (XPosition - PointsX[p])/(PointsX[p+1]-PointsX[p])
		 lambday = (YPosition - PointsY[p])/(PointsY[p+1]-PointsY[p])
		 if lambdax >= 1 and lambday >= 1
		 then p = p + 1
			  --print(tostring(p))
		 end
		 --print("asdf")
		-- print(tostring(PointsX[p+1]))
		 --print(tostring(PointsY[p+1]))
		 if p < Pindex - 1
		 then FollowAngle = CalcAngle(XPosition, YPosition, PointsX[p+1], PointsY[p+1])
		 else tastudio.setrecording(false)
		 end
	end
	
		 
		 
	if HasGameRotatingCam == "true"
	then InputAngle = ((FollowAngle - CamAngle - Offset) % Modulo)*math.pi/(Modulo/2);
	else InputAngle = ((FollowAngle - Offset) % Modulo)*math.pi/(Modulo/2);
	end;
	
	if Optimisation == "None" then NoOptimisation(RadiusMax);
	elseif Optimisation == "Rotate around" then RotateAround(math.floor(RadiusMax-RadiusMin/2+0.5));
	elseif Optimisation == "Line drawing" then LineDrawing()
	end
	
	if tastudio.engaged()
	then forms.settext(xLabel, Xbest);
		 forms.settext(yLabel, Ybest);
		 
		 Xinput["P1 X Axis"] = Xbest;
		 Yinput["P1 Y Axis"] = Ybest;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);
		 
	else Xinput["P1 X Axis"] = Xbest;
		 Yinput["P1 Y Axis"] = Ybest;
		 joypad.setanalog(Xinput);
		 joypad.setanalog(Yinput);
	end;

end;

function MarkerControl()

	marker = tastudio.getmarker(emu.framecount())
	
	if bizstring.startswith(marker, "a=")
	then s = bizstring.remove(marker, 0,2)
		 forms.settext(AngFollowTxt, s)
		 FollowAngle = tonumber(s);
	end

end



function AppendWayPoint(MX, MY)
	
	if Pindex == 1
	then table.insert(PointsX, Pindex, (XPosition)) --First point must be current player position
		 table.insert(PointsY, Pindex, (YPosition))
		 firstPointFrame = emu.framecount() -- save the frame to jump back when the user edits
		 Pindex = Pindex + 1
	end
	
	table.insert(PointsX, Pindex, (XPosition+MX-XdrawPlayer))
	table.insert(PointsY, Pindex, (YPosition+MY-YdrawPlayer))
			  
			  --CPoints.X = mouseX
			  --CPoints.Y = mouseY
			  --table.insert(CPoints, Pindex, mouseY)
	Pindex = Pindex + 1
	
end

function DeleteWayPoint(index)
	
	if index == 1
	then for i = Pindex-1, 1, -1 do
			
			table.remove(PointsX, i)--Delete every point if first one is clicked
			table.remove(PointsY, i)
			Pindex = Pindex -1
			
		 end
	elseif Pindex == 3 and index > 1 
		then table.remove(PointsX, index) --Delete the first one aswell if only two are remaining
			 table.remove(PointsY, index)
			 --print(tostring(k))
			 table.remove(PointsX, 1)
			 table.remove(PointsY, 1)
			 Pindex = Pindex - 2
		else table.remove(PointsX, index)
			 table.remove(PointsY, index)
			 Pindex = Pindex - 1
	end
	
end

function SplitPath(index)

	table.insert(PointsX, index+1, (PointsX[index]+(PointsX[index+1]-PointsX[index])/2))
	table.insert(PointsY, index+1, (PointsY[index]+(PointsY[index+1]-PointsY[index])/2))
	Pindex = Pindex + 1

end

function DrawCanvas()

	Canvas.Clear(0xFFFFFFFF)
	XPosition = memory.readfloat(XPosAddr, true);
	YPosition = memory.readfloat(YPosAddr, true);
	Pselection = {}
	--selected = false
	--TODO:resizable canvas
	--TODO:Zooming
	
	--Player coordinate lines
	Canvas.DrawLine(XdrawPlayer, 0, XdrawPlayer, 800, 0x55FF0000)
	Canvas.DrawLine(0, YdrawPlayer, 800, YdrawPlayer, 0x55FF0000)
	Canvas.DrawText(XdrawPlayer+1, 785, XPosition)
	Canvas.DrawText(0, YdrawPlayer+1, YPosition)
	
	--Origin lines
	Canvas.DrawLine(XdrawPlayer-XPosition, 0, XdrawPlayer-XPosition, 800, 0x55000000)
	Canvas.DrawLine(0, YdrawPlayer-YPosition, 800, YdrawPlayer-YPosition, 0x55000000)
	Canvas.DrawText(XdrawPlayer-XPosition, YdrawPlayer-YPosition, "(0;0)")
	
	--Canvas.DrawText(0, 64, tostring(XdrawPlayer))
	
	Canvas.DrawEllipse(XdrawPlayer-10, YdrawPlayer-10, 20, 20, 0xFFFF0000)
	
	mouseX = Canvas.GetMouseX()
	mouseY = Canvas.GetMouseY()
	
	mouseButt = input.getmouse()
	
	--keyb = input.get() FUCK doesn't work on Canvas
	--print(tostring(keyb["K"]))
		 -- if keyb["K"] == true
		 -- then XdrawPlayer = 400
			  -- YdrawPlayer = 400
		 -- end
	if mouseX >= 0 and mouseX <= 800 and mouseY >= 0 and mouseY <= 800
	then if mouseButt["Left"] and not wasMouseButtL and not selected and CanvasMode == "edit"
		 then AppendWayPoint(mouseX, mouseY)
		 end
		 if mouseButt["Right"]
		 then dmx = mouseX - oldMouseX
			  dmy = mouseY - oldMouseY
			  
			  XdrawPlayer = XdrawPlayer + dmx
			  YdrawPlayer = YdrawPlayer + dmy
		 end
		
		 --print(tostring(mouseButt[Wheel]))
		 Canvas.DrawText(0,0, " "..(XPosition+mouseX-XdrawPlayer).."\n"..(YPosition+mouseY-YdrawPlayer))
		
	else 
	end
	
	for k,v in pairs(PointsX) do
	
		--print(tostring(k).." "..tostring(v))
		
		--print("x "..tostring(PointsX[k]))
		--print("y "..tostring(PointsY[k]))
		
		if PointsX[k] ~= nil and PointsY[k] ~= nil
		then local x = (XdrawPlayer-(XPosition-PointsX[k])*Zoom)
			 local y = (YdrawPlayer-(YPosition-PointsY[k])*Zoom)
			 
			 if k == 1
			 then Canvas.DrawEllipse(x-5, y-5, 10, 10, 0xFF000000, 0xFFFF0000)--first one is red
			 else Canvas.DrawEllipse(x-5, y-5, 10, 10, 0xFF000000, 0xFF00FF00)
			 end
			 --Canvas.DrawText(x, y, ""..PointsX[k].."\n"..PointsY[k])
			-- Canvas.DrawText(0, 16+16*k, ""..tostring(PointsX[k]).." , "..tostring(PointsY[k]))
			
			if k > 1
			then Canvas.DrawLine((XdrawPlayer-(XPosition-PointsX[k-1])*Zoom), (YdrawPlayer-(YPosition-PointsY[k-1])*Zoom), x, y)
			end
			
			if math.sqrt((x-mouseX)^2+(y-mouseY)^2) < 5
			then --selected = true
				 Pselection[k] = true
				 Canvas.DrawText(x, y, ""..PointsX[k].."\n"..PointsY[k])
				 Canvas.DrawEllipse(x-5, y-5, 10, 10, 0xFF000000, 0xFFFFFF00)
				 
				 if k > 1
				 then Canvas.DrawLine((XdrawPlayer-(XPosition-PointsX[k-1])*Zoom), (YdrawPlayer-(YPosition-PointsY[k-1])*Zoom), x, y, 0xFFFFFF00)
				 end
				 
				 if CanvasMode == "edit"
				 then if mouseButt["Left"] and k > 1
					  then ind = k
					  else ind = nil
					  end
					  if mouseButt["Right"]
					  then DeleteWayPoint(k)
					  end
					  if mouseButt["Middle"] and k > 0 and k < Pindex - 1 and not wasMouseButtM
					  then SplitPath(k)
					  end
				 end
			else --selected = false
				Pselection[k] = false
			end

			--Canvas.DrawText(x, y+36, tostring(Pselection[k]).."\n"..tostring(ind))
		end
		
		
		
	end
	selected = false
	for k,v in pairs(PointsX) do
		if Pselection[k]
		then selected = true
		end
	end 
	
	
	if ind ~= nil-- and Pselection[ind]
	then dmx = mouseX - oldMouseX
		dmy = mouseY - oldMouseY
		PointsX[ind] = PointsX[ind] + dmx
		PointsY[ind] = PointsY[ind] + dmy
		selected = true
	else --selected = false
	end
	
	--Canvas.DrawText(0,32, tostring(selected))
	--Canvas.DrawText(0,48, tostring(Pindex))
	wasMouseButtL = mouseButt["Left"]
	wasMouseButtM = mouseButt["Middle"]
	oldMouseX = mouseX
	oldMouseY = mouseY

	Canvas.Refresh()
end

while true do

	local old_in = {};
	
	f = emu.framecount();
	
	if f_old ~= f then done = false; end;
	
	f_old = f;
	
	--MarkerControl()
	DrawCanvas()

	if StartFlag and not PauseFlag and not done and not emu.islagged()
	then --tastudio.setrecording(true)
		 CreateInput()
	else --tastudio.setrecording(false)
	end

	done = true
	
	inget = input.get()
	
	if not fromAddSub then 
	if inget.R == true
	then Add()
	elseif inget.E == true
		then Sub()
	end
	end
	
	if emu.framecount() < movie.length()
	then old_in = movie.getinput(emu.framecount()) 
		 joypad.set(old_in)
	end
	
	if fromAddSub == true
	then client.unpause()
		 if emu.framecount() >= lastf
		 then client.pause()
			  fromAddSub = false
		 end
	end

	emu.yield()

end

function Main()

	f = emu.framecount();
	
	if f_old ~= f then done = false; end;
	
	f_old = f;

	if StartFlag and not PauseFlag and not done
	then CreateInput()
	end

	done = true

end

--event.onloadstate(Main)
--event.onframestart(Main)
--event.oninputpoll(Main)

