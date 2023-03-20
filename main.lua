import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'assets/data/cards'
import 'assets/data/enemies'

import 'scenes/game/GameScene'
import 'scenes/game/cards/hand'
import 'scenes/game/cards/deck'
import 'scenes/game/cards/card'
import 'scenes/game/cards/property'
import 'scenes/game/player/player'
import 'scenes/game/UI/reticle'
import 'scenes/game/enemies/enemyManager'
import 'scenes/game/enemies/enemy'
import 'scenes/game/enemies/basicEnemy'
import 'scenes/game/enemies/blokus'

local mainFont = Graphics.font.new("assets/fonts/WhackyJoeMonospaced-12")
Graphics.setFont(mainFont)

-- Noble.showFPS = true

Noble.new(GameScene, 0, Noble.TransitionType.CROSS_DISSOLVE)