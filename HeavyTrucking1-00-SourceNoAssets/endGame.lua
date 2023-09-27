

function endGameStart()
    endGameImage = gfx.image.new(240,400,gfx.kColorWhite)
    gfx.pushContext(endGameImage)
        gfx.drawText("The end. You win!\n\n" .. "Total miles: " .. totalMiles,20,20)
    gfx.popContext()
    endGameSprite = gfx.sprite.new(endGameImage)
    --endGameSprite:setImageDrawMode(gfx.kDrawModeInverted)
    endGameSprite:moveTo(200,120)
    endGameSprite:setRotation(-90)
    endGameSprite:add()
end

function endGameScene()
    gfx.sprite.update()
    if pd.buttonJustPressed(playdate.kButtonA) then
        switchSceneNum = 1
        goodSound:play()
    end
end

function endGameEnd()
    endGameSprite:remove()
end