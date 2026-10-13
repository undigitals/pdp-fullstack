# GitHub — repo, fork, PR, kod ko'rigi

Bu topshiriqlar **avtomatik tekshirilmaydi** — ular haqiqiy GitHub hisobi va repolarda bajariladi. Har birida *topshirish mezoni* bor: o'qituvchiga nimani ko'rsatish kerak. Tekshirish uchun ixtiyoriy `gh` buyruqlari ham berilgan.

> **Oldin:** `10-git` mashqlarining kamida 1–9 tasini bajaring. Git buyruqlarini bilmasdan GitHub'da qiynalasiz.

Qiyinlik: ⭐ oson · ⭐⭐ o'rta · ⭐⭐⭐ qiyinroq
Juftlik belgisi 👥 — ikki talaba birga ishlaydi (har biri o'z hisobidan).

## GitHub Flow (hamma topshiriqlar shu tartibda)

```
main (har doim ishlaydigan holat)
  └─ branch ochish ─ commit'lar ─ push ─ Pull Request ─ ko'rib chiqish ─ merge ─ branch'ni o'chirish
```

Qoida: **`main` ga to'g'ridan-to'g'ri commit qilinmaydi.** Hamma o'zgarish branch + PR orqali.

---

## 1. Hisobni sozlash ⭐

**Qadamlar**
1. Ikki bosqichli autentifikatsiyani (2FA) yoqing: *Settings → Password and authentication*.
2. Profilga ism, rasm va qisqa bio qo'shing.
3. Kompyuterdan kirishni sozlang — **bittasini** tanlang:
   - `gh auth login` (eng oson), yoki
   - SSH kalit: `ssh-keygen -t ed25519 -C "email"` → ochiq kalit (`.pub`) ni *Settings → SSH keys* ga qo'shing.
4. Git'ga ism/emailni bering: `git config --global user.name "..."`, `git config --global user.email "..."`.

> ⚠️ Parol, token va **maxfiy (private) kalit**ni hech kimga yubormang va repoga yuklamang. Faqat `.pub` fayl ochiq bo'lishi mumkin.

**Topshirish mezoni:** `gh auth status` (yoki `ssh -T git@github.com`) muvaffaqiyatli; profilda 2FA yoqilgan.

---

## 2. Birinchi repo ⭐

**Qadamlar**
1. GitHub'da `my-first-repo` nomli **public** repo yarating: README, `.gitignore` (Node) va MIT litsenziya bilan.
2. Kompyuterga `git clone` qiling.
3. README'ga o'zingiz haqingizda 3 qator yozing, commit qiling va `git push` qiling.
4. GitHub saytida commit tarixini (*Commits*) ochib ko'ring.

**Topshirish mezoni:** repo havolasi; kamida 2 ta commit (GitHub'da yaratilgan birinchisi + sizniki).

```bash
gh repo view <username>/my-first-repo --json name,visibility,licenseInfo
```

---

## 3. Lokal loyihani GitHub'ga yuklash ⭐

**Qadamlar**
1. Kompyuteringizda yangi papka yarating, `git init` qiling, 2–3 ta fayl va 2 ta commit qiling (masalan, `04-tsikllar` dagi yechimingiz).
2. GitHub'da **bo'sh** repo yarating (README'siz!).
3. Uni ulang va yuklang:
   ```bash
   git remote add origin <repo-havolasi>
   git branch -M main
   git push -u origin main
   ```
4. `git remote -v` natijasini tushuntiring: `origin` nima?

**Topshirish mezoni:** GitHub'dagi repoda lokal commit tarixi aynan ko'rinadi.

---

## 4. Issue bilan ishlash ⭐⭐

**Qadamlar**
1. Repoda 3 ta issue oching: biri `bug`, biri `enhancement`, biri `documentation` yorlig'i (label) bilan. Har birida aniq sarlavha va tavsif (nima kutilgan, nima bo'lyapti) bo'lsin.
2. Bittasini o'zingizga *assign* qiling.
3. Branch oching: `fix/issue-1-typo`, o'zgarish qiling va commit xabariga `Closes #1` qo'shing.
4. PR ochib merge qilganingizda issue **o'zi yopilishini** kuzating.

**Topshirish mezoni:** yopilgan issue, unda bog'langan PR ko'rinadi.

```bash
gh issue list --state all
```

---

## 5. Fork va upstream ⭐⭐

Fork — boshqa odamning repo'sidan **o'zingizning nusxangiz**. Sizda asl repoga yozish huquqi bo'lmaganda ishlatiladi.

**Qadamlar**
1. O'qituvchi repo'sini (`undigitals/pdp-fullstack`) **fork** qiling.
2. O'z fork'ingizni clone qiling.
3. Asl repoga `upstream` nomi bilan ulaning:
   ```bash
   git remote add upstream https://github.com/undigitals/pdp-fullstack.git
   git remote -v        # origin (sizniki) va upstream (asl)
   ```
4. Asl repoda yangilanish bo'lganda fork'ni yangilashni mashq qiling:
   ```bash
   git fetch upstream
   git switch main
   git merge upstream/main
   git push origin main
   ```
   (GitHub saytida *Sync fork* tugmasi ham bor.)

**Topshirish mezoni:** `git remote -v` natijasida ikkita remote; fork'ingiz asl repo bilan sinxron.

> Savol: `origin` va `upstream` o'rtasidagi farq nima? Nega `upstream` ga to'g'ridan-to'g'ri push qila olmaysiz?

---

## 6. Birinchi Pull Request ⭐⭐

**Qadamlar**
1. Fork'ingizda yangi branch oching (nom `aralash/ism-familiya` kabi — tavsiya etilgan nomlash repo README'sida).
2. O'zgarish qiling, commit qiling, fork'ingizga `push` qiling.
3. GitHub'da **Compare & pull request** → asl repo `main` ga PR oching.
4. PR tavsifini to'ldiring (pastdagi shablon).
5. Reviewer izohi bo'lsa — xuddi shu branch'ga yangi commit push qiling (PR o'zi yangilanadi).

**PR tavsifi shabloni**
```md
## Nima qildim
- ...

## Qanday tekshirdim
- [ ] `node tests.js` — X/16 test o'tdi

## Savollar / qiyin joylar
- ...
```

**Topshirish mezoni:** ochilgan PR havolasi; aniq sarlavha va to'ldirilgan tavsif.

```bash
gh pr list --repo undigitals/pdp-fullstack --author "@me"
```

---

## 7. Boshqaning PR'ini ko'rib chiqish (code review) 👥 ⭐⭐

**Qadamlar**
1. Guruhdoshingizning PR'ini oching → *Files changed*.
2. Kamida **2 ta qatorga izoh** (inline comment) yozing: biri savol, biri taklif. Kichik tuzatishlar uchun **Suggestion** funksiyasidan foydalaning.
3. Yakuniy baho bering: *Comment*, *Approve* yoki *Request changes*.
4. O'z PR'ingizga kelgan izohlarga javob yozing, tuzatishlarni push qiling va hal bo'lgan suhbatni *Resolve conversation* qiling.

**Yaxshi izoh qoidalari**
- Kodni tanqid qiling, odamni emas. «Bu ishlamaydi» o'rniga «`n = 0` bo'lganda nima bo'ladi?».
- Yechimni to'g'ridan-to'g'ri yozib bermang — savol bering yoki yo'nalish ko'rsating.
- Yaxshi qilingan joyni ham maqtang.

**Topshirish mezoni:** siz yozgan 2+ izoh va olgan izohlarga javoblaringiz.

---

## 8. PR'da merge konflikt 👥 ⭐⭐⭐

**Tayyorlash:** ikki talaba bitta umumiy repoda ishlaydi (biri yaratadi, ikkinchisini *collaborator* qiladi) yoki biri ikkinchisining fork'idan foydalanadi.

**Qadamlar**
1. Repoda `greeting.txt` bor (bir qatorli). Ikkala talaba **o'z branch'ida shu qatorni turlicha** o'zgartiradi.
2. Birinchi PR merge qilinadi.
3. Ikkinchi PR'da GitHub «**This branch has conflicts**» deydi.
4. Konfliktni **lokal** hal qiling:
   ```bash
   git switch <sizning-branch>
   git fetch origin
   git merge origin/main        # konflikt chiqadi
   # faylni oching, <<<<<<< ======= >>>>>>> belgilarini olib tashlang, to'g'ri qatorni qoldiring
   git add greeting.txt
   git commit -m "Merge main, resolve greeting conflict"
   git push
   ```
5. PR yangilanib «conflicts» belgisi yo'qolganini tekshiring, merge qiling.

**Topshirish mezoni:** merge qilingan ikkala PR; konflikt belgilarsiz yakuniy fayl. Ikkala talaba ham nima uchun aynan shu qatorni tanlaganini tushuntiradi.

---

## 9. Commit va branch nomlash ⭐⭐

Jamoa uchun yagona qoida kerak.

**Branch nomlari:** `feature/qidiruv`, `fix/login-xatosi`, `docs/readme`, `chore/lint`
**Commit xabarlari (Conventional Commits):**
```
feat: qidiruv maydoni qo'shildi
fix: bo'sh vazifa qo'shilishi to'g'rilandi
docs: README'ga o'rnatish yo'riqnomasi qo'shildi
refactor: renderList soddalashtirildi
```

**Qadamlar**
1. O'z repoda 4 ta kichik o'zgarish qiling — har biri **alohida branch va commit** (`feat`, `fix`, `docs`, `refactor`).
2. Har birini PR orqali merge qiling (kamida 4 ta PR).
3. `git log --oneline` natijasini tekshiring: har bir commit bitta ishni ifodalaydimi?

**Topshirish mezoni:** 4 ta merge qilingan PR, qoidaga mos nomlar.

---

## 10. `main` ni himoyalash (repo egasi uchun) ⭐⭐⭐

**Qadamlar**
1. Repo → *Settings → Rules → Rulesets* (yoki *Branches → Branch protection rule*): `main` uchun qoida yarating.
2. Yoqing: *Require a pull request before merging* (1 ta approval) va *Block force pushes*.
3. Sinab ko'ring: `main` ga to'g'ridan-to'g'ri push qilib ko'ring — rad etilishi kerak. Keyin PR orqali merge qiling.

**Topshirish mezoni:** rad etilgan push'ning xato xabari skrinshoti; nima uchun bu jamoada kerakligini 2–3 gapda yozing.

---

## 11. GitHub Pages ⭐⭐

**Qadamlar**
1. Repoda oddiy `index.html` (yoki `09-dom` dagi ishlaringizdan bittasi) bo'lsin.
2. *Settings → Pages → Source: Deploy from a branch → `main` / root*.
3. 1–2 daqiqadan keyin `https://<username>.github.io/<repo>/` manzilida sahifa ochilishini tekshiring.
4. `index.html` ni PR orqali o'zgartiring va merge dan keyin sayt yangilanganini ko'ring.

**Topshirish mezoni:** ishlayotgan sayt havolasi.

---

## 12. `gh` CLI ⭐⭐

Brauzersiz GitHub bilan ishlash.

**Qadamlar** — hammasini terminaldan bajaring:
```bash
gh repo create gh-cli-practice --public --clone     # repo yaratish
cd gh-cli-practice
git switch -c feat/hello
echo "salom" > hello.txt && git add . && git commit -m "feat: hello.txt qo'shildi"
git push -u origin feat/hello
gh pr create --fill                                  # PR ochish
gh pr list                                           # PR'lar ro'yxati
gh pr view --web                                     # brauzerda ochish
gh pr merge --squash --delete-branch                 # merge qilish
gh issue create --title "Sinov" --body "gh orqali"   # issue
```

**Topshirish mezoni:** terminal tarixi (yoki skrinshot) va repo havolasi.

---

## Yakuniy mini-loyiha: jamoada ishlash 👥 ⭐⭐⭐

2–3 kishilik jamoa umumiy repoda kichik sahifa (masalan, "Jamoa haqida") yaratadi:

- `main` himoyalangan (10-topshiriq); hamma o'zgarish PR orqali, kamida 1 approval bilan.
- Har bir a'zo kamida 2 ta PR ochadi va 2 ta boshqaning PR'ini ko'rib chiqadi.
- Kamida bitta konflikt hal qilinadi.
- README'da: loyiha tavsifi, qanday ishga tushirish, jamoa a'zolari.
- GitHub Pages'da deploy.

**Baholash:** PR'lar soni va sifati · izohlar sifati · commit xabarlari · README · hamma a'zoning ishtiroki (`Insights → Contributors`).

## Foydali buyruqlar jadvali

| Maqsad | Buyruq |
| --- | --- |
| Repo nusxasi | `git clone <url>` |
| Remote'lar | `git remote -v`, `git remote add <nom> <url>` |
| Asl repodan yangilash | `git fetch upstream` → `git merge upstream/main` |
| Yangi branch | `git switch -c <nom>` |
| Branch'ni yuklash | `git push -u origin <nom>` |
| PR ochish (terminal) | `gh pr create --fill` |
| PR'ni lokal tekshirish | `gh pr checkout <raqam>` |
| Konflikt holatida bekor qilish | `git merge --abort` |
