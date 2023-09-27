dashGif = playdate.graphics.imagetable.new("images/dottedLines")
grassGif = playdate.graphics.imagetable.new("images/grass1flip")
roadGif = playdate.graphics.imagetable.new("images/roadWideFlip")
treeGif = playdate.graphics.imagetable.new("images/treeFlipped")
wheelGif = playdate.graphics.imagetable.new("images/wheelGif")

function drivingStart(time)
    gfx.setBackgroundColor(gfx.kColorBlack)

    dashGifAnimation = playdate.graphics.animation.loop.new(75, dashGif, true)
    
    grassGifAnimation = playdate.graphics.animation.loop.new(300, grassGif, true)

    grassSprite = gfx.sprite.new(grassGifAnimation:image())
    grassSprite:moveTo(298,120)--128,120)
    --grassSprite:setRotation(-90)
    --grassSprite:setScale(2)
    grassSprite.frameNum = grassGifAnimation.frame
    grassSprite:setZIndex(-3)
    grassSprite:add()

    counter = 0

    
    roadGifAnimation = playdate.graphics.animation.loop.new(75, roadGif, true)
    roadSprite = gfx.sprite.new(roadGifAnimation:image())
    roadSprite:moveTo(280,120)--128,120)
    roadX, roadY = roadSprite:getPosition()
    --roadSprite:setRotation(-90)
    --roadSprite:setScale(5/2,3/2)
    roadSprite:setZIndex(-2)
    roadSprite.frameNum = roadGifAnimation.frame 
    roadSprite.Xmove = 0
    roadSprite:add()

    blackSprite = gfx.sprite.new(gfx.image.new(70,70,gfx.kColorBlack))
    blackSprite:moveTo(280,120)--128,120)
    blackSprite:setRotation(-90)
    blackSprite:setScale(5,3)
    blackSprite:setZIndex(-4)
    blackSprite:add()

    

    skyImage = gfx.image.new("images/sky")
    skySprite = gfx.sprite.new(skyImage)
    skySprite:setRotation(-90)
    skySprite:setScale(2)
    skySprite:setZIndex(-5)
    skySprite:moveTo(100,120)
    skySprite:add()


    dashImage = gfx.image.new("images/dash")
    dashSprite = gfx.sprite.new(dashImage)
    dashSprite:moveTo(400,0)
    dashSprite:setRotation(-90)
    dashSprite:setScale(2)
    dashSprite:setZIndex(0)
    dashSprite:add()

    

    treeGifAnimation = playdate.graphics.animation.loop.new(750, treeGif, false)

    
    treeOffset = 270
    treeFlip = gfx.kImageFlippedY
    treeDelay = 750
    treeFrame = treeGifAnimation:image()
    treeSprite = gfx.sprite.new(treeFrame)
    --treeSprite:setRotation(-90)
    treeSprite:moveTo(200,-100)
    treeSprite:setImageFlip(gfx.kImageFlippedY)
    treeSprite:setZIndex(-1)
    tree()
    treeSprite:add()

    wheelImage = gfx.image.new(70,70)
    --[[
    gfx.pushContext(wheelImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(4)
        gfx.drawCircleAtPoint(35,35,32)
        gfx.fillCircleAtPoint(35,35,4)
        gfx.drawLine(32,32, math.cos(math.rad(1))*32, -math.sin(math.rad(1))*32 ) --circle math * legth
    gfx.popContext()
    ]]--
    wheelSprite = gfx.sprite.new(wheelImage)
    wheelSprite:moveTo(370,175)
    --wheelSprite:setRotation(-90)
    --wheelSprite:setScale(2.2)
    wheelSprite:setZIndex(2)
    wheelSprite.rotation = -90
    steeringWheel(wheelSprite.rotation - 89)
    wheelSprite:add()

    
    potholeImage1 = gfx.image.new("images/pothole1")
    potholeImage2 = gfx.image.new("images/pothole2")
    potholeImage3 = gfx.image.new("images/pothole3")
    potholeSprite = gfx.sprite.new(potholeImage1)
    --potholeSprite:setRotation(-90)
    potholeSprite:setZIndex(-1)
    potholeSprite:moveTo(200,120-27)
    potholeSprite.isRight = true
    potholeSprite.counter = 0
    potholeSprite:setVisible(false)
    pothole()
    potholeSprite:add()

    --truckSound = snd.synth.new(playdate.sound.kWaveTriangle)
    dirtSound = snd.synth.new(playdate.sound.kWaveNoise)

    
    

    --truckSound:playNote(125,0.3)

    truckLoopSound:play(0)

    offroadFrames = 0

    saveTime = 0
    checkTime = 0

    clocking = playdate.timer.new(time*1000)--300000)
    clocking.fullTime = time*1000
    clocking:start()

    clockImage = gfx.image.new(font:getTextWidth(timerClock(clocking.timeLeft))+4,fontHeight,gfx.kColorWhite)
    gfx.pushContext(clockImage)
        gfx.drawText(timerClock(clocking.timeLeft),2,0)
    gfx.popContext()
    clockSprite = gfx.sprite.new(clockImage)
    clockSprite:setRotation(-90)
    clockSprite:moveTo(400,12)
    clockSprite.totalMilesHold = -1
    clockSprite:setImageDrawMode(gfx.kDrawModeInverted)
    clockSprite:setScale(2)
    --if time > 60 * 60 then
        --clockSprite:setScale(1)  
        --clockSprite:moveTo(380,30)
    --end
    clockSprite:setZIndex(100)
    clockUpdateImage()
    clockSprite:add()

    offroadBarImage = gfx.image.new(20,240)
    offroadBarSprite = gfx.sprite.new(offroadBarImage)
    offroadBarSprite:moveTo(10,120)
    offroadBarSprite:setZIndex(102)
    offroadBar()
    offroadBarSprite:add()

    topTruckImage = gfx.image.new("images/topTruck")
    topTruckSprite = gfx.sprite.new(topTruckImage)
    topTruckSprite:moveTo(34,4)
    topTruckSprite:setRotation(-90)
    topTruckSprite:setScale(2)
    topTruckSprite:setZIndex(101)
    topTruckSprite:add()

    playdate.ui.crankIndicator:start()

    frameAmount = 1
    crashing = false

    checkmarkMenuItem, error = menu:addCheckmarkMenuItem("view bob", viewBobbing, function(value)
        viewBobbing = value
        wheelSprite:moveTo(370,175)
        dashSprite:moveTo(400,0)
        local _, clockY = clockSprite:getPosition()
        clockSprite:moveTo(400,clockY)
        topTruckSprite:moveTo(34,4)
        playdate.datastore.write({viewBobbing}, "viewBobbingSave", true)
    end)

    skySprite:moveTo(120,clamp(roadY/4,-250+120,250-120))-- & ~2)
    grassSprite:moveTo(298,clamp(roadY,-500,500)) --& ~2 & ~1)
