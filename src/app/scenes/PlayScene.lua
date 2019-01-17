FruitItem = import("app.scenes.FruitItem")
local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

function PlayScene:ctor()
    display.addSpriteFrames("images/button1.plist","images/button1.png")
    math.newrandomseed()    --添加随机数rand 
    
    self.xCount = 8         --水平方向的水果数量
    self.yCount = 8         --水平方向的水果数量
    self.fruitGap = 0       --精灵之间的间距
    self.highSorce =cc.UserDefault:getInstance():getIntegerForKey("HighSorce")
    self.stage=cc.UserDefault:getInstance():getIntegerForKey("Stage")
        if self.stage ==0 then
            self.stage =1
        end
    self.target=200
    self.curSorce=0
    self:initUI()

    self.scoreStart = 5     --水果积分
    self.scoreStep =10      --加成积分 
    self.activeScore =0     --当前高亮的水果得分

    self.matrixLBX =(display.width - FruitItem.getWidth() * self.xCount - (self.yCount - 1) * self.fruitGap)/2
    self.matrixLBY =(display.height - FruitItem.getWidth() * self.yCount - (self.xCount - 1) * self.fruitGap)/2 - 30

    self:addNodeEventListener(cc.NODE_EVENT,function ( event )
        if event.name =="enterTransitionFinish" then
            self:initMatrix()
        end
    end)                    --event.name = enterTransitionFinis 时加载矩阵

    audio.playMusic("music/mainbg.mp3",true)
    audio.setMusicVolume(1)

end
function PlayScene:initMatrix()
    self.matrix = {}    --创建空矩阵 
    self.actives = {}   --创建高亮水果表单
    for y=1,self.yCount do
        for x=1,self.xCount do
            if 1==y and 2== x   then --确保有可以消除的水果
                self:createAndDropFruit(x,y,self.matrix[1].FruitItem)
            else
                self:createAndDropFruit(x,y)
            end
        end
    end
end



function PlayScene:initUI()
        --背景
    display.newSprite("images/playsceneBG.png")
        :pos(display.cx, display.cy)
        :addTo(self)
        --返回主界面
    local startbtnimages={
        normal ="#home.png",}
    cc.ui.UIPushButton.new(startbtnimages,{scale9=false})
        :onButtonClicked(function ( event )
            audio.playSound("music/itemSelect.mp3")
            audio.stopMusic() 
             local mainSence = import("app.scenes.MainScene"):new()
                display.replaceScene(mainSence,"crossFade",0.5)

        end)
        :align(display.LEFT_CENTER, display.cx+160, display.top-150)
        :addTo(self)

        --重新开始
    local startbtnimages={
        normal ="images/return.png",}
    cc.ui.UIPushButton.new(startbtnimages,{scale9=false})
        :onButtonClicked(function ( event )
            audio.playSound("music/itemSelect.mp3")
                self:tochoose()
          
        
            

        end)
        :align(display.LEFT_CENTER, display.cx+230, display.top-153)
        :addTo(self)
        --购买按钮
      local startbtnimages={
        normal ="#buy.png",}
    cc.ui.UIPushButton.new(startbtnimages,{scale9=false})
        :onButtonClicked(function ( event )
            audio.playSound("music/itemSelect.mp3")
        end)
        :align(display.LEFT_CENTER, display.left+30, display.top-150)
        :addTo(self)
        --添加滑动条
    local sliderImages={
    bar= "#The_time_axis_Tunnel.png",
    button="#The_time_axis_Trolley.png"}

    self.sliderBar = cc.ui.UISlider.new(display.LEFT_TO_RIGHT,sliderImages,{scale9 =false})   
    :setSliderSize(display.width, 125)  --设置滑动条大小
    :setSliderValue(0)      --设置滑动块位置
    :align(display.LEFT_BOTTOM, 0, 0)
    :addTo(self)
    self.sliderBar:setTouchEnabled(false)

    display.newSprite("#high_score.png")
        :align(display.LEFT_CENTER, display.left+15, display.top-30)
        :addTo(self)
    display.newSprite("#highscore_part.png")
        :align(display.LEFT_CENTER, display.cx+10, display.top-26)
        :addTo(self)
    self.highSorceLabel = cc.ui.UILabel.new({UILabelType=1 , text =tostring(self.highSorce), font="font/font38.fnt"})
        :align(display.CENTER, display.cx+105, display.top-24)
        :addTo(self)
        --最高分部分

    display.newSprite("#stage.png")
        :align(display.LEFT_CENTER, display.left+10, display.top-80)
        :addTo(self)
    display.newSprite("#stage_part.png")
        :align(display.LEFT_CENTER, display.cx-140, display.top-78)
        :addTo(self)
    self.stageLabel = cc.ui.UILabel.new({UILabelType=1 , text =tostring(self.stage), font="font/font32.fnt"})
        :align(display.CENTER, display.cx-100, display.top-78)
        :addTo(self)
        --当前关卡部分

    display.newSprite("#tarcet.png")
        :align(display.LEFT_CENTER, display.cx-20, display.top-80)
        :addTo(self)
    display.newSprite("#tarcet_part.png")
        :align(display.LEFT_CENTER, display.right-150, display.top-78)
        :addTo(self)
   self.targetLabel = cc.ui.UILabel.new({UILabelType=1 , text =tostring(self.target), font="font/font32.fnt"})
        :align(display.CENTER, display.right-85, display.top-78)
        :addTo(self)
        --得分

    display.newSprite("#sound.png")
        :align(display.LEFT_CENTER, display.right-80, display.top-30)
        :addTo(self)
        :setTouchEnabled(true)
        :addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event ) 
            if event.name =="began" then
                local a= audio.getMusicVolume()
                if a==1 then
                   audio.setMusicVolume(0)
                   audio.setSoundsVolume(0) 
                   else
                       audio.setMusicVolume(1)
                       audio.setSoundsVolume(1)
                end
            end
        end)
        --声音图标
    display.newSprite("#score_now.png")
        :align(display.CENTER, display.cx, display.top-150)
        :addTo(self)
    self.curSorceLabel = cc.ui.UILabel.new({UILabelType=1 , text =tostring(self.curSorce), font="font/font48.fnt"})
        :align(display.CENTER, display.cx, display.top-150)
        :addTo(self)

        --添加了一个label用来显示消除的分数
    self.activeScoreLabel = display.newTTFLabel({text="",size=30})
        :pos(display.width/2, 120)
        :addTo(self)
    self.activeScoreLabel:setColor(display.COLOR_WHITE)
