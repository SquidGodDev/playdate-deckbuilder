class("MarketScene").extends(NobleScene)
MarketScene.backgroundColor = Graphics.kColorBlack

function MarketScene:init()
	MarketScene.super.init(self)

end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function MarketScene:enter()
	MarketScene.super.enter(self)
end

-- This runs once a transition from another scene is complete.
function MarketScene:start()
	MarketScene.super.start(self)
end

-- This runs once per frame.
function MarketScene:update()
	MarketScene.super.update(self)
end

-- This runs as as soon as a transition to another scene begins.
function MarketScene:exit()
	MarketScene.super.exit(self)
end

-- This runs once a transition to another scene completes.
function MarketScene:finish()
	MarketScene.super.finish(self)
end
