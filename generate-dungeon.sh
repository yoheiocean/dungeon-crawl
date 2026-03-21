#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# The Sunken Citadel of Kernighan — Dungeon Generator
# ============================================================
# Usage: sudo ./generate-dungeon.sh [SEED] [DUNGEON_ROOT]
#   SEED         — integer for treasure codes (default: 42)
#   DUNGEON_ROOT — where to build (default: ~/dungeon)
# ============================================================

SEED="${1:-42}"
DUNGEON_ROOT="${2:-$HOME/dungeon}"

# --- Helper Functions ---

generate_code() {
    local filepath="$1"
    local points="$2"
    local hash
    hash=$(echo -n "${SEED}:${filepath}" | md5sum | cut -c1-8)
    echo "TRSR-${points}-${hash}"
}

make_treasure() {
    local filepath="$1"
    local name="$2"
    local points="$3"
    local lore="$4"
    local tier="$5"
    local code
    code=$(generate_code "$filepath" "$points")

    mkdir -p "$(dirname "$filepath")"

    local art=""
    case "$tier" in
        common)
            art='         _____
        |     |
        | . . |
        |_____|'
            ;;
        uncommon)
            art='        .--""--.
       /        \
      |  ()  ()  |
       \   __   /
        `------`'
            ;;
        rare)
            art='       ,     ,
      /(     )\
     |  >   <  |
     | /     \ |
      \`-._.-`/
       `-----`'
            ;;
        legendary)
            art='      ___________
     /           \
    / ~~~ ~~~ ~~~ \
   |  *  RARE  *   |
   |  *  FIND  *   |
    \ ~~~ ~~~ ~~~ /
     \___________/'
            ;;
        mythic)
            art='        _.--._
      .-        -.
     /    ***      \
    |   *     *     |
    |  * CROWN  *   |
    |   * JEWEL *   |
    |    *     *    |
     \    ***      /
      -._    _.-
          --'
            ;;
    esac

    cat > "$filepath" << TREASURE_EOF
================================================

  TREASURE FOUND!

${art}

  Item:   ${name}
  Value:  ${points} points
  Lore:   "${lore}"

  CODE: ${code}

================================================
TREASURE_EOF
}

make_mimic() {
    local filepath="$1"
    local name="$2"
    local lore="$3"
    local code
    code=$(generate_code "$filepath" "0")

    mkdir -p "$(dirname "$filepath")"
    cat > "$filepath" << MIMIC_EOF
================================================

  YOU FOUND... A MIMIC!

         ,---.
        / x x \\
       |  ___  |
       |_/   \\_|
        \\_____/

  Item:   ${name}
  Value:  0 points
  Lore:   "${lore}"

  CODE: ${code}

================================================
MIMIC_EOF
}

# --- Build the Dungeon ---

echo "=== The Sunken Citadel of Kernighan ==="
echo "Building dungeon with seed=${SEED} at ${DUNGEON_ROOT}..."
echo ""

rm -rf "${DUNGEON_ROOT}"
mkdir -p "${DUNGEON_ROOT}"

D="${DUNGEON_ROOT}"

# ============================================================
# NOTICE (root level)
# ============================================================

cat > "${D}/notice.txt" << 'NOTICE_EOF'
=== THE SUNKEN CITADEL OF KERNIGHAN ===

Welcome, adventurer.

You stand at the entrance of an ancient fortress that
sank beneath the earth long ago. Its halls contain
treasures of varying value -- from common copper coins
to a legendary crown jewel worth 250 points.

YOUR MISSION:
  1. Explore the dungeon using: cd, ls, cat
  2. Find .treasure files
  3. Copy them to your machine using scp
  4. The adventurer with the most points wins!

TIPS:
  - Read EVERYTHING. Clues hide in plain text.
  - Not every path leads somewhere useful.
  - Some rooms look dangerous but hold great rewards.
  - Some treasures are not what they seem...
  - You have 45 minutes. Go.

May the shell be with you.
NOTICE_EOF

# ============================================================
# LEVEL 1: ENTRANCE HALL
# ============================================================

# -- Torch Room --
make_treasure "${D}/entrance-hall/torch-room/copper_coin.treasure" \
    "Copper Coin" 5 \
    "A small coin worn smooth by centuries of handling." \
    common

