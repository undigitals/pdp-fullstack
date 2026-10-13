# Bash — skript yozish masalalari

`scripts/` papkasidagi har bir faylda `# Shu yerga yozing` degan joyga kodingizni yozing, so'ng tekshiring:

```bash
bash tests.sh        # hammasini tekshiradi
bash tests.sh 5      # faqat 5-masalani tekshiradi
```

Qiyinlik: ⭐ oson · ⭐⭐ o'rta · ⭐⭐⭐ qiyinroq

Masalalar osondan o'rtaga qarab tartiblangan. Har bir masalada qaysi tuzilmadan foydalanish yozilgan — aynan shuni ishlating. Skriptni qo'lda ham sinab ko'rishingiz mumkin: `bash scripts/01-greet.sh Ali`.

## Muhim qoidalar

- Skriptlar **macOS** (bash 3.2) va **Linux** da bir xil ishlashi kerak. Shuning uchun faqat ko'chma (portable) vositalardan foydalaning: `awk`, `grep`, `sort`, `uniq`, `tr`, `wc`, `cut`, `head`, `tail`, `find`, `cp`.
- Quyidagilarni **ishlatmang**: `sed -i`, `date -d`, `readlink -f`, `declare -A` (assotsiativ massiv), `mapfile`/`readarray`, `${x^^}`, `${x,,}`, `[[ -v x ]]`.
- Natija **aynan** kutilgandek bo'lishi kerak: ortiqcha bo'sh joy, ortiqcha qator yoki qo'shimcha matn chiqarmang (xato xabarlari bundan mustasno — ular `stderr` ga yoziladi).
- Skript stdin dan hech narsa kutmasligi kerak (aytilgan joydan tashqari). 3 soniyada tugamagan skript "yiqildi" hisoblanadi.
- O'zgaruvchilarni har doim qo'shtirnoqda yozing: `"$1"`, `"$@"` — fayl nomida bo'shliq bo'lishi mumkin.

---

## 1. Salomlashish ⭐ (`$1`, `echo`)

`scripts/01-greet.sh` — birinchi argument sifatida berilgan ismga salom bering.

```bash
bash scripts/01-greet.sh Ali    # Salom, Ali!
bash scripts/01-greet.sh Vali   # Salom, Vali!
```

<details><summary>Maslahat</summary>

Birinchi argument `$1` o'zgaruvchisida turadi. `echo "Salom, $1!"` kabi yozing.

</details>

---

## 2. O'zgaruvchilar va arifmetika ⭐ (`$(( ))`)

`scripts/02-arifmetika.sh` — ikki butun son oling va uchta qatorda yig'indi, ayirma, ko'paytmani chiqaring.

```bash
bash scripts/02-arifmetika.sh 7 3
# Yig'indi: 10
# Ayirma: 4
# Ko'paytma: 21
```

Manfiy sonlar ham bo'lishi mumkin (`-4 6`).

<details><summary>Maslahat</summary>

Argumentlarni o'zgaruvchiga oling: `a=$1`. Hisoblash uchun `$(( a + b ))` ishlating; ichida `$` shart emas. `*` ni `$(( ))` ichida qo'shtirnoqsiz yozish xavfsiz.

</details>

---

## 3. Juft yoki toq ⭐ (`if / else`)

`scripts/03-juft-toq.sh` — son juft bo'lsa `juft`, toq bo'lsa `toq` deb chiqaring.

```bash
bash scripts/03-juft-toq.sh 4    # juft
bash scripts/03-juft-toq.sh 7    # toq
bash scripts/03-juft-toq.sh -3   # toq
```

<details><summary>Maslahat</summary>

`if [ $(( n % 2 )) -eq 0 ]; then ... else ... fi`. Diqqat: bashda `-3 % 2` natijasi `-1` bo'ladi — shuning uchun "1 ga tengmi?" emas, "0 ga tengmi?" deb tekshirish qulayroq. `[ ]` ichida bo'shliqlarni unutmang.

</details>

---

## 4. Argumentni tekshirish ⭐ (`$#`, chiqish kodi)

`scripts/04-argument.sh`:

- Argument berilmasa: `stderr` ga yordam xabarini yozing (masalan `Foydalanish: ...`), `stdout` ga **hech narsa** chiqarmang va `exit 1` bilan chiqing.
- Argument berilsa: birinchi argumentni chiqaring va `0` kod bilan tugating.

```bash
bash scripts/04-argument.sh          # stderr: Foydalanish: ...   (kod 1)
bash scripts/04-argument.sh salom    # salom                      (kod 0)
```

<details><summary>Maslahat</summary>

