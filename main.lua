import 'libraries/noble/Noble'

TEST_LOCALIZATION = false
Japanese_Font = Graphics.font.new("assets/fonts/MadouFutoMaruGothic-d9Xo7-12")

local mainFont = Graphics.font.new("assets/fonts/WhackyJoeMonospaced-12")
Noble.Text.setFont(mainFont)

-- Libraries
import 'utilities/Utilities'

-- Properties
import 'scenes/game/cards/properties/property'
import 'scenes/game/cards/properties/aoeDamage'
import 'scenes/game/cards/properties/cardDraw'
import 'scenes/game/cards/properties/heal'
import 'scenes/game/cards/properties/shield'
import 'scenes/game/cards/properties/singleTargetDamage'

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
import 'scenes/game/UI/cardInspector'

-- Enemies
import 'scenes/game/enemies/enemyManager'
import 'scenes/game/enemies/enemy'
import 'scenes/game/enemies/basicEnemy'

Noble.showFPS = false
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