mkdir -p "${D}/entrance-hall/torch-room"
cat > "${D}/entrance-hall/torch-room/inscription.txt" << 'EOF'
The ancient writing on the wall is faded but readable:

"The smith kept his finest work not on the rack,
 but locked in a chest within the armory.
 Seek the forge-district when you are ready."
EOF

# -- Dusty Corridor --
make_treasure "${D}/entrance-hall/dusty-corridor/cobweb-corner/rusty_dagger.treasure" \
    "Rusty Dagger" 7 \
    "A blade so old it crumbles at the edges. Still worth something to a collector." \
    common

mkdir -p "${D}/entrance-hall/dusty-corridor/collapsed-passage"
cat > "${D}/entrance-hall/dusty-corridor/collapsed-passage/rubble.txt" << 'EOF'
The ceiling has caved in here. Rocks and dust block
any further passage. There is nothing of value.

You should turn back and try another way.
EOF

# -- Guard Quarters --
make_treasure "${D}/entrance-hall/guard-quarters/worn_shield.treasure" \
    "Worn Shield" 10 \
    "Dented and scratched, but the insignia of the citadel guard is still visible." \
    common

cat > "${D}/entrance-hall/guard-quarters/old-logbook.txt" << 'EOF'
--- GUARD LOG ---
Day 127: Prisoner escaped again. Found tracks
leading into the bone-corridor of the catacombs.
Last seen near a hidden alcove in the north wall.
He was carrying something -- could not identify.

Day 128: Searched the alcove. Found scratched marks
on the wall but nothing else. Prisoner may have
hidden something deeper in the fortress.
--- END LOG ---
EOF

# -- Rat Nest --
mkdir -p "${D}/entrance-hall/rat-nest"
cat > "${D}/entrance-hall/rat-nest/warning.txt" << 'EOF'
!! DANGER !! DANGER !! DANGER !!

The rats here are enormous and aggressive.
Several guards have been bitten.
DO NOT PROCEED FURTHER.

(The rats have eaten everything of value.
 There is nothing left here.)

...or is there?
EOF

cat > "${D}/entrance-hall/rat-nest/chewed-map.txt" << 'EOF'
A torn and chewed piece of parchment. You can barely
make out the writing:

"The librar... ...hispers holds many scro...
 ...shelf-d contains somethi... ...valuable...
 ...do not overlook the shelv..."

The rest is illegible. Stupid rats.
EOF

# -- Grand Staircase --
mkdir -p "${D}/entrance-hall/grand-staircase"
cat > "${D}/entrance-hall/grand-staircase/faded-sign.txt" << 'EOF'
A wooden sign, barely legible:

     "DESCEND AT YOUR OWN RISK"
     "The catacombs below hold both
      treasure and terror."

An arrow points downward.
EOF

make_treasure "${D}/entrance-hall/grand-staircase/loose-stone/tarnished_ring.treasure" \
    "Tarnished Ring" 13 \
    "Hidden behind a loose stone in the staircase wall. Patience pays." \
    common

# ============================================================
# LEVEL 2: CATACOMBS
# ============================================================

# -- Bone Corridor --
make_treasure "${D}/catacombs/bone-corridor/north-crypt/silver_chalice.treasure" \
    "Silver Chalice" 18 \
    "A ceremonial cup used by the ancient order. Tarnished but intact." \
    uncommon

mkdir -p "${D}/catacombs/bone-corridor/south-crypt"
cat > "${D}/catacombs/bone-corridor/south-crypt/empty-coffin.txt" << 'EOF'
An open stone coffin. Empty.
Cobwebs suggest no one has been here in a very long time.
There is nothing of value.
EOF

mkdir -p "${D}/catacombs/bone-corridor/east-crypt"
cat > "${D}/catacombs/bone-corridor/east-crypt/cracked-urn.txt" << 'EOF'
A large ceramic urn, cracked down the middle.
Inside: dust and bone fragments. Nothing useful.

You notice scratch marks on the floor leading
toward the hidden-alcove to the west...
EOF

make_treasure "${D}/catacombs/bone-corridor/hidden-alcove/jade_amulet.treasure" \
    "Jade Amulet" 28 \
    "A pale green stone set in bronze. It hums faintly when held." \
    uncommon

