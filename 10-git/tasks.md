# Git — amaliy mashqlar

Bu mashqlar kompyuteringizda, haqiqiy git bilan bajariladi. Har bir mashq uchun `lab.sh` skripti tayyor "sandbox" (mashq papkasi) yaratadi, siz git buyruqlari bilan vazifani bajarasiz, keyin skript natijani avtomatik tekshiradi. Internet kerak emas: "masofaviy" repozitoriylar ham kompyuteringizdagi oddiy papka.

## Qanday ishlatiladi

```bash
./lab.sh list        # barcha mashqlar ro'yxati
./lab.sh start 1     # 1-mashq uchun yangi sandbox tayyorlaydi va vazifani chiqaradi
./lab.sh check 1     # natijani tekshiradi
```

1. `./lab.sh start N` — sandbox yaratadi va vazifani (maqsadni) hamda `cd` qilinadigan papkani chiqaradi. Sandbox `~/git-lab/N-nom` papkasida bo'ladi.
2. Aytilgan papkaga `cd` qiling va git buyruqlari bilan vazifani bajaring.
3. `./lab.sh check N` ni ishga tushiring (`lab.sh` turgan papkadan). Har bir shart uchun `✓` yoki `✗` chiqadi, oxirida `Natija: X/Y shart bajarildi`.
4. Hammasi `✓` bo'lmaguncha tuzating va qayta tekshiring. Adashib ketsangiz, `./lab.sh start N` mashqni noldan boshlaydi (eski sandbox o'chib, yangisi yaratiladi).

Sandbox joyini o'zgartirish mumkin: `GIT_LAB_DIR=/boshqa/papka ./lab.sh start 1`.

Qiyinlik: ⭐ oson · ⭐⭐ o'rta

Mashqlar osondan o'rtaga qarab tartiblangan. Har bir sarlavhada qaysi buyruqlarni mashq qilayotganingiz yozilgan.

## Tayyorlanish

Git o'rnatilganini tekshiring:

```bash
git --version
```

Git sizning ismingiz va emailingizni bilishi kerak (bir marta sozlanadi):

```bash
git config --global user.name "Ismingiz"
git config --global user.email "siz@example.com"
```

Sandbox ichidagi repozitoriylarda ism `Talaba` deb o'zi sozlanadi, shuning uchun mashqlarga bu halaqit bermaydi.

Muhim qoida: git ba'zan matn muharririni (vim/nano) ochib yuboradi va chiqib ketolmay qolasiz. Buning oldini oling:

