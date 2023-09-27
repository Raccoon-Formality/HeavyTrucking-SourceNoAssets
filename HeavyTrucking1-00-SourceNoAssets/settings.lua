function settingsStart()
    
    gfx.setBackgroundColor(gfx.kColorWhite)

    settingsMenuSelcetion = 0
    settingsGapSize = 40
    settingsAmount = 6

    settingsMenuImage = gfx.image.new(240,400)
    settingsMenuSprite = gfx.sprite.new(mainMenuImage)
    settingsImageChange()
    settingsMenuSprite:setRotation(-90)
    settingsMenuSprite:moveTo(200,120)
    settingsMenuSprite:add()

    settingSelectorImage = gfx.image.new(30,240,gfx.kColorWhite)
    settingSelectorSprite = gfx.sprite.new(selectorImage)
    settingSelectorSprite:moveTo(27+(settingsGapSize*settingsMenuSelcetion),120)
    settingSelectorSprite:setImageDrawMode(gfx.kDrawModeXOR)
    settingSelectorSprite:add()

    saveChecking = false
    willDelete = false

    sureBoxImage = gfx.image.new(200, 100)
    sureBoxSprite = gfx.sprite.new(sureBoxImage)
    sureBoxSprite:setRotation(-90)
    sureBoxSprite:setImageDrawMode(gfx.kDrawModeInverted)
    sureBoxSprite:moveTo(200,120)
    settingsSureBoxChange()

    settingSelectorLerp = 27+(settingsGapSize*settingsMenuSelcetion)
    

end

function settingsScene()
    gfx.sprite.update()

    settingSelectorX, settingSelectorY = settingSelectorSprite:getPosition()
    settingSelectorLerp = lerp(settingSelectorLerp,27+(settingsGapSize*settingsMenuSelcetion),0.25)
    settingSelectorSprite:moveTo(math.floor(settingSelectorLerp+0.5),120)

    if not saveChecking then

        if pd.buttonJustPressed(playdate.kButtonB) then
            switchSceneNum = 1
            playdate.datastore.write({difficulty,timeSpeed}, "difficultySave", true)
            playdate.datastore.write({viewBobbing}, "viewBobbingSave", true)
            playdate.datastore.write({radial}, "radialSave", true)
            playdate.datastore.write({showFPS}, "showFPSSave", true)
            playdate.datastore.write({potholeDifficulty, potholeTime, potholeChance}, "potholeDifficultySave", true)

            badSound:play()
        end

        if pd.buttonJustPressed(playdate.kButtonLeft) then
            settingsMenuSelcetion -= 1
            if settingsMenuSelcetion < 0 then
                settingsMenuSelcetion += settingsAmount
            end
            --settingsImageChange()
            nuSound:play()
        elseif pd.buttonJustPressed(playdate.kButtonRight) then
        
            settingsMenuSelcetion += 1
            if settingsMenuSelcetion > settingsAmount - 1 then
                settingsMenuSelcetion -= settingsAmount
            end
            --settingsImageChange()
            nuSound:play()
        end

        if pd.buttonJustPressed(playdate.kButtonA) then
            goodSound:play()
            playdate.datastore.write({sensitiveSettings}, "sensitiveSettingsSave", true)
            
            if settingsMenuSelcetion == 0 then --view bobbing
                viewBobbing = reverseBool(viewBobbing)
                settingsImageChange()
            elseif settingsMenuSelcetion == 2 then
                difficultyIndex += 1
                if difficultyIndex > 3 then difficultyIndex = 1 end
                setDifficulty(difficultyList[difficultyIndex])
                settingsImageChange()
            elseif settingsMenuSelcetion == 1 then
                showFPS = reverseBool(showFPS)
                settingsImageChange()
            elseif settingsMenuSelcetion == 5 then
                saveChecking = true
                sureBoxSprite:add()
                --[[
                pd.datastore.delete("DesertBusSave")
                pd.datastore.delete("difficultySave")
                pd.datastore.delete("QuickStorySave")
                pd.datastore.delete("sensitiveSettingsSave")
                pd.datastore.delete("viewBobbingSave")
                desertBusPoints = 0
                difficulty = "normal"
                timeSpeed = 1.0
                sensitiveSettings = 1.0
                viewBobbing = true
                switchSceneNum = 1
                ]]--
            elseif settingsMenuSelcetion == 3 then
                potholeDifficultyIndex += 1
                if potholeDifficultyIndex > 4 then potholeDifficultyIndex = 1 end
                setPotholeDifficulty(potholeDifficultyList[potholeDifficultyIndex])
                settingsImageChange()
            elseif settingsMenuSelcetion == 4 then
                radial = reverseBool(radial)
                settingsImageChange()
            end
        end
    else
        if pd.buttonJustPressed(pd.kButtonUp) or pd.buttonJustPressed(pd.kButtonDown) then
            willDelete = reverseBool(willDelete)
            settingsSureBoxChange()
        end

        if pd.buttonJustPressed(pd.kButtonA) then
            if willDelete then
                saveChecking = false
                sureBoxSprite:remove()
                pd.datastore.delete("DesertBusSave")
                pd.datastore.delete("difficultySave")
                pd.datastore.delete("QuickStorySave")
                pd.datastore.delete("sensitiveSettingsSave")
                pd.datastore.delete("viewBobbingSave")
                pd.datastore.delete("radialSave")
                pd.datastore.delete("showFPSSave")
                pd.datastore.delete("potholeDifficultySave")
                desertBusPoints = 0
                difficulty = "normal"
                timeSpeed = 1.0
                potholeDifficulty = "easy"
                potholeTime = 100
                potholeChance = 10
                sensitiveSettings = 1.0
                viewBobbing = true
                showFPS = false
                switchSceneNum = 1
            else 
                saveChecking = false
                sureBoxSprite:remove()
            end
        end

    end
