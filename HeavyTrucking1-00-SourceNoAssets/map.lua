locations = {
    "Seattle", Seattle = {{66,116},false,5},
    "Portland", Portland = {{54,150},true,4},
    "LA", LA = {{75,205},false,5},
    "Austin", Austin = {{214,254},false,3},
    "NewYork", NewYork = {{393,174},false,5},
    "Charlotte", Charlotte = {{350,230},false,3},
    "Nashville", Nashville = {{303,211},false,2},
    "Pittsburgh", Pittsburgh = {{352,181},false,3},
    "Vegas", Vegas = {{120,215},false,4},
    "Chicago", Chicago = {{327,169},false,4},
    "Miami", Miami = {{349,296},false,5},
    "Denver", Denver = {{210,191},false,2},
    "Detroit", Detroit = {{372,161},false,3},
    "Winnipeg", Winnipeg = {{230,61},false,1},
    "Toronto", Toronto = {{358,136},false,2},
}

function mapStart()
    gfx.setBackgroundColor(gfx.kColorBlack)

    --[[
    backgroundImage = gfx.image.new(400,240)
    gfx.pushContext(backgroundImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(0,0,400,240)
    gfx.popContext()
    backgroundSprite = gfx.sprite.new(backgroundImage)
    backgroundSprite:moveTo(200,120)
    backgroundSprite:setZIndex(-20000)
    backgroundSprite:add()
    ]]--

    mapImage = gfx.image.new("images/map")
    gfx.pushContext(mapImage)
        gfx.setColor(gfx.kColorWhite)
        for x = 1, #locations do
            local location = locations[locations[x]]
            
            if location[2] == true then
                currentLoc = locations[x]
                gfx.fillRect(location[1][1]-3,location[1][2]-3,6,6)
                moveMapToX = (250 - location[1][1]) --* 2
                moveMapToY = (200 - location[1][2]) --* 2


                currentSelect = findClosestPoint(location[1][1],location[1][2],locations)
                clostestPlaceX = locations[currentSelect][1][1]
                clostestPlaceY = locations[currentSelect][1][2]
                --print(currentLoc .. " -> " .. currentSelect)
                    
                moveMapToX = (250 - (location[1][1] + clostestPlaceX)/2) --* 2
                moveMapToY = (200 - (location[1][2] + clostestPlaceY)/2) --* 2

                gfx.setColor(gfx.kColorWhite)
                gfx.setLineWidth(2)
                gfx.drawLine(locations[currentLoc][1][1],locations[currentLoc][1][2],clostestPlaceX,clostestPlaceY)
            else
                gfx.fillCircleAtPoint(location[1][1],location[1][2],4)
            end
        end
    gfx.popContext()
    mapSprite = gfx.sprite.new(mapImage)
    --mapSprite:setScale(2)
    mapSprite:setRotation(-90)
    mapSprite:moveTo(200+moveMapToY,120-moveMapToX)
    mapSprite.posx = 200+moveMapToY
    mapSprite.posy = 120-moveMapToX
    mapSprite:add()

    textBoxTopImage = gfx.image.new(240,fontHeight*3+8)
    textBoxTopSprite = gfx.sprite.new(textBoxTopImage)
    textBoxTopSprite:setRotation(-90)
    textBoxTopSprite:setImageDrawMode(gfx.kDrawModeNXOR)
    textBoxTopSprite:setZIndex(100)
    textBoxTopSprite:moveTo(8+(fontHeight*3+8)/2,120-4)
    textBoxTop()
    textBoxTopSprite:add()

    crankCheckTextImage = gfx.image.new(font:getTextWidth("Please position\ncrank vertically")+4,fontHeight*2+8)
    gfx.pushContext(crankCheckTextImage)
        gfx.drawText("Please position\ncrank vertically",2,4)
    gfx.popContext()
    crankCheckTextSprite = gfx.sprite.new(crankCheckTextImage)
    crankCheckTextSprite:setRotation(-90)
    crankCheckTextSprite:setImageDrawMode(gfx.kDrawModeInverted)
    crankCheckTextSprite:setZIndex(10)
    crankCheckTextSprite:moveTo(200,120)
    crankCheckTextSprite:setVisible(false)
    crankCheckTextSprite:add()

    textBoxImage = gfx.image.new(240,fontHeight*2+8)
    textBoxSprite = gfx.sprite.new(textBoxImage)
    textBoxSprite:setRotation(-90)
    textBoxSprite:setImageDrawMode(gfx.kDrawModeNXOR)
    textBoxSprite:setZIndex(100)
    textBoxSprite:moveTo(400-(fontHeight*3+8)/2,120-4)
    textBox()
    textBoxSprite:add()

    shopping = false
    shopImage = gfx.image.new(240,400,gfx.kColorWhite)
    gfx.pushContext(shopImage)
        gfx.drawText("Your money: $" .. yourMoney .. "\nCurrent fuel price: $" .. tostring(locations[currentLoc][3]),10,10)
            
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(20,200,200,20)
        gfx.drawText("V",20+((190/150)*yourGasPoints),180)
        gfx.drawText("press A to buy fuel.",20,225)
    gfx.popContext()
    shopSprite = gfx.sprite.new(shopImage)
    shopSprite:setRotation(-90)
    shopSprite:setZIndex(150)
    shopSprite:moveTo(200,120)
    shopSprite:setVisible(false)
    shopSprite:add()
    shop()

    
    noMoreMoneyButton, error = menu:addMenuItem("I'm stranded!", function()
        
        switchSceneNum = 4
    end)

    saveButton, error = menu:addMenuItem("quick save", function()
        
        playdate.datastore.write({storyNumer, yourGasPoints, yourMoney, currentLoc, totalMiles}, "QuickStorySave", true)

    end)

    checkmarkMenuItem, error = menu:addCheckmarkMenuItem("view bob", viewBobbing, function(value)
        viewBobbing = value
        playdate.datastore.write({viewBobbing}, "viewBobbingSave", true)
    end)
end

function mapScene()
    gfx.sprite.update()
    if shopping == false then
        textBox()
        if pd.buttonJustPressed(playdate.kButtonA) and gasPoints < yourGasPoints then
            
            if not pd.isCrankDocked() and not (pd.getCrankPosition() > 240 and pd.getCrankPosition() < 300) then
                badSound:play()
                playdate.graphics.clear()
                crankCheckTextSprite:setVisible(true)    
                gfx.sprite.update()
            else
            switchSceneNum = 3

            currentTime = 2 * distance(locations[currentLoc][1][1],locations[currentLoc][1][2],locations[currentSelect][1][1],locations[currentSelect][1][2]) * timeSpeed
            yourGasPoints -= gasPoints

            --goodSound:play()
            truckSound:play()
        
            --mapImageFunc(findClosestPoint(locations[currentLoc][1][1],locations[currentLoc][1][2],locations))
            end
        end
        if pd.buttonJustPressed(playdate.kButtonB) then
            shopping = true
            shopSprite:setVisible(true)
            goodSound:play()
        end

        mapPosX, mapPosY = mapSprite:getPosition()
        mapSprite:moveTo(lerp(mapPosX,mapSprite.posx,0.1),lerp(mapPosY,mapSprite.posy,0.1))

        --[[
        if math.abs(pd.getCrankChange()) > 0.2 then
        mapImageFunc(crankPosRotateMap(locations[currentLoc][1][1],locations[currentLoc][1][2],locations,currentSelect,pd.getCrankPosition()))
        end
        ]]--

        if pd.buttonJustPressed(playdate.kButtonLeft) then
            nuSound:play()
            if radial then
                mapImageFunc(findLastRotationTo(locations[currentLoc][1][1],locations[currentLoc][1][2],locations,currentSelect))
            else
                mapImageFunc(findNextClosest(locations[currentLoc][1][1],locations[currentLoc][1][2],locations,currentSelect))
            end
        elseif pd.buttonJustPressed(playdate.kButtonRight) then
            nuSound:play()
            if radial then
                mapImageFunc(findNextRotationTo(locations[currentLoc][1][1],locations[currentLoc][1][2],locations,currentSelect))
            else
                mapImageFunc(findNextFarthest(locations[currentLoc][1][1],locations[currentLoc][1][2],locations,currentSelect))
            end
        elseif pd.buttonIsPressed(playdate.kButtonUp) then
            mapSprite:moveBy(0,5)
        elseif pd.buttonIsPressed(playdate.kButtonDown) then
            mapSprite:moveBy(0,-5)
        end
    else
        if pd.buttonJustPressed(playdate.kButtonB) then
            
            shopping = false
            shopSprite:setVisible(false)
            textBoxTop()
            textBox()
            badSound:play()
        end
        
        if pd.buttonJustPressed(pd.kButtonA) and yourGasPoints+5 <= 150 and yourMoney >= locations[currentLoc][3] then
            yourMoney -= locations[currentLoc][3]
            yourGasPoints += 5
            shop()
            nuSound:play()
        end

    end
end

function mapEnd()
    mapSprite:remove()
    --backgroundSprite:remove()
    textBoxSprite:remove()
    textBoxTopSprite:remove()
    shopSprite:remove()
    crankCheckTextSprite:remove()
    menu:removeAllMenuItems()
    
    --gfx.sprite.removeAll()
end

function mapImageFunc(localCurrentSelect)
    mapImage = gfx.image.new("images/map")
    gfx.pushContext(mapImage)
        gfx.setColor(gfx.kColorWhite)
        for x = 1, #locations do
            local location = locations[locations[x]]
            
            if location[2] == true then
                currentLoc = locations[x]
                gfx.fillRect(location[1][1]-3,location[1][2]-3,6,6)
                moveMapToX = (250 - location[1][1]) --* 2
                moveMapToY = (200 - location[1][2]) --* 2


                currentSelect = localCurrentSelect
                clostestPlaceX = locations[currentSelect][1][1]
                clostestPlaceY = locations[currentSelect][1][2]
                --print(currentLoc .. " -> " .. currentSelect)
                
                moveMapToX = (250 - (location[1][1] + clostestPlaceX)/2) --* 2
                moveMapToY = (200 - (location[1][2] + clostestPlaceY)/2) --* 2

                gfx.setColor(gfx.kColorWhite)
                gfx.setLineWidth(2)
                gfx.drawLine(location[1][1],location[1][2],clostestPlaceX,clostestPlaceY)
            else
                gfx.fillCircleAtPoint(location[1][1],location[1][2],4)
            end
        end
    gfx.popContext()
    mapSprite:setImage(mapImage)
    mapSprite.posx = 200+moveMapToY
    mapSprite.posy = 120-moveMapToX
end

function findClosestPoint(currentLocX, currentLocY,list)
    local smallestDis = 10000.0
    for i = 1, #list do
        item = list[list[i]]
        currentDis = distance(currentLocX,currentLocY,item[1][1],item[1][2])
        if currentDis < smallestDis and currentDis > 1 then
            closestPlace = list[i]
            smallestDis = currentDis
        end
    end
    return closestPlace
end

function findNextClosest(currentLocX, currentLocY,list,currentSelect)
    local smallestDis = 10000.0
    local limitDis = distance(currentLocX,currentLocY,list[currentSelect][1][1],list[currentSelect][1][2])
    for i = 1, #list do
        item = list[list[i]]
        currentDis = distance(currentLocX,currentLocY,item[1][1],item[1][2])
        if currentDis < smallestDis and currentDis > limitDis then
            closestPlace = list[i]
            smallestDis = currentDis
        end
    end
    return closestPlace
end

function findNextFarthest(currentLocX, currentLocY,list,currentSelect)
    local smallestDis = -10000.0
    local limitDis = distance(currentLocX,currentLocY,list[currentSelect][1][1],list[currentSelect][1][2])
    for i = 1, #list do
        item = list[list[i]]
        currentDis = distance(currentLocX,currentLocY,item[1][1],item[1][2])
        if currentDis > smallestDis and currentDis < limitDis and currentDis > 1 then
            closestPlace = list[i]
            smallestDis = currentDis
        end
    end
    return closestPlace
end

function findNextRotationTo(currentLocX, currentLocY,list,currentSelect)
    local smallestRot = 10000.0
    local clockPoint = rotationTo(currentLocX,currentLocY,list[currentSelect][1][1],list[currentSelect][1][2])
    --print(clockPoint)
    for i = 1, #list do
        if list[i] ~= currentSelect and list[i] ~= currentLoc then
            item = list[list[i]]
            currentRotation = fixAngle(rotationTo(currentLocX,currentLocY,item[1][1],item[1][2]) - clockPoint)
            --print(list[i]..": "..currentRotation)
            if currentRotation < smallestRot then
                closestPlace = list[i]
                smallestRot = currentRotation
                --print(closestPlace .. smallestRot)
            end
        end
    end
    return closestPlace
end

function findLastRotationTo(currentLocX, currentLocY,list,currentSelect)
    local smallestRot = -10000.0
    local clockPoint = rotationTo(currentLocX,currentLocY,list[currentSelect][1][1],list[currentSelect][1][2])
    for i = 1, #list do
        if list[i] ~= currentSelect and list[i] ~= currentLoc then
            item = list[list[i]]
            currentRotation = fixAngle(rotationTo(currentLocX,currentLocY,item[1][1],item[1][2]) - clockPoint)
            --print(list[i]..": "..currentRotation)
            if currentRotation > smallestRot then
                closestPlace = list[i]
                smallestRot = currentRotation
                --print(closestPlace .. smallestRot)
            end
        end
    end
    return closestPlace
end

function crankPosRotateMap(currentLocX, currentLocY,list,currentSelect,crankRot)
    local smallestRot = -10000.0
    
    local clockPoint = 360.0 - crankRot
    --print(clockPoint)
    for i = 1, #list do
        if list[i] ~= currentLoc then
            item = list[list[i]]
            currentRotation = clockPoint - math.abs(math.deg(rotationTo(currentLocX,currentLocY,item[1][1],item[1][2])) - clockPoint)
            --print(list[i] .. ": " .. currentRotation)
            if currentRotation > smallestRot then
                closestPlace = list[i]
                smallestRot = currentRotation
                --print(closestPlace .. smallestRot)
            end
        end
    end
    return closestPlace
end

function textBox()
    textBoxImage = gfx.image.new(240,fontHeight*3+8)
    gfx.pushContext(textBoxImage)
        gasPoints = math.floor(distance(locations[currentLoc][1][1],locations[currentLoc][1][2],locations[currentSelect][1][1],locations[currentSelect][1][2]))
        if gasPoints > yourGasPoints then
            --gfx.drawText("\n" .. "\ngoal location: "..storyList[storyNumer][2],0,0)
            gfx.drawText(currentLoc .. " to " .. currentSelect .. "\n" .. "TOO FAR, need " .. -(yourGasPoints - gasPoints) .. " more\ngoal location: "..storyList[storyNumer][2],0,0)
        else 
            
            gfx.drawText(currentLoc .. " to " .. currentSelect .. "\n" .. "fuel needed: " .. gasPoints .. "\ngoal location: "..storyList[storyNumer][2],0,0)
        end
    gfx.popContext()
    textBoxSprite:setImage(textBoxImage)
end

function textBoxTop()
    textBoxTopImage = gfx.image.new(240,fontHeight*3+8)
    gfx.pushContext(textBoxTopImage)
        gfx.drawText("B to open store" .. "\n" .. "Your fuel: " .. yourGasPoints .. " / 150\n" .. "Your money: $" .. yourMoney ,0,0)
    gfx.popContext()
    textBoxTopSprite:setImage(textBoxTopImage)
end

function shop()

    shopImage = gfx.image.new(240,400,gfx.kColorWhite)
    gfx.pushContext(shopImage)
        gfx.drawText("Your money: $" .. yourMoney .. "\nCurrent fuel price: $" .. tostring(locations[currentLoc][3]) .. "\nYour fuel: " .. yourGasPoints .. " / 150",10,10)
            
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(20,200,200,20)
        gfx.drawText("V",20+((190/150)*yourGasPoints),180)
        gfx.drawText("press A to buy fuel.",20,225)
    gfx.popContext()
    shopSprite:setImage(shopImage)
end