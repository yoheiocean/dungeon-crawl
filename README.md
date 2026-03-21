# The Sunken Citadel of Kernighan — Dungeon Crawl

A competitive Linux command-line game for CS students. Students explore a deeply nested directory tree ("dungeon"), find treasure files, and `scp` them to their computers. Highest score wins.

## Commands Practiced

`cd`, `ls`, `cat`, `mkdir`, `ssh`, `scp` (and `ls -a` for advanced students)

## Quick Start

### 1. Generate the dungeon

```bash
sudo ./generate-dungeon.sh 42 ~/dungeon
```

Arguments:
- `42` — seed (change this between class periods so students can't share paths)
- `~/dungeon` — where to build (default)

### 2. Create the submissions directory

```bash
sudo mkdir -p /home/student/submissions
sudo chmod 777 /home/student/submissions
```

### 3. Print the student handout

See `student-handout.md` — fill in `SERVER_IP` before printing.

### 4. Run the game (45 min)

Students SSH in and explore. See the handout for their workflow.

### 5. Score submissions

After students upload their collections:

```bash
sudo ./score-all.sh /home/student/submissions ~/dungeon/.teacher/scoring-data.sh
```

This displays a ranked leaderboard for the whole class.

To score a single student:

```bash
sudo ./score-student.sh /home/student/submissions/alex ~/dungeon/.teacher/scoring-data.sh
```

## Dungeon Structure

5 levels, progressively harder:

| Level | Name | Treasures | Difficulty |
|-------|------|-----------|------------|
| 1 | entrance-hall | 4 common | Easy |
| 2 | catacombs | 5 mixed | Moderate |
| 3 | forge-district | 4 uncommon/rare + 2 mimics | Clue-dependent |
| 4 | library-of-whispers | 5 rare (1 hidden) | Puzzle-dependent |
| 5 | throne-room | 3 legendary/mythic + 1 mimic | Expert |

## Treasure Tiers

| Tier | Points | Count |
|------|--------|-------|
| Common | 5-13 | 4 |
| Uncommon | 18-45 | 7 |
| Rare | 50-75 | 5 |
| Legendary | 100-150 | 2 |
| Mythic | 250 | 1 |
| Mimic (trap) | 0 | 3 |

**Total: 19 real treasures + 3 mimics**

## Advanced Challenges

These reward students who go beyond the basics:

- **Hidden treasure** — A `.treasure` file starting with a dot (requires `ls -a`)
- **Cipher puzzle** — ROT13-encoded message reveals a secret path
- **Map fragments** — 5 pieces scattered across all levels; assembling them reveals a legendary treasure's location
- **Twin vaults** — Two nearly identical room names, only one has real treasure

## Answer Key

After generating the dungeon:

```bash
sudo cat ~/dungeon/.teacher/answer-key.txt
```

This lists every treasure, its location, point value, and validation code.

## Regenerating

Change the seed to get fresh validation codes (the dungeon layout stays the same, but codes change so students can't share them between class periods):

```bash
sudo ./generate-dungeon.sh $RANDOM ~/dungeon
```

## Permissions

The generator sets these automatically:

- `~/dungeon/` — read + traverse for everyone, no writes
- `~/dungeon/.teacher/` — accessible only to root (mode 700)
- Students can `cd`, `ls`, `cat`, and `scp` but cannot modify anything

## Optional: Time Pressure

To add urgency mid-game, lock levels as the game progresses:

```bash
# At 25 min: "The forge is collapsing!"
sudo chmod 000 ~/dungeon/forge-district

# At 35 min: "The library is flooding!"
sudo chmod 000 ~/dungeon/library-of-whispers
```

Reset with:
```bash
sudo chmod -R a+rX ~/dungeon/forge-district ~/dungeon/library-of-whispers
```

## Cleanup

```bash
# Remove dungeon
sudo rm -rf ~/dungeon

# Remove submissions
sudo rm -rf /home/student/submissions/*
```

## Files

| File | Purpose |
|------|---------|
| `generate-dungeon.sh` | Builds the dungeon directory tree |
| `score-student.sh` | Scores one student's collection |
| `score-all.sh` | Scores all students + leaderboard |
| `student-handout.md` | Printable rules and command reference |
