#!/usr/bin/env bash
# Git amaliy laboratoriyasi: ./lab.sh list | start <n> | check <n>
# macOS bash 3.2 va yangi Linux bash bilan ishlaydi.

ROOT="${GIT_LAB_DIR:-$HOME/git-lab}"
ROOT="${ROOT%/}"
COUNT=15
TICK=0

# ---------------------------------------------------------------- metadata
title() {
  case "$1" in
    1) echo "Repozitoriy yaratish va birinchi commit" ;;
    2) echo "Tanlab staging qilish" ;;
    3) echo ".gitignore" ;;
    4) echo "Tarixni o'qish" ;;
    5) echo "Branch va merge" ;;
    6) echo "O'zgarishlarni bekor qilish" ;;
    7) echo "Oxirgi commitni tuzatish (amend)" ;;
    8) echo "Commitni revert qilish" ;;
    9) echo "Commitlarni birlashtirish (squash)" ;;
    10) echo "Merge conflictni hal qilish" ;;
    11) echo "Stash" ;;
    12) echo "Hamkasb bilan push/pull" ;;
    13) echo "Feature branchni push qilish" ;;
    14) echo "Rebase" ;;
    15) echo "Cherry-pick" ;;
  esac
}

slug() {
  case "$1" in
    1) echo "init-commit" ;;
    2) echo "selective-staging" ;;
    3) echo "gitignore" ;;
    4) echo "history" ;;
    5) echo "branch-merge" ;;
    6) echo "undo-changes" ;;
    7) echo "amend" ;;
    8) echo "revert" ;;
    9) echo "squash" ;;
    10) echo "conflict" ;;
    11) echo "stash" ;;
    12) echo "push-pull" ;;
    13) echo "push-branch" ;;
    14) echo "rebase" ;;
    15) echo "cherry-pick" ;;
  esac
}

# ---------------------------------------------------------------- yordamchilar
valid_n() {
  case "$1" in
    ''|*[!0-9]*) return 1 ;;
  esac
  [ "$1" -ge 1 ] && [ "$1" -le "$COUNT" ]
}

