#!/usr/bin/env bash
# 11-mavzu: Bash — avtomatik tekshiruv
# Ishlatish:  bash tests.sh        (hammasi)
#             bash tests.sh 5      (faqat 5-masala)

ROOT=$(cd "$(dirname "$0")" && pwd)
export LC_ALL=C
BASE=$(mktemp -d "${TMPDIR:-/tmp}/bashtest.XXXXXX") || exit 1
trap 'rm -rf "$BASE"' EXIT
mkdir -p "$BASE/io"
IO="$BASE/io"

PASS=0
FAIL=0
MSG=""
SCRIPT=""
STDIN_FILE=""
OUT=""
ERR=""
CODE=0
TIMEDOUT=0

# ---------- yordamchi funksiyalar ----------

# run arg...  -> $SCRIPT ni ishga tushiradi (3 soniyadan keyin to'xtatadi)
run() {
  rm -f "$IO/out" "$IO/err"
  bash "$ROOT/scripts/$SCRIPT.sh" "$@" <"${STDIN_FILE:-/dev/null}" >"$IO/out" 2>"$IO/err" &
  local pid=$! i=0
  while kill -0 "$pid" 2>/dev/null && [ "$i" -lt 60 ]; do
    sleep 0.05
    i=$((i + 1))
  done
  TIMEDOUT=0
  if kill -0 "$pid" 2>/dev/null; then
    TIMEDOUT=1
    pkill -P "$pid" 2>/dev/null
    kill -9 "$pid" 2>/dev/null
  fi
  { wait "$pid"; CODE=$?; } 2>/dev/null
  OUT=$(cat "$IO/out")
  ERR=$(cat "$IO/err")
  STDIN_FILE=""
}

show() {
  local s
  s=$(printf '%s' "$1" | awk '{printf "%s%s", (NR>1 ? "\\n" : ""), $0}')
  printf '%s' "${s:0:110}"
}

norm() {
  printf '%s\n' "$1" | awk '{$1=$1; print}' | awk 'NF'
}

timeout_msg() {
  MSG="vaqt tugadi (3 soniya) — skript to'xtamadi (stdin kutyaptimi yoki cheksiz tsikl?)"
}

# expect "izoh" "kutilgan stdout"
expect() {
  if [ "$TIMEDOUT" = 1 ]; then timeout_msg; return 1; fi
  if [ "$OUT" != "$2" ]; then
    MSG="[$1] kutilgan: $(show "$2") | olingan: $(show "$OUT")"
    return 1
  fi
  return 0
}

# expect_norm: bo'shliqlar normallashtiriladi (boshi/oxiri/ketma-ket)
expect_norm() {
  if [ "$TIMEDOUT" = 1 ]; then timeout_msg; return 1; fi
  local a b
  a=$(norm "$OUT")
  b=$(norm "$2")
  if [ "$a" != "$b" ]; then
    MSG="[$1] kutilgan: $(show "$b") | olingan: $(show "$a")"
    return 1
  fi
  return 0
}

# expect_code "izoh" kod
expect_code() {
  if [ "$TIMEDOUT" = 1 ]; then timeout_msg; return 1; fi
  if [ "$CODE" != "$2" ]; then
    MSG="[$1] chiqish kodi kutilgan: $2 | olingan: $CODE"
    return 1
  fi
  return 0
}

# expect_stderr "izoh" yes|no   (stderr bo'sh emasmi?)
expect_stderr() {
  if [ "$TIMEDOUT" = 1 ]; then timeout_msg; return 1; fi
  if [ "$2" = yes ] && [ -z "$ERR" ]; then
    MSG="[$1] kutilgan: stderr ga xabar | olingan: stderr bo'sh"
    return 1
  fi
  if [ "$2" = no ] && [ -n "$ERR" ]; then
    MSG="[$1] kutilgan: stderr bo'sh | olingan: $(show "$ERR")"
    return 1
  fi
  return 0
}

# ---------- sinovlar ----------

t1() {
  SCRIPT=01-greet
  run Ali; expect "Ali" "Salom, Ali!" || return 1
  run Vali; expect "Vali" "Salom, Vali!" || return 1
  run Zuhra; expect "Zuhra" "Salom, Zuhra!" || return 1
}

t2() {
  SCRIPT=02-arifmetika
  run 7 3
  expect "7 3" "Yig'indi: 10
Ayirma: 4
Ko'paytma: 21" || return 1
  run 10 25
  expect "10 25" "Yig'indi: 35
Ayirma: -15
Ko'paytma: 250" || return 1
  run -4 6
  expect "-4 6" "Yig'indi: 2
Ayirma: -10
Ko'paytma: -24" || return 1
}

t3() {
  SCRIPT=03-juft-toq
  run 4; expect "4" "juft" || return 1
  run 7; expect "7" "toq" || return 1
  run 0; expect "0" "juft" || return 1
  run -3; expect "-3" "toq" || return 1
  run 100; expect "100" "juft" || return 1
}