end



function drivingScene()
    
    crankPos = 0
    pd.timer.updateTimers()
    clockUpdateImage()
    gfx.sprite.update()
    if not playdate.isCrankDocked() then
        --playdate.ui.crankIndicator:update()
    --else
    --wheelSprite.rotation += (pd.getCrankChange() / 2) * sensitiveSettings
    crankPos = pd.getCrankPosition() - 270
    if pd.getCrankPosition() < 90 then
        crankPos += 360
    end
    wheelSprite.rotation = -90 + ((math.floor(crankPos))/4 * sensitiveSettings)
    end
    --print(-90 + ((math.floor(crankPos)) * sensitiveSettings))
    
    if pd.buttonIsPressed(pd.kButtonDown) then
        frameAmount += 1

        wheelSprite.rotation -= frameAmount
    end
    if pd.buttonIsPressed(pd.kButtonUp) then
        frameAmount += 1
        wheelSprite.rotation += frameAmount
    end
    if pd.buttonJustReleased(pd.kButtonUp) or pd.buttonJustReleased(pd.kButtonDown) then
        frameAmount = 1
    end



    wheelSprite.rotation = clamp(wheelSprite.rotation,-180,0)
    --wheelSprite:setRotation(wheelSprite.rotation)
    if pd.getCrankChange() == 0 then 
        wheelSprite.rotation = lerp(wheelSprite.rotation,-92,0.25)
    end
    roadSprite.Xmove += wheelSprite.rotation/10 + 9
    roadSprite:moveBy(0,roadSprite.Xmove/10)
    steeringWheel(wheelSprite.rotation - 89)

    roadX, roadY = roadSprite:getPosition()
    skySprite:moveTo(120,clamp(roadY/4,-250+120,250-120))-- & ~2)
    grassSprite:moveTo(298,clamp(roadY,-500,500)) --& ~2 & ~1)
    if not (roadY < 240 and roadY > 0) then
        if dirtSound:isPlaying() == false then
            dirtSound:playNote(25,0.2)
        end
    else
        offroadFrames = 0
        dirtSound:stop()
    end


    if dirtSound:isPlaying() then
        offroadFrames += 1
    end

    

    counter += 1
    if desertMode then
        if math.fmod(counter,math.floor(2400)) == 0 then
            totalMiles += 1
        end
    end

    if storyMode then
        if math.fmod(counter,math.floor(300 * timeSpeed)) == 0 then
            totalMiles += 1
        end
    end

    if crashing then 
        crashCounter += 1
        dashGifAnimation.delay += 10
        treeGifAnimation.delay += 10
        grassGifAnimation.delay += 10
        sinWave = (math.sin(2*crashCounter)*8) / (crashCounter/8)
        wheelSprite:moveTo(370+sinWave,175)
        dashSprite:moveTo(400+sinWave,0)
        local _, clockY = clockSprite:getPosition()
        clockSprite:moveTo(400+sinWave,clockY)
        topTruckSprite:moveTo(34+sinWave,4)
        if crashCounter > 150 then
            --badSound:play()
            menu:removeAllMenuItems()
            switchSceneNum = 4
        end
    end
    
    if viewBobbing and not crashing then
        sinWave = math.sin(counter/6)*4
        wheelSprite:moveTo(370+sinWave,175)
        dashSprite:moveTo(400+sinWave,0)
        local _, clockY = clockSprite:getPosition()
        clockSprite:moveTo(400+sinWave,clockY)
        topTruckSprite:moveTo(34+sinWave,4)
    end
    road()

    tree()
    if math.fmod(counter,100) == 0 and treeGifAnimation:isValid() == false then
        willThereBeTree = math.random(1,2) 
        if willThereBeTree == 1 then
            willTreeBeRight = math.random(1,2) 
            treeGifAnimation = playdate.graphics.animation.loop.new(treeDelay, treeGif, false)
            if willTreeBeRight == 1 then
                treeOffset = -230
                treeFlip = gfx.kImageUnflipped
            elseif willTreeBeRight == 2 then
                treeOffset = 270
                treeFlip = gfx.kImageFlippedY
            end
            tree()
            treeSprite:add()
        end
    end

    pothole()
    if math.fmod(counter,potholeTime) == 0  and potholeSprite:isVisible() == false and not crashing then
        willThereBePothole = math.random(1,potholeChance) 
        print(willThereBePothole)
        if willThereBePothole == 1 then
            potholeImageRoll = math.random(1,3) 
            if potholeImageRoll == 1 then
                potholeSprite:setImage(potholeImage1)
            elseif potholeImageRoll == 2 then
                potholeSprite:setImage(potholeImage2)
            elseif potholeImageRoll == 3 then
                potholeSprite:setImage(potholeImage3)
            end
            willPotholeBeRight = math.random(1,2) 
            if willPotholeBeRight == 1 then
                potholeSprite:moveTo(200,120-27)
                potholeSprite.counter = 0
                potholeSprite.isRight = true
                potholeSprite:setVisible(true)
            else
                potholeSprite:moveTo(200,120+27)
                potholeSprite.counter = 0
                potholeSprite.isRight = false
                potholeSprite:setVisible(true)
            end
        end
        pothole()
    end
    
    if offroadFrames > 60 and not crashing then
        crashing = true
        truckLoopSound:stop()
        crashCounter = 0
        crashSound:play()
        offroadBarSprite:remove()
        
        --menu:removeAllMenuItems()
        --switchSceneNum = 4
        --badSound:play()
    elseif not crashing then
        offroadBar()
    end

    if (clocking.timeLeft == 0) and not crashing then

        menu:removeAllMenuItems()
        if storyMode then
            goodSound:play()
            
            for x = 1, #locations do
                local location = locations[locations[x]]
                location[2] = false 
            end
            locations[currentSelect][2] = true
            currentLoc = currentSelect

            if currentLoc == storyList[storyNumer][2] then
                yourMoney += storyList[storyNumer][3]
                storyNumer += 1
                currentStory = storyList[storyNumer][1]
                switchSceneNum = 7
            else
                switchSceneNum = 5
            end
            
        end

        if desertMode then
            goodSound:play()
            desertBusPoints += 1
            switchSceneNum = 1
            playdate.datastore.write({desertBusPoints}, "DesertBusSave", true)
        end
    end