- commitda doim `-m "xabar"` yozing;
- merge/revert/cherry-pick paytida `--no-edit` ishlating (xabarni o'zgartirmasdan davom etadi).

Agar tasodifan vim ochilib qolsa: `Esc`, so'ng `:q!` va `Enter`.

---

## 1. Birinchi repozitoriy ⭐ (`git init`, `git add`, `git commit`)

**Maqsad:** bo'sh papkada git repozitoriy yarating (asosiy branch `main`), `README.md` faylini yarating va birinchi commitni qiling. Oxirida ishchi papka toza bo'lsin.

**Nima qilish kerak:**

```bash
./lab.sh start 1
cd ~/git-lab/1-init-commit
# ... git buyruqlaringiz ...
```

So'ng `lab.sh` turgan papkaga qaytib `./lab.sh check 1` ni ishga tushiring.

<details><summary>Maslahat</summary>

`git init -b main` repozitoriy yaratadi. Eski git `-b` ni tanimasa, `git init` dan keyin `git branch -M main` ishlating. Holatni `git status` bilan kuzating.
</details>

---

## 2. Tanlab staging ⭐ (`git status`, `git add <fayl>`, `git commit`)

**Maqsad:** `a.txt` o'zgartirilgan, `b.txt` yangi, `c.txt` esa hali tayyor emas. `a.txt` va `b.txt` ni **bitta** commitga joylang. `c.txt` commit qilinmay, o'z holicha qolsin.

**Nima qilish kerak:** `./lab.sh start 2`, papkaga `cd` qiling, so'ng bajaring va `./lab.sh check 2`.

<details><summary>Maslahat</summary>

`git add .` hamma narsani qo'shadi, bu yerda esa kerak emas. Fayllarni nomi bilan qo'shing, so'ng commitdan oldin `git status` bilan nima staging da ekanini ko'ring.
</details>

---

## 3. .gitignore ⭐ (`.gitignore`, `git check-ignore`)

**Maqsad:** papkada `app.js`, `node_modules/` va `.env` bor. `node_modules/` va `.env` git e'tiboridan chetda qolsin, faqat `app.js` va `.gitignore` commit qilinsin. `.env` va `node_modules/` papkadan o'chib ketmasligi kerak.

**Nima qilish kerak:** `./lab.sh start 3`, bajaring, `./lab.sh check 3`.

<details><summary>Maslahat</summary>

`.gitignore` oddiy matn fayl: har bir qatorda bitta nom yoki andoza. Fayl ignore qilinganini `git check-ignore -v .env` ko'rsatadi. Avval `git status` ni ko'ring: ignore qilingan fayllar ro'yxatdan yo'qoladi.
</details>

---

## 4. Tarixni o'qish ⭐ (`git log`, `--diff-filter`, `--oneline`)

**Maqsad:** repozitoriyda 6 ta commit bor. Qaysi commit `config.json` faylini **o'chirgan**? O'sha commitning qisqa hashini (7 belgi) `javob.txt` fayliga yozing. Tarixni o'zgartirmang, faqat o'qing.

**Nima qilish kerak:** `./lab.sh start 4`, `cd`, javobni `javob.txt` ga yozing (masalan `echo` bilan), `./lab.sh check 4`.

<details><summary>Maslahat</summary>

`git log --oneline` qisqa hashlarni ko'rsatadi. Aynan bitta faylga tegishli commitlarni `git log -- config.json`, faqat o'chirish turidagilarini `--diff-filter=D` bilan ajratib oling. Xohlasangiz `git show <hash> --stat` bilan tekshirib ko'ring.
</details>

---

## 5. Branch va merge ⭐ (`git switch -c`, `git merge`, `git branch -d`)

**Maqsad:** `feature/login` branchini yarating, unda `login.js` faylini yaratib commit qiling. Keyin `main` ga qaytib, `feature/login` ni merge qiling va branchni o'chiring. Oxirida `main` da bo'lasiz va `login.js` shu yerda turadi.

**Nima qilish kerak:** `./lab.sh start 5`, `cd`, bajaring, `./lab.sh check 5`.

<details><summary>Maslahat</summary>

`git switch -c nom` branch yaratadi va unga o'tadi (eski usul: `git checkout -b nom`). Merge doim **qabul qiluvchi** branchda turib bajariladi. Merge qilingan branchni `git branch -d` bilan o'chirasiz.
</details>

---

## 6. O'zgarishlarni bekor qilish ⭐ (`git restore`, `git restore --staged`)

**Maqsad:** `notes.txt` (kuzatiladigan fayl) tasodifan buzilgan: uni oxirgi commitdagi holatiga qaytaring. `todo.txt` dagi o'zgarish staging ga qo'shilgan: uni staging dan chiqaring, lekin fayl ichidagi yangi qator saqlanib qolsin. Yangi commit yaratmang.

**Nima qilish kerak:** `./lab.sh start 6`, `cd`, `git status` ni o'qing (u o'zi ham maslahat beradi), bajaring, `./lab.sh check 6`.

<details><summary>Maslahat</summary>

`git restore <fayl>` — ishchi papkadagi o'zgarishni **qaytarib bo'lmas** tarzda tashlaydi. `git restore --staged <fayl>` — faqat staging dan chiqaradi, faylning o'ziga tegmaydi. Bu ikki xil vazifa: qaysi biri qaysi faylga kerakligini o'zingiz hal qiling.
</details>

---

## 7. Oxirgi commitni tuzatish ⭐⭐ (`git commit --amend`)

**Maqsad:** oxirgi commit xabarida xato bor (`Add feture`) va `style.css` ni qo'shishni unutgansiz. Xabarni `Add feature` ga to'g'rilang va `style.css` ni **shu commitning o'ziga** qo'shing. Commitlar soni o'zgarmasin.

**Nima qilish kerak:** `./lab.sh start 7`, `cd`, bajaring, `./lab.sh check 7`.

<details><summary>Maslahat</summary>

Avval `style.css` ni staging ga qo'shing, so'ng `git commit --amend -m "..."`. `--amend` yangi commit qo'shmaydi, oxirgisini almashtiradi. Faqat hali push qilinmagan commitlarda ishlating.
</details>

---

## 8. Commitni revert qilish ⭐⭐ (`git revert`, `git log`)

**Maqsad:** tarixning o'rtasida `Break the build` nomli yomon commit bor. Uni tarixni o'chirmasdan bekor qiling: yangi "revert" commit yarating. Yomon commit tarixda qolishi, undan keyingi `Add footer` commiti esa yo'qolmasligi kerak.

**Nima qilish kerak:** `./lab.sh start 8`, `cd`, yomon commit hashini toping, bajaring, `./lab.sh check 8`.

<details><summary>Maslahat</summary>

`git log --oneline` dan kerakli hashni oling va `git revert <hash> --no-edit` ishlating. `git reset` tarixni **o'chiradi**, `git revert` esa bekor qiluvchi yangi commit qo'shadi. Jamoada ishlaganda aynan revert xavfsiz.
</details>

