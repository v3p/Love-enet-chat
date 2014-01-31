local config = {
		x = 12,
	}

	local cursor = "<"
	
console = {
		text = "",
		input = "",
		font = love.graphics.newFont(16),
		x = 6,
		y = 6, --offset from bottom not real position.
		lines = 0,
		history = {},
		_history = 0
	}
	

function console:textInput(text)
	--if #self.input > 0 then self.input = self.input:sub(1, -2) end
	self.input = self.input..text

end

function console:keypressed(key)
	if key == "backspace" then
		if #self.input > 0 then
			self.input = self.input:sub(1, -2)
			if #self.input > 1 then
				if self.input:sub(-1, -1):byte() >= 129 then 
					self.input = self.input:sub(1, -2)
					self.input = self.input..cursor
				end
			end
		end
	elseif key == "return" then
		if #self.input > 0 then
			self._history = #self.history + 1
			self:cmd()
		end
	elseif key == "up" then
		if #self.history > 0 then
			self.input = self.history[self._history]
			
			self._history = self._history - 1
			if self._history < 1 then self._history = 1 end
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
	self.history[#self.history + 1] = self.input
	self.input = ""
	
	if t[1] == "/quit" then
		love.event.push("quit")
	elseif t[1] == "/name" then
		if t[2] ~= nil then
			name = t[2]
			console:print("Name changed to "..t[2])
			_data[1] = t[2]
		else
			console:print("Usage: /name <name>")
		end
	elseif t[1] == "/connect" then
		if t[2] ~= nil and #name > 0 then
			ip = t[2]
			server = host:connect(ip)
			console:print("Connected to "..t[2])
			_data[2] = t[2]
		else
			if t[2] == nil then
				console:print("Usage: connect <ip:port>")
			elseif #name < 1 then
				console:print("Please choose a name first with /name <name>")
			end
		end
	elseif t[1] == "/reconnect" then
		if ip ~= "none" then
			server = host:connect(ip)
			console:print("Connected to "..ip)
		else
			console:print("No previous server found")
		end
	elseif t[1] == "/backgroundcolor" then
		if t[2] ~= nil and t[3] ~= nil and t[4] ~= nil then
			love.graphics.setBackgroundColor(t[2], t[3], t[4])
			console:print("Background color changed")
		else
			console:print("Usage: /backgroundcolor <red> <green> <blue>")
		end
	
	else
		local s = ""
		for i,v in ipairs(t) do s = s..t[i].." " end
		if server ~= false then 
			server:send(name..": "..s) 
		else
			console:print("Use /connect to connect to a server")
		end
	end
end

function console:draw()
	love.graphics.setColor(200, 200, 200)
	love.graphics.setFont(self.font)
	love.graphics.print(self.input, self.x, (screen.height - love.graphics.getFont():getHeight()) - self.y)
	love.graphics.setColor(150, 150, 150)
	love.graphics.print(self.text, self.x, screen.height - (self.y * 8) - (love.graphics.getFont():getHeight() * self.lines))
end

function split(str)
  local t = {}
	str:gsub("([^ ]+)", function(c) t[#t+1] = c end)
  return t
end