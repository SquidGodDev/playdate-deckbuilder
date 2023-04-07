CARDS = {
    fireball = {
        imagePath = "assets/images/cards/fireball",
        sfx = "",
        properties = {
            SingleTargetDamage
        },
        stats = {
            cost = 1,
            damage = 3
        }
    },
    stoneWall = {
        imagePath = "assets/images/cards/stoneWall",
        sfx = "",
        properties = {
            Shield
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
            damage = 1
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
    },
    investigate = {
        imagePath = "assets/images/cards/investigate",
        sfx = "",
        properties = {
            CardDraw
        },
        stats = {
            cost = 1,
            drawCount = 2
        }
    }
}

CARD_IMAGETABLES = {}
for _, spellData in pairs(CARDS) do
    local imagePath = spellData.imagePath
    CARD_IMAGETABLES[imagePath] = Graphics.imagetable.new(imagePath)
end
