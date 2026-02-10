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
                if (!texte) return;

                texte.style.display = "none";
                corpus.appendChild(texte);
                textes.push(texte);
            });
    });

    /* Menus déroulants ana */
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

    /* Écouteurs */
    document.querySelectorAll("select")
        .forEach(s => s.addEventListener("change", appliquerFiltres));

    function appliquerFiltres() {
        const langue = document.getElementById("langue").value;
        const type = document.getElementById("type").value;
        const niveau = document.getElementById("niveau").value;

        let filtresActifs =
            langue || type || niveau ||
            hasAnaSelection("conjugaison") ||
            hasAnaSelection("morphologie") ||
            hasAnaSelection("syntaxe");

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

    function hasAnaSelection(cat) {
        return [...document.querySelectorAll(`.ana[data-cat="${cat}"]`)]
            .some(s => s.value);
    }

function testAnaCat(cat, texte) {
    const selects = [...document.querySelectorAll(`.ana[data-cat="${cat}"]`)];
    const ops = [...document.querySelectorAll(`.op[data-cat="${cat}"]`)];
    const anaSet = (texte.dataset[cat] || "").split(/\s+/).filter(s => s.length > 0);

    let result = null;

    for (let i = 0; i < selects.length; i++) {
        const value = selects[i].value;
        if (!value) continue;

        const present = anaSet.includes(value);
        
        // On récupère l'opérateur situé AVANT ce select (si i > 0)
        const op = i > 0 ? ops[i - 1].value : "or";

        if (result === null) {
            // C'est le premier critère rempli de la ligne
            // Si l'utilisateur a mis "SANS" devant un champ alors que le précédent est vide, 
            // on considère qu'il veut (Rien) SANS (Valeur), donc il faut inverser.
            result = (op === "without") ? !present : present;
        } else {
            // Application des opérateurs classiques
            if (op === "without") {
                result = result && !present;
            } else if (op === "and") {
                result = result && present;
            } else { // "or"
                result = result || present;
            }
        }
    }

    return result === null ? true : result;
}


});







