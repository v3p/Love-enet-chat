require "enet"

screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}
require "console"
name = "twat"

function love.load()
	host = enet.host_create()
	server = false
	love.keyboard.setKeyRepeat(true)
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
end

function love.textinput(t)
	console:textInput(t)
end

function love.quit()
	server:send(name.." has disconnected")
	server:disconnect()
	host:flush()
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	console:keypressed(key)
end

function love.mousepressed(x, y, key)

end