# Faqat $ROOT/<n>-<slug> ko'rinishidagi yo'lni o'chirishga ruxsat beramiz.
safe_sandbox() {
  case "$ROOT" in
    ""|"/"|"$HOME") return 1 ;;
    /*) ;;
    *) return 1 ;;
  esac
  case "$1" in
    *..*) return 1 ;;
    "$ROOT"/[0-9]*-[a-z-]*) ;;
    *) return 1 ;;
  esac
  [ "$(dirname "$1")" = "$ROOT" ]
}

ginit() {
  git init -q -b main "$1" >/dev/null 2>&1 || {
    git init -q "$1" >/dev/null 2>&1
    git -C "$1" symbolic-ref HEAD refs/heads/main
  }
}

gconf() { # dir [name] [email]
  git -C "$1" config user.name "${2:-Talaba}"
  git -C "$1" config user.email "${3:-talaba@example.com}"
  git -C "$1" config commit.gpgsign false
  git -C "$1" config tag.gpgsign false
}

mkrepo() { ginit "$1"; gconf "$1" "$2" "$3"; }

gbare() {
  git init -q --bare -b main "$1" >/dev/null 2>&1 || {
    git init -q --bare "$1" >/dev/null 2>&1
    git --git-dir="$1" symbolic-ref HEAD refs/heads/main
  }
}

# joriy papkada barcha o'zgarishlarni qo'shib, qat'iy sana bilan commit qiladi
cm() {
  local d
  TICK=$((TICK + 1))
  d=$(printf '2024-01-01T10:%02d:00+0000' "$TICK")
  git add -A
  GIT_AUTHOR_DATE="$d" GIT_COMMITTER_DATE="$d" git commit -q -m "$1"
}

start_dir() {
  case "$1" in
    12|13) echo "$SB/work" ;;
    *) echo "$SB" ;;
  esac
}

# ---------------------------------------------------------------- setup
setup_1() { :; }

setup_2() {
  cd "$SB" || exit 1
  mkrepo .
  printf '# Loyiha\n' > README.md
  printf 'a: v1\n' > a.txt
  cm "Initial commit"
  printf 'a: v2 (o%szgartirildi)\n' "'" >> a.txt
  printf 'b: yangi fayl\n' > b.txt
  printf 'c: hali tayyor emas\n' > c.txt
}

setup_3() {
  cd "$SB" || exit 1
  mkrepo .
  mkdir -p node_modules/lib
  printf 'module.exports = 1;\n' > node_modules/lib/index.js
  printf 'API_KEY=12345\n' > .env
  printf 'console.log("Salom");\n' > app.js
}

setup_4() {
  cd "$SB" || exit 1
  mkrepo .
  printf '# Demo\n' > README.md
  cm "Initial commit"
  printf '{ "debug": true }\n' > config.json
  cm "Add config"
  printf 'console.log("start");\n' > index.js
  cm "Add main script"
  printf 'Ishga tushirish: node index.js\n' >> README.md
  cm "Update docs"
  git rm -q config.json
  cm "Cleanup"
  printf 'console.log("test");\n' > test.js
  cm "Add tests"
}

setup_5() {
  cd "$SB" || exit 1
  mkrepo .
  printf 'console.log("app");\n' > app.js
  cm "Initial commit"
}

setup_6() {
  cd "$SB" || exit 1
  mkrepo .
  printf 'Muhim eslatmalar\n' > notes.txt
  printf 'Vazifalar:\n' > todo.txt
  cm "Add notes and todo"
  printf 'XATO: bu qator tasodifan yozilgan\n' >> notes.txt
  printf 'Buy milk\n' >> todo.txt
  git add todo.txt
}

setup_7() {
  cd "$SB" || exit 1
  mkrepo .
  printf '<h1>Salom</h1>\n' > index.html
  cm "Initial commit"
  printf 'function feature() {}\n' > feature.js
  cm "Add feture"
  printf 'body { margin: 0; }\n' > style.css
}

setup_8() {
  cd "$SB" || exit 1
  mkrepo .
  printf 'console.log("app");\n' > app.js
  cm "Initial commit"
  printf 'function login() {}\n' > login.js
  cm "Add login"
  printf 'throw new Error("boom");\n' >> app.js
  cm "Break the build"
  printf '<footer>2024</footer>\n' > footer.js
  cm "Add footer"
}

setup_9() {
  cd "$SB" || exit 1
  mkrepo .
  printf '# Demo\n' > README.md
  cm "Initial commit"
  printf '// search v1\n' > search.js
  cm "wip"
  printf '// search v2 - filter by name\n' >> search.js
  cm "wip"
}

setup_10() {
  cd "$SB" || exit 1
  mkrepo .
  printf '# Salomlashuv\nHello, World!\nXayr!\n' > greeting.txt
  cm "Add greeting"
  git checkout -q -b feature
  printf '# Salomlashuv\nAssalomu alaykum, Olam!\nXayr!\n' > greeting.txt
  cm "Greet formally"
  git checkout -q main
  printf '# Salomlashuv\nSalom, Dunyo!\nXayr!\n' > greeting.txt
  cm "Greet in Uzbek"
}

setup_11() {
  cd "$SB" || exit 1
  mkrepo .
  printf '// app v1\n' > app.js
  printf 'status: broken\n' > bug.txt
  cm "Initial commit"
  printf '// yarim qolgan ish\n' >> app.js
}

setup_12() {
  cd "$SB" || exit 1
  gbare remote.git
  git clone -q remote.git teammate >/dev/null 2>&1
  git -C teammate symbolic-ref HEAD refs/heads/main
  gconf teammate "Hamkasb" "hamkasb@example.com"
  ( cd teammate && printf '# Jamoa loyihasi\n' > README.md && cm "Initial commit" \
      && git push -q -u origin main >/dev/null 2>&1 )
  git clone -q remote.git work >/dev/null 2>&1
  gconf work
  git -C work config pull.rebase false
  ( cd teammate && printf 'Hamkasb shu yerda edi\n' > team.txt && cm "Add team.txt" \
      && git push -q origin main >/dev/null 2>&1 )
}

setup_13() {
  cd "$SB" || exit 1
  gbare remote.git
  git clone -q remote.git work >/dev/null 2>&1
  git -C work symbolic-ref HEAD refs/heads/main
  gconf work
  ( cd work && printf '# Mening loyiham\n\nWellcome to my project!\n' > README.md && cm "Initial commit" \
      && git push -q -u origin main >/dev/null 2>&1 )
}

setup_14() {
  cd "$SB" || exit 1
  mkrepo .
  printf 'base\n' > base.txt
  cm "Initial commit"
  git checkout -q -b feature
  printf 'feature\n' > feature.txt
  cm "Add feature.txt"
  git checkout -q main
  printf 'm1\n' > m1.txt
  cm "Add m1.txt"
  printf 'm2\n' > m2.txt
  cm "Add m2.txt"
  git checkout -q feature
}

setup_15() {
  cd "$SB" || exit 1
  mkrepo .
  printf 'Do%skon sayti\nSarlavha: Dokon\n' "'" > README.md
  printf 'function total(price, qty) { return price + qty; }\n' > price.js
  cm "Initial commit"
  git checkout -q -b hotfix
  printf 'Do%skon sayti\nSarlavha: Do%skon\n' "'" "'" > README.md
  cm "Fix typo in header"
  printf 'function total(price, qty) { return price * qty; }\n' > price.js
  cm "Fix price calculation"
  printf '# Hujjatlar\n' > docs.md
  cm "Update docs"
  git checkout -q main
}

# ---------------------------------------------------------------- vazifa matnlari
goal_1() { cat <<'TXT'
Bu papka bo'sh. Unda git repozitoriy yarating (asosiy branch nomi: main),
README.md faylini yarating va uni birinchi commit qiling.
Oxirida ishchi papka toza bo'lishi kerak.
TXT
}
goal_2() { cat <<'TXT'
a.txt o'zgartirilgan, b.txt yangi, c.txt esa hali tayyor emas.
a.txt va b.txt ni BITTA commitga joylang. c.txt commit qilinmasdan
(untracked holda) qolsin.
TXT
}
goal_3() { cat <<'TXT'
Papkada app.js, node_modules/ va .env bor. node_modules/ va .env git
tomonidan e'tiborga olinmasin (.gitignore yarating). Faqat app.js va
.gitignore ni commit qiling.
TXT
}
goal_4() { cat <<'TXT'
Repozitoriyda taxminan 6 ta commit bor. Qaysi commit config.json faylini
O'CHIRGAN? O'sha commitning qisqa hashini (7 belgi) javob.txt fayliga yozing.
Tarixni o'zgartirmang, faqat o'qing.
TXT
}
goal_5() { cat <<'TXT'
feature/login nomli branch yarating, unda login.js faylini yarating va
commit qiling. Keyin main ga o'tib, feature/login ni main ga merge qiling
va branchni o'chiring. Oxirida siz main da bo'lishingiz kerak.
TXT
}
goal_6() { cat <<'TXT'
notes.txt (tracked) tasodifan buzilgan: o'zgarishni to'liq bekor qiling (fayl
oxirgi commitdagi holatiga qaytsin).
todo.txt dagi o'zgarish staging ga qo'shilgan: uni staging dan chiqaring,
lekin fayl ichidagi o'zgarish (yangi qator) saqlanib qolsin.
Hech qanday commit yaratmang.
TXT
}
goal_7() { cat <<'TXT'
Oxirgi commitning xabari xato ("Add feture") va style.css ni qo'shishni
unutgansiz. Xabarni "Add feature" ga to'g'rilang va style.css ni SHU commitning
o'ziga qo'shing. Commitlar soni o'zgarmasligi kerak.
TXT
}
goal_8() { cat <<'TXT'
Tarixning o'rtasida "Break the build" nomli yomon commit bor. Uni tarixni
o'chirmasdan bekor qiling: yangi "revert" commit yarating. Yomon commit
tarixda qolishi, keyingi commit (footer.js) esa yo'qolmasligi kerak.
TXT
}
goal_9() { cat <<'TXT'
Oxirgi ikkita commit ikkalasi ham "wip" deb nomlangan. Ularni bitta commitga
birlashtiring: xabar "Add search feature" bo'lsin. Fayl mazmuni
(search.js) o'zgarmasin, jami commitlar soni 1 taga kamaysin.
TXT
}
goal_10() { cat <<'TXT'
main va feature branchlar greeting.txt ning bir xil qatorini turlicha
o'zgartirgan. feature ni main ga merge qiling va conflictni shunday hal
qilingki, salomlashuv qatori aynan "Assalomu alaykum, Dunyo!" bo'lsin
(fayldagi boshqa qatorlar o'zgarmasin, <<<<<<< belgilari qolmasin).
Natijada ikki ota-onali merge commit hosil bo'lsin.
TXT
}
goal_11() { cat <<'TXT'
app.js da tugallanmagan ishingiz bor (commit qilinmagan). Shoshilinch xato:
bug.txt dagi "broken" ni "fixed" ga o'zgartirib, main ga commit qilish kerak.
Ishni yo'qotmasdan: stash qiling, tuzatishni commit qiling, so'ng stash ni
qaytaring. Oxirida app.js dagi o'zgarish yana commit qilinmagan holda
turishi va stash ro'yxati bo'sh bo'lishi kerak.
TXT
}
goal_12() { cat <<'TXT'
work/ papkasi - sizning klon. Hamkasbingiz (teammate/ papka) allaqachon
yangi commit push qilgan. Uni pull qiling, o'zingizning commitingizni
(istalgan yangi fayl) qo'shing va push qiling. Oxirida origin/main da
ikkala commit ham bo'lsin va sizning main = origin/main.
TXT
}
goal_13() { cat <<'TXT'
work/ ichidagi README.md da imlo xatosi bor ("Wellcome"). fix/typo nomli
branch yarating, xatoni to'g'rilang, commit qiling va branchni origin ga
upstream (kuzatuv) bilan push qiling. origin dagi main o'zgarmasligi kerak.
TXT
}
goal_14() { cat <<'TXT'
feature branch main dan 2 ta commit orqada. feature ni main ustiga rebase
qiling: tarix chiziqli (merge commitsiz) bo'lsin, feature ichida main ning
oxirgi commiti va feature ning o'z commiti bo'lsin.
TXT
}
goal_15() { cat <<'TXT'
hotfix branchda 3 ta commit bor. Faqat "Fix price calculation" commitini main
ga olib keling (main ga o'ting). Qolgan ikkitasi main da bo'lmasligi kerak.
TXT
}

# ---------------------------------------------------------------- tekshiruv yordamchilari
PASS=0
TOTAL=0

t() { # tavsif, ifoda
  TOTAL=$((TOTAL + 1))
  if eval "$2" >/dev/null 2>&1; then
    PASS=$((PASS + 1))
    echo "  ✓ $1"
  else
    echo "  ✗ $1"
  fi
}

g()  { [ -e "$D/.git" ] || return 1; git -C "$D" "$@"; }
gw() { [ -e "$D/work/.git" ] || return 1; git -C "$D/work" "$@"; }
gr() { [ -e "$D/remote.git/HEAD" ] || return 1; git --git-dir="$D/remote.git" "$@"; }

ok_repo()  { g rev-parse -q --verify HEAD; }
ok_repow() { gw rev-parse -q --verify HEAD; }
clean()    { ok_repo && [ -z "$(g status --porcelain)" ]; }
branch_is() { [ "$(g symbolic-ref --short HEAD)" = "$1" ]; }
count() { g rev-list --count "${1:-HEAD}"; }
head_files() { g diff-tree --no-commit-id --name-only -r HEAD | tr '\n' ' '; }

# -- 3
no_ignored_tracked() {
  ok_repo || return 1
  [ -z "$(g ls-tree -r --name-only HEAD | grep -E '^(node_modules/|\.env$)')" ] &&
  [ -z "$(g ls-files | grep -E '^(node_modules/|\.env$)')" ]
}
# -- 4
real_hash() { g log --diff-filter=D --format=%H -1 -- config.json; }
answer() { [ -f "$D/javob.txt" ] && tr -d ' \t\r\n' < "$D/javob.txt"; }
ans_format() { local a; a=$(answer); [ "${#a}" -ge 7 ] && [ -z "$(printf '%s' "$a" | tr -d '0-9a-f')" ]; }
ans_match() {
  local a f
  a=$(answer); f=$(real_hash)
  [ "${#a}" -ge 7 ] && [ -n "$f" ] || return 1
  case "$f" in "$a"*) return 0 ;; esac
  return 1
}
# -- 8
bad_hash() { g log --format='%H %s' | grep ' Break the build$' | head -1 | cut -d' ' -f1; }
has_revert() {
  local b; b=$(bad_hash)
  [ -n "$b" ] && g log --format=%B | grep -q "This reverts commit $b"
}
# -- 10
greeting_ok() {
  [ -f "$D/greeting.txt" ] || return 1
  [ "$(cat "$D/greeting.txt")" = "$(printf '# Salomlashuv\nAssalomu alaykum, Dunyo!\nXayr!')" ]
}
no_markers() {
  [ -f "$D/greeting.txt" ] && ! grep -qE '^(<<<<<<<|=======|>>>>>>>)' "$D/greeting.txt"
}
two_parents() { [ "$(g rev-list --parents -n 1 HEAD | wc -w | tr -d ' ')" = 3 ]; }
# -- 12
remote_has_student() { gr log main --no-merges --format=%an | grep -qxF Talaba; }
same_as_remote() {
  local a b
  a=$(gw rev-parse HEAD); b=$(gr rev-parse refs/heads/main)
  [ -n "$a" ] && [ "$a" = "$b" ]
}
# -- 13
remote_fixed() {
  local f; f=$(gr show fix/typo:README.md) || return 1
  printf '%s\n' "$f" | grep -q 'Welcome' && ! printf '%s\n' "$f" | grep -q 'Wellcome'
}
remote_main_untouched() {
  [ "$(gr rev-list --count main)" = 1 ] && gr show main:README.md | grep -q 'Wellcome'
}
local_remote_same() {
  local a b
  a=$(gw rev-parse fix/typo); b=$(gr rev-parse refs/heads/fix/typo)
  [ -n "$a" ] && [ "$a" = "$b" ]
}
no_rebase_in_progress() { [ ! -d "$D/.git/rebase-merge" ] && [ ! -d "$D/.git/rebase-apply" ]; }

# ---------------------------------------------------------------- tekshiruvlar
check_1() {
  t "git repozitoriy yaratilgan (.git bor)" '[ -d "$D/.git" ]'
  t "asosiy branch nomi main" 'branch_is main'
  t "README.md fayli mavjud" '[ -f "$D/README.md" ]'
  t "kamida bitta commit bor" 'ok_repo'
  t "README.md git tomonidan kuzatiladi (commitda)" 'ok_repo && g cat-file -e HEAD:README.md'
  t "ishchi papka toza (hamma narsa commit qilingan)" 'clean'
}

check_2() {
  t "aynan bitta yangi commit yaratilgan (jami 2 ta)" '[ "$(count)" = 2 ]'
  t "yangi commitda aynan a.txt va b.txt bor" '[ "$(head_files)" = "a.txt b.txt " ]'
  t "a.txt va b.txt da commit qilinmagan o'zgarish qolmagan" 'ok_repo && [ -z "$(g status --porcelain -- a.txt b.txt)" ]'
  t "c.txt papkada bor va commit qilinmagan (untracked)" '[ -f "$D/c.txt" ] && [ "$(g status --porcelain)" = "?? c.txt" ]'
}

check_3() {
  t ".gitignore fayli mavjud" '[ -f "$D/.gitignore" ]'
  t "node_modules/ ignore qilingan" 'ok_repo && g check-ignore -q node_modules/lib/index.js'
  t ".env ignore qilingan" 'ok_repo && g check-ignore -q .env'
  t "app.js va .gitignore commit qilingan" 'ok_repo && g cat-file -e HEAD:app.js && g cat-file -e HEAD:.gitignore'
  t "node_modules/ va .env commitga tushmagan (tracked emas)" 'no_ignored_tracked'
  t ".env va node_modules/ papkada o'chirilmagan" '[ -f "$D/.env" ] && [ -f "$D/node_modules/lib/index.js" ]'
  t "ishchi papka toza" 'clean'
}

check_4() {
  t "javob.txt fayli mavjud" '[ -f "$D/javob.txt" ]'
  t "javob.txt da kamida 7 belgili hash bor" 'ans_format'
  t "hash config.json ni o'chirgan commitga to'g'ri keladi" 'ans_match'
  t "tarix o'zgartirilmagan (6 ta commit)" 'ok_repo && [ "$(count)" = 6 ]'
}

check_5() {
  t "feature/login branchi yaratilgan va ishlatilgan" 'ok_repo && g log -g --format=%gs HEAD | grep -q "to feature/login"'
  t "feature/login main ga merge qilingan" 'ok_repo && g log -g --format=%gs HEAD | grep -q "merge feature/login"'
  t "main da login.js bor" 'ok_repo && g cat-file -e main:login.js'
  t "feature/login branchi o'chirilgan" 'ok_repo && [ -z "$(g branch --list feature/login)" ]'
  t "siz main branchdasiz" 'branch_is main'
  t "ishchi papka toza" 'clean'
}

check_6() {
  t "notes.txt oxirgi commit holatiga qaytgan" 'ok_repo && g diff --quiet HEAD -- notes.txt'
  t "todo.txt staging dan chiqarilgan" 'ok_repo && g diff --cached --quiet -- todo.txt'
  t "todo.txt dagi o'zgarish (Buy milk) saqlangan" 'grep -qxF "Buy milk" "$D/todo.txt"'
  t "todo.txt hali ham o'zgartirilgan (commit qilinmagan)" 'ok_repo && ! g diff --quiet -- todo.txt'
  t "yangi commit yaratilmagan" 'ok_repo && [ "$(count)" = 1 ]'
}

check_7() {
  t "commitlar soni o'zgarmagan (2 ta)" '[ "$(count)" = 2 ]'
  t "oxirgi commit xabari aynan: Add feature" '[ "$(g log -1 --format=%s)" = "Add feature" ]'
  t "oxirgi commitda feature.js va style.css bor" '[ "$(head_files)" = "feature.js style.css " ]'
  t "avvalgi commit tegilmagan (Initial commit)" 'ok_repo && [ "$(g log -1 --format=%s HEAD~1)" = "Initial commit" ]'
  t "ishchi papka toza" 'clean'
}

check_8() {
  t "yomon commit (Break the build) tarixda saqlangan" '[ -n "$(bad_hash)" ]'
  t "yangi revert commit mavjud (This reverts commit ...)" 'has_revert'
  t "app.js dagi xato qator olib tashlangan" '[ -f "$D/app.js" ] && ! grep -q boom "$D/app.js"'
  t "keyingi ish yo'qolmagan (footer.js, login.js bor)" '[ -f "$D/footer.js" ] && [ -f "$D/login.js" ]'
  t "commitlar soni 5 (4 ta + 1 ta revert)" 'ok_repo && [ "$(count)" = 5 ]'
  t "ishchi papka toza" 'clean'
}

check_9() {
  t "commitlar soni 1 taga kamaygan (2 ta)" '[ "$(count)" = 2 ]'
  t "oxirgi commit xabari: Add search feature" '[ "$(g log -1 --format=%s)" = "Add search feature" ]'
  t "avvalgi commit Initial commit (wip lar birlashgan)" 'ok_repo && [ "$(g log -1 --format=%s HEAD~1)" = "Initial commit" ]'
  t "tarixda wip commit qolmagan" 'ok_repo && ! g log --format=%s | grep -qx wip'
  t "search.js mazmuni saqlangan (v1 va v2)" 'ok_repo && g show HEAD:search.js | grep -q "search v1" && g show HEAD:search.js | grep -q "search v2"'
  t "ishchi papka toza" 'clean'
}

check_10() {
  t "siz main branchdasiz" 'branch_is main'
  t "oxirgi commit merge commit (2 ta ota-ona)" 'ok_repo && two_parents'
  t "feature branch main ga qo'shilgan" 'ok_repo && g merge-base --is-ancestor feature HEAD'
  t "greeting.txt da conflict belgilari (<<<<<<<, =======, >>>>>>>) yo'q" 'no_markers'
  t "salomlashuv qatori aynan: Assalomu alaykum, Dunyo!" 'greeting_ok'
  t "merge yakunlangan, ishchi papka toza" 'clean && [ ! -f "$D/.git/MERGE_HEAD" ]'
}

check_11() {
  t "stash ro'yxati bo'sh" 'ok_repo && [ -z "$(g stash list)" ]'
  t "app.js dagi o'zgarish qaytgan va commit qilinmagan" 'grep -q "yarim qolgan ish" "$D/app.js" && ok_repo && ! g diff --quiet -- app.js'
  t "app.js dagi o'zgarish commitga tushib ketmagan" 'ok_repo && ! g show HEAD:app.js | grep -q "yarim qolgan ish"'
  t "bug.txt tuzatilgan va commit qilingan (fixed)" 'ok_repo && g show HEAD:bug.txt | grep -q fixed'
  t "tuzatish alohida bitta commitda (jami 2 ta), faqat bug.txt" '[ "$(count)" = 2 ] && [ "$(head_files)" = "bug.txt " ]'
  t "siz main branchdasiz" 'branch_is main'
}

check_12() {
  t "work/ klon mavjud" '[ -d "$D/work/.git" ]'
  t "origin/main da hamkasbning commiti bor (team.txt)" 'gr cat-file -e main:team.txt'
  t "origin/main da sizning (Talaba) commitingiz bor" 'remote_has_student'
  t "sizning main = origin/main (hammasi push qilingan)" 'same_as_remote'
  t "work/ da main branchdasiz" '[ "$(gw symbolic-ref --short HEAD)" = main ]'
  t "work/ ishchi papkasi toza" 'ok_repow && [ -z "$(gw status --porcelain)" ]'
}

check_13() {
  t "origin da fix/typo branchi bor" 'gr show-ref --verify -q refs/heads/fix/typo'
  t "origin/fix/typo da README.md to'g'rilangan (Welcome)" 'remote_fixed'
  t "origin/main o'zgarmagan" 'remote_main_untouched'
  t "fix/typo main dan aynan 1 commit oldinda" '[ "$(gr rev-list --count main..fix/typo)" = 1 ]'
  t "lokal fix/typo origin/fix/typo ni kuzatadi (upstream)" '[ "$(gw rev-parse --abbrev-ref "fix/typo@{upstream}")" = "origin/fix/typo" ]'
  t "lokal fix/typo = origin/fix/typo" 'local_remote_same'
}

check_14() {
  t "feature ichida main ning oxirgi commiti bor" 'ok_repo && g merge-base --is-ancestor main feature'
  t "main o'zgarmagan (3 ta commit, feature.txt yo'q)" 'ok_repo && [ "$(count main)" = 3 ] && ! g cat-file -e main:feature.txt'
  t "feature ning o'z commiti aynan 1 ta (Add feature.txt)" 'ok_repo && [ "$(count main..feature)" = 1 ] && [ "$(g log -1 --format=%s feature)" = "Add feature.txt" ]'
  t "tarix chiziqli (merge commit yo'q)" 'ok_repo && [ -z "$(g rev-list --merges feature)" ]'
  t "feature da feature.txt, m1.txt va m2.txt bor" 'ok_repo && g cat-file -e feature:feature.txt && g cat-file -e feature:m1.txt && g cat-file -e feature:m2.txt'
  t "rebase yakunlangan, ishchi papka toza" 'clean && no_rebase_in_progress'
}

check_15() {
  t "siz main branchdasiz" 'branch_is main'
  t "main da \"Fix price calculation\" commiti bor" 'ok_repo && g log main --format=%s | grep -qx "Fix price calculation"'
  t "price.js hotfix dagi bilan bir xil" 'ok_repo && g diff --quiet main hotfix -- price.js'
  t "main da boshqa ikki commit (typo, docs) yo'q" 'ok_repo && ! g log main --format=%s | grep -qE "^(Fix typo in header|Update docs)$" && ! g cat-file -e main:docs.md'
  t "main da faqat 1 ta yangi commit (jami 2 ta, merge emas)" 'ok_repo && [ "$(count main)" = 2 ] && [ -z "$(g rev-list --merges main)" ]'
  t "hotfix branchi o'zgarmagan (4 ta commit)" 'ok_repo && [ "$(count hotfix)" = 4 ]'
  t "ishchi papka toza" 'clean'
}

# ---------------------------------------------------------------- buyruqlar
usage() {
  cat <<'TXT'
Foydalanish:
  ./lab.sh list         mashqlar ro'yxati
  ./lab.sh start <n>    n-mashq uchun yangi sandbox tayyorlaydi
  ./lab.sh check <n>    n-mashq natijasini tekshiradi
Sandbox joyi: $GIT_LAB_DIR (standart: ~/git-lab)
TXT
}

cmd_list() {
  local i
  echo "Git amaliy mashqlari:"
  i=1
  while [ "$i" -le "$COUNT" ]; do
    printf '%3d. %s\n' "$i" "$(title "$i")"
    i=$((i + 1))
  done
}

cmd_start() {
  valid_n "$1" || { echo "Xato: mashq raqami 1 dan $COUNT gacha bo'lishi kerak."; exit 2; }
  command -v git >/dev/null 2>&1 || { echo "Xato: git o'rnatilmagan."; exit 2; }
  SB="$ROOT/$1-$(slug "$1")"
  if ! safe_sandbox "$SB"; then
    echo "Xato: sandbox yo'li xavfsiz emas: '$SB'"
    echo "GIT_LAB_DIR to'liq (absolyut) yo'l bo'lishi va uy papkangiz yoki / bo'lmasligi kerak."
    exit 2
  fi
  rm -rf "$SB"
  mkdir -p "$SB" || exit 1
  ( "setup_$1" ) || { echo "Xato: sandbox tayyorlashda muammo."; exit 1; }
  echo "=== Mashq $1: $(title "$1") ==="
  echo
  "goal_$1"
  echo
  echo "Boshlash uchun:"
  echo "  cd \"$(start_dir "$1")\""
  echo "Tugatgach tekshiring:  ./lab.sh check $1"
  echo "(Agar terminal avval shu papkada bo'lsa, papka qayta yaratildi: yana cd qiling.)"
}

cmd_check() {
  valid_n "$1" || { echo "Xato: mashq raqami 1 dan $COUNT gacha bo'lishi kerak."; exit 2; }
  SB="$ROOT/$1-$(slug "$1")"
  D="$SB"
  if [ ! -d "$D" ]; then
    echo "Sandbox topilmadi. Avval ishga tushiring: ./lab.sh start $1"
    exit 2
  fi
  cd "$D" || exit 2
  echo "=== Mashq $1 tekshiruvi: $(title "$1") ==="
  "check_$1"
  echo
  echo "Natija: $PASS/$TOTAL shart bajarildi"
  if [ "$PASS" -eq "$TOTAL" ]; then
    echo "Barakalla! Mashq bajarildi."
    exit 0
  fi
  echo "Hali hamma shart bajarilmadi. Maslahat: git status va git log --oneline --graph --all dan foydalaning."
  exit 1
}

case "$1" in
  list) cmd_list ;;
  start) cmd_start "$2" ;;
  check) cmd_check "$2" ;;
  *) usage; [ -z "$1" ] || exit 2 ;;
esac
