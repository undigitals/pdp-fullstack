(function () {
  const testlar = [];

  function sinov(nom, fn) {
    testlar.push({ nom, fn });
  }

  function tengmi(olingan, kutilgan, izoh) {
    const a = JSON.stringify(olingan);
    const b = JSON.stringify(kutilgan);
    if (a !== b) {
      throw new Error(`${izoh ? izoh + " — " : ""}kutilgan: ${b}, olingan: ${a}`);
    }
  }

  function rost(shart, izoh) {
    if (!shart) throw new Error(izoh);
  }

  // Test uchun yangi HTML bo'lagi yaratadi
  function yasash(html) {
    const d = document.createElement("div");
    d.innerHTML = html.trim();
    document.getElementById("sandbox").appendChild(d);
    return d;
  }

  // Input qiymatini o'zgartirib, "input" hodisasini yuboradi
  function yoz(input, qiymat) {
    input.value = qiymat;
    input.dispatchEvent(new Event("input", { bubbles: true }));
  }

  sinov("1. setText", () => {
    const r = yasash('<p id="a">eski</p>');
    const p = r.querySelector("#a");
    setText(p, "<b>yangi</b>");
    tengmi(p.textContent, "<b>yangi</b>");
    tengmi(p.children.length, 0, "HTML emas, oddiy matn bo'lishi kerak");
  });

  sinov("2. getTexts", () => {
    const r = yasash('<ul><li>A</li><li>B</li><li class="x">C</li></ul>');
    const natija = getTexts(r, "li");
    rost(Array.isArray(natija), "oddiy massiv qaytarilishi kerak");
    tengmi(natija, ["A", "B", "C"]);
    tengmi(getTexts(r, ".x"), ["C"]);
    tengmi(getTexts(r, "p"), []);
  });

  sinov("3. toggleHighlight", () => {
    const r = yasash('<p class="a">matn</p>');
    const p = r.querySelector("p");
    tengmi(toggleHighlight(p), true, "birinchi chaqiruv");
    rost(p.classList.contains("highlight"), "highlight sinfi qo'shilishi kerak");
    rost(p.classList.contains("a"), "boshqa sinflar saqlanishi kerak");
    tengmi(toggleHighlight(p), false, "ikkinchi chaqiruv");
    rost(!p.classList.contains("highlight"), "highlight sinfi olib tashlanishi kerak");
  });

  sinov("4. setLink", () => {
    const r = yasash("<a>havola</a>");
    const a = r.querySelector("a");
    setLink(a, "https://example.com", "Sayt");
    tengmi(a.getAttribute("href"), "https://example.com");
    tengmi(a.textContent, "Sayt");
    tengmi(a.getAttribute("target"), "_blank");
    tengmi(a.getAttribute("rel"), "noopener");
  });

  sinov("5. createItem", () => {
    const li = createItem("Salom");
    rost(li instanceof HTMLElement, "element qaytarilishi kerak");
    tengmi(li.tagName, "LI");
    tengmi(li.textContent, "Salom");
    tengmi(li.parentNode, null, "hali hujjatga qo'shilmagan bo'lishi kerak");
  });

  sinov("6. renderList", () => {
    const r = yasash("<ul><li>eski</li></ul>");
    const ul = r.querySelector("ul");
    renderList(ul, ["a", "b", "c"]);
    tengmi(getTextsOf(ul), ["a", "b", "c"], "eski elementlar o'chirilishi kerak");
    tengmi([...ul.children].every((c) => c.tagName === "LI"), true);
    renderList(ul, ["<b>x</b>"]);
    tengmi(ul.children[0].children.length, 0, "matn HTML sifatida emas, oddiy matn bo'lishi kerak");
    renderList(ul, []);
    tengmi(ul.children.length, 0);
  });

  function getTextsOf(parent) {
    return [...parent.children].map((c) => c.textContent);
  }

  sinov("7. removeByClass", () => {
    const r = yasash('<div id="k"><p class="old">1</p><p>2</p><span class="old">3</span></div>');
    const k = r.querySelector("#k");
    tengmi(removeByClass(k, "old"), 2);
    tengmi(k.children.length, 1);
    tengmi(k.children[0].textContent, "2");
    tengmi(removeByClass(k, "old"), 0);
  });

  sinov("8. setStyles", () => {
    const r = yasash("<p>matn</p>");
    const p = r.querySelector("p");
    setStyles(p, { color: "red", fontSize: "20px", backgroundColor: "blue" });
    tengmi(p.style.color, "red");
    tengmi(p.style.fontSize, "20px");
    tengmi(p.style.backgroundColor, "blue");
  });

  sinov("9. readData", () => {
    const r = yasash(
      '<div id="u1" data-id="42" data-role="admin"></div><div id="u2" data-id="7" data-role="user"></div>'
    );
    tengmi(readData(r.querySelector("#u1")), { id: 42, role: "admin" }, "id son bo'lishi kerak");
    tengmi(readData(r.querySelector("#u2")), { id: 7, role: "user" });
  });

  sinov("10. bindClickCounter", () => {
    const r = yasash("<button>+</button><span></span>");
    const btn = r.querySelector("button");
    const out = r.querySelector("span");
    bindClickCounter(btn, out);
    tengmi(out.textContent, "0", "boshida 0 ko'rinishi kerak");
    btn.click();
    btn.click();
    btn.click();
    tengmi(out.textContent, "3");
  });

  sinov("11. mirrorInput", () => {
    const r = yasash("<input><span></span>");
    const input = r.querySelector("input");
    const out = r.querySelector("span");
    mirrorInput(input, out);
    yoz(input, "salom");
    tengmi(out.textContent, "salom");
    yoz(input, "");
    tengmi(out.textContent, "");
  });

  sinov("12. handleForm", () => {
    const r = yasash('<form><input name="name" value="Ali"><input name="age" value="20"></form>');
    const form = r.querySelector("form");
    let olingan = null;
    handleForm(form, (data) => {
      olingan = data;
    });
    const ev = new Event("submit", { cancelable: true, bubbles: true });
    form.dispatchEvent(ev);
    rost(ev.defaultPrevented, "sahifa qayta yuklanmasligi uchun preventDefault() kerak");
    tengmi(olingan, { name: "Ali", age: "20" });
  });

  sinov("13. enableDelegation", () => {
    const r = yasash("<ul><li>A</li><li><span>B</span></li></ul>");
    const ul = r.querySelector("ul");
    const chaqiruvlar = [];
    enableDelegation(ul, (t) => chaqiruvlar.push(t));
    ul.children[0].click();
    ul.querySelector("span").click();
    const yangi = document.createElement("li");
    yangi.textContent = "C";
    ul.append(yangi);
    yangi.click();
    ul.click();
    tengmi(chaqiruvlar, ["A", "B", "C"], "ul ning o'ziga bosish hisobga olinmasligi kerak");
  });

  sinov("14. setupTodo", () => {
    const r = yasash('<input id="new"><button id="add">Qo\'shish</button><ul id="list"></ul>');
    const input = r.querySelector("#new");
    const add = r.querySelector("#add");
    const ul = r.querySelector("#list");
    setupTodo(r);

    input.value = "Non olish";
    add.click();
    tengmi(ul.children.length, 1, "vazifa qo'shilishi kerak");
    const li = ul.children[0];
    tengmi(li.tagName, "LI");
    tengmi(li.querySelector("span") && li.querySelector("span").textContent, "Non olish");
    rost(li.querySelector("button.delete"), "li ichida button.delete bo'lishi kerak");
    tengmi(input.value, "", "qo'shilgandan keyin input tozalanishi kerak");

    input.value = "   ";
    add.click();
    tengmi(ul.children.length, 1, "bo'sh vazifa qo'shilmasligi kerak");

    li.querySelector("span").click();
    rost(li.classList.contains("done"), "bosilganda li ga done sinfi qo'shilishi kerak");
    li.querySelector("span").click();
    rost(!li.classList.contains("done"), "qayta bosilganda done sinfi olib tashlanishi kerak");

    li.querySelector("button.delete").click();
    tengmi(ul.children.length, 0, "delete tugmasi vazifani o'chirishi kerak");
  });

  sinov("15. filterList", () => {
    const r = yasash("<input><ul><li>Olma</li><li>Anor</li><li>Banan</li></ul>");
    const input = r.querySelector("input");
    const ul = r.querySelector("ul");
    filterList(input, ul);
    const yashirin = () => [...ul.children].map((li) => li.hidden);
    yoz(input, "an");
    tengmi(yashirin(), [true, false, false]);
    yoz(input, "OL");
    tengmi(yashirin(), [false, true, true], "katta-kichik harf farq qilmasligi kerak");
    yoz(input, "");
    tengmi(yashirin(), [false, false, false]);
  });

  sinov("16. tabs", () => {
    const r = yasash(
      '<button data-tab="a">A</button><button data-tab="b">B</button>' +
        '<div data-panel="a">Panel A</div><div data-panel="b">Panel B</div>'
    );
    const [btnA, btnB] = r.querySelectorAll("button");
    const [panelA, panelB] = r.querySelectorAll("[data-panel]");
    tabs(r);
    rost(btnA.classList.contains("active"), "boshida birinchi tab faol bo'lishi kerak");
    tengmi([panelA.hidden, panelB.hidden], [false, true], "boshida faqat birinchi panel ko'rinadi");
    btnB.click();
    tengmi([btnA.classList.contains("active"), btnB.classList.contains("active")], [false, true]);
    tengmi([panelA.hidden, panelB.hidden], [true, false]);
    btnA.click();
    tengmi([panelA.hidden, panelB.hidden], [false, true]);
  });

  sinov("17. persistInput", () => {
    const kalit = "dom-mashq-test";
    localStorage.removeItem(kalit);
    try {
      const r = yasash("<input><input>");
      const [a, b] = r.querySelectorAll("input");
      persistInput(a, kalit);
      yoz(a, "salom");
      tengmi(localStorage.getItem(kalit), "salom", "yozilgan matn localStorage ga saqlanishi kerak");
      persistInput(b, kalit);
      tengmi(b.value, "salom", "saqlangan qiymat inputga tiklanishi kerak");
    } finally {
      localStorage.removeItem(kalit);
    }
  });

  // --- Ishga tushirish ---
  function chiqar(xabar) {
    const joy = document.getElementById("xato");
    joy.style.display = "block";
    joy.textContent += xabar + "\n";
  }

  window.addEventListener("error", (e) => chiqar("Xato: " + e.message));

  function ishga() {
    let otdi = 0;
    let yiqildi = 0;
    const ro = document.getElementById("natijalar");
    for (const { nom, fn } of testlar) {
      const li = document.createElement("li");
      li.textContent = nom;
      try {
        fn();
        li.className = "otdi";
        otdi++;
      } catch (xato) {
        li.className = "yiqildi";
        const kichik = document.createElement("small");
        kichik.textContent = xato.message;
        li.append(kichik);
        yiqildi++;
      }
      ro.append(li);
    }
    document.getElementById("sandbox").innerHTML = "";
    document.getElementById("xulosa").textContent = `Natija: ${otdi} ta o'tdi, ${yiqildi} ta yiqildi`;
    window.__natija = { otdi, yiqildi };
  }

  window.addEventListener("load", ishga);
})();
