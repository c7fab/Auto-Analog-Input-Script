# Auto-Analog-Input-Script
For BizHawk (TAStudio only)

[CLick here for a demonstration](https://www.youtube.com/watch?v=3_EKGR7o780)

Right now the script is in development, don't use it for serious TASing. Many things are broken and don't work right, also the script is undocumented spaghetti code.


# How to use

## First time using

* Type in the memory addresses for horizontal position of the player.
* Type in the memory address for movement angle of the player.
* Type in the memory address for camera angle of the camera, leave it empty if the game doesn't use a rotating camera.
* Type in the offset for the analog stick angle in the unit system the game uses.
* Pick the unit system for the angles in the game.
* Type in controller deadzones, if unsure leave it as is.

After clicking "Done" a file called <romname>.ais will be in your Lua folder. This file will be used to get the settings for later uses.

## Main use

### Using the canvas

* The red circle and lines are at player position, the value on bottom indicates X position, the value on left Y Position.
* The grey lines are the origin (0,0,0) of the level.
* The light green circles show objects positions.
* The triangles show level collision.
* The black triangle shows the camera.
* The values on the top-left show the position of the mouse courser and zoom factor.
* The red and green dots show the waypoints, the first one is red.
* Drag the view by holding right mouse button and moving mouse courser.
* Hold "XButton1" mouse button to zoom in, "XButton2" to zoom out.
* Hover over the items on the status strip on the bottom to get information what it does when clicking it.
  * Click on "Toggle Follow Player" to toggle between automatically following the player or not.
  * Click on "Reset View to Player" to center the player into the canvas view.
  * Click on "Zoom In" to zoom in.
  * Click on "Zoom Out" to zoom out.
  * Click on "Reset Zoom" to reset the zoom to one.
  * Click on "Toggle Map Display" to set wheter the map should be displayed or not. Values are "yes", "no" and "auto". "auto" only displays the map if the emulator is paused.
* In "View Mode" click on a waypoint to jump to that waypoint. Does not work if the waypoint was never visited.
* Click "Edit Mode" to switch to editing the path. Click again to stop editing the path.
* Left click anywhere on the canvas and a new point will be created. Two if it is the first point.	
* Hover mouse courser over a point, except original red point, and click and hold left mouse button and move mouse courser to change the position of the point.
* Hover mouse courser over a point, except original red point, and click right mouse button to delete the point. Clicking on the original point will delete all.
* Hover mouse courser over a point, except last point, and click middle mouse button to split the next line.
* It's possible to edit the points even if the script is running. The current waypoint will be updated accordingly.
* Right click without moving the courser opens the right-click menu. Not correctly implemented yet

### Using the main form

* Check one of the checkboxes or none to use the canvas and type in numbers. Angle in the unit system the game uses
* Type in the radius for the analog stick, if unsure: minimum=127, maximum=182
* Click "Start" to start moving the player, "Stop" to stop moving the player. "Pause" is not working
* Select a frame in TAStudio and have the playback courser after the selection courser and click "+" or "-" to increment or decrement the current stick angle. If the values look weird it's because the line drawing algorithm produces more accurate angles than trigonomy for integers. It's also possible to hit "R" and "E" on keyboard to archive the same
* Two stepping is not implemented
* Press "I" on the keyboard to set frames to ignore for input calculation, "O" to unset.

### Using the Lua API

* Make sure all scripts are in the same folder.
* Initialize the game script with require("AutoInputAPI").
* Look into the AutoInputAPI.lua file to see what variables can be used.
* Set the player variables with player._group_._subgroup_.item = memory.read_type_(int address_, bool endian_)
  * E.g.: player.position.x = memory.readfloat(0xABCDEF, true)
* Set the camera variable with camera._group_._subgroup_.item = memory.read_type_(int address_, bool endian_)
  * E.g.: camera.position.x = memory.readfloat(0x123456, true)
* To set objects, first empty the objects with objects = {} before running through a loop and setting the variables into the table.
* In the loop make a new table with the same contents as the object table in the AutoInputAPI.lua file. 
* Set the object variables with newtablename._group_._subgroup_.item = memory.read_type_(int address + int size * int slot_, bool endian_)
  * E.g.: o.position.x = memory.readfloat(0x234567+0x100*i, true)
* At the end in the loop set the new table to the objects table with objects(int slot+1) = newtablename.
  * E.g.: objects(i+1) = o
* To set level collision, first empty the maps with maps = {} before running through a loop and setting the variables into the table.
* In the loop make a new table with the same contents as the map table in the AutoInputAPI.lua file.
* Set the map variables with newtablename._group_._subgroup_.item = memory.read<type>(pointer address + int slot_, bool endian_)
  * E.g.: mp.position.x = memory.readfloat(address + 48, true)
* Make a nested loop and make a new table with the same contents as the polygon table in the AutoInputAPI.lua file.
* Calculate the relative positions for the vertices, middle point and color of the polygon in the nested loop and set the polygon variables with newtablename.item = value.
  * E.g.: ply.dx1 = dx1.
* At the end in the nested loop set new polygon to the new map table.
  * E.g.: mp.polygons[j+1] = ply
* At the end of the main looop set the map into the maps table.
  * E.g.: maps[i+1] = mp
* Update the pointer.
* Look into the provided game script to get help with setting the variables.

# TODOs

* Implement Pause() function properly. Pressing the Pause button should save current frame number, current waypoint goal, current waypoint list and current input (as saving a branch). The script then should stop calculating any input. If the user then clicks the Pause button again, it should set the saved variables and continue from the point when it was paused. 
* Fix dragging a waypoint. Right now the focus jumps to another point if two point the mouse courser moves over another point. 
* Fix zooming: If the player is not being followed zoom into where the mouse courser is or into the center of the window if the status strip buttons are used.  
* Implement undo for deleting waypoint and moving waypoint. 
* Insert new point for splitting path at the yellow highlighted line segment. 
* Make a table/list in the main form of the waypoints list for viewing and editing points of the waypoints list. Content of that table/list should be: Index; X position; Y position; Global angle between current point and the next point; Angle between the lines of previous point to current point and current point to next point; Lenght of current point to next point. 
* Multiplayer support. 
* Improve the path following algorithm. The player coordinates should be always as close as posible to a line. If the angles are very tight, curve the path instead. 
* Setting control stick radius for each waypoint individually. 
* Add Circle segments and bezier curves as trajectory to follow. 
* Improve the above and recalculate waypoint depending on the hitbox radius of player and objects.
* Setting conditions if buttons should be pressed or not (i.e. auto-jumping), asign multiple button combinations to test; Set if a waypoint should be ignored under specific conditions, stop ignoring the waypoint if the condition becomes false. These are also drawn into the canvas, more specifically on the lines between waypoint. For example the player goes from A to B and there's a wall in between which the player can jump over, the user will set a "point" or a region (point is a region, the player doesn't need to be exactly on the point) with the condition "if on ground then press A for n frames". If the script then comes at this point it automatically presses A. The user can also specify if n is a constant or not. If the user has set a region it will test different frames to start pressing A.
* Images for status strip buttons: 15x15px. Make images for "toggle follow player on/off", "reset view to player", "view next/previous/current waypoing", "zoom in", "zoom out", "reset zoom", "display objects on/off/auto", "display map on/off/auto"

# Warnings

* Do not do undo branch deletion in TAStudio!














	



