Card Types
Need 3 categories:
[v] Monster Cards (Spades & Clubs)
[v] Weapon Cards (Diamonds)
[v] Potion Cards (Hearts)

Card Values
[v] Cards 1–10 have numeric values
[v] J = 11
[v] Q = 12
[v] K = 13
[v] A = 14

Player State Rules
Track:
[v] Player HP (starts at 20)
[v] Current equipped weapon (nullable)
[  ] Remaining deck
[v] Current room (array of 4 cards)
[  ] Discard pile (optional, depending on implementation)

Room Generation Rules
[v] At start of game, shuffle deck
[v] Deal 4 cards face-up
[v] Player must choose 1 card
After resolving it:
[v] Remove card
After 3 cards are chosen:
[v] Refill room back to 4 (if deck not empty), keeping last card from room
Edge Case:
[  ] If deck runs out and room clears → game ends

Monster Rules
When selecting a Monster:
If player has no weapon:
[v] Lose HP equal to monster value
If player has a weapon:
[v] Health Lost = monster value - weapon value
[v] Weapon cannot attack stronger monsters
If monster is larger then weapon:
[v] Player takes remaining damage

Weapon Rules
When selecting a Weapon:
[v] Player may equip it
[v] Player discards previous weapon
[v] Player can only hold 1 weapon at a time
Optional design choice:
[  ] Replace automatically or prompt player?

Potion Rules
When selecting a Potion:
[v] Restore HP equal to card value
[v] HP cannot exceed 20
[v] Potion is discarded after use

Game Over Conditions
[  ] If HP ≤ 0 → lose
[  ] If deck empty AND room empty → win

Turn Order Logic (Game Loop)
Each turn:
[v] Display 4 cards
[v] Wait for player selection
[v] Resolve card effect
[v] Remove card
[v] Refill room
[  ] Check win/loss
[v] Repeat

UI Rules:
[v] Clickable cards
[  ] HP display
[  ] Weapon display
[  ] Visual feedback for damage
[  ] Clear room update animation
Optional but nice:
[  ] Hover tooltip for card value
[  ] Damage numbers floating
[  ] Game over screen

Edge Cases to Handle
Very important for bug prevention:
[  ] Selecting card while resolving another
[  ] Empty deck but room not empty
[  ] Healing at full HP
[  ] Weapon used on 0-value monster
[  ] Player HP hitting exactly 0
[  ] Multiple monsters in room (order shouldn't matter)

Optional Advanced Mechanics (Digital Enhancements)
[  ] Add difficulty modes
[  ] Add score system
[  ] Add achievements
[  ] Add relics/passives
[  ] Add animations
[  ] Add sound effects
