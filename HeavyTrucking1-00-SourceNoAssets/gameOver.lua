

function gameOverStart()
    gameOverImage = gfx.image.new(242,402,gfx.kColorWhite)
    gfx.pushContext(gameOverImage)
        gfx.drawText("*GAME OVER*\n\n" .. "Total miles: " .. totalMiles,20,20)
    gfx.popContext()
    gameOverSprite = gfx.sprite.new(gameOverImage)
    gameOverSprite:setImageDrawMode(gfx.kDrawModeInverted)
    gameOverSprite:moveTo(201,121)
    gameOverSprite:setRotation(-90)
    gameOverSprite:add()
end

function gameOverScene()
    gfx.sprite.update()
    if pd.buttonJustPressed(playdate.kButtonA) then
        switchSceneNum = 1
    end
end

function gameOverEnd()
    gameOverSprite:remove()
end