mkdir -p "${D}/catacombs/bone-corridor/hidden-alcove"
cat > "${D}/catacombs/bone-corridor/hidden-alcove/scratched-note.txt" << 'EOF'
Scratched into the stone wall in hasty letters:

"I buried the real treasure where no one would
 look -- shaft-3 of the abandoned mine in the
 forge-district. They will never find it there."

               -- the prisoner
EOF

# -- Flooded Passage --
make_treasure "${D}/catacombs/flooded-passage/submerged-vault/crystal_orb.treasure" \
    "Crystal Orb" 32 \
    "Perfectly spherical and warm to the touch despite the cold water." \
    uncommon

mkdir -p "${D}/catacombs/flooded-passage/drain-tunnel/old-bones"
cat > "${D}/catacombs/flooded-passage/drain-tunnel/old-bones/remains.txt" << 'EOF'
Skeletal remains of an unfortunate explorer.
A rusted lantern lies nearby, long since extinguished.
There is nothing of value here -- only a warning
to watch your step.
EOF

# -- Echo Chamber --
mkdir -p "${D}/catacombs/echo-chamber"
cat > "${D}/catacombs/echo-chamber/riddle.txt" << 'EOF'
A voice echoes through the chamber:

    "I have pages but am not a book.
     I have a spine but am not alive.
     I hold knowledge but cannot think.
     Find the room that matches my name
     within the library-of-whispers."

The answer to this riddle will guide your path.

(Hint: Think about where you store scrolls...)
EOF

# -- The Long Corridor --
make_treasure "${D}/catacombs/the-corridor-that-seems-to-go-on-forever/tiny-room/moonstone.treasure" \
    "Moonstone" 36 \
    "A luminous white gem that seems to glow from within. Worth the long walk." \
    uncommon

# -- Map Fragment 2 --
cat > "${D}/catacombs/map-fragment-2.txt" << 'EOF'
=== MAP FRAGMENT (2 of 5) ===

Path piece: secret-passage/

(Collect all 5 fragments to find the hidden path
 to a legendary treasure. Fragments are scattered
 across all levels of the citadel.)
EOF

# -- Labyrinth --
mkdir -p "${D}/catacombs/labyrinth/passage-south"
cat > "${D}/catacombs/labyrinth/passage-south/dead-end.txt" << 'EOF'
You hit a wall. The passage ends here.
Turn back and try another direction.
EOF

mkdir -p "${D}/catacombs/labyrinth/passage-east/passage-east"
cat > "${D}/catacombs/labyrinth/passage-east/passage-east/echo.txt" << 'EOF'
...hello? ...hello? ...hello?

The echoes mock you. This is a dead end.
The correct path through the labyrinth
starts by heading north.
EOF

mkdir -p "${D}/catacombs/labyrinth/passage-west"
cat > "${D}/catacombs/labyrinth/passage-west/dead-end.txt" << 'EOF'
A collapsed tunnel. No way through.
Try heading north from the labyrinth entrance.
EOF

mkdir -p "${D}/catacombs/labyrinth/passage-north/passage-east/passage-south"
cat > "${D}/catacombs/labyrinth/passage-north/passage-east/passage-south/dead-end.txt" << 'EOF'
Another dead end. You are going in circles.
From passage-north, try heading west instead.
EOF

make_treasure "${D}/catacombs/labyrinth/passage-north/passage-west/passage-north/ancient-door/emerald_ring.treasure" \
    "Emerald Ring" 40 \
    "A gold band set with a deep green emerald. The labyrinth guards its secrets well." \
    uncommon

mkdir -p "${D}/catacombs/labyrinth/passage-north/passage-west/passage-north/ancient-door"
cat > "${D}/catacombs/labyrinth/passage-north/passage-west/passage-north/ancient-door/engraving.txt" << 'EOF'
Carved into the ancient door frame:

"You have navigated the labyrinth. Few find this room.
 Take what you have earned, adventurer."
EOF

# ============================================================
# LEVEL 3: FORGE DISTRICT
# ============================================================

# -- Blacksmith Workshop --
make_treasure "${D}/forge-district/blacksmith-workshop/quenching-trough/tempered_blade.treasure" \
    "Tempered Blade" 45 \
    "A finely crafted sword, still sharp after centuries in the trough." \
    uncommon