---

## 9. Commitlarni birlashtirish ⭐⭐ (`git reset --soft`, `git commit`)

**Maqsad:** oxirgi ikkita commit ikkalasi ham `wip` deb nomlangan. Ularni bitta `Add search feature` commitiga birlashtiring. `search.js` mazmuni to'liq saqlansin, jami commitlar soni 1 taga kamaysin.

**Nima qilish kerak:** `./lab.sh start 9`, `cd`, bajaring, `./lab.sh check 9`.

<details><summary>Maslahat</summary>

`git reset --soft HEAD~N` oxirgi N ta commitni "olib tashlaydi", lekin o'zgarishlarni staging da qoldiradi. Keyin ularni bitta yangi commit qilasiz. `HEAD~2` — "ikki commit orqaga".
</details>

---

## 10. Merge conflictni hal qilish ⭐⭐ (`git merge`, conflict markerlar)

**Maqsad:** `main` va `feature` branchlar `greeting.txt` ning bir xil qatorini turlicha o'zgartirgan. `feature` ni `main` ga merge qiling va conflictni shunday hal qilingki, salomlashuv qatori aynan `Assalomu alaykum, Dunyo!` bo'lsin. Fayldagi `<<<<<<<`, `=======`, `>>>>>>>` belgilari qolmasin, boshqa qatorlar o'zgarmasin. Natija — ikki ota-onali merge commit.

**Nima qilish kerak:** `./lab.sh start 10`, `cd`, merge qiling, faylni tahrirlang, merge ni yakunlang, `./lab.sh check 10`.

<details><summary>Maslahat</summary>

Merge to'xtaganda `git status` conflictli fayllarni ko'rsatadi. Faylni tahrirlab markerlarni olib tashlang, so'ng `git add <fayl>` bilan "hal qilindi" deb belgilang va `git commit --no-edit` bilan merge ni yakunlang. Agar adashsangiz, `git merge --abort` hamma narsani merge boshlanishidagi holatga qaytaradi.
</details>

---

## 11. Stash ⭐⭐ (`git stash`, `git stash pop`, `git stash list`)

**Maqsad:** `app.js` da tugallanmagan, commit qilinmagan ishingiz bor. Shoshilinch xato: `bug.txt` dagi `broken` ni `fixed` ga o'zgartirib `main` ga commit qilish kerak. Ishni yo'qotmasdan: stash qiling, tuzatishni commit qiling, stash ni qaytaring. Oxirida `app.js` dagi o'zgarish yana commit qilinmagan holda turadi va stash ro'yxati bo'sh bo'ladi.

**Nima qilish kerak:** `./lab.sh start 11`, `cd`, bajaring, `./lab.sh check 11`.

<details><summary>Maslahat</summary>

