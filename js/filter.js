document.addEventListener("DOMContentLoaded", () => {

    const compteur = document.getElementById("compteur");
    const messageVide = document.getElementById("message-vide");
    const corpus = document.getElementById("corpus");

    let textes = [];

    document.querySelectorAll("[data-src]").forEach(div => {
        fetch(div.dataset.src)
            .then(r => {
                if (!r.ok) return null;
                return r.text();
            })
            .then(html => {
                if (!html) return;

                const temp = document.createElement("div");
                temp.innerHTML = html;

                const texte = temp.querySelector(".texte");
                if (texte) {
                    corpus.appendChild(texte);
                    textes.push(texte);
                    texte.style.display = "none"; // caché par défaut
                }
            })
            .catch(() => {});
    });

    document.querySelectorAll("select")
        .forEach(select => select.addEventListener("change", appliquerFiltres));

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

            texte.style.display = visible ? "block" : "none";
            if (visible) count++;
        });

compteur.textContent = filtresActifs
    ? `${count} ${count > 1 ? "résultats trouvés" : "résultat trouvé"}`
    : "";


        messageVide.style.display =
            filtresActifs && count === 0 ? "block" : "none";
    }
});


