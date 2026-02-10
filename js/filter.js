document.addEventListener("DOMContentLoaded", () => {

    const corpus = document.getElementById("corpus");
    const compteur = document.getElementById("compteur");

    // Charger tous les textes
    document.querySelectorAll("[data-src]").forEach(div => {
        fetch(div.dataset.src)
            .then(r => r.text())
            .then(html => {
                div.innerHTML = html;
                appliquerFiltres();
            });
    });

    // Filtres
    document.querySelectorAll("#langue, #type, #niveau")
        .forEach(select => select.addEventListener("change", appliquerFiltres));

    function appliquerFiltres() {
        const langue = document.getElementById("langue").value;
        const type = document.getElementById("type").value;
        const niveau = document.getElementById("niveau").value;

        let count = 0;

        document.querySelectorAll(".texte").forEach(texte => {
            let visible = true;

            if (langue && texte.dataset.langue !== langue) visible = false;
            if (type && texte.dataset.type !== type) visible = false;
            if (niveau && texte.dataset.niveau !== niveau) visible = false;

            texte.style.display = visible ? "block" : "none";
            if (visible) count++;
        });

        compteur.textContent = `${count} résultats trouvés`;
    }

});

