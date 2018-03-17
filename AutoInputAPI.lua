-- API to be used from other scripts

settings = {angle = {offset, modulo},
			deadzone = {minimum, maximum}
		   }

player = {position = {x, y, z, xOld, yOld, zOld}, 
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

