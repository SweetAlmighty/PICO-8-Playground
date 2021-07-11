function drawbackground(linecol)
	-- small
	line(62, 59, 65, 59, linecol) -- N
	line(65, 59, 68, 62, linecol) -- NE
	line(68, 62, 68, 65, linecol) -- E
	line(68, 65, 65, 68, linecol) -- SE
	line(62, 68, 65, 68, linecol) -- S
	line(62, 68, 59, 65, linecol) -- SW
	line(59, 62, 59, 65, linecol) -- W
	line(59, 62, 62, 59, linecol) -- NW

	-- dividers
	line(65, 59, 90, 0, linecol)   -- N/NE
	line(68, 62, 127, 37, linecol) -- NE/E
	line(68, 65, 127, 90, linecol) -- E/SE
	line(65, 68, 90, 127, linecol) -- SE/S
	line(62, 68, 37, 127, linecol) -- S/SW
	line(59, 65, 0, 90, linecol)   -- SW/W
	line(59, 62, 0, 37, linecol)   -- W/NW
	line(62, 59, 37, 0, linecol)   -- NW/N

	-- large
	line(37, 0, 90, 0, linecol)     -- N
	line(90, 0, 127, 37, linecol)   -- NE
	line(127, 37, 127, 90, linecol) -- E
	line(127, 90, 90, 127, linecol) -- SE
	line(90, 127, 37, 127, linecol) -- S
	line(37, 127, 0, 90, linecol)   -- SW
	line(0, 90, 0, 37, linecol)     -- W
	line(0, 37, 37, 0, linecol)     -- NW
end
function _draw()
	cls(0)	
	drawbackground(7)
end
