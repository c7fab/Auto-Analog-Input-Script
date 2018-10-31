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
	
	player.position.previous.x = memory.readfloat(0x174C38, true)
	player.position.previous.y = memory.readfloat(0x174C3C, true)
	player.position.previous.z = memory.readfloat(0x174C40, true)
	
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
	objects = {}
	local size = memory.read_u32_be(0x252274)
	for i = 0, size, 1 do
	--i=0
		o = {name, active, group,
			position = {x, y, z
					   },
			velocity = {x, y, z, horizontal, vertical
					   },
			rotation = {x, y, z, yaw, pitch, roll
					   },
			collision = {radius, height
						},
			flags = {
					}
		 }
		o.active = memory.read_u8(0x176AEB+0x174*i)
		if o.active == 0 
		then o.active = nil
		end
		
		o.position.x = memory.readfloat(0x176B0C+0x174*i, true)
		o.position.y = memory.readfloat(0x176B10+0x174*i, true)
		o.position.z = memory.readfloat(0x176B14+0x174*i, true)
		 
		o.velocity.x = memory.readfloat(0x176B18+0x174*i, true)
		o.velocity.y = memory.readfloat(0x176B1C+0x174*i, true)
		o.velocity.z = memory.readfloat(0x176B20+0x174*i, true)
		 
		o.rotation.y = memory.readfloat(0x176B78+0x174*i, true)
		 
		o.collision.radius = memory.readfloat(0x176B48+0x174*i, true)
		o.collision.height = memory.readfloat(0x176B4C+0x174*i, true)
		
		--SetObjects(object, i+1)
		--objects[i+1] = object
		objects[i+1] = o
		--print(objects[i+1].active)
		--print(objects[i+1].position)
	end

end

