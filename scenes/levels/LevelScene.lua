class('LevelScene').extends(NobleScene)

function LevelScene:init()
    LevelScene.super.init(self)
    self.deck = {}
    self.playerMaxHealth = 40
    self.playerHealth = self.playerMaxHealth
    self.level = 1
    self.world = 1
end

function LevelScene:enter()
    LevelScene.super.enter(self)
end

function LevelScene:loadLevel()
    Noble.transition(GameScene, 1, Noble.TransitionType.CROSS_DISSOLVE, nil, self.playerMaxHealth, self.playerHealth, self.deck)
end