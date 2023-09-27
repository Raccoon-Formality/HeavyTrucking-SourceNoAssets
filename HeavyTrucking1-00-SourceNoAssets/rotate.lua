rotateImage = gfx.image.new("images/rotate")

function rotateScene()
    rotateImage:draw(0,0)
    if pd.buttonJustPressed(playdate.kButtonA) then
        switchSceneNum = 3
    end
end