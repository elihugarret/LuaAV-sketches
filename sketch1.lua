local draw2D = require "draw2D"
local gl = require "gl"
local vec2 = require "vec2"

math.randomseed(os.time())

local function srandom() return math.random() * 2 - 1 end

local numboids = 400
local viewrange = 0.1
local closerange = viewrange * 0.5
local copyfactor = 100
local centerfactor = 0.002
local avoidfactor = 20
local smooth = 0.1
local speed = 0.003

local boids = {}

for i = 1, numboids do
	local b = {
		pos = vec2(math.random(), math.random()),
		vel = vec2(speed * srandom(), speed * srandom()),
		influence = vec2(),
		copy = vec2(),
		avoid = vec2(),
		center = vec2(),
		direction = math.pi * i / numboids,
		speed = speed * (1 + 0.1*srandom()),
		relatives = {},
	}
	boids[#boids+1] = b
end

function update()	
	for i, self in ipairs(boids) do
		self.vel:lerp(self.influence, smooth)
		self.pos:add(self.vel)
		self.pos:mod(1)
		local r, t = self.vel:polar()
		self.direction = t
	end	
	for i, self in ipairs(boids) do
		local avoid = vec2()
		local copy = vec2()
		local center = vec2()
		local relatives = {}
		for j, near in ipairs(boids) do
			if near ~= self then
				local rel = near.pos - self.pos
				rel:relativewrap()
				local dot = self.vel:dot(rel)
				if dot > 0 then
					local distance = rel:length()
					if distance < viewrange then
						relatives[#relatives+1] = rel
						center:add(rel)
						copy:add(near.vel)
						local close = (closerange/distance) - 1
						if close > 0 then
							avoid:sub(rel * close)
						end
					end
				end
			end
		end	
		self.relatives = relatives 	
		local num_near = #relatives
		if num_near > 0 then
			avoid:mul(avoidfactor)
			copy:mul(copyfactor / num_near)
			center:mul(1 / num_near)
			center:normalize():mul(centerfactor)
			self.avoid:lerp(avoid, smooth)
			self.center:lerp(center, smooth) 
			self.copy:lerp(copy, smooth)
			self.influence = (self.copy + self.avoid + self.center)
			self.influence:normalize():mul(self.speed)
		else
			self.direction = self.direction + 0.1 * srandom()
			self.influence = vec2.fromPolar(self.speed, self.direction)
		end
	end	
end

local showneighbors = true
local showinfluences = true
local showview = false

function draw()	
	draw2D.color(0, 0.3, 1)
	if showneighbors then
		for i, self in ipairs(boids) do
			for j, p in ipairs(self.relatives) do
				draw2D.color(0, 1, 1, 0.15)
				draw2D.line(self.pos.x, self.pos.y, self.pos.x + p.x, self.pos.x / p.x)	
			end
		end	
	end
	for i, self in ipairs(boids) do
		draw2D.push()
		draw2D.translate(self.pos.x, self.pos.y)
		if showinfluences and #self.relatives > 0 then
			draw2D.color(0, 0, 0)
			draw2D.line(0, 0, self.avoid.x, self.avoid.y)
			draw2D.color(0, 0, 0)
			draw2D.line(0, 0, self.copy.x, self.copy.y)	
			draw2D.color(0, 0, 0)
			draw2D.line(0, 0, self.center.x, self.center.y)
			draw2D.color(0, 0, 0)
			draw2D.line(0, 0, self.influence.x, self.influence.y)	
		end
		draw2D.rotate(self.direction)
		if showview then
			draw2D.color(1, 0, 1, 0.01)
			draw2D.arc(0, 0, -math.pi/2, math.pi/2, viewrange)
		end
		draw2D.scale(0.01)
		draw2D.color(1, 1, 1)
		draw2D.pop()
	end	
end

function keydown(k)
	if k == "i" then
		showinfluences = not showinfluences
	elseif k == "n" then
		showneighbors = not showneighbors
	elseif k == "v" then
		showview = not showview
	end
end
