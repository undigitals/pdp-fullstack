# PDP Fullstack JavaScript

Fullstack JavaScript kursi uchun topshiriqlar reposi.

## Topshiriqlar

| Papka | Mavzu |
| --- | --- |
| [08-aralash-mashqlar](08-aralash-mashqlar) | Aralash takrorlash: operatorlar, shartlar, o'zgaruvchilar, tsikllar (16 ta masala) |
| [10-git](10-git) | Git amaliy mashqlari: commit, branch, merge, konflikt, rebase, stash (15 ta, avtomatik tekshiruv) |
| [11-bash](11-bash) | Bash skriptlash: 16 ta masala, avtomatik tekshiruv |
| [12-github](12-github) | GitHub: repo, fork, Pull Request, kod ko'rigi, konfliktlar |

## Topshiriqni qanday topshirish kerak (PR orqali)

Node.js (16 yoki yangiroq) va Git o'rnatilgan bo'lishi kerak.

1. Bu repoda **Fork** tugmasini bosing (o'zingizning nusxangiz yaratiladi).
2. O'z fork'ingizni kompyuteringizga yuklab oling:
   ```bash
   git clone https://github.com/<sizning-username>/pdp-fullstack.git
   cd pdp-fullstack
   ```
3. Yangi branch oching (nom: `aralash/ism-familiya`):
   ```bash
   git checkout -b aralash/ism-familiya
   ```
4. `08-aralash-mashqlar/tasks.md` dagi shartlarni o'qing va **faqat** `08-aralash-mashqlar/starter.js` faylini to'ldiring. `tests.js` va `tasks.md` ni o'zgartirmang.
5. Yechimingizni tekshiring:
   ```bash
   cd 08-aralash-mashqlar
   node tests.js
   ```
   Hamma testlar o'tishiga harakat qiling. Hammasi o'tmasa ham topshiring — qaysilari ishlamayotganini PR tavsifida yozing.
6. Commit qiling va fork'ingizga push qiling:
   ```bash
   git add 08-aralash-mashqlar/starter.js
   git commit -m "feat: aralash mashqlar yechimi (Ism Familiya)"
   git push -u origin aralash/ism-familiya
   ```
7. GitHub'da **Compare & pull request** tugmasini bosing va PR oching:
   - **Sarlavha:** `Aralash mashqlar — Ism Familiya`
   - **Tavsif:** nechta test o'tdi (`X/16`), qaysi masala eng qiyin bo'ldi, nimani o'rgandingiz.

## Qoidalar

- Yechimni o'zingiz yozing. Boshqaning kodini ko'chirmang — kodni og'zaki tushuntirib berishingiz so'raladi.
- Bitta PR — bitta talaba — faqat `starter.js` o'zgargan.
- Boshqa talabalarning PR'lariga izoh qoldirish mumkin, lekin yechimni to'g'ridan-to'g'ri yozib bermang; maslahat bering.