end

function settingsEnd()
    settingsMenuSprite:remove()
    settingSelectorSprite:remove()
end

checkboxChecked = gfx.image.new("images/checkbox-on")
checkboxUnchecked = gfx.image.new("images/checkbox-off")

function reverseBool(rbool)
    if rbool then return false
    else return true end
end

function boolImage(bool)
    if bool then return checkboxChecked
    else return checkboxUnchecked end
end

function settingsImageChange()
    settingsMenuImage = gfx.image.new(240,400)
    gfx.pushContext(settingsMenuImage)
        gfx.drawText("view bobbing",25,20)
        boolImage(viewBobbing):draw(170,15)

        --gfx.drawText(">",12,20+(settingsGapSize*settingsMenuSelcetion))
        
        gfx.drawText("difficulty",25,20+(settingsGapSize*2))--250)
        gfx.drawText(difficulty,155,20+(settingsGapSize*2))

        gfx.drawText("show FPS",25,20+(settingsGapSize*1))
        boolImage(showFPS):draw(170,15+(settingsGapSize*1))
        
        gfx.drawText("clear save files",25,20+(settingsGapSize*5))--280)
        --boolImage(true):draw(180,20+(settingsGapSize*2)-5)

        gfx.drawText("potholes",25,20+(settingsGapSize*3))--250)
        gfx.drawText(potholeDifficulty,155,20+(settingsGapSize*3))

        gfx.drawText("map-move",25,20+(settingsGapSize*4))--250)
        if radial then
            gfx.drawText("radial",155,20+(settingsGapSize*4))
        else
            gfx.drawText("distance",155,20+(settingsGapSize*4))
        end

        --gfx.drawText("idk, something",25,20+(settingsGapSize*3))
        --boolImage(false):draw(180,20+(settingsGapSize*3)-5)
    gfx.popContext()
    settingsMenuSprite:setImage(settingsMenuImage)
end

function settingsSureBoxChange()
    
    sureBoxImage = gfx.image.new(200, 100)
    gfx.pushContext(sureBoxImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(-1,-1,202,102)
        gfx.setColor(gfx.kColorBlack)

        gfx.drawText("are you sure?",10,10)
        gfx.drawText("yes",25,50)
        if willDelete then 
            gfx.drawText(">",12,50)
        else
            gfx.drawText(">",112,50)
        end
        gfx.drawText("no",125,50)
    gfx.popContext()
    sureBoxSprite:setImage(sureBoxImage)

end