mkdir -p "${D}/forge-district/blacksmith-workshop/anvil-room/hammer-rack"
cat > "${D}/forge-district/blacksmith-workshop/anvil-room/hammer-rack/empty.txt" << 'EOF'
A rack that once held hammers of various sizes.
All have been taken or rusted away. Nothing remains.
EOF

# -- Armory --
mkdir -p "${D}/forge-district/armory/weapon-rack"
cat > "${D}/forge-district/armory/weapon-rack/battle-notes.txt" << 'EOF'
--- ARMORER NOTES ---
Inventory is running low. The locked chest in the
back holds our most valuable piece -- a golden scroll
bearing the tactical wisdom of the ancients.
Only the captain has the key.
--- END NOTES ---
EOF

mkdir -p "${D}/forge-district/armory/shield-room"
cat > "${D}/forge-district/armory/shield-room/empty-hooks.txt" << 'EOF'
Iron hooks line the walls where shields once hung.
All have been claimed. Nothing left here.
EOF

make_treasure "${D}/forge-district/armory/locked-chest/golden_scroll.treasure" \
    "Golden Scroll" 50 \
    "A scroll bearing the lost tactical theorems of the ancients." \
    rare

# -- Smelting Room --
make_mimic "${D}/forge-district/smelting-room/cooling-tunnels/vent-shaft/cursed_pebble.treasure" \
    "Cursed Pebble" \
    "It looked shiny from a distance. Up close, just a rock."

mkdir -p "${D}/forge-district/smelting-room/cooling-tunnels/deep-grate"
cat > "${D}/forge-district/smelting-room/cooling-tunnels/deep-grate/map-fragment-3.txt" << 'EOF'
=== MAP FRAGMENT (3 of 5) ===

Path piece: dragons-hoard/

(Collect all 5 fragments to find the hidden path
 to a legendary treasure. Fragments are scattered
 across all levels of the citadel.)
EOF

# -- Abandoned Mine --
mkdir -p "${D}/forge-district/abandoned-mine/shaft-1"
cat > "${D}/forge-district/abandoned-mine/shaft-1/cave-in.txt" << 'EOF'
The shaft has collapsed. Rocks block the path.
Nothing can be recovered from here.
EOF

make_mimic "${D}/forge-district/abandoned-mine/shaft-2/fools_gold.treasure" \
    "Fools Gold" \
    "Glitters like gold but weighs nothing. You have been deceived."

make_treasure "${D}/forge-district/abandoned-mine/shaft-3/enchanted_gem.treasure" \
    "Enchanted Gem" 65 \
    "A gem that shifts colors when tilted. The prisoner hid it well." \
    rare

# -- Spider Den --
make_treasure "${D}/forge-district/spider-den/web-covered-chest/phoenix_feather.treasure" \
    "Phoenix Feather" 75 \
    "Warm to the touch and faintly glowing. Those who brave the spiders are rewarded." \
    rare

mkdir -p "${D}/forge-district/spider-den/web-covered-chest"
cat > "${D}/forge-district/spider-den/web-covered-chest/warning-scratches.txt" << 'EOF'
Scratched into the chest lid:

"The spiders are gone now. I cleared them out years ago.
 But the name keeps everyone away. Perfect hiding spot."
EOF

# ============================================================
# LEVEL 4: LIBRARY OF WHISPERS
# ============================================================

# -- Reading Room --
mkdir -p "${D}/library-of-whispers/reading-room/dusty-desk"
cat > "${D}/library-of-whispers/reading-room/dusty-desk/torn-page.txt" << 'EOF'
A torn page from what appears to be a journal:

"...the restricted section holds forbidden knowledge.
 Beyond the tome-of-shadows lies the forbidden-archive.
 I have hidden something valuable there, behind the
 ancient texts that no one dares to read..."

The rest of the page is too damaged to read.
EOF

cat > "${D}/library-of-whispers/reading-room/map-fragment-1.txt" << 'EOF'
=== MAP FRAGMENT (1 of 5) ===

Path piece: ~/dungeon/throne-room/

(Collect all 5 fragments to find the hidden path
 to a legendary treasure. Fragments are scattered
 across all levels of the citadel.)
EOF

# -- Scroll Vault --
mkdir -p "${D}/library-of-whispers/scroll-vault/shelf-a"
cat > "${D}/library-of-whispers/scroll-vault/shelf-a/dust.txt" << 'EOF'
Nothing but dust. The scrolls here crumbled long ago.
EOF

