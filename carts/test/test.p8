pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
bullets={}
x=64 y=64 r=0
function newbullet()
	r+=0.05
	if (r>1) then r=0 end
	add(bullets, {
		x=x,y=y,
		dx=sin(r)*2,
		dy=cos(r)*2
	})
end
function drawbullets()
  foreach(bullets, function(b) pset(b.x,b.y,7) end)
end
function updatebullets()
	foreach(bullets, 
		function(b)
  			b.x += b.dx
  			b.y += b.dy
  			if b.x < -20 or b.x > 130
  				or b.y < -20 or b.y > 130
  			then del(bullets,b) end
		end
	)
end
function overlap(a,b)
	return not (a.x>b.x+b.w 
		   or a.y>b.y+b.h 
		   or a.x+a.w<b.x 
		   or a.y+a.h<b.y)
end
function input()
	if (btn(0) and x > 0) x -= 1
	if (btn(1) and x < 127) x += 1
	if (btn(2) and y > 0) y -= 1
	if (btn(3) and y < 127) y += 1
end
function _update60()
	updatebullets()
	input()
	if (time()%0.5 == 0) then newbullet() end
end
function _draw()
	cls(5)
	circfill(x, y, 7, 14)
	drawbullets()
end

__gfx__
01230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
89ab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdef0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
