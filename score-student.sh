#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Dungeon Crawl — Student Scorer
# ============================================================
# Scores a single student's treasure collection by validating
# treasure codes against the answer key.
#
# Usage: ./score-student.sh <student-dir> [scoring-data-path]
#   student-dir       — directory containing .treasure files
#   scoring-data-path — path to scoring-data.sh (default: /dungeon/.teacher/scoring-data.sh)
# ============================================================

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <student-treasure-dir> [scoring-data-path]"
    echo "  Example: $0 /home/student/submissions/alex"
    exit 1
fi

STUDENT_DIR="$1"
SCORING_DATA="${2:-$HOME/dungeon/.teacher/scoring-data.sh}"

if [[ ! -d "$STUDENT_DIR" ]]; then
    echo "Error: Directory not found: $STUDENT_DIR"
    exit 1
fi

if [[ ! -f "$SCORING_DATA" ]]; then
    echo "Error: Scoring data not found: $SCORING_DATA"
    echo "  (Run generate-dungeon.sh first, or provide the correct path)"
    exit 1
fi

# Load valid codes
declare -A VALID_CODES
source "$SCORING_DATA"

# Tracking
total=0
found=0
mimics=0
duplicates=0
invalid=0
declare -A seen_codes

student_name=$(basename "$STUDENT_DIR")

echo ""
echo "=== SCORING: ${student_name} ==="
echo "  Directory: ${STUDENT_DIR}"
echo "-----------------------------------------------"

# Find all .treasure files (including hidden ones)
file_count=0
while IFS= read -r -d '' f; do
    ((file_count++)) || true
    filename=$(basename "$f")

    # Extract the CODE line
    code=$(grep '  CODE:' "$f" 2>/dev/null | head -1 | sed 's/.*CODE: //' || true)

    if [[ -z "$code" ]]; then
        ((invalid++)) || true
        echo "  INVALID: ${filename} (no valid code found)"
        continue
    fi

    # Check for duplicates
    if [[ -n "${seen_codes[$code]+x}" ]]; then
        ((duplicates++)) || true
        echo "  DUPLICATE: ${filename} (already counted)"
        continue
    fi
    seen_codes[$code]=1

    # Validate against answer key
    if [[ -n "${VALID_CODES[$code]+x}" ]]; then
        points=${VALID_CODES[$code]}
        if [[ "$points" -eq 0 ]]; then
            ((mimics++)) || true
            echo "  MIMIC:  ${filename} (0 points -- it was a trap!)"
        else
            ((found++)) || true
            total=$((total + points))
            echo "  FOUND:  ${filename} (+${points} points)"
        fi
    else
        ((invalid++)) || true
        echo "  FAKE:   ${filename} (invalid code -- not counted)"
    fi
done < <(find "$STUDENT_DIR" -name '*.treasure' -print0 2>/dev/null | sort -z)

if [[ $file_count -eq 0 ]]; then
    echo "  (no .treasure files found)"
fi

echo "-----------------------------------------------"
echo "  Treasures found: ${found}"
echo "  Mimics collected: ${mimics}"
echo "  Duplicates: ${duplicates}"
echo "  Invalid/fake: ${invalid}"
echo ""
echo "  TOTAL SCORE: ${total} points"
echo "==============================================="
echo ""

# Output just the score for piping (used by score-all.sh)
# This goes to fd 3 if available, otherwise nowhere
if [[ -e /dev/fd/3 ]]; then
    echo "${total}" >&3
fi
