pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--subpar octagon
--by brian sweet

--Game
--player table
local plr={}

--lane borders
local lbs={}

--obstacles
local obs={}

--center points
local cps={
  {x=65,y=62},-- +/+
  {x=65,y=65},-- +/-
  {x=62,y=65},-- -/-
  {x=62,y=62},-- -/+
}

--end points
local eps={
  {x=90,y=0},--n/ne
  {x=127,y=37},--ne/e
  {x=127,y=90},--e/se
  {x=90,y=127},--se/s
  {x=37,y=127},--s/sw
  {x=0,y=90},--sw/w
  {x=0,y=37},--w/nw
  {x=37,y=0},--nw/n
}

--lanes
local lns={
  {l=1,r=2},--n
  {l=2,r=3},--ne
  {l=3,r=4},--e
  {l=4,r=5},--se
  {l=5,r=6},--s
  {l=6,r=7},--sw
  {l=7,r=8},--w
  {l=8,r=1},--nw
}

function _init()
  gen_plr()
  for i=1, 4, 1 do
    lbs[#lbs+1] = {
      s={x=cps[i].x,y=cps[i].y,},
      e={x=eps[i+(i-1)].x,y=eps[i+(i-1)].y}
    }
    lbs[#lbs+1] = {
      s={x=cps[i].x,y=cps[i].y,},
      e={x=eps[i*2].x,y=eps[i*2].y}
    }
  end
end

function _update60()
  plr.update()
  if time()%0.25==0 then
    local ln=lns[flr(rnd(#lns)+1)]
    gen_ob(ln.l,ln.r)
  end
  foreach(obs, function(ob)ob:update() end)
end

function _draw()
  cls(0)
  plr.draw()
  foreach(obs, function(ob) ob:draw() end)
  draw_bg(7)
end

-- shape draw algoriths
-- draws a filled convex polygon
-- v is an array of vertices
-- {x1, y1, x2, y2} etc
function render_poly(v,col)
 col=col or 5

 -- initialize scan extents
 -- with ludicrous values
 local x1,x2={},{}
 for y=0,127 do
  x1[y],x2[y]=128,-1
 end
 local y1,y2=128,-1

 -- scan convert each pair
 -- of vertices
 for i=1, #v/2 do
  local next=i+1
  if (next>#v/2) next=1

  -- alias verts from array
  local vx1=flr(v[i*2-1])
  local vy1=flr(v[i*2])
  local vx2=flr(v[next*2-1])
  local vy2=flr(v[next*2])

  if vy1>vy2 then
   -- swap verts
   local tempx,tempy=vx1,vy1
   vx1,vy1=vx2,vy2
   vx2,vy2=tempx,tempy
  end 

  -- skip horizontal edges and
  -- offscreen polys
  if vy1~=vy2 and vy1<128 and
   vy2>=0 then

   -- clip edge to screen bounds
   if vy1<0 then
    vx1=(0-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
    vy1=0
   end
   if vy2>127 then
    vx2=(127-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
    vy2=127
   end

   -- iterate horizontal scans
   for y=vy1,vy2 do
    if (y<y1) y1=y
    if (y>y2) y2=y

    -- calculate the x coord for
    -- this y coord using math!
    x=(y-vy1)*(vx2-vx1)/(vy2-vy1)+vx1

    if (x<x1[y]) x1[y]=x
    if (x>x2[y]) x2[y]=x
   end 
  end
 end

 -- render scans
 for y=y1,y2 do
  local sx1=flr(max(0,x1[y]))
  local sx2=flr(min(127,x2[y]))

  local c=col*16+col
  local ofs1=flr((sx1+1)/2)
  local ofs2=flr((sx2+1)/2)
  memset(0x6000+(y*64)+ofs1,c,ofs2-ofs1)
  pset(sx1,y,c)
  pset(sx2,y,c)
 end 
end

function gen_plr()
  plr={x=0,r=0.75,col=12,v={0,0,0,0},}
  
  plr.draw=function()
    sspr(plr.x,0,8,8,63+cos(plr.r)*50,63+sin(plr.r)*50)
  end

  plr.update=function()
    if btnp(0) then
      plr.x+=8
      if plr.x>=64 then plr.x=0 end
      plr.r-=45/360
    end
    if btnp(1) then
      plr.x-=8
      if plr.x<=-8 then plr.x=56 end
      plr.r+=45/360
    end
  end
end

--generate new obstacle
function gen_ob(l,r)
  local left=lbs[l]
  local right=lbs[r]
  local ob={s=0.1,e=0,col=8,v={0,0,0,0}}

  ob.update=function()
    ob.s+=0.01
    ob.v[1]=point_on_line(left.s,left.e,min(1,ob.s))
    ob.v[2]=point_on_line(right.s,right.e,min(1,ob.s))

    ob.e+=0.01
    ob.v[3]=point_on_line(left.s,left.e,min(1,ob.e))
    ob.v[4]=point_on_line(right.s,right.e,min(1,ob.e))
  
    if ob.s>=1.1 then del(obs,ob) end
  end
    
  ob.draw=function()
    render_poly({
      ob.v[3].x,ob.v[3].y,
      ob.v[4].x,ob.v[4].y,
      ob.v[2].x,ob.v[2].y,
      ob.v[1].x,ob.v[1].y,
    },ob.col)
  end
  
  obs[#obs+1]=ob
end

--point on line at given percentage
function point_on_line(s,e,p)
  return {x=s.x*(1-p)+e.x*p,y=s.y*(1-p)+e.y*p}
end

function draw_bg(col)
  --draw center
  line(62,59,65,59,col)--n
  line(65,59,68,62,col)--ne
  line(68,62,68,65,col)--e
  line(68,65,65,68,col)--se
  line(62,68,65,68,col)--s
  line(62,68,59,65,col)--sw
  line(59,62,59,65,col)--w
  line(59,62,62,59,col)--nw

  --draw lane borders
  foreach(lbs,
    function(lb)
      line(lb.s.x,lb.s.y,lb.e.x,lb.e.y,col)
    end
  )

  --draw outer border
  line(37,0,90,0,col)--n
  line(90,0,127,37,col)--ne
  line(127,37,127,90,col)--e
  line(127,90,90,127,col)--se
  line(90,127,37,127,col)--s
  line(37,127,0,90,col)--sw
  line(0,90,0,37,col)--w
  line(0,37,37,0,col)--nw
end

__gfx__
00077000000007707770000000077700777777770077700000000777077000000000000000000000000000000000000000000000000000000000000000000000
00733700007773377337700000733700733333370073370000077337733777000000000000000000000000000000000000000000000000000000000000000000
00733700777333377333377007333770733333370773337007733337733337770000000000000000000000000000000000000000000000000000000000000000
07333370733333707333333773333370073333700733333773333337073333370000000000000000000000000000000000000000000000000000000000000000
07333370733333707333333773333370073333700733333773333337073333370000000000000000000000000000000000000000000000000000000000000000
73333337073337707333377077733337007337007333377707733337077333700000000000000000000000000000000000000000000000000000000000000000
73333337007337007337700000777337007337007337770000077337007337000000000000000000000000000000000000000000000000000000000000000000
77777777000777007770000000000770000770000770000000000777007770000000000000000000000000000000000000000000000000000000000000000000
