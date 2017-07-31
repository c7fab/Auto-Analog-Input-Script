# Auto-Analog-Input-Script
For BizHawk (TAStudio only)


Right now the script is in development, don't use it for serious TASing. Many things are broken and don't work right, also the script is undocumented spaghetti code.


How to use:

First time using:

	-Type in the memory addresses for horizontal position of the player.

	-Type in the memory address for movement angle of the player.

	-Type in the memory address for camera angle of the camera, leave it empty if the game doesn't use a rotating camera.

	-Type in the offset for the analog stick angle in the unit system the game uses.

	-Pick the unit system for the angles in the game.

	-Type in controller deadzones, if unsure leave it as is.

After clicking "Done" a file called <romname>.ais will be in your Lua folder. This file will be used to get the settings for later uses.


Main use:

Using the canvas:

	-Drag the view by holding right mouse button and moving mouse courser.
	
	-The red circle and lines are at player position, the value on bottom indicates X position, the value on left Y Position.
	
	-The grey lines are the origin.
	
	-The values on the top-left show the position of the mouse courser.
	
	-Click "Edit Mode" to switch to editing the path. Click again to stop editing the path.
	
	-Left click anywhere on the canvas and a new point will be created. Two if it is the first point.
	
	-Hover mouse courser over a point, except original red point, and click and hold left mouse button and move mouse courser to change the position of the point.
	
	-Hover mouse courser over a point, except original red point, and click right mouse button to delete the point. Clicking on the original point will delete all.
	
	-Hover mouse courser over a point, except last point, and click middle mouse button to split the next line.
	
Using the main form:

	-Check one of the checkboxes or none to use the canvas and type in numbers. Angle in the unit system the game uses
	
	-Type in the radius for the analog stick, if unsure: minimum=127, maximum=182
	
	-Click "Start" to start moving the player, "Stop" to stop moving the player. "Pause" is not working
	
	-Select a frame in TAStudio and have the playback courser after the selection courser and click "+" or "-" to increment or decrement the current stick angle. If the values look weird it's because the line drawing algorithm produces more accurate angles than trigonomy for integers. It's also possible to hit "R" and "E" on keyboard to archive the same
	
	-Two stepping is not implemented
	