end


function PlayScene:createAndDropFruit( x,y,fruitIndex )     --单个水果精灵的创建
    local  newFruit = FruitItem.new(x,y,fruitIndex)
    local endPosition = self:positionOfFruit(x,y)
    local startPosition = cc.p(endPosition.x,endPosition.y + display.height /2)
    newFruit:setPosition(startPosition)
    local speed = startPosition.y /(2* display.height)
    newFruit:runAction(cc.MoveTo:create(speed,endPosition))
    self.matrix[(y - 1)* self.xCount + x] = newFruit
    self:addChild(newFruit)

    newFruit:setTouchEnabled(true)      --触摸事件
    newFruit:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
        if  event.name == "ended" then
            if newFruit.isActive then
                local musicIndex = #self.actives
                if (musicIndex < 2) then
                    musicIndex =2 
                end
                if (musicIndex > 9) then
                    musicIndex= 9
                end
    local tmpStr = string.format("music/broken%d.mp3", musicIndex)
    audio.playSound(tmpStr)
    audio.setSoundsVolume(1)
    self:removeActivedFruits()
    self:dropFruits()                                             --消除水果，加分，并掉落补全
    self:checkNextStage()                                         --验证是否达到过关分数
    else
        self:inactive()                       --清楚已经高亮水果
        self:activeNeighbor(newFruit)         --以选中的水果为中心高亮周围相同的水果
        self:showActivesScore()               --计算高亮区域水果的分数
        audio.playSound("music/itemSelect.mp3")
        audio.setSoundsVolume(1)
        end
    end
        if event.name =="began" then
            return true
        end
    end)
end

function PlayScene:inactive()           --清除高亮水果函数
    for _,fruit in pairs(self.actives) do
        if (fruit) then
            fruit:setActive(false)
        end
    end
    self.actives = {}    
end

