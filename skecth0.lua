local draw2D = require "draw2D"
local vec2 = require "vec2"

math.randomseed(os.clock())

local f1 = function(p) return p:add(vec2(0, 0.2)):rotate(10.4):mul(0.3) end
local f2 = function(p) return p:add(vec2(0, 0.2)):rotate(-0.4):mul(0.3) end
local f3 = function(p) return p:add(vec2(0.2, 0.4)):rotate(0.09):mul(0.6) end
local f4 = function(p) return p:add(vec2(0.2, 0.2)):rotate(0.7):mul(0.3) end

local transforms = { f1, f2, f3, f4 }

function plot()
	for i = 1, 1000 do
		local p = vec2(math.random(), math.random())
		for j = 1, 100 + math.random(1000) do
			local rule = transforms[math.random(#transforms)]
			p = rule(p)
		end
		draw2D.color(0, 1, 0.9, 0.11)
		draw2D.line(p.x, p.y, p.y, p.x)
		draw2D.line(p.x, p.y, -p.y, p.y)
	end
end

function draw()
	draw2D.translate(0.5, 0.3)
	plot()
end
