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
        "déponent": "Déponent"
    },

    morphologie: {
        "is": "is, ea, id",
        "comparatif": "Comparatif"
    },

    syntaxe: {
        "relative": "Proposition relative",
        "infinitive": "Proposition infinitive",
        "ablatif_absolu": "Ablatif absolu",
        "omission_esse": "Omission de esse"
    }
};

document.addEventListener("DOMContentLoaded", () => {

    const compteur = document.getElementById("compteur");
    const messageVide = document.getElementById("message-vide");
    const corpus = document.getElementById("corpus");

    let textes = [];

    /* Chargement des textes */
    document.querySelectorAll("[data-src]").forEach(div => {
        fetch(div.dataset.src)
            .then(r => r.ok ? r.text() : null)
            .then(html => {
                if (!html) return;
                const temp = document.createElement("div");
                temp.innerHTML = html;
                const texte = temp.querySelector(".texte");
                if (texte) {
                    texte.style.display = "none";
                    corpus.appendChild(texte);
                    textes.push(texte);
                }
            });
    });

    /* Génération automatique des menus ana */
    document.querySelectorAll("select.ana").forEach(select => {
        const cat = select.dataset.cat;
        select.innerHTML = `<option value="">—</option>`;
        Object.entries(ANA_LABELS[cat]).forEach(([v, l]) => {
            const opt = document.createElement("option");
            opt.value = v;
            opt.textContent = l;
            select.appendChild(opt);
        });
    });

    document.querySelectorAll("select")
        .forEach(s => s.addEventListener("change", appliquerFiltres));

    function appliquerFiltres() {
        const langue = document.getElementById("langue").value;
        const type = document.getElementById("type").value;
        const niveau = document.getElementById("niveau").value;

        let filtresActifs = langue || type || niveau;
        let count = 0;

        textes.forEach(texte => {
            let visible = true;

            if (!filtresActifs) visible = false;
            if (langue && texte.dataset.langue !== langue) visible = false;
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

    function testAnaCat(cat, texte) {
        const selects = [...document.querySelectorAll(`.ana[data-cat="${cat}"]`)];
        const ops = [...document.querySelectorAll(`.filtres-${cat} .op`)];
        const values = selects.map(s => s.value).filter(Boolean);

        if (values.length === 0) return true;

        const anaSet = (texte.dataset[cat] || "").split(" ");
        let result = anaSet.includes(values[0]);

        for (let i = 1; i < values.length; i++) {
            const present = anaSet.includes(values[i]);
            const op = ops[i - 1].value;

            if (op === "and") result = result && present;
            if (op === "or") result = result || present;
            if (op === "without") result = result && !present;
        }

        return result;
    }
});
