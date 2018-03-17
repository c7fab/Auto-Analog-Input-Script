vx = 0;
vy = 0;

require("AutoInputAPI")

memory.usememorydomain("RDRAM")
function Draw()

	gui.drawText(0, 15, "XZv':"..XZSpeed2, 0xAAFFFFFF, 0x55000000);
	gui.drawText(0, 30, "XZv :"..player.velocity.horizontal, 0xAAFFFFFF, 0x55000000);
	gui.drawText(0, 45, "Ya  :"..player.rotation.y, 0xAAFFFFFF, 0x55000000);
	gui.drawText(0, 60, "XZva:"..XZSA, 0xAAFFFFFF, 0x55000000);
	gui.drawText(0, 75, "Xv:"..player.velocity.x, 0xAAFFFFFF, 0x55990000);
	gui.drawText(0, 90, "Yv:"..player.velocity.y, 0xAAFFFFFF, 0x55009900);   
	gui.drawText(0, 105, "Zv:"..player.velocity.z, 0xAAFFFFFF, 0x55000099);    
	gui.drawText(0, 125, "Xp:"..player.position.x, 0xAAFFFFFF, 0x55990000);
	gui.drawText(0, 140, "Yp:"..player.position.y, 0xAAFFFFFF, 0x55009900);
	gui.drawText(0, 155, "Zp:"..player.position.z, 0xAAFFFFFF, 0x55000099);
	gui.drawText(0, 170, "XZ:"..XZVector, 0xAAFFFFFF, 0x55999900);
	-- UxPosition = (math.cos(YAngle*math.pi/180));
	-- UyPosition = (math.sin(YAngle*math.pi/180));
	-- VxPosition = (math.cos((90+YAngle)*math.pi/180));
	-- VyPosition = (math.sin((90+YAngle)*math.pi/180));
	
	-- gui.drawLine(230, 90, (230+UxPosition*100), (90+UyPosition*100));
	-- gui.drawLine(230, 90, (230+VxPosition*100), (90+VyPosition*100));
	
	-- gui.drawText(0, 160, "Ux:"..UxPosition, 0xAAFFFFFF, 0x55999900)
	-- gui.drawText(0, 175, "Uy:"..UyPosition, 0xAAFFFFFF, 0x55990099)
	--gui.drawText(0, 190, "Vx:"..VxPosition, 0xAAFFFFFF, 0x55999900)
	--gui.drawText(0, 205, "Vy:"..VyPosition, 0xAAFFFFFF, 0x55990099)
	
	--dvx = XPosition + XSpeed;
	--dvy = ZPosition + ZSpeed;
	
	--vx = math.cos(45*math.pi/180) + dvx
	--vy = math.sin(45*math.pi/180) + dvy
	
	--v = math.sqrt(vx^2+vy^2)

	--gui.drawText(2, 170, vx.."; "..vy)
	--gui.drawText(2, 191, v);
	
	--gui.drawRectangle(149, 9, 163, 163, 0x00000000, 0x44000000);
	gui.drawLine(150, 90, 310, 90);
	gui.drawPixel(309, 89);
	gui.drawPixel(309, 91);
	gui.drawPixel(151, 89);
	gui.drawPixel(151, 91);
	gui.drawLine(230, 170, 230, 10);
	gui.drawPixel(229, 11);
	gui.drawPixel(231, 11);
	gui.drawPixel(229, 169);
	gui.drawPixel(231, 169);
	
	gui.drawLine(230, 90, 230+player.velocity.x*3, 90-player.velocity.z*3, 0xFFFF0000);
	
	gui.drawLine(230, 90, 230+XCoordYAngl, 90-YCoordYAngl, 0xFF00FF00);
	
	gui.drawLine(230, 90, 230+XCoordInAngl, 90-YCoordInAngl, 0xFF0000FF);

end

local function Player()

	player.position.x = memory.readfloat(0x174C2C, true);
	player.position.y = memory.readfloat(0x174C30, true);
	player.position.z = memory.readfloat(0x174C34, true);
	
	player.position.xOld = memory.readfloat(0x174C38, true)
	player.position.yOld = memory.readfloat(0x174C3C, true)
	player.position.zOld = memory.readfloat(0x174C40, true)
	
	player.velocity.x = memory.readfloat(0x174C4C, true);
	player.velocity.y = memory.readfloat(0x174C50, true);
	player.velocity.z = memory.readfloat(0x174C54, true);
	
	player.velocity.horizontal = memory.readfloat(0x174C68, true);
	
	player.rotation.y = memory.readfloat(0x174C64, true);
	
	player.collision.radius = memory.readfloat(0x174C74, true)
	player.collision.height = memory.readfloat(0x174C78, true)
	
	InAngle = memory.readfloat(0x18148C, true);
	
	XZSpeed2 = math.sqrt(player.velocity.x^2 + player.velocity.z^2);
	
	XZSA = (math.atan2(player.velocity.x, player.velocity.z)*(180)/math.pi - 90) % 360;
	
	XZVector = math.sqrt(player.position.x^2 + player.position.z^2)
	
	XCoordYAngl = math.floor(math.cos((player.rotation.y*math.pi)/180)*75);
	YCoordYAngl = -math.floor(math.sin((player.rotation.y*math.pi)/180)*75);
	XCoordInAngl = math.floor(math.cos((InAngle*math.pi)/180)*75);
	YCoordInAngl = -math.floor(math.sin((InAngle*math.pi)/180)*75);
	
	
	
end

local function Camera()

	camera.position.x = memory.readfloat(0x176940, true)
	camera.position.y = memory.readfloat(0x176944, true)
	camera.position.z = memory.readfloat(0x176948, true)
	
	camera.focus.x = memory.readfloat(0x17694C, true)
	camera.focus.y = memory.readfloat(0x176950, true)
	camera.focus.z = memory.readfloat(0x176954, true)
	
	camera.focus.target.x = memory.readfloat(0x176924,true)
	camera.focus.target.y = memory.readfloat(0x176928,true)
	camera.focus.target.z = memory.readfloat(0x17692C,true)
	
	camera.rotation.y = memory.readfloat(0x176920, true)
	camera.rotation.target.y = memory.readfloat(0x17691C, true)

end

local function Objects()

	for i = 0, 0x30, 1 do
	
		object.active = memory.read_u8(0x176AEB+0x174*i)
		
		object.position.x = memory.readfloat(0x176B0C+0x174*i, true)
		object.position.y = memory.readfloat(0x176B10+0x174*i, true)
		object.position.z = memory.readfloat(0x176B14+0x174*i, true)
		      
		object.velocity.x = memory.readfloat(0x176B18+0x174*i, true)
		object.velocity.y = memory.readfloat(0x176B1C+0x174*i, true)
		object.velocity.z = memory.readfloat(0x176B20+0x174*i, true)
		      
		object.rotation.y = memory.readfloat(0x176B78+0x174*i, true)
		      
		object.collision.radius = memory.readfloat(0x176B48+0x174*i, true)
		object.collision.height = memory.readfloat(0x176B4C+0x174*i, true)
		
		objects[i+1] = object
		
		--print(objects[i+1].position)
	end

end

settings.angle.offset = 90
settings.angle.modulo = 360
settings.deadzone.minimum = 0
settings.deadzone.maximum = 129
--event.onframeend(Draw)

while true do
	
	Player()
	Camera()
	Objects()
	
	emu.frameadvance();
	
end