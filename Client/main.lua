require "enet"

screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}
require "console"
love.filesystem.setIdentity("enet_chat")
name = "none"
ip = "none"

data_file = love.filesystem.newFile("data.txt")
data, _ = data_file:read()

if not love.filesystem.exists("data.txt") then
	data_file:open("w")
	data_file:write("name=none\r\nip=none")
	data_file:close()
end

_data = {}
for line in data_file:lines() do
	local s = line:find("=")
	line = line:sub(s + 1)
	_data[#_data + 1] = line
end

if _data[1] ~= "none" then
	name = _data[1]
	console:print("Welcome back "..name)
end
if _data[2] ~= "none" then
	ip = _data[2]
end


function love.load()
	host = enet.host_create()
	server = false
	love.keyboard.setKeyRepeat(true)
	if name == "none" then console:print("Use /name <name> to select a nickname") end
	console:print("Use /connect <ip:port> to connect to a server or /reconnect to connect to the last server")
end

function love.update(dt)
	if server ~= false then
		local event = host:service()
	  if event then
			if event.type == "receive" then
				console:print(event.data)
			end
	  end
	 end
end

function love.draw()
	console:draw()
	
	love.graphics.setColor(100, 100, 100)
	if server ~= false then
		local p = "ping: "..server:round_trip_time()
		love.graphics.print(p, screen.width - love.graphics.getFont():getWidth(p) - 12, 12)
	end
end

function love.textinput(t)
	console:textInput(t)
end

function love.quit()
	if server ~= false then
		server:send(name.." has disconnected")
		server:disconnect()
		host:flush()
	end
	local d = ""
	for i,v in ipairs(_data) do
		if i == 1 then
			d = d.."name="..v
		elseif i == 2 then
			d = d.."\r\nip="..v
		end
	end
	data_file:open("w")
	data_file:write(d)
	data_file:close()
end

function love.resize(width, height)
	screen.width, screen.height = width, height
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	console:keypressed(key)
end

function love.mousepressed(x, y, key)

end
