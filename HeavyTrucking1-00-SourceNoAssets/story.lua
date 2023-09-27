
storyList = {
    {"The contracts have been signed and the keys have been given. Today is the day! The day you start your new life as a professional truck driver. Your first job? Drive from Portland to Seattle. Buckle your seatbelt and get driving!","Seattle",100},
    {"Great job! You have collected $100 for doing this job. Now onto the next one, your employer has ordered you to go to Austin, Texas.","Austin",50},
    {"Oh no! People in Texas are very cheap, you have only been rewarded $50 for this job. Although, there are some rumbling of a big east coast job. Make your way to Charlotte with your next load and see what's happening.","Charlotte",200},
    {"Oh wow, a big job, you have be awarded $200 for accepting this job. It will have you driving all over the east coast non-stop for the next week or two. You must now go to Miami to pick up your first load for this big job.","Miami",200},
    {"Oh wow! Lots of avocados! People in New York love avocado toast. Time to bring them to New York.","NewYork",300},
    {"The people in New York were very cold to you, but they payed you well because they knew what you were worth. They also treated you to some pizza and you saw a rat and some turtles. Now you must go to Detroit.","Detroit",100},
    {"Uh oh! There seems to be some kind of robot revolution happening here, quick, make your way to Pittsburgh!","Pittsburgh",0},
    {"Oh no! Now it seems like here there seems to be some kind of revolution with many people in animal costumes! Quick, make your way to Toronto!","Toronto",0},
    {"Ah yes, Toronto, a Raccoon's dream city. I know it's hard to say goodbye, unfortunately the people in Chicago need their maple syrup.","Chicago",100},
    {"The people in Chicago were very nice, you got a hot dog, but it's very cold. Make your way to Nashville.","Nashville",100},
    {"Nashville is your last stop on this big east coast job, well done! You now have one more delievery to make in Winnipeg and then you can make your way back home.","Winnipeg",250},
    {"You are very excited for the future of you being a truck driver. This is your first big adventure, you also need a nap. Get back to Portland.","Portland",250},
    {"You made it back to Portland! Congratulations, you have been rewarded a promotion to business worker. Your time as a truck driver is no more.","Portland",250},
}

storyNumer = 1
currentStory = storyList[storyNumer][1]

function storyStart(text)
    
    font:setLeading(font:getLeading() + 8)
    gfx.setBackgroundColor(gfx.kColorWhite)

    backgroundImage = gfx.image.new(400,240,gfx.kColorWhite)
    backgroundSprite = gfx.sprite.new(backgroundImage)
    backgroundSprite:moveTo(200,120)
    backgroundSprite:setZIndex(-20000)
    backgroundSprite:add()

    wrapText, lineCount = wrapTextFunc(text, 220, font)
    _, textHight = gfx.getTextSize(wrapText)
    storyImage = gfx.image.new(240,textHight+40)
    gfx.pushContext(storyImage)
        gfx.drawText(wrapText,10,20)
        
    gfx.popContext()
    storySprite = gfx.sprite.new(storyImage)
    --storySprite:setImageDrawMode(gfx.kDrawModeInverted)
    storySprite:moveTo((textHight+40)/2,120)
    storySprite:setRotation(-90)
    storySprite:setZIndex(20)
    storySprite:add()

    font:setLeading(font:getLeading() - 8)

end

function storyScene()
    gfx.sprite.update()
    if pd.buttonJustPressed(playdate.kButtonA) then
        --switchSceneNum = 5

        goodSound:play()
        if #storyList < storyNumer += 1 then
            switchSceneNum = 8
        else
        switchSceneNum = 5
        end
    end
    if textHight + 40 > 400 then
        if pd.buttonIsPressed(playdate.kButtonRight) then
            storySprite:moveBy(-5,0)
        end
        if pd.buttonIsPressed(playdate.kButtonLeft) then
            storySprite:moveBy(5,0)
        end
        storySprite:moveBy(-pd.getCrankChange(),0)
        
        storySpritePosX, storySpritePosY = storySprite:getPosition()
        storySprite:moveTo(clamp(storySpritePosX, -(textHight+40)/2+400, (textHight+40)/2),120)
    end
end

function storyEnd()
    backgroundSprite:remove()
    storySprite:remove()
end

function wrapTextFunc(line, width, font)
    font = font or gfx.getFont()
    local currentWidth, currentLine = 0, ""
    local lineNumber = 1
    if line == "" or font:getTextWidth(line) <= width then
        return line
    else
    newLine = ""
    for word in line:gmatch("%S+") do
        if (font:getTextWidth(currentLine) + font:getTextWidth(word)) >= width then
            newLine = newLine .. "\n" .. word .. " "
            currentLine = word .. " "
            lineNumber += 1
        else
            newLine = newLine .. word .. " "
            currentLine = currentLine .. word .. " "
        end
    end
    return newLine, lineNumber
    end
end