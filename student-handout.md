# The Sunken Citadel of Kernighan

## Your Mission

An ancient fortress has been discovered beneath the classroom server. Its halls contain treasures of varying value -- from common coins worth 5 points to a legendary Crown Jewel worth 250 points.

Your job: explore the dungeon, find treasures, and copy them back to your computer. **The adventurer with the most points wins.**

You have **45 minutes**. Good luck.

---

## Rules

1. Treasures are files that end in `.treasure`
2. Use `cat` to read a treasure and see its point value
3. Use `scp` to copy treasures to your computer
4. At the end, upload your collection to the server for scoring
5. Read everything -- clues are hidden in text files throughout the dungeon
6. Some treasures are **traps** worth 0 points. Choose wisely.
7. Do NOT modify or delete anything in the dungeon

---

## Setup (Do This First)

### Step 1: Create a folder on YOUR computer for your treasures

Open a terminal on your computer and type:

```
mkdir ~/my-treasure
```

### Step 2: Connect to the server

```
ssh student@SERVER_IP
```

(Your teacher will give you the server address and password.)

### Step 3: Go to the dungeon entrance

```
cd ~/dungeon
```

### Step 4: Read the welcome message

```
cat notice.txt
```

---

## How to Play

### Exploring

Use these commands to move through the dungeon:

| Command | What it does | Example |
|---------|-------------|---------|
| `ls` | See what's in the current room | `ls` |
| `cd room-name` | Enter a room | `cd entrance-hall` |
| `cd ..` | Go back one room | `cd ..` |
| `cat filename` | Read a file | `cat inscription.txt` |

### Collecting Treasures

When you find a `.treasure` file, first read it:

```
cat copper_coin.treasure
```

Then copy it to your computer. **Stay connected to the server** and type:

```
scp ~/dungeon/entrance-hall/torch-room/copper_coin.treasure YOUR_USERNAME@YOUR_COMPUTER_IP:~/my-treasure/
```

Replace `YOUR_USERNAME` with your computer's username and `YOUR_COMPUTER_IP` with your computer's IP address.

**Important:** You need to type the **full path** to the treasure file. You can see where you are with `pwd`.

### Submitting Your Collection

When time is up (or when you're done), open a terminal **on your computer** and type:

```
mkdir ~/my-treasure
```

(Skip this if you already created it.)

Then upload your treasures to the server:

```
scp ~/my-treasure/* student@SERVER_IP:~/submissions/YOUR_NAME/
```

Replace `YOUR_NAME` with your first name (lowercase, no spaces).

---

## Command Reference Card

| Command | Description | Example |
|---------|-------------|---------|
| `ssh user@host` | Connect to a remote server | `ssh student@192.168.1.10` |
| `ls` | List files and folders | `ls` |
| `cd folder` | Change into a folder | `cd catacombs` |
| `cd ..` | Go up one folder | `cd ..` |
| `cat file` | Display file contents | `cat clue.txt` |
| `pwd` | Show current location | `pwd` |
| `mkdir name` | Create a new folder | `mkdir ~/my-treasure` |
| `scp source dest` | Copy files between computers | (see examples above) |

---

## Tips

- **Read everything.** Clues hide in plain text files.
- **Not every path leads somewhere.** Some rooms are dead ends.
- **Scary room names might hold the best loot.** Don't be afraid to explore.
- **Some treasures are not what they seem.** Check the point value before you collect.
- **The deeper you go, the better the rewards.**
- **There are about 20 real treasures** scattered across 5 levels of the dungeon.

---

## Treasure Tiers

| Tier | Points | How Hard to Find |
|------|--------|-----------------|
| Common | 5-13 | Easy -- near the entrance |
| Uncommon | 18-45 | Moderate -- explore deeper |
| Rare | 50-75 | Hard -- follow the clues |
| Legendary | 100-150 | Very hard -- solve puzzles |
| Mythic | 250 | Extremely hard -- the ultimate prize |
| Mimic (trap) | 0 | Looks like treasure, but isn't |

---

## Advanced Challenges

Already found the easy treasures? Try these:

- **Some things are hidden from `ls`.** There might be a way to see MORE files...
- **An encoded message** exists somewhere in the library. Can you crack it?
- **Map fragments** are scattered across all 5 levels. Find all 5 to reveal a secret path.
- **Two rooms might look almost the same.** Look carefully at their names.

---

*May the shell be with you.*
