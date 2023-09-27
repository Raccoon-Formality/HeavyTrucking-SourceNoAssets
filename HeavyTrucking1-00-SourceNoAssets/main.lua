import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/animation"
import "CoreLibs/qrcode"



function lerp(a,b,t) return a * (1-t) + b * t end

function clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

function fixAngle(angle)
    if angle < 0.0 then
        return -angle
    else
        return (math.pi - angle) + math.pi
    end
end

function rotationTo(x1,y1,x2,y2)
    --return math.atan2(math.abs(x1-x2),math.abs(x2-y2))
    --angle = math.atan2 ( centre.y - target.y, target.x - centre.x)
    return fixAngle(math.atan2(y2-y1,x2-x1))
end

function rotationToNoFix(x1,y1,x2,y2)
    return math.atan2(y2-y1,x2-x1)
end

function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

pd = playdate
gfx = pd.graphics
snd = playdate.sound

menu = playdate.getSystemMenu()

currentSceneNum = 1
switchSceneNum = 1

local fontFam = {
    [playdate.graphics.font.kVariantNormal] = "font/Sasser-Slab",
    [playdate.graphics.font.kVariantBold] = "font/Sasser-Slab-Bold",
    [playdate.graphics.font.kVariantItalic] = "font/Sasser-Slab-Italic"
}

gfx.setFontFamily(gfx.font.newFamily(fontFam))

font = gfx.getFont()
fontBold = gfx.getFont("bold")
fontHeight = font:getHeight()



currentTime = 0
desertBusPoints = 0
yourGasPoints = 150
yourMoney = 500
totalMiles = 0

storyMode = false
desertMode = false

nuSound = snd.sampleplayer.new(snd.sample.new("sounds/beep-00"))
goodSound = snd.sampleplayer.new(snd.sample.new("sounds/beep-06"))
badSound = snd.sampleplayer.new(snd.sample.new("sounds/beep-05"))

crashSound = snd.sampleplayer.new(snd.sample.new("sounds/crash"))

truckSound = snd.fileplayer.new("sounds/truck")
truckLoopSound = snd.fileplayer.new("sounds/truck-loop")

truckLoopSound:setLoopRange(0, truckLoopSound:getLength() - 0.1)
--truckLoopSound:setBufferSize(1)

goodSound:setVolume(0.5)
badSound:setVolume(0.5)
--nuSound:setVolume(2.5)

truckSound:setVolume(0.5)
truckLoopSound:setVolume(0.5)

sensitiveSettings = 1.0

math.randomseed(playdate.getSecondsSinceEpoch())

if playdate.datastore.read("sensitiveSettingsSave") ~= nil then
    sensitiveSettings = playdate.datastore.read("sensitiveSettingsSave")[1]
end

showFPS = false

if playdate.datastore.read("showFPSSave") ~= nil then
    showFPS = playdate.datastore.read("showFPSSave")[1]
end

viewBobbing = true

if playdate.datastore.read("viewBobbingSave") ~= nil then
    viewBobbing = playdate.datastore.read("viewBobbingSave")[1]
end

radial = false

if playdate.datastore.read("radialSave") ~= nil then
    radial = playdate.datastore.read("radialSave")[1]
end

difficulty = "normal"
timeSpeed = 1.0

potholeDifficulty = "easy"
potholeTime = 100
potholeChance = 10

function setDifficulty(stringy)
    difficulty = stringy
    if stringy == "easy" then
        timeSpeed = 0.5
        difficultyIndex = 1
    elseif stringy == "normal" then
        timeSpeed = 1.0
        difficultyIndex = 2
    elseif stringy == "hard" then
        timeSpeed = 2.0
        difficultyIndex = 3
    end
end

function setPotholeDifficulty(stringy)
    potholeDifficulty = stringy
    if stringy == "easy" then
        potholeTime = 300
        potholeChance = 10
        potholeDifficultyIndex = 1
    elseif stringy == "medium" then
        potholeTime = 200
        potholeChance = 6
        potholeDifficultyIndex = 2
    elseif stringy == "hard" then
        potholeTime = 100
        potholeChance = 2
        potholeDifficultyIndex = 3
    elseif stringy == "dread" then
        potholeTime = 50
        potholeChance = 1
        potholeDifficultyIndex = 4
    end
end

import "mainMenu"
import "rotate"
import "driving"
import "gameOver"
import "map"
import "credits"
import "story"
import "endGame"
import "settings"

--drivingStart(100000)


difficultyList = {"easy","normal","hard"}
difficultyIndex = 2

if playdate.datastore.read("difficultySave") ~= nil then
    difficulty = playdate.datastore.read("difficultySave")[1]
    timeSpeed = playdate.datastore.read("difficultySave")[2]
    setDifficulty(difficulty)
end

potholeDifficultyList = {"easy","medium","hard","dread"}
potholeDifficultyIndex = 1

