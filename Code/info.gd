extends Node

#screen size 1152 x 648

#.005 AU per 512 pixels (on drive)
#0.00000976562 AU per pixel (on drive)
#2.4h per irl minute
#0.04 min per irl second

#big bugs:
#Music stops after holding B and entering a new scene (probably because the let go script isn't ran)
#Complete dreadnought boss
#Use TextureProgressBar to amplify HUD
	#Solar
	#CrudSol
	#Clock (complete hud as followed):
		#fix sprite
		#Lower = Frame 2
		#Top = Frame 1 (finishes rotation weekly)
		#Progress = Frame 3 (finishes rotation daily; full blackhole = 0:00, full sun = 12:00)
