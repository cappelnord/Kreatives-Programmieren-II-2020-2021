--[[
function love.draw()
  love.graphics.print("Hello World!")
end
]]

function love.load()
  circle = {}
  circle.r = 100
  circle.x = circle.r
  circle.y = circle.r
  circle.velX = 1
  circle.velY = 1

  speed = 100
end

function love.update(dt)
  if ((circle.x > (800 - circle.r)) or (circle.x < circle.r)) then
    circle.velX = circle.velX * -1
  end
  circle.x = circle.x + speed * circle.velX * dt

  if ((circle.y > (600 - circle.r)) or (circle.y < circle.r)) then
    circle.velY = circle.velY * -1
  end
  circle.y = circle.y + speed * circle.velY * dt
end

function love.draw()
  love.graphics.setColor(0, 0, 255)
  love.graphics.circle("fill", circle.x, circle.y, circle.r)
end

function love.mousepressed(x, y, button, isTouch)
  if button == 1 then
    if distance(circle.x, circle.y, x, y) < circle.r then
      speed = speed * 2
    end
  end
end

function distance(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
