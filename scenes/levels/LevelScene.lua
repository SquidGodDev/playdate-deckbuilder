class('LevelScene').extends(NobleScene)
LevelScene.backgroundColor = Graphics.kColorBlack

function LevelScene:init()
    LevelScene.super.init(self)

    LevelScene.inputHandler = {
		AButtonDown = function()
			Noble.transition(GameScene, 3, Noble.TransitionType.DRAW)
		end
    }
end

function LevelScene:enter()
    LevelScene.super.enter(self)
end

function LevelScene:loadLevel()
    Noble.transition(GameScene, 1, Noble.TransitionType.DRAW, nil, self.playerMaxHealth, self.playerHealth, self.deck)
end