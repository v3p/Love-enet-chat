local config = {
		x = 12,
	}

console = {
		text = "",
		input = "",
		font = love.graphics.newFont(16),
		x = 6,
		y = 6, --offset from bottom not real position.
		lines = 0
	}
	

function console:textInput(text)
	self.input = self.input..text
end

function console:keypressed(key)
	if key == "backspace" then
		self.input = self.input:sub(1, -2)
	elseif key == "return" then
		if #self.input > 0 then
			self:cmd()
		end
	end
end

function console:print(t)
	if #self.text > 0 then
		self.text = self.text.."\n"..t
	else
		self.text = self.text..t
	end
	self.lines = 0
	for _ in self.text:gmatch('\n') do
		self.lines = self.lines + 1
	end
end

function console:cmd()
	local t = split(self.input)
	self.input = ""
	
	if t[1] == "quit" then
		love.event.push("quit")
	elseif t[1] == "start" then
		
	else
		console:print("Unknown command")
	end
end

function console:draw()
	love.graphics.setColor(32, 32, 32)
	love.graphics.setFont(self.font)
	--love.graphics.rectangle("fill", 0, (screen.height - love.graphics.getFont():getHeight()) - self.y, screen.width, love.graphics.getFont():getHeight())
	love.graphics.setColor(200, 200, 200)
	love.graphics.print(self.input, self.x, (screen.height - love.graphics.getFont():getHeight()) - self.y)
	love.graphics.setColor(100, 100, 100)
	love.graphics.print(self.text, self.x, screen.height - (self.y * 8) - (love.graphics.getFont():getHeight() * self.lines))
end

function split(str)
  local t = {}
	str:gsub("([^ ]+)", function(c) t[#t+1] = c end)
  return t
end