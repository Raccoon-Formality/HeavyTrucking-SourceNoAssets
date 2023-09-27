

function mainMenuStart()
    
    gfx.setBackgroundColor(gfx.kColorWhite)
    
    storyMode = false
    desertMode = false

    menuSelcetion = 0
    mainMenuImage = gfx.image.new(240,400)
    gfx.pushContext(mainMenuImage)
        
        gfx.drawText("Story Mode",25,170)
        
        --gfx.drawText("Random Mode",25,220)
        
        gfx.drawText("Credits",25,200)--250)
        
        gfx.drawText("Tucson to Vegas",25,230)--280)

        gfx.drawText("Settings",25,260)

        gfx.drawText("score: " .. desertBusPoints,4,4)
        gfx.drawText("Raccoon Formality   v" .. playdate.metadata.version,4,400-fontHeight-4)
    gfx.popContext()
    mainMenuSprite = gfx.sprite.new(mainMenuImage)
    mainMenuSprite:setRotation(-90)
    mainMenuSprite:moveTo(200,120)
    mainMenuSprite:add()
    
    


    sensitivityImage = gfx.image.new(240,100)
    gfx.pushContext(sensitivityImage)
        local percent = (sensitiveSettings-0.25)/1.75
        --print(percent)
        --print(sensitiveSettings)
        --gfx.drawText("V",,300)
        
        gfx.fillRect(20+(percent*(200-4)),0,4,18)

        gfx.fillRect(20,20,200,20)
        gfx.drawText("Sensitivity: " .. math.floor(100*sensitiveSettings + 0.5)/100,20,44)
    gfx.popContext()
    sensitivitySprite = gfx.sprite.new(sensitivityImage)
    sensitivitySprite:setRotation(-90)
    sensitivitySprite:moveTo(350,120)
    sensitivitySprite:add()

    --[[
    carrotImage = gfx.image.new(18,18)
    gfx.pushContext(carrotImage,gfx.kColorClear)
        gfx.drawText(">",0,0)
    gfx.popContext()
    carrotSprite = gfx.sprite.new(carrotImage)
    carrotSprite:setRotation(-90)
    carrotSprite:moveTo(170+(30*menuSelcetion)+9,240-12-9)
    carrotSprite:add()
    ]]--

    
    logoImage = gfx.image.new(font:getTextWidth("Heavy\nTrucking")+4,60)
    gfx.pushContext(logoImage)
        gfx.drawText("Heavy\nTrucking",2,0)
    gfx.popContext()
    logoSprite = gfx.sprite.new(logoImage)
    logoSprite:setScale(2)
    logoSprite:setRotation(-90)
    logoSprite:moveTo(120,140)
    logoSprite:add()


    --sensitivityImage = gfx.image.new()


    selectorImage = gfx.image.new(30,240,gfx.kColorWhite)
    selectorSprite = gfx.sprite.new(selectorImage)
    selectorSprite:moveTo(179+(30*menuSelcetion),120)
    selectorSprite:setImageDrawMode(gfx.kDrawModeXOR)
    selectorSprite:add()

    mainMenucrankCheckTextImage = gfx.image.new(146,44)--, gfx.kColorWhite)
    gfx.pushContext(mainMenucrankCheckTextImage)
        gfx.drawText("Please position\ncrank vertically",2,4)
    gfx.popContext()
    mainMenucrankCheckTextImage = mainMenucrankCheckTextImage:rotatedImage(-90)
    mainMenucrankCheckTextSprite = gfx.sprite.new(mainMenucrankCheckTextImage)
    mainMenucrankCheckTextSprite:setZIndex(100)
    mainMenucrankCheckTextSprite:moveTo(25,79)
    mainMenucrankCheckTextSprite.isAdded = false


    if playdate.datastore.read("QuickStorySave") ~= nil then
        loadButton, error = menu:addMenuItem("quick load", function()
            local saveFile = playdate.datastore.read("QuickStorySave")
            --playdate.datastore.write({storyNumer, yourGasPoints, yourMoney, currentLoc}, "QuickStorySave", true)
            
            storyNumer = saveFile[1]
            currentStory = storyList[storyNumer][1]
            yourGasPoints = saveFile[2]
            yourMoney = saveFile[3]
            totalMiles = saveFile[5]
            storyMode = true

            for x = 1, #locations do
                local location = locations[locations[x]]
                location[2] = false 
            end
            locations[saveFile[4]][2] = true
            currentLoc = saveFile[4]

            switchSceneNum = 5
            
            menu:removeAllMenuItems()
    
        end)

        
    end
    
    checkmarkMenuItem, error = menu:addCheckmarkMenuItem("view bob", viewBobbing, function(value)
        viewBobbing = value
        playdate.datastore.write({viewBobbing}, "viewBobbingSave", true)
    end)

    
    difficultyMenuItem, error = menu:addOptionsMenuItem("difficulty", {"easy","normal","hard"}, difficulty, function(value)
        setDifficulty(value)
        playdate.datastore.write({difficulty,timeSpeed}, "difficultySave", true)
    end)
    --test change

    loadChecking = false
    willLoad = true

    loadBoxImage = gfx.image.new(200, 200)
    loadBoxSprite = gfx.sprite.new(loadBoxImage)
    loadBoxSprite:setRotation(-90)
    loadBoxSprite:setImageDrawMode(gfx.kDrawModeInverted)
    loadBoxSprite:moveTo(200,120)
    loadBoxChange()

    selectorLerp = 179+(30*menuSelcetion)
end