`$#` — argumentlar soni. `if [ "$#" -lt 1 ]; then echo "..." >&2; exit 1; fi`. `>&2` xabarni stderr ga yuboradi. Oxirgi buyruqning kodini `echo $?` bilan ko'rish mumkin.

</details>

---

## 5. 1 dan N gacha ⭐ (`for`)

`scripts/05-sanash.sh` — 1 dan N gacha sonlarni har birini alohida qatorda chiqaring. `N` 0 bo'lsa hech narsa chiqarmang.

```bash
bash scripts/05-sanash.sh 3
# 1
# 2
# 3
```

<details><summary>Maslahat</summary>

`for ((i = 1; i <= $1; i++)); do echo "$i"; done` — bu bash 3.2 da ham ishlaydi.

</details>

---

## 6. Argumentlar bo'ylab tsikl ⭐ (`for ... in "$@"`)

`scripts/06-argumentlar.sh` — har bir argumentni tartib raqami bilan chiqaring. Argumentlar ichida bo'shliq bo'lishi mumkin.

```bash
bash scripts/06-argumentlar.sh a b "c d"
# 1: a
# 2: b
# 3: c d
```

<details><summary>Maslahat</summary>

`for x in "$@"` har bir argumentni alohida beradi (qo'shtirnoq bilan!). Hisoblagichni o'zingiz yuriting: `i=$((i + 1))`.

</details>

---

## 7. Teskari sanash ⭐ (`while`)

`scripts/07-teskari-sanash.sh` — `N` dan `1` gacha sanang, oxirida `Start!` deb yozing. `N` 0 bo'lsa faqat `Start!` chiqadi.

```bash
bash scripts/07-teskari-sanash.sh 3
# 3
# 2
# 1
# Start!
```

<details><summary>Maslahat</summary>

`while [ "$n" -ge 1 ]; do ... n=$((n - 1)); done`. Hisoblagichni kamaytirishni unutsangiz tsikl to'xtamaydi — test 3 soniyadan so'ng uni to'xtatadi.

</details>

---

## 8. Faktorial ⭐⭐ (funksiya)

`scripts/08-faktorial.sh` — `factorial` nomli **funksiya** yozing va `n!` ni chiqaring. `0! = 1`.

```bash
bash scripts/08-faktorial.sh 5    # 120
bash scripts/08-faktorial.sh 0    # 1
bash scripts/08-faktorial.sh 10   # 3628800
```

<details><summary>Maslahat</summary>

Funksiya argumentlari ham `$1` bo'ladi. Natijani `echo` bilan chiqaring, funksiyani skript oxirida `factorial "$1"` deb chaqiring. Funksiya ichidagi o'zgaruvchilarni `local` qiling.

</details>

---

## 9. Buyruqlar menyusi ⭐⭐ (`case`)

`scripts/09-buyruq.sh` — birinchi argumentga qarab javob bering:

| Argument | Chiqish |
|---|---|
| `start` | `Xizmat ishga tushdi` |
| `stop` | `Xizmat to'xtadi` |
| `status` | `Xizmat ishlayapti` |
| boshqa har qanday | `Noma'lum buyruq: <argument>` |

```bash
bash scripts/09-buyruq.sh start     # Xizmat ishga tushdi
bash scripts/09-buyruq.sh restart   # Noma'lum buyruq: restart
```

<details><summary>Maslahat</summary>

```bash
case "$1" in
  start) echo "..." ;;
  *) echo "..." ;;
esac
```

Har bir tarmoq `)` bilan boshlanib, `;;` bilan tugaydi. `*` — "qolgan hamma holat".

</details>

---

## 10. Fayl turini aniqlash ⭐⭐ (`-f`, `-d`, `-e`)

`scripts/10-fayl-turi.sh` — har bir argument (yo'l) uchun bitta qator chiqaring: oddiy fayl bo'lsa `<yo'l>: fayl`, papka bo'lsa `<yo'l>: papka`, bo'lmasa `<yo'l>: yo'q`.

```bash
bash scripts/10-fayl-turi.sh a.txt papka nope
# a.txt: fayl
# papka: papka
# nope: yo'q
```

<details><summary>Maslahat</summary>

`[ -f "$p" ]` — oddiy fayl, `[ -d "$p" ]` — papka, `[ -e "$p" ]` — mavjud. `if / elif / else` zanjiri yozing. Nomida bo'shliq bo'lgan fayllar uchun `"$p"` ni qo'shtirnoqda yozing.

</details>

---

## 11. Faylni qator-qator o'qish ⭐⭐ (`while read -r`)

`scripts/11-qator-raqam.sh` — argument sifatida berilgan faylni o'qing va har bir qatorni raqami bilan chiqaring: `1: birinchi qator`. Qatordagi boshidagi bo'shliqlar va `\` belgisi o'zgarmay chiqishi kerak.

```bash
# fayl.txt ichida:  salom
#                     dunyo      (boshida 2 ta bo'shliq)
bash scripts/11-qator-raqam.sh fayl.txt
# 1: salom
# 2:   dunyo
```

<details><summary>Maslahat</summary>

```bash
while IFS= read -r line; do
  ...
done < "$1"
```

`IFS=` boshidagi bo'shliqlarni saqlaydi, `-r` esa `\` ni o'zgartirmaydi. Faylni tsiklga `< "$1"` bilan ulang.

</details>

---

## 12. .txt fayllarni sanash ⭐⭐ (`find` yoki glob)

`scripts/12-txt-soni.sh` — argument sifatida berilgan papkadagi `.txt` bilan tugaydigan **fayllar** sonini chiqaring. Ichki papkalar ichiga kirmang; nomi `.txt` bilan tugaydigan *papka* sanalmaydi. Natija faqat son bo'lsin.

```bash
bash scripts/12-txt-soni.sh papka   # 3
```

<details><summary>Maslahat</summary>

`find "$1" -maxdepth 1 -type f -name '*.txt' | wc -l`. macOS da `wc -l` son oldiga bo'shliq qo'yadi — test bu bo'shliqlarni e'tiborsiz qoldiradi, lekin chiroyli natija uchun `| tr -d ' '` yoki `awk '{print $1}'` qo'shishingiz mumkin.

</details>

---

## 13. Eng ko'p uchragan so'zlar ⭐⭐⭐ (quvur: `tr`, `sort`, `uniq`, `head`)

`scripts/13-top-sozlar.sh` — matndagi eng ko'p uchragan **3 ta** so'zni `N so'z` ko'rinishida chiqaring.

Qoidalar:

- Matn argument sifatida berilgan fayldan o'qiladi; fayl berilmasa — **stdin** dan.
- So'z — ketma-ket kelgan lotin harflari (`a-z`). Katta harflar kichigiga aylantiriladi (`The` = `the`). Boshqa hamma belgi (raqam, tinish belgisi, apostrof) so'zlarni ajratadi: `it's` → `it` va `s`.
- Tartib: avval soni kamayish bo'yicha, **soni teng bo'lsa alifbo tartibida**.
- 3 tadan kam so'z bo'lsa, borini chiqaring.
- Format: `soni so'z` (bitta bo'shliq bilan). Test ortiqcha bo'shliqlarni normallashtiradi, ya'ni `uniq -c` ning bo'shliqlari muammo emas.

```bash
bash scripts/13-top-sozlar.sh matn.txt
# 4 the
# 3 cat
# 3 dog

echo "b a c b a c d" | bash scripts/13-top-sozlar.sh
# 2 a
# 2 b
# 2 c
```

<details><summary>Maslahat</summary>

Quvur taxminan shunday: kichik harfga o'tkazish (`tr 'A-Z' 'a-z'`) → harf bo'lmagan hamma narsani yangi qatorga almashtirish (`tr -cs 'a-z' '\n'`) → bo'sh qatorlarni olib tashlash (`awk 'NF'`) → `sort` → `uniq -c` → tartiblash (`sort -k1,1nr -k2,2`) → `head -3`.

Fayl yoki stdin ni birdek o'qish uchun `cat "$@"` ishlating: argument bo'lmasa `cat` stdin dan o'qiydi.

</details>

---

## 14. CSV dan jami summa ⭐⭐⭐ (`awk`)

`scripts/14-jami-narx.sh` — CSV faylda birinchi qator sarlavha, qolganlari `name,price,qty` ko'rinishida. Hamma qatorlar uchun `price * qty` yig'indisini 2 xona aniqlikda chiqaring. Faqat sarlavha bo'lsa `0.00`.

```bash
# savat.csv:
# name,price,qty
# olma,1.50,4
# non,0.80,10
# sut,12.25,2
bash scripts/14-jami-narx.sh savat.csv   # 38.50
```

<details><summary>Maslahat</summary>

`awk -F, 'NR > 1 { s += $2 * $3 } END { printf "%.2f\n", s }' "$1"`. `-F,` — ajratuvchi vergul, `NR` — qator raqami, `END` — hamma qator o'qilgach bajariladi. Hech qator qo'shilmagan bo'lsa ham `printf "%.2f"` `0.00` beradi.

</details>

---

## 15. Zaxira nusxa skripti ⭐⭐⭐ (`cp`, chiqish kodi)

`scripts/15-zaxira.sh` — har bir argument fayli uchun shu papkaning o'zida `<nom>.bak` nusxasini yarating (`sub/b.txt` → `sub/b.txt.bak`).

- Fayl topilmasa: `stderr` ga xabar yozing, qolganlarini davom ettiring.
- Hamma fayl nusxalansa kod `0`, kamida bittasi topilmagan bo'lsa kod `1` bilan tugating.
- Asl fayllarni o'chirmang yoki o'zgartirmang. Hamma fayl bor bo'lsa `stderr` bo'sh bo'lsin.

```bash
bash scripts/15-zaxira.sh a.txt yoq.txt sub/b.txt
# stderr: Topilmadi: yoq.txt
# a.txt.bak va sub/b.txt.bak yaratildi; chiqish kodi 1
```

<details><summary>Maslahat</summary>

`bad=0` deb boshlang; fayl topilmasa `bad=1` qiling. Oxirida `exit "$bad"`. Nusxalash: `cp "$f" "$f.bak"`. Nomlarda bo'shliq bo'lishi mumkin — qo'shtirnoqni unutmang.

</details>

---

## 16. Log tahlilchisi ⭐⭐⭐ (`grep` / `awk`, `&&`, `||`)

`scripts/16-log-tahlil.sh` — log faylda qatorlar `2024-01-05 ERROR disk full` ko'rinishida: sana, daraja, xabar. Darajalar sonini aynan shu tartibda chiqaring: `INFO`, `WARN`, `ERROR`. Soni 0 bo'lsa ham qator chiqadi.

- Daraja deb faqat **ikkinchi so'z** hisoblanadi. Xabar ichida `ERROR` so'zi uchrasa (masalan `2024-01-06 INFO retry after ERROR`) u sanalmaydi.
- Fayl berilmasa yoki mavjud bo'lmasa: `stderr` ga xabar yozing, `stdout` ga hech narsa chiqarmang, kod `1`.

```bash
bash scripts/16-log-tahlil.sh app.log
# INFO: 3
# WARN: 1
# ERROR: 2
```

<details><summary>Maslahat</summary>

Faylni tekshirish: `[ -f "$1" ] || { echo "..." >&2; exit 1; }` — `||` chap tomon yolg'on bo'lsa o'ng tomonni bajaradi. Sanash: `awk -v lvl="$level" '$2 == lvl { c++ } END { print c + 0 }' "$1"` (`c + 0` bo'sh o'rniga `0` beradi). Uchala darajani `for level in INFO WARN ERROR; do ... done` bilan aylanib chiqing. `grep -c` ham mumkin, lekin xabar ichidagi so'zlarga e'tibor bering.

</details>

---

## Mashq qilingan buyruqlar va sintaksis

| Mavzu | Sintaksis / buyruq | Masala |
|---|---|---|
| Argumentlar | `$1`, `$2`, `$#`, `"$@"` | 1, 2, 4, 6 |
| Chiqarish | `echo`, `>&2` (stderr) | 1, 4 |
| Arifmetika | `$(( a + b ))`, `%` | 2, 3, 7, 8 |
| Shart | `if / elif / else / fi`, `[ ... ]` | 3, 10 |
| Chiqish kodi | `exit 1`, `$?` | 4, 15, 16 |
| Tsikllar | `for`, `for ((...))`, `while` | 5, 6, 7 |
| Funksiya | `name() { ...; }`, `local` | 8 |
| Tanlash | `case ... esac` | 9 |
| Fayl testlari | `-f`, `-d`, `-e` | 10, 15, 16 |
| Fayl o'qish | `while IFS= read -r line; do ...; done < "$f"` | 11 |
| Qidirish va sanash | `find -maxdepth 1 -type f -name`, `wc -l` | 12 |
| Quvur (pipe) | `tr`, `sort`, `uniq -c`, `head`, `cat` | 13 |
| Matn bilan ishlash | `awk -F,`, `NR`, `END`, `printf "%.2f"` | 13, 14, 16 |
| Nusxalash | `cp "$f" "$f.bak"` | 15 |
| Mantiqiy bog'lash | `&&`, `\|\|`, `{ ...; }` | 16 |

## Maslahat: skriptni tekshirish

Skriptni ishga tushirmasdan sintaksis xatolarini topish uchun:

```bash
bash -n scripts/01-greet.sh      # faqat sintaksisni tekshiradi, bajarmaydi
shellcheck scripts/01-greet.sh   # (agar o'rnatilgan bo'lsa) xatolar va ehtiyotsiz joylarni ko'rsatadi
```

`shellcheck` ni macOS da `brew install shellcheck`, Ubuntu da `sudo apt install shellcheck` bilan o'rnatish mumkin. Skriptni `set -x` bilan ishga tushirsangiz (`bash -x scripts/01-greet.sh Ali`), har bir bajarilgan buyruq ko'rinadi — xatoni topishda juda foydali.
