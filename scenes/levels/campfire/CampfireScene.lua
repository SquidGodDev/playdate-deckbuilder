class("CampfireScene").extends(NobleScene)
CampfireScene.backgroundColor = Graphics.kColorBlack

function CampfireScene:init()
	CampfireScene.super.init(self)

end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function CampfireScene:enter()
	CampfireScene.super.enter(self)
end

-- This runs once a transition from another scene is complete.
function CampfireScene:start()
	CampfireScene.super.start(self)
end

-- This runs once per frame.
function CampfireScene:update()
	CampfireScene.super.update(self)
end

-- This runs as as soon as a transition to another scene begins.
function CampfireScene:exit()
	CampfireScene.super.exit(self)
end

-- This runs once a transition to another scene completes.
function CampfireScene:finish()
	CampfireScene.super.finish(self)
end