make_treasure "${D}/library-of-whispers/scroll-vault/shelf-b/brittle_scroll.treasure" \
    "Brittle Scroll" 22 \
    "Handle with extreme care. The text describes star patterns used for navigation." \
    uncommon

mkdir -p "${D}/library-of-whispers/scroll-vault/shelf-c"
cat > "${D}/library-of-whispers/scroll-vault/shelf-c/moth-eaten.txt" << 'EOF'
Moths have destroyed everything on this shelf.
Only fragments remain, too damaged to be of value.
EOF

make_treasure "${D}/library-of-whispers/scroll-vault/shelf-d/sapphire_brooch.treasure" \
    "Sapphire Brooch" 25 \
    "A deep blue gem in a silver setting, used as a bookmark in a lost text." \
    uncommon

mkdir -p "${D}/library-of-whispers/scroll-vault/shelf-e"
cat > "${D}/library-of-whispers/scroll-vault/shelf-e/empty.txt" << 'EOF'
This shelf is completely empty. Not even dust.
EOF

mkdir -p "${D}/library-of-whispers/scroll-vault/shelf-f"
cat > "${D}/library-of-whispers/scroll-vault/shelf-f/map-fragment-4.txt" << 'EOF'
=== MAP FRAGMENT (4 of 5) ===

Path piece: ancient_artifact.treasure

(Collect all 5 fragments to find the hidden path
 to a legendary treasure. Fragments are scattered
 across all levels of the citadel.)
EOF

# -- Restricted Section --
mkdir -p "${D}/library-of-whispers/restricted-section/tome-of-shadows"
cat > "${D}/library-of-whispers/restricted-section/tome-of-shadows/dark-text.txt" << 'EOF'
The pages of this tome are written in a dark ink
that seems to absorb light. The words shift and
change as you read them. You feel uneasy.

Most of it is illegible, but one passage stands out:

"Not all that is hidden requires a key.
 Some things hide in plain sight, visible
 only to those who look more carefully
 than others. The study-alcove holds
 more than meets the eye."
EOF

make_treasure "${D}/library-of-whispers/restricted-section/forbidden-archive/ruby_pendant.treasure" \
    "Ruby Pendant" 55 \
    "A blood-red stone on a silver chain. It pulses faintly, as if alive." \
    rare

mkdir -p "${D}/library-of-whispers/restricted-section/forbidden-archive"
cat > "${D}/library-of-whispers/restricted-section/forbidden-archive/cipher.txt" << 'EOF'
An encoded message is carved into the archive wall:

    Gur frperg cnffntr oruvaq gur guebar
    yrnqf gb gur qentba'f ubneq.
    Bayl gur oenir jvyy svaq jung yvrf jvguva.

(This appears to be encoded with a simple letter
 substitution. Each letter has been shifted by the
 same amount. Can you decode it?)

HINT: A=N, B=O, C=P ...
EOF

# -- Librarian Office --
mkdir -p "${D}/library-of-whispers/librarians-office"
cat > "${D}/library-of-whispers/librarians-office/catalog.txt" << 'EOF'
=== CITADEL TREASURE CATALOG ===
(Partial -- many entries are water damaged)

KNOWN LOCATIONS:
  - Entrance Hall / torch-room ........ copper coin
  - Entrance Hall / guard-quarters .... worn shield
  - Catacombs / bone-corridor / north . silver chalice
  - Forge District / armory / chest ... golden scroll
  - Forge District / mine / shaft-3 ... [illegible]

RUMORED LOCATIONS:
  - "The spider den holds something rare"
  - "The labyrinth rewards those who persist"
  - "Not all vaults in the throne room are equal"

MISSING ENTRIES:
  Several pages have been torn out. Someone did not
  want the full catalog to be found.

        -- Librarian Torvalds
EOF

# -- Study Alcove (hidden dot-file treasure) --
mkdir -p "${D}/library-of-whispers/study-alcove"
cat > "${D}/library-of-whispers/study-alcove/reading-notes.txt" << 'EOF'
Notes left by a previous explorer:

"I have searched this alcove thoroughly and found
 nothing. The desk is empty, the shelves are bare.
 I am moving on to the throne room."

