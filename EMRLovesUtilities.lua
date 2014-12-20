require 'lib/lutil/util'

------------------
-- MATH ----------
------------------

function math.bounce(direction, dx, dy) return math.abs(dx) > math.abs(dy) and math.atan2(math.sin(direction), -math.cos(direction)) or (math.abs(dx) < math.abs(dy) and math.atan2(-math.sin(direction), math.cos(direction)) or math.atan2(-math.sin(-direction), math.cos(-direction))) end
--self.dir = math.bounce(self.dir, dx, dy)

------------------
-- RAND WEIGHTS --
------------------

WeightedRandom = class()

function WeightedRandom:init(weights, sum)
	self.weights = weights
	table.shuffle(self.weights)
	self.sum = sum or 1
end
--creates a weighted table for weighted random selections.
--self.weights = WeightedRandom({{1, .1}, {2, .2}, {3, .3}}, .1 + .2 + .3)

function WeightedRandom:pick(x)
	local picked = {}
	local x = x or 1
	for i = 1, x do
		local r = love.math.random() * self.sum
		for _, t in ipairs(self.weights) do
			local entry, chance = t[1], t[2]--unpack(t)
			if r < chance then
				table.insert(picked, entry)
				break
			else
				r = r - chance
			end
		end
	end

	return picked
end
--picks x items from the weighted table and returns a table of the items. can repeat.

------------------
-- TABLE ---------
------------------

function table.random(t)
	local weights = {}
	table.each(t, function(v, k) table.insert(weights, {v, 1 / #t}) end)
	local weightedRand = WeightedRandom(weights)
	return weightedRand:pick()[1]
end
--picks and returns 1 random item from the given table.

------------------
-- LOVE MOUSE ----
------------------

function love.mouse.inBox(bx, by, bw, bh)
	local mx, my = love.mouse.getX(), love.mouse.getY()
	return mx >= bx and mx <= bx + bw and my >= by and my <= by + bh
end
--returns true if the mouse is within the bounds of a box, inclusive. false otherwise.

function love.mouse.isDownPausing(button)
	return not paused and love.mouse.isDown(button)
end
--returns true if the button is down and the game is not paused. Requires global 'paused'


------------------
-- LOVE KEYBOARD -
------------------

function love.keyboard.isDownPausing(key)
	return not paused and love.keyboard.isDown(key)
end
--returns true if the key is down and the game is not paused. Requires global 'paused'


------------------
-- LOVE GFX ------
------------------

function love.graphics.drawBar(bx, by, bw, bh, bv, bd, br)
	local segmenti = 0
	local segmentl = 0
	if br then
		--vertical
		segmentl = bh / bd
		while bv >= 1 / bd do
			love.graphics.rectangle('fill', bx, by + segmenti * segmentl, bw, segmentl - 1)
			bv = bv - 1 / bd
			segmenti = segmenti + 1
		end
		if bv > 0 then love.graphics.rectangle('fill', bx, by + segmenti * segmentl, bw, bh * bv) end
	else
		--horizontal
		segmentl = bw / bd
		while bv >= 1 / bd do
			love.graphics.rectangle('fill', bx + segmenti * segmentl, by, segmentl - 1, bh)
			bv = bv - 1 / bd
			segmenti = segmenti + 1
		end
		if bv > 0 then love.graphics.rectangle('fill', bx + segmenti * segmentl, by, bw * bv, bh) end
	end
end
--for a vertically oriented bar with 5 segments, do:
--love.graphics.drawBar(x, y, width, height, ratio from 0 to 1, 5, true if vertical)