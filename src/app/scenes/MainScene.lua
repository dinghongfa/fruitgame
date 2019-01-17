
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    --开始按钮
    display.addSpriteFrames("images/fruit.plist","images/fruit.png")
    display.newSprite("images/mainBG.png")
    	:pos(display.cx, display.cy)
    	:addTo(self)
    local playNode = display.newNode()
        :align(display.CENTER, display.cx, display.cy-150)
        :addTo(self)
    local startbtnimages={
    	normal ="#startBtn_N.png",
    	pressed="#startBtn_S.png",}
    cc.ui.UIPushButton.new(startbtnimages,{scale9=false})
    	:onButtonClicked(function ( event )
            audio.playSound("Music/btnStart.mp3")
    		local playScene = import("app.scenes.PlayScene"):new()
    		display.replaceScene(playScene,"turnOffTiles",0.5)

    	end)	
    	:addTo(playNode)
        :align(display.CENTER,0,0)


        --微信按钮
    local lightNode = display.newNode()
        :align(display.CENTER, display.cx, 150)
        :addTo(self)
    local button = cc.ui.UIPushButton.new({normal = "images/wechat.png",
            pressed ="images/wechat.png"
            }, {scale9 =false})
        :onButtonClicked(function ( event )
            audio.playSound("music/itemSelect.mp3")
            local resultLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150))
            resultLayer:addTo(self)
            --  吞噬事件
            resultLayer:setTouchEnabled(true) 
            resultLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
                if event.name=="began"  then
                    return true
                    end
                end)
            display.newTTFLabel({text =string.format("接口还没做好，\n请返回以游客身份登陆！"),size=40})
            :pos(display.cx+40, display.cy+140)
            :addTo(resultLayer)
        local startbtnimages = {
        normal ="#startBtn_N.png",
        pressed="#startBtn_S.png",
    }
        cc.ui.UIPushButton.new(startbtnimages,{scale9=false})
            :onButtonClicked(function ( event )
                audio.playSound("music/itemSelect.mp3")
                local mainSence = import("app.scenes.MainScene"):new()
                display.replaceScene(mainSence,"crossFade",0.5)
            end)

            :align(display.CENTER, display.cx, display.cy-150)      
            :addTo(resultLayer)
            -- 接口还没想好
        end)
        :addTo(lightNode)
    --打入高光效果
    local stencil = display.newSprite("images/wechat.png")
    local btncil =display.newSprite("#startBtn_N.png")
    local light = display.newSprite("images/light.png")
    local clip = cc.ClippingNode:create(stencil)
    local btnclip = cc.ClippingNode:create(btncil)
    clip:setAlphaThreshold(0.08)
    clip:addChild(light)
    clip:addTo(lightNode)

    btnclip:setAlphaThreshold(0.08)
    btnclip:addChild(light)
    btnclip:addTo(playNode)

    --在NODE上的移动动画显示
    local size = stencil:getContentSize()
    local size1 = btncil:getContentSize()
    local sizeLight = light:getContentSize()
    light:pos(-size.width / 2 - sizeLight.width, 0)
    light:runAction(cc.RepeatForever:create(
        cc.Sequence:create(
            cc.MoveTo:create(1.5, cc.p(size.width / 2 + sizeLight.width, 0)),
            cc.Place:create(cc.p(-size.width / 2 - sizeLight.width, 0)),
            cc.DelayTime:create(1)
        )
    ))

    light:pos(-size1.width / 2 - sizeLight.width, 0)
    light:runAction(cc.RepeatForever:create(
        cc.Sequence:create(
            cc.MoveTo:create(1.5, cc.p(size1.width / 2 + sizeLight.width, 0)),
            cc.Place:create(cc.p(-size1.width / 2 - sizeLight.width, 0)),
            cc.DelayTime:create(1)
        )
    ))
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
