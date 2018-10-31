-- API to be used from other scripts

settings = {angle = {offset, modulo},
			deadzone = {minimum, maximum}
		   }

player = {position = {x, y, z, previous = {x, y, z}
		 },
		  velocity = {x, y, z, horizontal, vertical}, 
		  rotation = {x, y, z, yaw, pitch, roll},
		  collision = {radius, height},
		  flags = {ground}
		 }
		  
camera = {position = {x, y, z, target = {x, y, z}
					 },
		  focus = {x, y, z,  target = {x, y, z}
				  },  
		  rotation = {x, y, z, yaw, pitch, roll,
					  target = {x, y, z, yaw, pitch, roll}
					 }
		 }

objects = {}
  
object = {name, active, group,
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
		 
maps = {}

polygon = {
		   dx1, dy1, dz1,
		   dx2, dy2, dz2,
		   dx3, dy3, dz3,
		   mx, my, mz,
		   color
		  }


map = {position = {x, y, z},
	   box = {x1, y1, z1, x2, y2, z3
			 },
	   polygons = {
				  }
	  }
	  


function SetObjects(obj, ind)

	objects[ind] = obj
	--print(tostring(objects[ind].position.x))
	
end