t4() {
  SCRIPT=04-argument
  run
  expect_code "argumentsiz" 1 || return 1
  expect "argumentsiz: stdout bo'sh bo'lsin" "" || return 1
  expect_stderr "argumentsiz" yes || return 1
  run salom
  expect_code "salom" 0 || return 1
  expect "salom" "salom" || return 1
  expect_stderr "salom" no || return 1
  run dunyo
  expect "dunyo" "dunyo" || return 1
}

t5() {
  SCRIPT=05-sanash
  run 5; expect "5" "1
2
3
4
5" || return 1
  run 1; expect "1" "1" || return 1
  run 0; expect "0" "" || return 1
  expect_code "0" 0 || return 1
  run 12; expect "12" "1
2
3
4
5
6
7
8
9
10
11
12" || return 1
}

t6() {
  SCRIPT=06-argumentlar
  run a b c; expect "a b c" "1: a
2: b
3: c" || return 1
  run "salom dunyo" x; expect "\"salom dunyo\" x" "1: salom dunyo
2: x" || return 1
  run; expect "argumentsiz" "" || return 1
  expect_code "argumentsiz" 0 || return 1
  run bir; expect "bir" "1: bir" || return 1
}

t7() {
  SCRIPT=07-teskari-sanash
  run 3; expect "3" "3
2
1
Start!" || return 1
  run 1; expect "1" "1
Start!" || return 1
  run 0; expect "0" "Start!" || return 1
  run 6; expect "6" "6
5
4
3
2
1
Start!" || return 1
}

t8() {
  SCRIPT=08-faktorial
  run 5; expect "5" "120" || return 1
  run 0; expect "0" "1" || return 1
  run 1; expect "1" "1" || return 1
  run 10; expect "10" "3628800" || return 1
  run 15; expect "15" "1307674368000" || return 1
}

t9() {
  SCRIPT=09-buyruq
  run start; expect "start" "Xizmat ishga tushdi" || return 1
  run stop; expect "stop" "Xizmat to'xtadi" || return 1
  run status; expect "status" "Xizmat ishlayapti" || return 1
  run restart; expect "restart" "Noma'lum buyruq: restart" || return 1
  run foo; expect "foo" "Noma'lum buyruq: foo" || return 1
  expect_code "foo" 0 || return 1
}

t10() {
  SCRIPT=10-fayl-turi
  : > a.txt
  : > "my file.txt"
  mkdir papka
  run a.txt papka nope "my file.txt"
  expect "a.txt papka nope \"my file.txt\"" "a.txt: fayl
papka: papka
nope: yo'q
my file.txt: fayl" || return 1
  run papka; expect "papka" "papka: papka" || return 1
  run zzz yyy; expect "zzz yyy" "zzz: yo'q
yyy: yo'q" || return 1
}

t11() {
  SCRIPT=11-qator-raqam
  local want
  printf 'birinchi\n  chekinish bor\nback\\slash\n\nohirgi\n' > f.txt
  want=$(printf '1: birinchi\n2:   chekinish bor\n3: back\\slash\n4: \n5: ohirgi')
  run f.txt; expect "f.txt" "$want" || return 1
  printf 'x\n' > one.txt
  run one.txt; expect "one.txt" "1: x" || return 1
  printf 'a\nb\n' > two.txt
  run two.txt; expect "two.txt" "1: a
2: b" || return 1
}

t12() {
  SCRIPT=12-txt-soni
  mkdir d e g d/sub d/papka.txt
  : > d/a.txt; : > d/b.txt; : > d/c.md; : > "d/my notes.txt"
  : > d/txt; : > d/x.txt.bak; : > d/sub/z.txt
  run d; expect_norm "d (3 ta .txt)" "3" || return 1
  run e; expect_norm "e (bo'sh papka)" "0" || return 1
  : > g/only.txt
  run g; expect_norm "g (1 ta)" "1" || return 1
}

t13() {
  SCRIPT=13-top-sozlar
  printf 'The cat and the dog. The CAT sat; the dog ran!\nBig cat, red dog, and one bird.\n' > t1.txt
  run t1.txt
  expect_norm "fayl: t1.txt" "4 the
3 cat
3 dog" || return 1
  printf 'b a c b a c d\n' > t2.txt
  STDIN_FILE=t2.txt; run
  expect_norm "stdin: teng sonlar (alifbo tartibi)" "2 a
2 b
2 c" || return 1
  printf 'hello hello World\n' > t3.txt
  STDIN_FILE=t3.txt; run
  expect_norm "stdin: 2 ta so'z" "2 hello
1 world" || return 1
  printf "it's 42 it's\n" > t4.txt
  run t4.txt
  expect_norm "fayl: apostrof va raqamlar" "2 it
2 s" || return 1
}

t14() {
  SCRIPT=14-jami-narx
  printf 'name,price,qty\nolma,1.50,4\nnon,0.80,10\nsut,12.25,2\n' > a.csv
  run a.csv; expect "a.csv" "38.50" || return 1
  printf 'name,price,qty\n' > b.csv
  run b.csv; expect "b.csv (faqat sarlavha)" "0.00" || return 1
  printf 'name,price,qty\nchoy,0.10,3\nqahva,19.99,3' > c.csv
  run c.csv; expect "c.csv" "60.27" || return 1
}

