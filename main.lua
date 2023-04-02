-- Libraries
import 'libraries/noble/Noble'
import 'utilities/Utilities'

-- Properties
import 'scenes/game/cards/properties/property'
import 'scenes/game/cards/properties/singleTargetDamage'
import 'scenes/game/cards/properties/aoeDamage'
import 'scenes/game/cards/properties/cardDraw'

-- Data
import 'assets/data/cards'
import 'assets/data/enemies'

-- Title
import "scenes/title/TitleScene"
import "scenes/title/ClassSelectScene"

-- Level
import "scenes/levels/LevelScene"

-- Game
import 'scenes/game/GameScene'
import 'scenes/game/cards/hand'
import 'scenes/game/cards/deck'
import 'scenes/game/cards/card'
import 'scenes/game/player/player'
import 'scenes/game/UI/reticle'

-- Enemies
import 'scenes/game/enemies/enemyManager'
import 'scenes/game/enemies/enemy'
import 'scenes/game/enemies/basicEnemy'

-- Noble.showFPS = true

local mainFont = Graphics.font.new("assets/fonts/WhackyJoeMonospaced-12")
Noble.Text.setFont(mainFont)

Noble.GameData.setup(
    {
        deck = {},
        playerMaxHealth = 40,
        playerHealth = 40,
        level = 1,
        world = 1,
    },
    1,
    false,
    true
)

Noble.new(TitleScene, 2, Noble.TransitionType.DRAW, {
    defaultTransitionDuration = 2,
    defaultTransitionType = Noble.TransitionType.DRAW,
    enableDebugBonkChecking = false,
    alwaysRedraw = false
})