end

function steeringWheel(angle)
    --wheelImage = gfx.image.new("images/wheelImages/"..math.floor(angle))--gfx.image.new(70,70)
    --[[
    gfx.pushContext(wheelImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillCircleAtPoint(35,35,32)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(4)
        gfx.drawCircleAtPoint(35,35,32)
        gfx.fillCircleAtPoint(35,35,6)
        gfx.drawLine(35,35, 35+ (math.cos(math.rad(angle+180)))*32, 35+ (math.sin(math.rad(angle+180)))*32 ) --circle math * legth
        gfx.drawLine(35,35, 35+ (math.cos(math.rad(angle-60)))*32, 35+ (math.sin(math.rad(angle-60)))*32 ) --circle math * legth
        gfx.drawLine(35,35, 35+ (math.cos(math.rad(angle+60)))*32, 35+ (math.sin(math.rad(angle+60)))*32 ) --circle math * legth
    gfx.popContext()
    ]]--
    wheelSprite:setImage(wheelGif:getImage(math.floor(angle+0.5)+360))--wheelImage)
end



function road()
    --roadFrame = gfx.image.new(70*2,70*2)--gfx.kColorBlack)
    --linesFrame = dashGifAnimation:image()

    --[[
    gfx.pushContext(roadFrame)
        gfx.fillPolygon(-7*2,70*2,24*2,-2*2,40*2,-2*2,74*2,70*2)
        linesFrame:drawScaled(28*2,-2*2,0.15*2,0.2*2)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(3*2)
        gfx.drawLine(-7*2,70*2,24*2,-2*2)
        gfx.drawLine(74*2,70*2,40*2,-2*2)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(0,0,70*2,1*2)
    gfx.popContext()
    ]]--
    if roadSprite.frameNum ~= roadGifAnimation.frame then
        roadSprite:setImage(roadGifAnimation:image()) --:setImage(roadFrame)
        roadSprite.frameNum = roadGifAnimation.frame
    end

    
    --pd.datastore.writeImage(roadFrame,counter..".gif")
    if grassSprite.frameNum ~= grassGifAnimation.frame then
        grassSprite:setImage(grassGifAnimation:image())
        grassSprite.frameNum = grassGifAnimation.frame
    end