(Are you sure there is nothing here?
 Some things are hidden from plain sight...)
EOF

make_treasure "${D}/library-of-whispers/study-alcove/.ancient_relic.treasure" \
    "Ancient Relic" 60 \
    "Hidden in plain sight. Only the most observant adventurers find this." \
    rare

# -- Map Fragment 2 is in catacombs (already placed) --

# ============================================================
# LEVEL 5: THRONE ROOM
# ============================================================

# -- Grand Hall --
mkdir -p "${D}/throne-room/grand-hall/broken-throne"
cat > "${D}/throne-room/grand-hall/broken-throne/royal-decree.txt" << 'EOF'
A royal decree, still legible:

"By order of the King of Kernighan:

 Let it be known that the Crown Jewel shall
 remain in the Royal Vault for all eternity.
 No thief, no invader, no passage of time
 shall remove it from its rightful place.

 The vault lies beyond the grand hall,
 guarded by name alone."

The decree is signed with an elaborate seal.
EOF

mkdir -p "${D}/throne-room/grand-hall/behind-the-tapestry"
cat > "${D}/throne-room/grand-hall/behind-the-tapestry/map-fragment-5.txt" << 'EOF'
=== MAP FRAGMENT (5 of 5) ===

Path piece: (none -- this is the final piece!)

FULL PATH (assemble fragments 1-5):
  Fragment 1: ~/dungeon/throne-room/
  Fragment 2: secret-passage/
  Fragment 3: dragons-hoard/
  Fragment 4: ancient_artifact.treasure
  Fragment 5: (you are here)

THE COMPLETE PATH:
  ~/dungeon/throne-room/secret-passage/dragons-hoard/ancient_artifact.treasure

Go claim your legendary treasure!
EOF

# -- Treasure Vault (mimic) --
make_mimic "${D}/throne-room/treasure-vault/gilded-chest/cursed_crown.treasure" \
    "Cursed Crown" \
    "It looked magnificent, but the gems are glass and the gold is paint."

# -- Treasure Vault II (real) --
make_treasure "${D}/throne-room/treasure-vault-ii/iron-chest/dragon_scale.treasure" \
    "Dragon Scale" 100 \
    "An iridescent scale from an ancient dragon. Warm and nearly indestructible." \
    legendary

mkdir -p "${D}/throne-room/treasure-vault-ii/iron-chest"
cat > "${D}/throne-room/treasure-vault-ii/iron-chest/scratch-marks.txt" << 'EOF'
Deep claw marks score the inside of this chest.
Whatever was kept here was alive once.

Also scratched into the metal:
"There are two vaults. Most stop at the first."
EOF

# -- Royal Vault --
make_treasure "${D}/throne-room/royal-vault/crown_jewel.treasure" \
    "Crown Jewel" 250 \
    "The legendary Crown Jewel of Kernighan. Priceless and radiant." \
    mythic

# -- Secret Passage (cipher solution leads here) --
make_treasure "${D}/throne-room/secret-passage/dragons-hoard/ancient_artifact.treasure" \
    "Ancient Artifact" 150 \
    "A relic of immense power from the founding of the citadel. Few have ever seen it." \
    legendary

mkdir -p "${D}/throne-room/secret-passage/dragons-hoard"
cat > "${D}/throne-room/secret-passage/dragons-hoard/dragon-bones.txt" << 'EOF'
Enormous bones line the walls of this chamber.
A dragon once lived here, guarding this treasure
for centuries. Now only its bones remain.

You have found the deepest secret of the citadel.
Well done, adventurer.
EOF

# -- Sealed Door (dead end) --
mkdir -p "${D}/throne-room/sealed-door"
cat > "${D}/throne-room/sealed-door/you-shall-not-pass.txt" << 'EOF'
A massive stone door, sealed shut with ancient magic.
No force can open it. No key exists.

Carved into the stone:

     "BEYOND THIS DOOR LIES NOTHING.
      TURN BACK, ADVENTURER.
      YOUR TREASURE LIES ELSEWHERE."

This is truly a dead end.
EOF

# ============================================================
# TEACHER DIRECTORY (hidden, mode 700)
# ============================================================

TEACHER_DIR="${D}/.teacher"
mkdir -p "${TEACHER_DIR}"