function Level()
	maps = {}
	--Level objects
	local lvl_obj_list_size = memory.read_u32_be(0x249F20)
	local lvl_obj_list_ptr = 0x8024AAF8
	
	for i = 1, lvl_obj_list_size, 1 do
		
		mp = {position = {x, y, z},
			   box = {x1, y1, z1, x2, y2, z3},
			   polygons = {}
	          }
		
		local addr = memory.read_u32_be(lvl_obj_list_ptr-0x80000000) - 0x80000000
		
		local index = memory.read_u32_be(addr+0)
		local index2 = memory.read_u32_be(addr+4)
		
		local state = memory.read_u32_be(addr+12)

		local x_ = memory.readfloat(addr+24, true)
		local y_ = memory.readfloat(addr+28, true)
		local z_ = memory.readfloat(addr+32, true)
		
		local x = memory.readfloat(addr+48, true)
		local y = memory.readfloat(addr+52, true)
		local z = memory.readfloat(addr+56, true)
		
		mp.position.x = x
		mp.position.y = y
		mp.position.z = z
		
		local force_scale = memory.read_u32_be(addr+72)
		local parent = memory.read_u32_be(addr+76)
		local x_scale = memory.readfloat(addr+80, true)
		local y_scale = memory.readfloat(addr+84, true)
		local z_scale = memory.readfloat(addr+88, true)
		local scaled = memory.read_u32_be(addr+92)
		local rotation = memory.readfloat(addr+96, true)
		--Bounding Box
		local x1 = memory.readfloat(addr+204, true)
		local y1 = memory.readfloat(addr+208, true)
		local z1 = memory.readfloat(addr+212, true)
		local x2 = memory.readfloat(addr+216, true)
		local y2 = memory.readfloat(addr+220, true)
		local z2 = memory.readfloat(addr+224, true)
		
		mp.box.x1 = x1
		mp.box.y1 = y1
		mp.box.z1 = z1
		mp.box.x2 = x2
		mp.box.y2 = y2
		mp.box.z2 = z2
		
		local col_ptr = memory.read_u32_be(addr+228)
		local ver_ptr = memory.read_u32_be(addr+232)
		
		--local _max = y2
		--local _min = y1
		--local y_size = math.abs(_max-_min)
		
		local list_1_size = memory.read_u32_be(ver_ptr - 0x80000000)
		local list_2_size = memory.read_u32_be(ver_ptr+4 - 0x80000000)
		local list_1_start_ptr = memory.read_u32_be(ver_ptr+8 - 0x80000000) 
		local list_2_start_ptr = memory.read_u32_be(ver_ptr+12 - 0x80000000)
		local list_3_start_ptr = memory.read_u32_be(ver_ptr+16 - 0x80000000)
		
		for j = 0, list_2_size-1, 1 do--19-3
		
			local addr1 = (list_1_start_ptr - 0x80000000)
			local addr2 = (list_2_start_ptr - 0x80000000)+(j)*12

			local p1 = addr1 + memory.read_u32_be(addr2+0)*12
			local p2 = addr1 + memory.read_u32_be(addr2+4)*12						
			local p3 = addr1 + memory.read_u32_be(addr2+8)*12
			
			
			local dx1 = memory.readfloat(p1+0, true)
			local dy1 = memory.readfloat(p1+4, true)
			local dz1 = memory.readfloat(p1+8, true)
			local dx2 = memory.readfloat(p2+0, true)
			local dy2 = memory.readfloat(p2+4, true)
			local dz2 = memory.readfloat(p2+8, true)
			local dx3 = memory.readfloat(p3+0, true)
			local dy3 = memory.readfloat(p3+4, true)
			local dz3 = memory.readfloat(p3+8, true)
			local p_val
			if parent > 0x80000000
			then p_val = memory.read_u32_be(parent+72-0x80000000)
			end
			
			if scaled == 0 or force_scale == 2 or p_val == 2 --value from parent
			then dx1 = dx1 * x_scale
			     dy1 = dy1 * y_scale
			     dz1 = dz1 * z_scale
			     dx2 = dx2 * x_scale
			     dy2 = dy2 * y_scale
			     dz2 = dz2 * z_scale
			     dx3 = dx3 * x_scale
			     dy3 = dy3 * y_scale
			     dz3 = dz3 * z_scale
			end
			
			local mx=1/3*(dx1+dx2+dx3+3*x)
			local my=1/3*(dy1+dy2+dy3+3*y)
			local mz=1/3*(dz1+dz2+dz3+3*z)
				
			if math.abs(my) < 1000--(y_size)*3
			then red = 80
				 green = math.floor((255/1000)*math.abs(my))
				 blue = 255
			else red = 80
				 green = 180
				 blue = math.floor(-(255/1000)*math.abs(my)+510)
			end
			
			
			
			ply = {dx1, dy1, dz1,
				   dx2, dy2, dz2,
				   dx3, dy3, dz3,
				   mx, my, mz,
				   color
				  }
					  
			ply.dx1 = dx1 
			ply.dy1 = dy1 
			ply.dz1 = dz1 
			ply.dx2 = dx2 
			ply.dy2 = dy2 
			ply.dz2 = dz2 
			ply.dx3 = dx3 
			ply.dy3 = dy3 
			ply.dz3 = dz3 
			
			ply.mx = mx
			ply.my = my
			ply.mz = mz
			
			ply.color = 0x44000000+red*256*256+green*256+blue

					  
			mp.polygons[j+1] = ply
			
			--canv.DrawPolygon({{Xdraw-(xpos-(x+dx1))*Zoom,Ydraw-(zpos-(z+dz1))*Zoom},
			--			{Xdraw-(xpos-(x+dx2))*Zoom,Ydraw-(zpos-(z+dz2))*Zoom},
			--			{Xdraw-(xpos-(x+dx3))*Zoom,Ydraw-(zpos-(z+dz3))*Zoom}},0xFF000000, 0x44000000+red*256*256+green*256+blue)					
			--canv.DrawAxis(Xdraw-(xpos-mx)*Zoom, Ydraw-(zpos-mz)*Zoom, 2, 0xFF005555)			
								
		end
		
		maps[i+1] = mp	
		--canv.DrawAxis(Xdraw-(xpos-x)*Zoom, Ydraw-(zpos-z)*Zoom, 2, 0xFFFF0000)
		--canv.DrawText(Xdraw-(xpos-x)*Zoom, Ydraw-(zpos-z)*Zoom, string.format("%X",addr),0xFF000000,0xFFFFFFFF)
		--canv.DrawBox(Xdraw-(xpos-x1)*Zoom, Ydraw-(zpos-z1)*Zoom, Xdraw-(xpos-x2)*Zoom, Ydraw-(zpos-z2)*Zoom,0xFFFF0000)--, 0x55550022
		lvl_obj_list_ptr = lvl_obj_list_ptr + 4
	end
	
end

settings.angle.offset = 90
settings.angle.modulo = 360
settings.deadzone.minimum = 0
settings.deadzone.maximum = 129
event.onframeend(Draw)

while true do
	
	Player()
	Camera()
	Objects()
	Level()
	
	emu.yield();
	
end