function mainMenuScene()

    gfx.sprite.update()
    playdate.timer.updateTimers()
    
    selectorX, selectorY = selectorSprite:getPosition()
    selectorLerp = lerp(selectorLerp,179+(30*menuSelcetion),0.25)
    --selectorSprite:moveBy(selectorLerp,0)
    selectorSprite:moveTo(math.floor(selectorLerp+0.5),120)

    if not loadChecking then
        if pd.buttonJustPressed(playdate.kButtonLeft) then
            menuSelcetion -= 1
            if menuSelcetion < 0 then
                menuSelcetion += 4
            end
            --menuImageChange()
            --moveCarrot()
            nuSound:play()
        elseif pd.buttonJustPressed(playdate.kButtonRight) then
        
            menuSelcetion += 1
            if menuSelcetion > 3 then
                menuSelcetion -= 4
            end
            --menuImageChange()
            --moveCarrot()
            nuSound:play()
        end

        if pd.buttonJustPressed(playdate.kButtonUp) then
            sensitiveSettings += 0.05
            if sensitiveSettings >= 2.0 then
                sensitiveSettings = 2.0
                badSound:play()
            else
                nuSound:play()
            end
            --menuImageChange()
            updateSensitive()
        elseif pd.buttonJustPressed(playdate.kButtonDown) then
            sensitiveSettings -= 0.05
            if sensitiveSettings <= 0.25 then
                sensitiveSettings = 0.25
                badSound:play()
            else 
                nuSound:play()
            end
            --menuImageChange()
            updateSensitive()
        end

        if pd.buttonJustPressed(playdate.kButtonA) then
            goodSound:play()
            playdate.datastore.write({sensitiveSettings}, "sensitiveSettingsSave", true)
            
            if menuSelcetion == 0 then
                if playdate.datastore.read("QuickStorySave") ~= nil then
                    loadChecking = true
                    willLoad = true
                    loadBoxChange()
                    loadBoxSprite:add()
                else
                    startNew()
                end
            elseif menuSelcetion == 1 then
                switchSceneNum = 6 
            elseif menuSelcetion == 2 then
                
                if not pd.isCrankDocked() and not (pd.getCrankPosition() > 240 and pd.getCrankPosition() < 300) then
                    badSound:play()
                    if not mainMenucrankCheckTextSprite.isAdded then
                        mainMenucrankCheckTextSprite:add()
                        mainMenucrankCheckTextSprite.isAdded = true
                    end
                else
                    currentTime = 60 * 60 * 8
                    desertMode = true
                    totalMiles = 0
                    truckSound:play()
                    switchSceneNum = 3
                end
                
            elseif menuSelcetion == 3 then
                switchSceneNum = 9
            end
        end
    else
        if pd.buttonJustPressed(pd.kButtonLeft) or pd.buttonJustPressed(pd.kButtonRight) then
            nuSound:play()
            willLoad = reverseBool(willLoad)
            loadBoxChange()
        end

        if pd.buttonJustPressed(pd.kButtonA) then
            if willLoad then
                goodSound:play()
                loadSave()
            else 
                goodSound:play()
                startNew()
            end
        end
        if pd.buttonJustPressed(pd.kButtonB) then
            badSound:play()
            loadChecking = false
            loadBoxSprite:remove()
        end
    end
end

function startNew()
    storyNumer = 1
    currentStory = storyList[storyNumer][1]
    yourGasPoints = 150
    yourMoney = 100
    totalMiles = 0
    storyMode = true

    for x = 1, #locations do
        local location = locations[locations[x]]
        location[2] = false 
    end
    locations["Portland"][2] = true
    currentLoc = "Portland"
    switchSceneNum = 7
end

function moveCarrot()
    --carrotSprite:moveTo(170+(30*menuSelcetion)+9,240-12-9)
end

function updateSensitive()
    sensitivityImage = gfx.image.new(240,100)
    gfx.pushContext(sensitivityImage)
        local percent = (sensitiveSettings-0.25)/1.75
        --print(percent)
        --print(sensitiveSettings)
        --gfx.drawText("V",,300)
        
        gfx.fillRect(20+(percent*(200-4)),0,4,18)

        gfx.fillRect(20,20,200,20)
        gfx.drawText("Sensitivity: " .. math.floor(100*sensitiveSettings + 0.5)/100,20,44)
    gfx.popContext()
    sensitivitySprite:setImage(sensitivityImage)
end

function loadSave()
    local saveFile = playdate.datastore.read("QuickStorySave")
    --playdate.datastore.write({storyNumer, yourGasPoints, yourMoney, currentLoc}, "QuickStorySave", true)
    
    storyNumer = saveFile[1]
    currentStory = storyList[storyNumer][1]
    yourGasPoints = saveFile[2]
    yourMoney = saveFile[3]
    totalMiles = saveFile[5]
    storyMode = true

    for x = 1, #locations do
        local location = locations[locations[x]]
        location[2] = false 
    end
    locations[saveFile[4]][2] = true
    currentLoc = saveFile[4]

    switchSceneNum = 5
    
    menu:removeAllMenuItems()
end

function mainMenuEnd()
    mainMenuSprite:remove()
    logoSprite:remove()
    selectorSprite:remove()
    mainMenucrankCheckTextSprite:remove()
    menu:removeAllMenuItems()
    loadBoxSprite:remove()
    sensitivitySprite:remove()
end

function menuImageChange()
end

function loadBoxChange()
    
    loadBoxImage = gfx.image.new(200, 200)
    gfx.pushContext(loadBoxImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(-1,-1,202,202)
        gfx.setColor(gfx.kColorBlack)

        gfx.drawText("load save\nor\nstart new?",25,25)
        gfx.drawText("load save",25,120)
        if willLoad then 
            gfx.drawText(">",12,120)
        else
            gfx.drawText(">",12,160)
        end
        gfx.drawText("start new",25,160)
    gfx.popContext()
    loadBoxSprite:setImage(loadBoxImage)
end