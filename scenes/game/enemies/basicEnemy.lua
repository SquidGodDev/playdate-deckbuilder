class('BasicEnemy').extends(Enemy)

function BasicEnemy:init(data)
    BasicEnemy.super.init(self, data.imagePath, data.health)
    self.damage = data.damage
    self.heal = data.heal
    self.attackChance = data.attackChance
end

function BasicEnemy:setIntent()
    local isAttack = math.random() <= self.attackChance
    if isAttack then
        self.intent = INTENTS.attack
        self.intentValue = math.random(self.damage[1], self.damage[2])
    else
        self.intent = INTENTS.heal
        self.intentValue = math.random(self.heal[1], self.heal[2])
    end
end