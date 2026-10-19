# DOM va hodisalar — kodlash masalalari

`starter.js` faylida funksiyalarni to'ldiring. Tekshirish **brauzerda**:

1. `index.html` ni brauzerda oching (ikki marta bosing yoki VS Code'da *Live Server* bilan).
2. `starter.js` ni o'zgartirib saqlang va sahifani yangilang (<kbd>F5</kbd>).
3. Har bir masala yonida ✓ yoki ✗ chiqadi; ✗ ostida nima kutilgani va nima olingani yoziladi.
4. Kod xato bersa — sahifa tepasida qizil xabar chiqadi. Batafsil ma'lumot uchun DevTools (<kbd>F12</kbd>) → Console.

Qiyinlik: ⭐ oson · ⭐⭐ o'rta · ⭐⭐⭐ qiyinroq

> Hamma funksiya tayyor elementlarni **parametr sifatida oladi**. `document.querySelector` bilan butun sahifani qidirmang — berilgan elementning o'zi bilan ishlang (`root.querySelector(...)`).

---

## 1. Matnni o'zgartirish ⭐ (`textContent`)

`setText(el, text)` — elementning matnini `text` ga almashtirsin. `"<b>x</b>"` kabi qiymat HTML sifatida emas, **oddiy matn** sifatida ko'rinishi kerak.

---

## 2. Elementlar matnlarini yig'ish ⭐ (`querySelectorAll`)

`getTexts(root, selector)` — `root` ichida `selector` ga mos barcha elementlar matnini **oddiy massiv** sifatida qaytarsin. Topilmasa — `[]`.

```js
// <ul><li>A</li><li>B</li></ul>
getTexts(root, "li"); // ["A", "B"]
```

<details><summary>Maslahat</summary>

`querySelectorAll` `NodeList` qaytaradi — `map` ishlatishdan oldin uni massivga aylantiring: `[...nodeList]`.
</details>

---

## 3. Sinfni almashtirish ⭐ (`classList`)

`toggleHighlight(el)` — elementda `highlight` sinfi bo'lmasa qo'shsin, bo'lsa olib tashlasin. Boshqa sinflarga tegmasin. Natija: sinf **hozir bor** bo'lsa `true`, aks holda `false`.

---

## 4. Havola sozlash ⭐ (`setAttribute`)

`setLink(a, url, text)` — `<a>` elementiga `href=url`, matn `text`, `target="_blank"` va `rel="noopener"` ni o'rnating.

---

## 5. Element yaratish ⭐ (`createElement`)

`createItem(text)` — matni `text` bo'lgan yangi `<li>` yaratib qaytarsin. Hujjatga **qo'shmasin**.

---

## 6. Ro'yxatni chizish ⭐⭐ (`createElement`, `append`)

`renderList(ul, items)` — `ul` ning eski mazmunini o'chirib, `items` massividagi har bir matn uchun `<li>` qo'shsin. Matn HTML sifatida emas, oddiy matn bo'lishi kerak. Bo'sh massiv — bo'sh ro'yxat.

<details><summary>Maslahat</summary>

`innerHTML` ga foydalanuvchi matnini qo'shish xavfli (XSS). `createElement` + `textContent` xavfsiz yo'l. Eskilarni tozalash uchun `replaceChildren()` ni qidiring.
</details>

---

## 7. Sinf bo'yicha o'chirish ⭐⭐ (`remove`)

`removeByClass(root, className)` — `root` ichidagi shu sinfli barcha elementlarni o'chirsin va **nechta** o'chirganini qaytarsin.

---

## 8. Uslub berish ⭐ (`style`)

`setStyles(el, styles)` — obyektdagi barcha uslublarni elementga qo'llasin. Kalitlar camelCase: `{ color: "red", fontSize: "20px", backgroundColor: "blue" }`.

---

## 9. `data-*` atributlari ⭐⭐ (`dataset`)

`readData(el)` — `data-id` va `data-role` ni o'qib, `{ id, role }` qaytarsin. `id` **son** bo'lsin.

```js
// <div data-id="42" data-role="admin">
readData(el); // { id: 42, role: "admin" }
```

---

## 10. Bosishlar hisoblagichi ⭐⭐ (`addEventListener`)

`bindClickCounter(button, output)` — `output` da avval `0` ko'rinsin; `button` har bosilganda son bittaga oshsin.

---

## 11. Yozilgan matnni aks ettirish ⭐⭐ (`input` hodisasi)

`mirrorInput(input, output)` — foydalanuvchi `input` ga yozayotganda `output` matni o'sha zahoti yangilansin (`input` hodisasi).

---

## 12. Formani qayta ishlash ⭐⭐ (`submit`, `FormData`)

`handleForm(form, onData)` — forma yuborilganda sahifa qayta yuklanmasin (`preventDefault`), formadagi maydonlar `name` bo'yicha obyektga yig'ilib `onData(obj)` ga berilsin.

```js
// <input name="name" value="Ali"> <input name="age" value="20">
// → onData({ name: "Ali", age: "20" })
```

<details><summary>Maslahat</summary>

`FormData` va `Object.fromEntries` ni qidirib ko'ring — ular formani obyektga aylantirishga yordam beradi.
</details>

---

## 13. Hodisalarni delegatsiya qilish ⭐⭐⭐ (`closest`)

`enableDelegation(ul, onSelect)` — `ul` ichidagi `<li>` bosilganda `onSelect(li.textContent)` chaqirilsin. Talablar:

- **bitta** tinglovchi — faqat `ul` ga qo'yiladi (har `li` ga emas);
- keyin **qo'shilgan** `li` lar ham ishlashi kerak;
- `li` ichidagi `<span>` bosilsa ham `li` matni berilsin;
- `ul` ning bo'sh joyiga bosilsa — hech narsa bo'lmasin.

<details><summary>Maslahat</summary>

`event.target` — aynan bosilgan element (masalan `span`). `event.target.closest("li")` yuqoriga qarab eng yaqin `li` ni topadi.
</details>

---

## 14. To'-do mini ilova ⭐⭐⭐ (hammasi birga)

`setupTodo(root)` — `root` ichida `#new` (input), `#add` (tugma) va `#list` (ul) bor.

- `#add` bosilganda `#new` dagi matn bilan `li` qo'shilsin. Bo'sh yoki faqat bo'sh joydan iborat matn qo'shilmasin. Qo'shilgach input tozalansin.
- `li` tuzilishi: `<li><span>matn</span><button class="delete">×</button></li>`
- `span` bosilsa — `li` ga `done` sinfi almashsin (qo'shilsin/olib tashlansin).
- `button.delete` bosilsa — `li` o'chirilsin.

> Bitta tinglovchi bilan (delegatsiya) yozishga harakat qiling — vazifalar keyin qo'shiladi.

---

## 15. Qidiruv / filtr ⭐⭐ (`input`, `hidden`)

`filterList(input, ul)` — `input` ga yozilganda matnida shu so'z **bo'lmagan** `li` larga `hidden = true`, bo'lganlarga `false`. Katta-kichik harf farq qilmasin. Input bo'sh bo'lsa — hammasi ko'rinsin.

---

## 16. Tablar ⭐⭐⭐ (`dataset`, `classList`, `hidden`)

`tabs(root)` — `root` ichida `button[data-tab="x"]` tugmalari va `[data-panel="x"]` panellar bor.

- Boshida **birinchi tab** faol: tugmada `active` sinfi, faqat shu panel ko'rinadi.
- Tugma bosilsa — o'sha tab faol bo'lsin (`active` boshqa tugmadan olinadi), mos panel ko'rinib, qolganlari `hidden` bo'lsin.

---

## 17. Matnni eslab qolish ⭐⭐ (`localStorage`)

`persistInput(input, key)` — `input` ga yozilgan matn `localStorage` ning `key` kaliti ostida saqlansin. Funksiya chaqirilganda, agar avval saqlangan qiymat bo'lsa, u `input.value` ga **tiklansin**.