function PlayScene:activeNeighbor(fruit)     --以选中水果为中心高亮周围一样的水果
    if fruit.isActive == false then     --高亮水果 
        fruit:setActive(true)
        table.insert(self.actives,fruit)
    end

    if (fruit.x -1)>= 1 then            --检查左边的水果
        local leftNeighbor = self.matrix[(fruit.y -1) * self.xCount + fruit.x -1]
        if (leftNeighbor.isActive == false) and (leftNeighbor.fruitIndex == fruit.fruitIndex) then
            leftNeighbor:setActive(true)
            table.insert(self.actives,leftNeighbor)
            self:activeNeighbor(leftNeighbor)
        end
    end

    if (fruit.x +1) <= self.xCount then            --检查右边的水果
        local rightNeighbor = self.matrix[(fruit.y -1) * self.xCount + fruit.x +1]
        if (rightNeighbor.isActive == false) and (rightNeighbor.fruitIndex == fruit.fruitIndex) then
            rightNeighbor:setActive(true)
            table.insert(self.actives,rightNeighbor)
            self:activeNeighbor(rightNeighbor)
        end
    end

    if (fruit.y -1)>= 1 then            --检查下边的水果
        local downNeighbor = self.matrix[(fruit.y -2) * self.xCount + fruit.x ]
        if (downNeighbor.isActive == false) and (downNeighbor.fruitIndex == fruit.fruitIndex) then
            downNeighbor:setActive(true)
            table.insert(self.actives,downNeighbor)
            self:activeNeighbor(downNeighbor)
        end
    end

    if (fruit.y +1)<=self.yCount then            --检查上边的水果
    local upNeighbor = self.matrix[(fruit.y) * self.xCount + fruit.x ]
    if (upNeighbor.isActive == false) and (upNeighbor.fruitIndex == fruit.fruitIndex) then
        upNeighbor:setActive(true)
        table.insert(self.actives,upNeighbor)
        self:activeNeighbor(upNeighbor)
        end
    end
end