# --- Generate Answer Key and Scoring Data ---
{
    echo "=== DUNGEON ANSWER KEY ==="
    echo "Seed: ${SEED}"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "TREASURES:"
    echo "-----------------------------------------------------------------------"
    printf "%-60s | %-20s | %6s | %s\n" "PATH" "ITEM" "VALUE" "CODE"
    echo "-----------------------------------------------------------------------"
} > "${TEACHER_DIR}/answer-key.txt"

SCORING_FILE="${TEACHER_DIR}/scoring-data.sh"
echo "# Scoring data — source this file to load VALID_CODES" > "$SCORING_FILE"
echo "# Generated: $(date '+%Y-%m-%d %H:%M:%S') | Seed: ${SEED}" >> "$SCORING_FILE"
echo "declare -A VALID_CODES" >> "$SCORING_FILE"

total_points=0
total_treasures=0
total_mimics=0

while IFS= read -r -d '' tfile; do
    code_line=$(grep '  CODE:' "$tfile" | head -1 | sed 's/.*CODE: //')
    value_line=$(grep '  Value:' "$tfile" | head -1 | sed 's/.*Value:  //' | sed 's/ points//')
    item_line=$(grep '  Item:' "$tfile" | head -1 | sed 's/.*Item:   //')
    rel_path="${tfile#${D}/}"

    echo "VALID_CODES[\"${code_line}\"]=${value_line}" >> "$SCORING_FILE"

    if [[ "$value_line" -eq 0 ]]; then
        ((total_mimics++)) || true
        printf "%-60s | %-20s | %6s | %s\n" "$rel_path" "$item_line" "MIMIC" "$code_line" >> "${TEACHER_DIR}/answer-key.txt"
    else
        ((total_treasures++)) || true
        total_points=$((total_points + value_line))
        printf "%-60s | %-20s | %6s | %s\n" "$rel_path" "$item_line" "$value_line" "$code_line" >> "${TEACHER_DIR}/answer-key.txt"
    fi
done < <(find "${D}" -name '*.treasure' -not -path '*/.teacher/*' -print0 | sort -z)

{
    echo "-----------------------------------------------------------------------"
    echo ""
    echo "SUMMARY:"
    echo "  Real treasures: ${total_treasures}"
    echo "  Mimics (0 pts): ${total_mimics}"
    echo "  Total possible points: ${total_points}"
    echo ""
    echo "ADVANCED CHALLENGES:"
    echo "  - Hidden dot-file: library-of-whispers/study-alcove/.ancient_relic.treasure (60 pts)"
    echo "    Requires: ls -a"
    echo "  - Cipher puzzle: library-of-whispers/restricted-section/forbidden-archive/cipher.txt"
    echo "    Solution: ROT13 -> The secret passage behind the throne leads to the dragons hoard."
    echo "    Leads to: throne-room/secret-passage/dragons-hoard/ancient_artifact.treasure (150 pts)"
    echo "  - Map fragments: 5 pieces across all levels"
    echo "    Assembled path: ~/dungeon/throne-room/secret-passage/dragons-hoard/ancient_artifact.treasure"
    echo "  - Twin vaults: treasure-vault (mimic) vs treasure-vault-ii (real, 100 pts)"
    echo "  - Labyrinth: passage-north > passage-west > passage-north > ancient-door (40 pts)"
} >> "${TEACHER_DIR}/answer-key.txt"

# ============================================================
# SET PERMISSIONS
# ============================================================

echo "Setting permissions..."
chmod -R a+rX "${D}"
chmod -R a-w "${D}"
chmod 700 "${TEACHER_DIR}"

# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "=== Dungeon Ready ==="
echo "  Location:     ${D}"
echo "  Seed:         ${SEED}"
echo "  Treasures:    ${total_treasures} real + ${total_mimics} mimics"
echo "  Max points:   ${total_points}"
echo "  Answer key:   ${TEACHER_DIR}/answer-key.txt"
echo "  Scoring data: ${TEACHER_DIR}/scoring-data.sh"
echo ""
echo "Before class, create the submissions directory:"
echo "  mkdir -p /home/student/submissions"
echo "  chmod 777 /home/student/submissions"
echo ""
echo "To regenerate with a new seed:"
echo "  sudo ./generate-dungeon.sh \$RANDOM ${D}"