if playdate.datastore.read("potholeDifficultySave") ~= nil then
    potholeDifficulty = playdate.datastore.read("potholeDifficultySave")[1]
    potholeTime = playdate.datastore.read("potholeDifficultySave")[2]
    potholeChance = playdate.datastore.read("potholeDifficultySave")[3]
    setPotholeDifficulty(potholeDifficulty)
end




mainMenu = 1
rotate = 2
driving = 3
gameOver = 4
map = 5
credits = 6
story = 7
endGame = 8
settings = 9

scenes = {
    mainMenuScene,
    rotateScene,
    drivingScene,
    gameOverScene,
    mapScene,
    creditsScene,
    storyScene,
    endGameScene,
    settingsScene
}

if playdate.datastore.read("DesertBusSave") ~= nil then
    desertBusPoints = playdate.datastore.read("DesertBusSave")[1]
end

mainMenuStart()

function startScene(num)
    if num == mainMenu then
        mainMenuStart()
    elseif num == driving then
        drivingStart(currentTime)
    elseif num == gameOver then
        gameOverStart()
    elseif num == map then
        mapStart()
    elseif num == credits then
        creditsStart()
    elseif num == story then
        storyStart(currentStory)
    elseif num == endGame then
        endGameStart()
    elseif num == settings then
        settingsStart()
    end
end

function endScene(num)
    if num == driving then
        drivingEnd()
    elseif num == mainMenu then
        mainMenuEnd()
    elseif num == map then
        mapEnd()
    elseif num == story then
        storyEnd()
    elseif num == credits then
        creditsEnd()
    elseif num == endGame then
        endGameEnd()
    elseif num == gameOver then
        gameOverEnd()
    elseif num == settings then
        settingsEnd()
    end

    
    
end

transitionStart = gfx.animator.new(0,0,400,pd.easingFunctions.outQuad)
transitionStart.done = true
transitionEnd = nil
--transitionEnd.done = true
transitioning = false
transitionImage = gfx.image.new(400,240)
transitionSprite = gfx.sprite.new(transitionImage)
transitionSprite:setZIndex(999)
transitionSprite:moveTo(200,120)
transitionSprite.setImageDrawMode = gfx.kDrawModeWhiteTransparent
transitionSprite:add()

blackImage = gfx.image.new("images/black")



local allImagesProcessed = false



function pd.update()
    if currentSceneNum ~= switchSceneNum and trans ~= true then
        transitionStart = gfx.animator.new(500,0,250,pd.easingFunctions.inQuart)
        transitionEnd = nil
        trans = true
        --transitionSprite:add()
    end
    if currentSceneNum == switchSceneNum and not trans then
        currentScene = scenes[currentSceneNum]
        currentScene()
        if showFPS then
            playdate.drawFPS(0,0)
        end
    end
    if trans then 
        gfx.sprite.update()
        transitionImage = gfx.image.new(400,240)
        gfx.pushContext(transitionImage)
            gfx.fillRect(0,0,400,transitionStart:currentValue())
        gfx.popContext()
        transitionSprite:setImage(transitionImage)

        if transitionStart:ended() and transitionEnd == nil then
            --transitionSprite:setImage(blackImage)
            --playdate.wait(100)
            endScene(currentSceneNum)
            startScene(switchSceneNum)
            coroutine.yield()
            playdate.wait(250)
            transitionEnd = gfx.animator.new(500,0,250,pd.easingFunctions.outQuart)
            currentSceneNum = switchSceneNum
            
        elseif transitionStart:ended() and transitionEnd ~= nil then
            transitionImage = gfx.image.new(400,240)
            gfx.pushContext(transitionImage)
                gfx.fillRect(0,transitionEnd:currentValue(),400,240-transitionEnd:currentValue())
            gfx.popContext()
            transitionSprite:setImage(transitionImage)

        end

        if transitionEnd ~= nil and transitionEnd:ended() then
            trans = false
        end

    end
end

function pd.gameWillPause()
    if currentSceneNum == 3 then
        menuImage = gfx.image.new(240,200,gfx.kColorWhite)
        gfx.pushContext(menuImage)
            gfx.drawText("time left: " .. timerClock(clocking.timeLeft),20,20)
            gfx.fillRect(20,40,200,10)
            gfx.fillRect(20 + ((1 - (clocking.timeLeft/clocking.fullTime)) * 196),52,4,10)
            gfx.drawText("Thanks for playing :)",20,80)
        gfx.popContext()
        
        fullMenuImage = gfx.image.new(400,240,gfx.kColorWhite)
        gfx.pushContext(fullMenuImage)
            menuImage:drawRotated(0,120,-90)
        gfx.popContext()

        pd.setMenuImage(fullMenuImage)
    else
        pd.setMenuImage(nil)
    end
end