function PlayScene:showActivesScore( )
    if #self.actives ==1 then                   --如果只有一个高亮则取消高亮并返回
        self:inactive()
        self.activeScoreLabel:setString("")
        self.activeScore =0
        return
    end
                                                --求和并且显示
    self.activeScore=(self.scoreStart *2 + self.scoreStep *(#self.actives -1 )) * #self.actives /2
    self.activeScoreLabel:setString(string.format("%d 连消，得分 %d", #self.actives,self.activeScore))
end

function PlayScene:removeActivedFruits( )
    local fruitScore = self.scoreStart
    for _,fruit in pairs(self.actives)do
        if (fruit) then
            --从矩阵中删除    
            self.matrix[(fruit.y-1) * self.xCount + fruit.x]=nil
            local  time =  0.3 
                    --爆炸圈
            local circleSprite = display.newSprite("images/circle.png")
            :pos(fruit:getPosition())
            :addTo(self)
            circleSprite:setScale(0)
            circleSprite:runAction(cc.Sequence:create(
            cc.ScaleTo:create(time,1.0),
            cc.CallFunc:create(function ( )
                circleSprite:removeFromParent()
            end)

            ))

            --爆炸碎片
            local emitter = cc.ParticleSystemQuad:create("stars.plist")
            emitter :setPosition(fruit:getPosition())
            local batch = cc.ParticleBatchNode:createWithTexture(emitter:getTexture())
            batch :addChild(emitter)
            self:addChild(batch)
            --分出特效
            self:scorePopupEffect(fruitScore,fruit:getPosition())
            fruitScore= fruitScore+ self.scoreStep
            --移除水果
            fruit:removeFromParent()


        end
    end

    --清空高亮数组
        self.actives={}
    --更新当前得分
        self.curSorce = self.curSorce + self.activeScore
        self.curSorceLabel:setString(tostring(self.curSorce))
    --清空高亮水果分数统计
        self.activeScoreLabel:setString("")
        self.activeScore = 0

     local slidervalue = self.curSorce /self.target *100  --进度条value的改变
     if slidervalue >100 then
            slidervalue = 100
        end  
        self.sliderBar:setSliderValue(slidervalue) 
end

function PlayScene:dropFruits()          --掉落补全表格    
    local emptyInfo={}
    -- 1.掉落已存在的水果   
    -- 一列列的处理
    for x=1,self.xCount do
        local removeFruits = 0
        local newY = 0
        for y=1,self.yCount do
            local temp = self.matrix[(y-1) * self.xCount +x]
            if temp == nil then
                removeFruits = removeFruits + 1
                else
                    if removeFruits > 0 then
                        newY = y - removeFruits
                        self.matrix[(newY -1) * self.xCount + x] = temp
                        temp.y = newY
                        self.matrix[(y-1) * self.xCount + x]=nil

                        local endPosition = self:positionOfFruit(x, newY)
                        local speed = (temp:getPositionY() -endPosition.y)/display.height
                        temp:stopAllActions()
                        temp:runAction(cc.MoveTo:create(speed,endPosition))
                    end
            end
        end
        emptyInfo[x] = removeFruits         --记录本列最终空缺数
    end
    -- 2.掉落新水果补齐空缺
    for x=1,self.xCount do
        for y=self.yCount - emptyInfo[x]+1,self.yCount do
            self:createAndDropFruit(x, y)
        end
    end

end

function PlayScene:positionOfFruit( x,y )                  --计算水果的终点坐标
    local px = self.matrixLBX + (FruitItem.getWidth() +self.fruitGap) * (x-1)+FruitItem.getWidth()/2
    local py = self.matrixLBY + (FruitItem.getWidth() +self.fruitGap) * (y-1)+FruitItem.getWidth()/2
    return cc.p(px,py)

end

function PlayScene:scorePopupEffect(score, px, py)
    local labelScore = cc.ui.UILabel.new({UILabelType = 1, text = tostring(score), font = "font/font32.fnt"})

    local move = cc.MoveBy:create(0.8, cc.p(0, 80))
    local fadeOut = cc.FadeOut:create(0.8)
    local action = transition.sequence({
        cc.Spawn:create(move,fadeOut),
        -- 动画结束移除 Label
        cc.CallFunc:create(function() labelScore:removeFromParent() end)
    })

    labelScore:pos(px, py)
        :addTo(self)
        :runAction(action)
end

function PlayScene:checkNextStage( )
    if self.curSorce < self.target then
        return
    end
    audio.playSound("music/wow.mp3")
    audio.setSoundsVolume(1)
    local resultLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150))
    resultLayer:addTo(self)
            --  吞噬事件
    resultLayer:setTouchEnabled(true) 
    resultLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
        if event.name=="began"  then
            return true
        end
    end)
        --数据更新
    if self.curSorce >=self.highSorce then
        self.highSorce =self.curSorce
    end
    self.stage =self.stage+1
    self.target = 200
    --存储到文件
    cc.UserDefault:getInstance():setIntegerForKey("HighSorce", self.highSorce)
    cc.UserDefault:getInstance():setIntegerForKey("Stage", self.stage)

    -- 通关信息
    display.newTTFLabel({text =string.format(" 恭喜过关！\n 最高得分：%d", self.highSorce),size=60})
        :pos(display.cx, display.cy+140)
        :addTo(resultLayer)
    -- 按钮
        local startbtnimages = {
        normal ="images/victory.png",
        pressed="images/victory.png",
    }
        cc.ui.UIPushButton.new(startbtnimages,{scale9=false})
            :onButtonClicked(function ( event )
                audio.playSound("music/itemSelect.mp3")
                audio.stopMusic()   --停止音乐
                local mainSence = import("app.scenes.MainScene"):new()
                display.replaceScene(mainSence,"flipX",0.5)
            end)

        :align(display.CENTER, display.cx, display.cy-80)      
        :addTo(resultLayer)
end

function PlayScene:tochoose( )
    local layer1 = display.newColorLayer(cc.c4b(0, 0, 0, 150))
    layer1:addTo(self)
    layer1:setTouchEnabled(true) 
    layer1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
        if event.name=="began"  then
           return true
       end
 end)
    local goimages = {normal="#go.png"}
    cc.ui.UIPushButton.new(goimages,{scal9=false})
        :onButtonClicked(function ( event )
            audio.playSound("music/itemSelect.mp3")
            self:removeChild(layer1)
        end)
        :align(display.CENTER, display.cx, display.cy+120)
        :addTo(layer1)

    local tohomeimages = {normal="#tohome.png"}
    cc.ui.UIPushButton.new(tohomeimages,{scal9=false})
        :onButtonClicked(function ( event )
            audio.playSound("music/itemSelect.mp3")
                audio.stopMusic()   --停止音乐
                local mainSence = import("app.scenes.MainScene"):new()
                display.replaceScene(mainSence,"crossFade",0.5)
        end)
        :align(display.CENTER, display.cx+4, display.cy+20)
        :addTo(layer1)

    local replayimages = {normal="#replay.png"}
    cc.ui.UIPushButton.new(replayimages,{scal9=false})
        :onButtonClicked(function ( event )
            audio.playSound("Music/btnStart.mp3")
            local playScene = import("app.scenes.PlayScene"):new()
            display.replaceScene(playScene,"crossFade",0.5)

        end)
        :align(display.CENTER, display.cx+4, display.cy-80)
        :addTo(layer1)
end

function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