t15() {
  SCRIPT=15-zaxira
  mkdir sub
  printf 'bir\n' > a.txt
  printf 'ikki\n' > sub/b.txt
  printf 'uch' > "my file.txt"
  run a.txt sub/b.txt "my file.txt"
  if [ "$TIMEDOUT" = 1 ]; then timeout_msg; return 1; fi
  expect_code "hammasi bor" 0 || return 1
  expect_stderr "hammasi bor" no || return 1
  [ -f a.txt.bak ] && cmp -s a.txt a.txt.bak || { MSG="[hammasi bor] kutilgan: a.txt.bak (a.txt nusxasi) | olingan: yo'q yoki farq qiladi"; return 1; }
  [ -f sub/b.txt.bak ] && cmp -s sub/b.txt sub/b.txt.bak || { MSG="[hammasi bor] kutilgan: sub/b.txt.bak | olingan: yo'q yoki farq qiladi"; return 1; }
  [ -f "my file.txt.bak" ] && cmp -s "my file.txt" "my file.txt.bak" || { MSG="[hammasi bor] kutilgan: 'my file.txt.bak' | olingan: yo'q yoki farq qiladi"; return 1; }
  rm -f a.txt.bak sub/b.txt.bak "my file.txt.bak"
  run a.txt nope.txt sub/b.txt
  expect_code "nope.txt yo'q" 1 || return 1
  expect_stderr "nope.txt yo'q" yes || return 1
  [ -f a.txt.bak ] && [ -f sub/b.txt.bak ] || { MSG="[nope.txt yo'q] kutilgan: qolgan fayllar baribir nusxalansin | olingan: .bak yo'q"; return 1; }
  [ ! -e nope.txt.bak ] || { MSG="[nope.txt yo'q] kutilgan: nope.txt.bak yaratilmasin | olingan: yaratilgan"; return 1; }
  [ -f a.txt ] && [ -f sub/b.txt ] || { MSG="asl fayllar o'chib ketdi (cp ishlating, mv emas)"; return 1; }
}

t16() {
  SCRIPT=16-log-tahlil
  printf '%s\n' \
    '2024-01-05 INFO server started' \
    '2024-01-05 ERROR disk full' \
    '2024-01-05 INFO user login' \
    '2024-01-06 WARN memory high' \
    '2024-01-06 INFO retry after ERROR' \
    '2024-01-06 ERROR timeout' > l1.log
  run l1.log
  expect "l1.log" "INFO: 3
WARN: 1
ERROR: 2" || return 1
  printf '%s\n' '2024-02-01 WARN a' '2024-02-01 WARN b' '2024-02-01 ERROR INFO lost' > l2.log
  run l2.log
  expect "l2.log" "INFO: 0
WARN: 2
ERROR: 1" || return 1
  : > l3.log
  run l3.log
  expect "bo'sh fayl" "INFO: 0
WARN: 0
ERROR: 0" || return 1
  run yoq.log
  expect_code "fayl yo'q" 1 || return 1
  expect "fayl yo'q: stdout bo'sh" "" || return 1
  expect_stderr "fayl yo'q" yes || return 1
  run
  expect_code "argumentsiz" 1 || return 1
  expect_stderr "argumentsiz" yes || return 1
}

# ---------- ishga tushirish ----------

NAME_1="greet"; NAME_2="arifmetika"; NAME_3="juft-toq"; NAME_4="argument"
NAME_5="sanash"; NAME_6="argumentlar"; NAME_7="teskari-sanash"; NAME_8="faktorial"
NAME_9="buyruq"; NAME_10="fayl-turi"; NAME_11="qator-raqam"; NAME_12="txt-soni"
NAME_13="top-sozlar"; NAME_14="jami-narx"; NAME_15="zaxira"; NAME_16="log-tahlil"

# Sinov subshell ichida ishlaydi, shuning uchun xabar faylga yoziladi
run_test() {
  local n=$1 nm rc
  eval "nm=\$NAME_$n"
  mkdir -p "$BASE/w$n"
  (cd "$BASE/w$n" && "t$n"; rc=$?; printf '%s' "$MSG" > "$BASE/msg"; exit $rc)
  rc=$?
  if [ "$rc" -eq 0 ]; then
    PASS=$((PASS + 1))
    echo "  ✓ $n. $nm"
  else
    FAIL=$((FAIL + 1))
    echo "  ✗ $n. $nm"
    MSG=$(cat "$BASE/msg")
    [ -n "$MSG" ] || MSG="kutilgan: to'g'ri natija | olingan: boshqacha natija"
    echo "      $MSG"
  fi
}

if [ -n "$1" ]; then
  case "$1" in
    [1-9]|1[0-6]) run_test "$1" ;;
    *) echo "Noto'g'ri raqam: $1 (1 dan 16 gacha)" >&2; exit 2 ;;
  esac
else
  n=1
  while [ "$n" -le 16 ]; do
    run_test "$n"
    n=$((n + 1))
  done
fi

echo
echo "Natija: $PASS ta o'tdi, $FAIL ta yiqildi"
[ "$FAIL" -eq 0 ]
