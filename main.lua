import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'assets/data/cards'

import 'scenes/game/GameScene'

local mainFont = Graphics.font.new("assets/fonts/WhackyJoeMonospaced-12")
Graphics.setFont(mainFont)

Noble.showFPS = true

Noble.new(GameScene, 0, Noble.TransitionType.CROSS_DISSOLVE)