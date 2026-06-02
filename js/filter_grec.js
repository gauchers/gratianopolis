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
    },
    
    genre: {
        comedie:               "Comédie",
        didactique:            "Didactique",
        discours:              "Discours",
        elegie:                "Élégie",
        epigramme:             "Épigramme",
        epistolaire:           "Épistolaire",
        epopee:                "Épopée",
        fable:                 "Fable",
        histoire:              "Histoire",
        philosophie:           "Philosophie",
        roman:                 "Roman",
        satire:                "Satire",
        theatre:               "Théâtre",
        tragedie:              "Tragédie",
        litterature_technique: "Littérature technique",
        compilation:           "Compilation",
        lyrique:               "Lyrique",
        epyllion:              "Épyllion"
    },  

  programme: {
    amour_amours:                                "Amour, amours",
    comprendre_le_monde:                         "Comprendre le monde",
    croire_savoir_douter:                        "Croire, savoir, douter",
    de_la_legende_du_mythe_a_l_histoire:         "De la légende/du mythe à l'histoire",
    de_la_republique_au_principat:               "De la république au principat",
    inventer_creer_fabriquer_produire:           "Inventer, créer, fabriquer, produire",
    justice_des_dieux_justice_des_hommes:        "Justice des dieux, justice des hommes",
    la_cite_entre_realites_et_utopies:           "La cité entre réalités et utopies",
    la_grece_dans_son_unite_et_sa_diversite:     "La Grèce dans son unité et sa diversité",
    l_empire_romain:                             "L'empire romain",
    le_monde_mediterraneen:                      "Le monde méditerranéen",
    lecons_de_sagesse_antique:                   "Leçons de sagesse antique",
    les_dieux_dans_la_cite:                      "Les dieux dans la cité",
    l_homme_et_l_animal:                         "L'Homme et l'animal",
    l_homme_et_le_divin:                         "L'Homme et le divin",
    l_homme_le_monde_le_destin:                  "L'homme, le monde, le destin",
    masculin_feminin:                            "Masculin, Féminin",
    mediterranee_conflit_influences_et_echanges: "Méditerranée : conflit, influences et échanges",
    mediterranee_presence_des_mondes_antiques:   "Méditerranée : présence des mondes antiques",
    mediterranee_voyager_explorer_decouvrir:     "Méditerranée : voyager, explorer, découvrir",
    soi_meme_et_l_autre:                         "Soi-même et l'autre",
    vie_familiale_sociale_et_intellectuelle:      "Vie familiale, sociale et intellectuelle",
    vie_privee_et_vie_publique:                  "Vie privée et vie publique",
    vivre_dans_la_cite:                          "Vivre dans la cité"
},

    
        themes: {
        amitie:      "Amitié",
        amour:       "Amour et érotisme",
        argent:      "Argent et commerce",
        education:   "Éducation et pédagogie",
        eloge:       "Éloge et blâme",
        famille:     "Famille et ancêtres",
        guerre:      "Guerre et paix",
        alterite:    "Identité et altérité",
        litterature: "Littérature, rhétorique et arts",
        mort:        "Mort",
        nature:      "Nature",
        philosophie: "Philosophie et sagesse",
        politique:   "Politique et pouvoir",
        religions:   "Religions et mythologie",
        societe:     "Société",
        quotidien:    "Vie quotidienne et realia",
        violence:      "Violence et luttes"
    }
};