end



function tree()
    treeDelay = treeGifAnimation.delay
    if treeGifAnimation:isValid() == false then
        treeSprite:remove()
        
    end
    treeSprite:moveTo(175,math.floor(roadY+treeOffset) & ~1)
    treeFrame = treeGifAnimation:image()
    treeSprite:setImage(treeFrame, treeFlip)
end

function pothole()
    if potholeSprite:isVisible() then

        potholeSprite.counter += 1
        if potholeSprite.isRight then
            potholeSprite:moveTo(200+(potholeSprite.counter * 2),roadY-25 - (potholeSprite.counter/4))
        else
            potholeSprite:moveTo(200+(potholeSprite.counter * 2),roadY+25+31 + (potholeSprite.counter/4))
        end

        potholeX, potholeY = potholeSprite:getPosition()
        if potholeX >= 380 then
            --print(roadY-25)
            potholeSprite:setVisible(false)
            if potholeSprite.isRight and roadY-25 > 40 and roadY-25 < 200 then

                crashing = true
                truckLoopSound:stop()
                crashCounter = 0
                crashSound:play()
                offroadBarSprite:remove()
                --menu:removeAllMenuItems()
                --switchSceneNum = 4
                --badSound:play()
            end
            if not potholeSprite.isRight and roadY+25+31 > 40 and roadY+25+31 < 200 then

                crashing = true
                truckLoopSound:stop()
                crashCounter = 0
                crashSound:play()
                offroadBarSprite:remove()
                --menu:removeAllMenuItems()
                --switchSceneNum = 4
                --badSound:play()
            end
        end
    end
