class('LevelScene').extends(NobleScene)
LevelScene.backgroundColor = Graphics.kColorBlack

function LevelScene:init()
    LevelScene.super.init(self)

    LevelScene.inputHandler = {
		AButtonDown = function()
			Noble.transition(GameScene)
		end
    }
end

function LevelScene:enter()
    LevelScene.super.enter(self)
end