`git stash` o'zgarishlarni vaqtincha yashiradi va papkani toza qiladi. `git stash list` yashirilganlarni ko'rsatadi. `git stash pop` oxirgisini qaytaradi **va** ro'yxatdan o'chiradi (`apply` esa o'chirmaydi).
</details>

---

## 12. Hamkasb bilan push/pull ⭐⭐ (`git pull`, `git push`, `git log origin/main`)

**Maqsad:** `work/` papkasi — sizning klon. `remote.git` — umumiy ("origin") repozitoriy. Hamkasbingiz (`teammate/` papkasi) yangi commit push qilib bo'lgan, sizda esa u yo'q. Uni oling (pull), o'zingizning commitingizni (istalgan yangi fayl) qo'shing va push qiling. Oxirida `origin/main` da ikkala commit ham bo'lsin va sizning `main` = `origin/main`.

**Nima qilish kerak:** `./lab.sh start 12`, chiqqan `.../work` papkasiga `cd` qiling, bajaring, `./lab.sh check 12`.

<details><summary>Maslahat</summary>

Bu yerda `git push` darrov ishlamaydi: origin sizdan oldinda. Avval `git pull` (hamkasbning ishi keladi), keyin commit, keyin `git push`. `git fetch` va `git log --oneline origin/main` bilan nima kelganini oldindan ko'rishingiz mumkin.
</details>

---

## 13. Feature branchni push qilish ⭐⭐ (`git switch -c`, `git push -u`)

**Maqsad:** `work/` ichidagi `README.md` da imlo xatosi bor (`Wellcome`). `fix/typo` branchini yarating, xatoni to'g'rilang, commit qiling va branchni `origin` ga **upstream** (kuzatuv) bilan push qiling. `origin` dagi `main` o'zgarmasligi kerak.

**Nima qilish kerak:** `./lab.sh start 13`, `.../work` papkasiga `cd`, bajaring, `./lab.sh check 13`.

<details><summary>Maslahat</summary>

Yangi branchni birinchi marta push qilishda `git push -u origin <branch>` ishlatiladi: `-u` lokal branchni masofaviy branch bilan bog'laydi, keyin oddiy `git push` / `git pull` yetadi. `git branch -vv` bog'lanishni ko'rsatadi.
</details>

---

## 14. Rebase ⭐⭐ (`git rebase`, `git log --graph`)

**Maqsad:** `feature` branch `main` dan 2 ta commit orqada. `feature` ni `main` ustiga rebase qiling: tarix chiziqli (merge commitsiz) bo'lsin, `feature` ichida `main` ning oxirgi commiti ham, `feature` ning o'z commiti ham bo'lsin. `main` o'zgarmasin.

**Nima qilish kerak:** `./lab.sh start 14`, `cd`, avval `git log --oneline --graph --all` bilan holatni ko'ring, bajaring, yana ko'ring va `./lab.sh check 14`.

<details><summary>Maslahat</summary>

Rebase **siz turgan** branchning commitlarini boshqa branch uchi ustiga "ko'chiradi". Ya'ni qaysi branchda turganingiz muhim: `git rebase <asos-branch>`. Rebase qilingan commitlar yangi hash oladi, shuning uchun uni faqat push qilinmagan commitlarda ishlating.
</details>

---

## 15. Cherry-pick ⭐⭐ (`git cherry-pick`, `git log <branch>`)

**Maqsad:** `hotfix` branchda 3 ta commit bor. Faqat `Fix price calculation` commitini `main` ga olib keling. Qolgan ikkitasi (`Fix typo in header`, `Update docs`) `main` da bo'lmasligi kerak. Merge qilmang.

**Nima qilish kerak:** `./lab.sh start 15`, `cd`, `main` da turganingizni tekshiring, hotfix commitlarini ko'ring, bajaring, `./lab.sh check 15`.

<details><summary>Maslahat</summary>

`git log hotfix --oneline` kerakli commit hashini ko'rsatadi. Qabul qiluvchi branchda (`main`) turib `git cherry-pick <hash>` ishlating: u faqat shu bitta commitni nusxalaydi (yangi hash bilan).
</details>

---

## Buyruqlar shpargalkasi

| Buyruq | Nima qiladi | Mashq |
|---|---|---|
| `git init -b main` | yangi repozitoriy yaratadi | 1 |
| `git status` | holatni ko'rsatadi (qaysi fayl o'zgargan/staged) | hammasi |
| `git add <fayl>` | faylni staging ga qo'shadi | 1, 2, 3 |
| `git commit -m "xabar"` | staging dagilarni commit qiladi | hammasi |
| `git check-ignore -v <fayl>` | fayl nega ignore qilinganini ko'rsatadi | 3 |
| `git log --oneline` | qisqa tarix | 4, 8, 15 |
| `git log --diff-filter=D -- <fayl>` | faylni o'chirgan commitlar | 4 |
| `git log --oneline --graph --all` | barcha branchlar tarixi, grafik ko'rinishda | 10, 14 |
| `git show <hash>` | bitta commit tafsiloti | 4 |
| `git switch -c <nom>` | yangi branch yaratib, unga o'tadi | 5, 13 |
| `git switch <nom>` | branchga o'tadi | 5 |
| `git merge <branch>` | branchni joriy branchga qo'shadi | 5, 10 |
| `git merge --abort` | merge ni bekor qiladi | 10 |
| `git branch -d <nom>` | merge qilingan branchni o'chiradi | 5 |
| `git restore <fayl>` | ishchi papkadagi o'zgarishni tashlaydi | 6 |
| `git restore --staged <fayl>` | faylni staging dan chiqaradi | 6 |
| `git commit --amend` | oxirgi commitni almashtiradi | 7 |
| `git revert <hash> --no-edit` | commitni bekor qiluvchi yangi commit qo'shadi | 8 |
| `git reset --soft HEAD~N` | N ta commitni olib tashlaydi, o'zgarishlar staging da qoladi | 9 |
| `git stash` / `git stash pop` | o'zgarishlarni yashiradi / qaytaradi | 11 |
| `git stash list` | yashirilganlar ro'yxati | 11 |
| `git pull` | masofaviy o'zgarishlarni olib, qo'shadi (fetch + merge) | 12 |
| `git push` | commitlarni masofaviy repozitoriyga yuboradi | 12 |
| `git push -u origin <branch>` | yangi branchni yuboradi va kuzatuvni sozlaydi | 13 |
| `git branch -vv` | branchlar va ularning upstream i | 13 |
| `git rebase <branch>` | joriy branch commitlarini boshqa branch ustiga ko'chiradi | 14 |
| `git cherry-pick <hash>` | bitta commitni joriy branchga nusxalaydi | 15 |