end

function unusedRoad()
    roadFrame = gfx.image.new(70,70)
    linesFrame = dashGifAnimation:image()
    gfx.pushContext(roadFrame)
    
        gfx.fillRect(0,3,70,70)
        linesFrame:drawScaled(28,0,0.15,0.2)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(4)
        gfx.drawLine(3,70,16,0)
        gfx.drawLine(64,70,48,0)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(2,0,70,3)
    gfx.popContext()
    roadSprite:setImage(roadFrame)
end


function drivingEnd()
    gfx.sprite.removeAll()
    transitionSprite:add()
    truckLoopSound:stop()
    dirtSound:stop()
    gfx.sprite.update()
end

function timerClock(milli)
    if math.floor(milli/(60000*60)) >= 1 then
        local hours = math.floor(milli/(60000*60))
        local minutes = math.floor(milli%(60000*60)/60000)
        local seconds = math.floor((milli%60000)/1000)
        if seconds < 10 then
            seconds = "0" .. seconds
        end
        if minutes < 10 then
            minutes = "0" .. minutes
        end
        return hours .. ":" .. minutes .. ":" .. seconds
    else
        local minutes = math.floor(milli/60000)
        local seconds = math.floor((milli%60000)/1000)
        if seconds < 10 then
            seconds = "0" .. seconds
        end
        return minutes .. ":" .. seconds
    end
    
end

function clockUpdateImage()
    if clockSprite.totalMilesHold ~= totalMiles then
        clockImage = gfx.image.new(75,50)--font:getTextWidth(timerClock(clocking.timeLeft))+4,fontHeight,gfx.kColorWhite)
        gfx.pushContext(clockImage)
            gfx.setColor(gfx.kColorWhite)
            gfx.fillRect(-2,-2,104,104)
            --gfx.drawText(timerClock(clocking.timeLeft) .. "\n" .. totalMiles,2,2)
            if totalMiles < 10 then
                gfx.drawText("000" .. totalMiles,2,2)
            elseif totalMiles < 100 then
                gfx.drawText("00" .. totalMiles,2,2)
            elseif totalMiles < 1000 then
                gfx.drawText("0" .. totalMiles,2,2)
            else
                gfx.drawText(totalMiles,2,2)
            end
            gfx.setColor(gfx.kColorBlack)
        gfx.popContext()
        clockSprite:setImage(clockImage)
        clockSprite.totalMilesHold = totalMiles
    end
end

function offroadBar()
    offroadBarImage = gfx.image.new(20,240)
    gfx.pushContext(offroadBarImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(0,240-(240/60)*offroadFrames,20,240)
    gfx.popContext()
    offroadBarSprite:setImage(offroadBarImage)
end