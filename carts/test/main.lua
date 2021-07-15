lane_borders={
	{x1=62,y1=59,x2=37,y2=0},-- nw/n
	{x1=65,y1=59,x2=90,y2=0},-- n/ne
	{x1=68,y1=62,x2=127,y2=37},-- ne/e
	{x1=68,y1=65,x2=127,y2=90},-- e/se
	{x1=65,y1=68,x2=90,y2=127},-- se/s
	{x1=62,y1=68,x2=37,y2=127},-- s/sw
	{x1=59,y1=65,x2=0,y2=90,},-- sw/w
	{x1=59,y1=62,x2=0,y2=37},-- w/nw
}

obs={}
function create_obs(l,r)
	local ldir=lane_borders[l]
	local rdir=lane_borders[r]

	local ld={x=ldir.x1-ldir.x2,y=ldir.y1-ldir.y2}
	local rd={x=rdir.x1-rdir.x2,y=rdir.y1-rdir.y2}
	
	local new_obs={
		col=24,
		verts={
			ldir.x1,
			ldir.y1,
			rdir.x2,
			rdir.y2
		}
	}

	new_obs.update=function()
		new_obs.verts[1] = new_obs.verts[1] - (1/100)*ld.x
		new_obs.verts[2]-=(1/100)*ld.y
		
		new_obs.verts[3]-=(1/100)*rd.x
		new_obs.verts[4]-=(1/100)*rd.y
	end
		
	new_obs.draw=function()
			--render_poly(new_obs.verts, new_obs.col)
			line(
				new_obs.verts[1],
				new_obs.verts[2],
				new_obs.verts[3],
				new_obs.verts[4],
				new_obs.col)
	end
	
	obs[#obs+1]=new_obs
end

function _init()
	create_obs(2,3)
end

function drawbackground(col)
	-- center
	line(62,59,65,59,col)-- n
	line(65,59,68,62,col)-- ne
	line(68,62,68,65,col)-- e
	line(68,65,65,68,col)-- se
	line(62,68,65,68,col)-- s
	line(62,68,59,65,col)-- sw
	line(59,62,59,65,col)-- w
	line(59,62,62,59,col)-- nw

	-- dividers
	foreach(lane_borders,
		function(div)
			line(div.x1,div.y1,div.x2,div.y2,col)
		end
	)

	-- outer
	line(37,0,90,0,col)-- n
	line(90,0,127,37,col)-- ne
	line(127,37,127,90,col)-- e
	line(127,90,90,127,col)-- se
	line(90,127,37,127,col)-- s
	line(37,127,0,90,col)-- sw
	line(0,90,0,37,col)-- w
	line(0,37,37,0,col)-- nw
end

--function draw_small_obs()
--	render_poly({10, 10, 20, 10, 20, 29}, 7)
--end

function _update()
	--px-=(1/100)*d.x
	--py-=(1/100)*d.y
	--if px>dir.x2 then px = dir.x1 end
	--if py<dir.y2 then py = dir.y1 end
	foreach(obs, function(o)
		o:update()
	end)
end

function _draw()
	cls(0)
	--draw_small_obs()
	foreach(obs, function(o)
		o:draw()
	end)
	drawbackground(7)

	--pset(dir.x1,dir.y1,24)
	--pset(px,py,15)
end