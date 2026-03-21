#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Dungeon Crawl — Class Leaderboard
# ============================================================
# Scores all student submissions and displays a ranked leaderboard.
#
# Usage: ./score-all.sh <submissions-dir> [scoring-data-path]
#   submissions-dir   — parent directory with student subdirectories
#   scoring-data-path — path to scoring-data.sh (default: /dungeon/.teacher/scoring-data.sh)
#
# Expected structure:
#   submissions-dir/
#     alex/
#       copper_coin.treasure
#       jade_amulet.treasure
#     jordan/
#       golden_scroll.treasure
#       ...
# ============================================================

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <submissions-dir> [scoring-data-path]"
    echo "  Example: $0 /home/student/submissions"
    exit 1
fi

SUBMISSIONS_DIR="$1"
SCORING_DATA="${2:-$HOME/dungeon/.teacher/scoring-data.sh}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$SUBMISSIONS_DIR" ]]; then
    echo "Error: Directory not found: $SUBMISSIONS_DIR"
    exit 1
fi

if [[ ! -f "$SCORING_DATA" ]]; then
    echo "Error: Scoring data not found: $SCORING_DATA"
    exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/score-student.sh" ]]; then
    echo "Error: score-student.sh not found in ${SCRIPT_DIR}"
    exit 1
fi

echo ""
echo "================================================"
echo "   THE SUNKEN CITADEL OF KERNIGHAN"
echo "   === CLASS LEADERBOARD ==="
echo "================================================"
echo ""

# Score each student and collect results
results=""
student_count=0

for student_dir in "${SUBMISSIONS_DIR}"/*/; do
    [[ -d "$student_dir" ]] || continue
    student_name=$(basename "$student_dir")
    ((student_count++)) || true

    # Run scorer and capture the detailed output
    echo "--- Scoring: ${student_name} ---"
    "${SCRIPT_DIR}/score-student.sh" "$student_dir" "$SCORING_DATA"

    # Extract the total score from the output
    score=$(
        "${SCRIPT_DIR}/score-student.sh" "$student_dir" "$SCORING_DATA" 2>/dev/null \
        | grep 'TOTAL SCORE:' \
        | sed 's/.*TOTAL SCORE: //' \
        | sed 's/ points//'
    )
    results="${results}${score:-0} ${student_name}\n"
done

if [[ $student_count -eq 0 ]]; then
    echo "No student submissions found in: ${SUBMISSIONS_DIR}"
    echo "Expected subdirectories like: ${SUBMISSIONS_DIR}/student-name/"
    exit 0
fi

# Display leaderboard
echo ""
echo "================================================"
echo "   FINAL LEADERBOARD"
echo "================================================"
echo ""
printf "  %-6s  %-20s  %s\n" "RANK" "ADVENTURER" "SCORE"
echo "  ------  --------------------  --------"

rank=1
echo -e "$results" | sort -rn | while read -r score name; do
    [[ -z "$name" ]] && continue
    if [[ $rank -eq 1 ]]; then
        printf "  %-6s  %-20s  %s points  <-- CHAMPION!\n" "#${rank}" "$name" "$score"
    elif [[ $rank -eq 2 ]]; then
        printf "  %-6s  %-20s  %s points  <-- Runner up\n" "#${rank}" "$name" "$score"
    elif [[ $rank -eq 3 ]]; then
        printf "  %-6s  %-20s  %s points  <-- Third place\n" "#${rank}" "$name" "$score"
    else
        printf "  %-6s  %-20s  %s points\n" "#${rank}" "$name" "$score"
    fi
    ((rank++)) || true
done

echo ""
echo "================================================"
echo "  Total adventurers: ${student_count}"
echo "================================================"
echo ""
