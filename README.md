# Playdate Deckbuilder
Source code for my unfinished Playdate deckbuilding game. Features basic turn-based card battle gameplay. Uses the [Noble Engine](https://github.com/NobleRobot/NobleEngine).

<img src="https://github.com/user-attachments/assets/54dc85a1-b16d-4906-8a12-7abb881e22f6" width="400" height="240"/>

## Project Structure
- `scenes/`
  - `game/`
    - `UI/`
      - `cardInspector.lua` - UI for looking through cards and descriptions
      - `reticle.lua` - Aiming reticle for selecting enemies
    - `cards/`
      - `properties/` - A sort of component system for composing cards from individual properties
        - `aoeDamage.lua`
        - `cardDraw.lua`
        - `heal.lua`
        - `property.lua`
        - `shield.lua`
        - `singleTargetDamage.lua`
      - `card.lua` - Card object
      - `deck.lua` - Deck manager (contains cards)
      - `hand.lua` - Draws animations and manages data of cards in hand 
    - `enemies/`
      - `basicEnemy.lua` - Base enemy data class
      - `enemy.lua` - Manages enemy animations and actions
      - `enemyManager.lua` - Manages enemy turn
    - `player/`
      - `player.lua` - Manages player animations and actions
    - `GameScene.lua` - Battle scene
  - `levels/`
    - `campfire/`
      - `CampfireScene.lua` - Unimplemented
    - `chest/`
      - `ChestScene.lua` - Unimplemented
    - `market/`
      - `MarketScene.lua` - Unimplemented
    - `cardSelection.lua` - UI for selecting scene to go to (campfire, chest, market)
    - `LevelScene.lua` - Level select screen
  - `title/`
    - `ClassSelectScene.lua` - Unimplemented
    - `TitleScene.lua` - Simple title screen
  - `ExampleScene.lua` - Example scene included with Noble Engine
  - `ExampleScene2.lua` - Example scene included with Noble Engine
## License
All code is licensed under the terms of the MIT license.
