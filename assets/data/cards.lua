CARDS = {
    fireball = {
        imagePath = "assets/images/cards/fireball",
        sfx = "",
        properties = {
            SingleTargetDamage
        },
        stats = {
            cost = 1,
            damage = 3,
            singleTarget = true
        }
    },
    stoneWall = {
        imagePath = "assets/images/cards/stoneWall",
        sfx = "",
        properties = {

        },
        stats = {
            cost = 1,
            shield = 3
        }
    },
    zap = {
        imagePath = "assets/images/cards/zap",
        sfx = "",
        properties = {
            SingleTargetDamage
        },
        stats = {
            cost = 0,
            damage = 1,
            singleTarget = true
        }
    },
    lightningStrike = {
        imagePath = "assets/images/cards/lightningStrike",
        sfx = "",
        properties = {
            AoeDamage
        },
        stats = {
            cost = 2,
            damage = 2
        }
    }
}

CARD_IMAGETABLES = {}
for _, spellData in pairs(CARDS) do
    local imagePath = spellData.imagePath
    CARD_IMAGETABLES[imagePath] = Graphics.imagetable.new(imagePath)
end