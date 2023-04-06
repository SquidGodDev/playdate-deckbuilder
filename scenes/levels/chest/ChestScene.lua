class("ChestScene").extends(NobleScene)
ChestScene.backgroundColor = Graphics.kColorBlack

function ChestScene:init()
	ChestScene.super.init(self)

end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function ChestScene:enter()
	ChestScene.super.enter(self)
end

-- This runs once a transition from another scene is complete.
function ChestScene:start()
	ChestScene.super.start(self)
end

-- This runs once per frame.
function ChestScene:update()
	ChestScene.super.update(self)
end

-- This runs as as soon as a transition to another scene begins.
function ChestScene:exit()
	ChestScene.super.exit(self)
end

-- This runs once a transition to another scene completes.
function ChestScene:finish()
	ChestScene.super.finish(self)
end
