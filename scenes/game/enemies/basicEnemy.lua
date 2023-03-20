class('BasicEnemy').extends(Enemy)

function BasicEnemy:init(data)
    BasicEnemy.super.init(self, data.imagePath, data.health)
    self.damageValues = data.damage
    self.healValues = data.heal
    self.attackChance = data.attackChance
end

function BasicEnemy:setIntent()
    local isAttack = math.random() <= self.attackChance
    if isAttack then
        self.intent = INTENTS.attack
        self.intentValue = math.random(self.damageValues[1], self.damageValues[2])
    else
        self.intent = INTENTS.heal
        self.intentValue = math.random(self.healValues[1], self.healValues[2])
    end
end