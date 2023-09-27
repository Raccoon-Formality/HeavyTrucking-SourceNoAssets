creditsImage = gfx.image.new(240,400,gfx.kColorWhite)
gfx.pushContext(creditsImage)
gfx.drawText("Created by Matthew\nas a part of\nRaccoon Formality\n\nPatreon supporters:\n- Poki\n- Colorblind Cowboy\n- FrazzledWings\n\nSpecial thanks to:\n- Toad\n- Lumi\n- Roux\n- my mom\nand everyone else\nwho believed in me.\n\n\n\nThank you :)",20,20)
gfx.popContext()

function creditsStart()
    creditsSprite = gfx.sprite.new(creditsImage)
    --creditsSprite:setImageDrawMode(gfx.kDrawModeInverted)
    creditsSprite:moveTo(200,120)
    creditsSprite:setRotation(-90)
    creditsSprite:add()
end


function creditsScene()
    gfx.sprite.update()
    if pd.buttonJustPressed(playdate.kButtonB) then
        switchSceneNum = 1
        badSound:play()
    end
end

function creditsEnd()
    creditsSprite:remove()
end