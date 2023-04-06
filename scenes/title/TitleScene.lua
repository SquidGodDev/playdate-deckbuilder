class('TitleScene').extends(NobleScene)
TitleScene.backgroundColor = Graphics.kColorBlack

function TitleScene:init()
    TitleScene.super.init(self)
    self.menu = Noble.Menu.new(true, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 6, 0, nil)
    self.menu:addItem("Play", function()
		-- ===== Temp values =====
		local cardList = {}
		for _, card in pairs(CARDS) do
			table.insert(cardList, card)
		end
		deck = {}
		for i=1,20 do
			local card = Card(cardList[math.random(#cardList)])
			deck[i] = card
		end
		local playerMaxHealth = 40
		Noble.GameData.set("deck", deck)
		Noble.GameData.set("playerMaxHealth", playerMaxHealth)
		Noble.GameData.set("playerHealth", playerMaxHealth)
		Noble.GameData.set("level", {})
		Noble.GameData.set("world", 1)
		Noble.transition(LevelScene)
    end)
    self.menu:addItem("Lexicon", function()
        
    end)

	local crankTick = 0
    TitleScene.inputHandler = {
        upButtonDown = function()
			self.menu:selectPrevious()
		end,
		downButtonDown = function()
			self.menu:selectNext()
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				self.menu:selectNext()
			elseif (crankTick < -30) then
				crankTick = 0
				self.menu:selectPrevious()
			end
		end,
		AButtonDown = function()
			self.menu:click()
		end
    }
end

function TitleScene:enter()
    TitleScene.super.enter(self)
end

function TitleScene:start()
    TitleScene.super.start(self)
	self.menu:activate()
end

function TitleScene:update()
    TitleScene.super.update(self)
    self.menu:draw(200, 120)
end