document.addEventListener("DOMContentLoaded", async () => {

    const compteur    = document.getElementById("compteur");
    const messageVide = document.getElementById("message-vide");
    const corpus      = document.getElementById("corpus");

    let textes = [];

    /* =========================
       1. Chargement des fichiers
       ========================= */

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
       2. Menus déroulants .ana
       ========================= */

    document.querySelectorAll("select.ana").forEach(select => {
        const cat = select.dataset.cat;
        if (!ANA_LABELS[cat]) return;
        select.innerHTML = `<option value="">—</option>`;
        Object.entries(ANA_LABELS[cat]).forEach(([value, label]) => {
            const opt = document.createElement("option");
            opt.value = value;
            opt.textContent = label;
            select.appendChild(opt);
        });
    });

    /* =========================
       3. Écouteurs
       ========================= */

    document.querySelectorAll("select")
        .forEach(s => s.addEventListener("change", appliquerFiltres));

    /* =========================
       4. Construction de la
          séquence de tokens
       ========================= */

    /*
     * buildSequence() lit le DOM une seule fois et construit
     * une liste plate de tokens dans l'ordre d'apparition :
     *
     *   [
     *     { type: "ana", cat: "conjugaison", el: <select> },
     *     { type: "op",                      el: <select> },
     *     { type: "ana", cat: "morphologie", el: <select> },
     *     ...
     *   ]
     *
     * La clé est d'utiliser un TreeWalker qui visite TOUS les
     * éléments du DOM dans l'ordre du document. On retient
     * uniquement les <select class="ana"> et <select class="op">.
     * Leur ordre dans le DOM reflète exactement l'ordre visuel,
     * indépendamment de leur catégorie ou de leur ligne.
     *
     * Structure HTML attendue par ligne :
     *   [ana] [op] [ana] [op] [ana]
     * Entre deux lignes, pas d'op supplémentaire : l'op qui
     * relie la dernière ana d'une ligne à la première ana de
     * la ligne suivante est le dernier op de la première ligne.
     *
     * Si ta maquette ne place pas d'op entre lignes, on
     * considère que le passage d'une ligne à l'autre est un OU
     * implicite (voir appliquerFiltres). Pour un ET ou SANS
     * inter-lignes, il suffit d'ajouter un <select class="op">
     * entre les deux <div class="ligne-filtre"> dans le HTML.
     */
    function buildSequence() {
        const sequence = [];
        const walker = document.createTreeWalker(
            document.getElementById("filtres-ana") || document.body,
            NodeFilter.SHOW_ELEMENT,
            {
                acceptNode(node) {
                    if (node.tagName !== "SELECT") return NodeFilter.FILTER_SKIP;
                    if (node.classList.contains("ana")) return NodeFilter.FILTER_ACCEPT;
                    if (node.classList.contains("op"))  return NodeFilter.FILTER_ACCEPT;
                    return NodeFilter.FILTER_SKIP;
                }
            }
        );

        let node;
        while ((node = walker.nextNode())) {
            if (node.classList.contains("ana")) {
                sequence.push({ type: "ana", cat: node.dataset.cat, el: node });
            } else {
                sequence.push({ type: "op", el: node });
            }
        }
        return sequence;
    }

    /* =========================
       5. Filtres
       ========================= */

    function appliquerFiltres() {
        const type   = document.getElementById("type").value;
        const genre  = document.getElementById("genre").value;
        const niveau = document.getElementById("niveau").value;

        const sequence  = buildSequence();
        const anaActive = sequence.some(t => t.type === "ana" && t.el.value);

        const filtresActifs = type || genre || niveau || anaActive;

        let count = 0;

        textes.forEach(texte => {
            let visible = true;

            if (!filtresActifs)                            visible = false;
            if (type   && texte.dataset.type   !== type)  visible = false;
            if (genre  && !texte.dataset.genre.split(/\s+/).includes(genre)) visible = false;
            if (niveau && texte.dataset.niveau !== niveau) visible = false;
            if (anaActive && !testAnaGlobal(texte, sequence)) visible = false;

            texte.style.display = visible ? "block" : "none";
            if (visible) count++;
        });

        compteur.textContent = filtresActifs
            ? `${count} ${count > 1 ? "résultats trouvés" : "résultat trouvé"}`
            : "";

        messageVide.style.display =
            filtresActifs && count === 0 ? "block" : "none";
    }

    /* =========================
       6. testAnaGlobal
       ========================= */

    /*
     * Parcourt la séquence plate [ana, op, ana, op, ana, ana, op, ana…]
     * et évalue si le texte passe le filtre.
     *
     * Règle de lecture de la séquence :
     *
     *  - Un token "ana" vide est ignoré.
     *    → son op PRÉCÉDENT (s'il existe) est aussi ignoré.
     *    → on cherche le prochain op valide en reculant ou avançant.
     *
     * Pour simplifier, on commence par extraire uniquement les
     * tokens "ana" renseignés, et on résout l'opérateur entre
     * deux tokens actifs consécutifs ainsi :
     *
     *   Entre ana[i] et ana[j] (i < j, tous deux actifs) :
     *   → on regarde s'il existe un token "op" entre eux dans
     *     la séquence. S'il en existe plusieurs, on prend le
     *     dernier (le plus proche de ana[j]).
     *   → s'il n'y en a pas, on utilise "or" par défaut.
     *
     * Ce comportement correspond à ce que l'utilisateur voit :
     * l'op entre deux champs actifs est le dernier op visible
     * entre eux dans l'interface.
     */
    function testAnaGlobal(texte, sequence) {

        // 1. Repérer les index des tokens "ana" actifs
        const activeAna = [];
        sequence.forEach((token, idx) => {
            if (token.type === "ana" && token.el.value) {
                activeAna.push(idx);
            }
        });

        if (activeAna.length === 0) return true;

        // 2. Évaluer le résultat en chaîne
        let result = null;

        for (let k = 0; k < activeAna.length; k++) {
            const idx  = activeAna[k];
            const token = sequence[idx];

            // Ensemble des valeurs ana du texte pour cette catégorie
            const anaSet = (texte.dataset[token.cat] || "").split(/\s+/).filter(Boolean);
            const present = anaSet.includes(token.el.value);

            if (result === null) {
                // Premier token actif : pas encore d'opérateur
                result = present;
            } else {
                // Trouver l'opérateur entre activeAna[k-1] et activeAna[k]
                // = dernier token "op" entre ces deux index dans la séquence
                const prevIdx = activeAna[k - 1];
                let op = "or"; // valeur par défaut si aucun op trouvé

                for (let j = prevIdx + 1; j < idx; j++) {
                    if (sequence[j].type === "op") {
                        op = sequence[j].el.value; // on écrase jusqu'au dernier
                    }
                }

                if      (op === "without") result = result && !present;
                else if (op === "and")     result = result && present;
                else                       result = result || present;
            }
        }

        return result === null ? true : result;
    }

});
