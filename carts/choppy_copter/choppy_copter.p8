pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--choppy copter
--by brian sweet

--Game
plr={
  spd=1,
  x=63,
  y=63
}
pipes={
  {x=129,y=0,w=20,h=40},
  {x=129,y=107,w=20,h=40}
}
gvy=0.3
jmp_spd=-4.5

function _init()
end

function _update()
  plr.spd+=gvy
  plr.y+=plr.spd
  
  foreach(pipes, function(v) v.x-=1 if v.x + v.w+1 < 0 then v.x=129 end end)
  
  if btnp(4) then
    plr.spd=jmp_spd
  end
end

function _draw()
  cls()
  foreach(pipes, function(v) rect(v.x, v.y, v.x+20, v.y+40, 3) end)
  color(7)
  circ(plr.x, plr.y, 7)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
