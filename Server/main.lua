require "enet"
screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}
require "console"

local port = 25565

function love.load()
	host = enet.host_create("0.0.0.0:25565")
end

function love.update(dt)
	local event = host:service()
  if event then
		if event.type == "connect" then
			console:print("Someone connected")
		elseif event.type == "disconnect" then
			console:print("Someone disconnected")
		elseif event.type == "receive" then
			console:print(event.data)
			host:broadcast(event.data)
		end
  end
end

function love.draw()
	console:draw()
end

function love.textinput(t)
	console:textInput(t)
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	console:keypressed(key)
end

function love.mousepressed(x, y, key)

end
