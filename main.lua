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
import 'assets/data/globals'
import 'assets/data/levelData'

-- Title
import "scenes/title/TitleScene"
import "scenes/title/ClassSelectScene"

-- Level
import "scenes/levels/LevelScene"
import "scenes/levels/cardSelection"
import "scenes/levels/campfire/CampfireScene"
import "scenes/levels/chest/ChestScene"
import "scenes/levels/market/MarketScene"

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

Graphics.setBackgroundColor(Graphics.kColorBlack)

Noble.GameData.setup(
    {
        deck = {},
        playerMaxHealth = 40,
        playerHealth = 40,
        level = {},
        world = 1,
    },
    1,
    false,
    true
)

local transitionTime = 1
Noble.new(TitleScene, transitionTime, Noble.TransitionType.QUICK_DRAW, {
    defaultTransitionDuration = transitionTime,
    defaultTransitionType = Noble.TransitionType.QUICK_DRAW,
    enableDebugBonkChecking = false,
    alwaysRedraw = false
})