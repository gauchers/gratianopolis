const ANA_LABELS = {
    conjugaison: {
        "indicatif_présent": "Indicatif présent",
        "indicatif_imparfait": "Indicatif imparfait",
        "indicatif_parfait": "Indicatif parfait",
        "infinitif_présent": "Infinitif présent",
        "infinitif_parfait": "Infinitif parfait",
        "infinitif_parfait_passif": "Infinitif parfait passif",
        "participe_parfait": "Participe parfait",
        "participe_futur": "Participe futur",
        "participe_substantivé": "Participe substantivé",
    },
    morphologie: {
        "comparatif": "Comparatif"
    },
    syntaxe: {
        "relative": "Proposition relative",
        "infinitive": "Proposition infinitive",
    }
};

document.addEventListener("DOMContentLoaded", async () => {

    const compteur = document.getElementById("compteur");
    const messageVide = document.getElementById("message-vide");
    const corpus = document.getElementById("corpus");

    let textes = [];

    const files = await fetch("../data/index.json")
    .then(r => {
        if (!r.ok) throw new Error("index.json introuvable");
        return r.json();
    })
    .catch(e => {
        console.error(e);
        return [];
    });

for (const file of files.filter(f => f.startsWith("grc_"))) {
    const html = await fetch(`../data/${file}`)
        .then(r => r.ok ? r.text() : null);

    if (!html) continue;

    const temp = document.createElement("div");
    temp.innerHTML = html;

    const texte = temp.querySelector(".texte");
    if (!texte) continue;

    texte.style.display = "none";
    corpus.appendChild(texte);
    textes.push(texte);
}


    /* =========================
       3. Menus déroulants
       ========================= */

    document.querySelectorAll("select.ana").forEach(select => {
        const cat = select.dataset.cat;
        select.innerHTML = `<option value="">—</option>`;

        Object.entries(ANA_LABELS[cat]).forEach(([value, label]) => {
            const opt = document.createElement("option");
            opt.value = value;
            opt.textContent = label;
            select.appendChild(opt);
        });
    });

    document.querySelectorAll("select")
        .forEach(s => s.addEventListener("change", appliquerFiltres));

    /* =========================
       4. Filtres
       ========================= */

    function appliquerFiltres() {
        const type = document.getElementById("type").value;
        const niveau = document.getElementById("niveau").value;

        let filtresActifs =
            type || niveau ||
            hasAnaSelection("conjugaison") ||
            hasAnaSelection("morphologie") ||
            hasAnaSelection("syntaxe");

        let count = 0;

        textes.forEach(texte => {
            let visible = true;

            if (!filtresActifs) visible = false;
            if (type && texte.dataset.type !== type) visible = false;
            if (niveau && texte.dataset.niveau !== niveau) visible = false;

            if (!testAnaCat("conjugaison", texte)) visible = false;
            if (!testAnaCat("morphologie", texte)) visible = false;
            if (!testAnaCat("syntaxe", texte)) visible = false;

            texte.style.display = visible ? "block" : "none";
            if (visible) count++;
        });

        compteur.textContent = filtresActifs
            ? `${count} ${count > 1 ? "résultats trouvés" : "résultat trouvé"}`
            : "";

        messageVide.style.display =
            filtresActifs && count === 0 ? "block" : "none";
    }

    function hasAnaSelection(cat) {
        return [...document.querySelectorAll(`.ana[data-cat="${cat}"]`)]
            .some(s => s.value);
    }

    function testAnaCat(cat, texte) {
        const selects = [...document.querySelectorAll(`.ana[data-cat="${cat}"]`)];
        const ops = [...document.querySelectorAll(`.op[data-cat="${cat}"]`)];
        const anaSet = (texte.dataset[cat] || "").split(/\s+/).filter(Boolean);

        let result = null;

        for (let i = 0; i < selects.length; i++) {
            const value = selects[i].value;
            if (!value) continue;

            const present = anaSet.includes(value);
            const op = i > 0 ? ops[i - 1].value : "or";

            if (result === null) {
                result = (op === "without") ? !present : present;
            } else {
                if (op === "without") result = result && !present;
                else if (op === "and") result = result && present;
                else result = result || present;
            }
        }

        return result === null ? true : result;
    }

});


