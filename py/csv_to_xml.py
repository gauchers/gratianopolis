import csv
import os
import re
import unicodedata
from xml.sax.saxutils import escape

# =========================
# 0. Chemins robustes
# =========================

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(SCRIPT_DIR)

CSV_FILE = os.path.join(BASE_DIR, "csv", "tableau.csv")
OUTPUT_DIR = os.path.join(BASE_DIR, "tei")

os.makedirs(OUTPUT_DIR, exist_ok=True)

if not os.path.exists(CSV_FILE):
    raise FileNotFoundError(f"CSV introuvable : {CSV_FILE}")

# =========================
# 1. Dictionnaire ANA
# =========================

ANA_LABELS = {
    "conjugaison": {
        "indicatif_present":              "Indicatif présent",
        "indicatif_imparfait":            "Indicatif imparfait",
        "indicatif_parfait":              "Indicatif parfait",
        "indicatif_plus_que_parfait":     "Indicatif plus-que-parfait",
        "indicatif_aoriste":              "Indicatif aoriste",
        "indicatif_futur":                "Indicatif futur",
        "indicatif_futur_anterieur":      "Indicatif futur antérieur",

        "subjonctif_present":             "Subjonctif présent",
        "subjonctif_imparfait":           "Subjonctif imparfait",
        "subjonctif_parfait":             "Subjonctif parfait",
        "subjonctif_plus_que_parfait":    "Subjonctif plus-que-parfait",

        "imperatif_present":              "Impératif présent",

        "infinitif_present":              "Infinitif présent",
        "infinitif_present_actif":        "Infinitif présent actif",
        "infinitif_present_passif":       "Infinitif présent passif",
        "infinitif_parfait":              "Infinitif parfait",
        "infinitif_parfait_passif":       "Infinitif parfait passif",
        "infinitif_futur":                "Infinitif futur",

        "participe_present":              "Participe présent",
        "participe_parfait":              "Participe parfait",
        "participe_futur":                "Participe futur",
        "participe_substantive":          "Participe substantivé",

        "adjectif_verbal":                "Adjectif verbal",
        "gerondif":                       "Gérondif",

        "deponent":                       "Déponent",
    },

    "morphologie": {
        "comparatif":         "Comparatif",
        "comparatif_adverbe": "Comparatif de l'adverbe",
        "superlatif":         "Superlatif",

        "ipse": "ipse, a, um",
        "is":   "is, ea, id",
        "ille": "ille, illa, illud",
        "hic":  "hic, haec, hoc",
        "idem": "idem, eadem, idem",

        "qui":  "qui, quae, quod",
        "quis": "quis, quae, quid",
    },

    "syntaxe": {
        "proposition_infinitive":                "Proposition infinitive",
        "proposition_relative_indicatif":        "Proposition relative (indicatif)",
        "proposition_relative_subjonctif":       "Proposition relative (subjonctif)",
        "relatif_liaison":                       "Relatif de liaison",

        "completive_ut_subjonctif":              "Complétive ut + subjonctif",
        "completive_ne_subjonctif":              "Complétive ne + subjonctif",

        "interrogative_directe":                 "Interrogative directe",
        "interrogative_indirecte":               "Interrogative indirecte",
        "exclamative":                           "Exclamative",

        "discours_indirect":                     "Discours indirect",

        "circonstancielle_temps_indicatif":      "Circonstancielle de temps (indicatif)",
        "circonstancielle_causale_indicatif":    "Circonstancielle causale (indicatif)",
        "circonstancielle_concessive_indicatif": "Circonstancielle concessive (indicatif)",
        "circonstancielle_lieu_qua":             "Circonstancielle de lieu (qua)",
        "circonstancielle_lieu_ubi":             "Circonstancielle de lieu (ubi)",

        "circonstancielle_finale_subjonctif":       "Circonstancielle finale (subjonctif)",
        "circonstancielle_consecutive_subjonctif":  "Circonstancielle consécutive (subjonctif)",
        "circonstancielle_causale_subjonctif":      "Circonstancielle causale (subjonctif)",
        "circonstancielle_concessive_subjonctif":   "Circonstancielle concessive (subjonctif)",

        "comparative_indicatif":       "Comparative (indicatif)",
        "complement_comparatif":       "Complément du comparatif",
        "quo_comparatif_ut":           "quo + comparatif = ut",

        "cum_indicatif":               "Cum + indicatif",
        "cum_subjonctif":              "Cum + subjonctif",
        "tum_cum":                     "tum ... cum",
        "quod_subjonctif":             "Quod + subjonctif",
        "ut_indicatif":                "Ut + indicatif",

        "passif_personnel_infinitif":  "Passif personnel + infinitif",
        "tournure_esse_datif":         "Tournure esse + datif",
        "attribut_cod":                "Attribut du COD",
        "accusatif_exclamatif":        "Accusatif exclamatif",
        "ablatif_absolu":              "Ablatif absolu",
        "omission_esse":               "Omission du verbe esse",

        "adjectif_verbal_epithete":    "Adjectif verbal épithète",
        "adjectif_verbal_attribut":    "Adjectif verbal attribut",

        "subjonctif_principale":       "Subjonctif en principale",

        "systeme_hypothetique_reel":             "Système hypothétique (réel)",
        "systeme_hypothetique_eventuel":         "Système hypothétique (éventuel)",
        "systeme_hypothetique_irreel_present":   "Système hypothétique (irréel du présent)",
        "systeme_hypothetique_irreel_passe":     "Système hypothétique (irréel du passé)",
    },

    "genre": {
        "comedie":               "Comédie",
        "didactique":            "Didactique",
        "discours":              "Discours",
        "elegie":                "Élégie",
        "epigramme":             "Épigramme",
        "epistolaire":           "Épistolaire",
        "epopee":                "Épopée",
        "fable":                 "Fable",
        "histoire":              "Histoire",
        "philosophie":           "Philosophie",
        "roman":                 "Roman",
        "satire":                "Satire",
        "theatre":               "Théâtre",
        "tragedie":              "Tragédie",
        "litterature_technique": "Littérature technique",
        "compilation":           "Compilation",
        "lyrique":               "Lyrique",
        "epyllion":              "Épyllion",
    },

    "programme": {
    "de_la_legende_du_mythe_a_l_histoire":   "De la légende/du mythe à l'histoire",
    "vie_privee_et_vie_publique":           "Vie privée et vie publique",
    "le_monde_mediterraneen":                "Le monde méditerranéen",
    "l_empire_romain":                       "L'empire romain",
    "de_la_republique_au_principat":         "De la république au principat",
    "vie_familiale_sociale_et_intellectuelle": "Vie familiale, sociale et intellectuelle",
    "la_grece_dans_son_unite_et_sa_diversite": "La Grèce dans son unité et sa diversité",
    "l_homme_et_l_animal":                   "L'Homme et l'animal",
    "l_homme_et_le_divin":                   "L'Homme et le divin",
    "soi_meme_et_l_autre":                   "Soi-même et l'autre",
    "vivre_dans_la_cite":                    "Vivre dans la cité",
    "les_dieux_dans_la_cite":                "Les dieux dans la cité",
    "masculin_feminin":                      "Masculin, Féminin",
    "mediterranee_voyager_explorer_decouvrir": "Méditerranée : voyager, explorer, découvrir",
    "mediterranee_conflit_influences_et_echanges": "Méditerranée : conflit, influences et échanges",
    "lecons_de_sagesse_antique":             "Leçons de sagesse antique",
    "comprendre_le_monde":                   "Comprendre le monde",
    "inventer_creer_fabriquer_produire":     "Inventer, créer, fabriquer, produire",
    "mediterranee_presence_des_mondes_antiques": "Méditerranée : présence des mondes antiques",
    "la_cite_entre_realites_et_utopies":     "La cité entre réalités et utopies",
    "justice_des_dieux_justice_des_hommes":   "Justice des dieux, justice des hommes",
    "amour_amours":                          "Amour, amours",
    "l_homme_le_monde_le_destin":            "L'homme, le monde, le destin",
    "croire_savoir_douter":                  "Croire, savoir, douter"
},

    "themes": {
        "alterite": "Identité et altérité",
        "amitie":      "Amitié",
        "amour":       "Amour",
        "education":   "Éducation et pédagogie",
        "eloge":       "Éloge et blâme",
        "famille":     "Famille et ancêtres",
        "guerre":      "Guerre et paix",
        "litterature": "Littérature rhétorique et arts",
        "mort":        "Mort",
        "nature":      "Nature",
        "philosophie": "Philosophie et sagesse",
        "politique":   "Politique et pouvoir",
        "religions":    "Religions et mythologie",
        "societe":     "Société",
        "quotidien":    "Vie quotidienne et realia",
        "argent":      "Argent et commerce",
        "violence":     "Violence et lutte",
    },
}

# =========================
# 2. Fonctions utilitaires
# =========================

def slug(text):
    if not text:
        return "inconnu"
    text = text.replace(".", "_")
    text = text.replace("'", "_")
    text = unicodedata.normalize("NFD", text)
    text = "".join(c for c in text if unicodedata.category(c) != "Mn")
    text = text.lower()
    text = re.sub(r"[^\w]+", "_", text)
    return re.sub(r"_+", "_", text).strip("_")


def xml_safe(text):
    return escape(text.strip()) if text else ""


def normalize(text):
    return re.sub(r"\s+", " ", text.strip()) if text else ""


def build_ana(field_value, category):
    if not field_value:
        return ""
    field_value = normalize(field_value)
    result = []
    for key, label in ANA_LABELS[category].items():
        if label in field_value:
            result.append(key)
    return " ".join(result)


def prose_poesie(value):
    return slug(value) if value else ""


def langue(value):
    codes = {"Latin": "la", "Grec": "grc"}
    return codes.get(value, value.lower() if value else "")


def lines_to_l(text):
    """Transforme un texte avec sauts de ligne en balises <l>"""
    if not text:
        return ""
    lines = re.split(r"\r?\n+", text.strip())
    return "\n        ".join(
        f"<l>{xml_safe(line)}</l>"
        for line in lines
        if line.strip()
    )


# =========================
# 3. Lecture CSV -> TEI
# =========================

with open(CSV_FILE, newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)

    for i, row in enumerate(reader, start=1):

        auteur      = row.get("Auteur", "")
        oeuvre      = row.get("Oeuvre", "")
        ref         = row.get("Référence", "")
        langue_code = langue(row.get("Langue", ""))

        filename = os.path.join(
            OUTPUT_DIR,
            f"{slug(langue_code)}_{slug(auteur)}_{slug(oeuvre)}_{slug(ref)}.xml"
        )

        title_fichier = (
            f"{slug(langue_code)}_{slug(auteur)}_{slug(oeuvre)}_{slug(ref)}.xml"
        )

        ana_conj   = build_ana(row.get("Conj"),        "conjugaison")
        ana_morph  = build_ana(row.get("Morphologie"), "morphologie")
        ana_syn    = build_ana(row.get("Syntaxe"),     "syntaxe")
        ana_genre  = build_ana(row.get("Genre"),       "genre")
        ana_themes = build_ana(row.get("Themes"),      "themes")
        ana_programme = build_ana(row.get("Programme"),      "programme")

        # Construction des lignes <term> optionnelles
        term_conj   = f'<term type="conjugaison" ana="{ana_conj}"/>' if ana_conj else ""
        term_morph  = f'<term type="morphologie" ana="{ana_morph}"/>' if ana_morph else ""
        term_syn    = f'<term type="syntaxe" ana="{ana_syn}"/>' if ana_syn else ""
        term_genre  = f'<term type="genre" ana="{ana_genre}"/>' if ana_genre else ""
        term_themes = f'<term type="themes" ana="{ana_themes}"/>' if ana_themes else ""
        term_programme = f'<term type="programme" ana="{ana_programme}"/>' if ana_programme else ""

        # Filtrage des lignes vides pour un XML propre
        optional_terms = "\n            ".join(
            t for t in [term_conj, term_morph, term_syn, term_genre, term_themes, term_programme] if t
        )

        tei = f"""<?xml version="1.0" encoding="UTF-8"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
  <teiHeader>
    <fileDesc>
      <titleStmt>
        <title>{xml_safe(row.get("Titre du texte"))}</title>

        <respStmt>
          <resp>Contributeur</resp>
          <name role="contributeur">{xml_safe(row.get("Contributrice"))}</name>
        </respStmt>

        <respStmt>
          <resp>Edition</resp>
          <name role="editeur">{xml_safe(row.get("Edition", ""))}</name>
        </respStmt>

        <respStmt>
          <resp>Traducteur</resp>
          <name role="traducteur">{xml_safe(row.get("Crédit Traduction"))}</name>
        </respStmt>

        <respStmt>
          <resp>Encodage</resp>
          <name>Sarah GAUCHER</name>
        </respStmt>

        <principal>Sarah GAUCHER</principal>
      </titleStmt>

      <publicationStmt>
        <p>Publication interne</p>
      </publicationStmt>

      <sourceDesc>
        <listBibl>
          <bibl>
            <author>{xml_safe(auteur)}</author>
            <title type="oeuvre">{xml_safe(oeuvre)}</title>
            <title type="fichier">{xml_safe(title_fichier)}</title>
            <biblScope>{xml_safe(ref)}</biblScope>

            <term type="prose/poésie" subtype="{prose_poesie(row.get('Prose/poésie'))}"/>
            <term type="mots" n="{row.get('Nombre de mots', '')}"/>
            <term type="niveau" n="{row.get('Niveau', '')}"/>
            <term type="coupe" subtype="{'oui' if row.get('Coupes') == 'TRUE' else 'non'}"/>

            {optional_terms}
          </bibl>
        </listBibl>
      </sourceDesc>
    </fileDesc>

    <profileDesc>
      <langUsage>
        <language ident="{langue_code}"/>
      </langUsage>
       <abstract ana="utilisation_pedagogique">
        <p>{xml_safe(row.get("Utilisation pédagogique", ""))}</p>
      </abstract>
    </profileDesc>
  </teiHeader>

  <text>
    <body>
      <ab type="orig" xml:id="texte_{i}">
        {lines_to_l(row.get('Texte latin/grec'))}
      </ab>

      <ab type="trad" corresp="#texte_{i}">
        {lines_to_l(row.get('Traduction'))}
      </ab>
    </body>
  </text>
</TEI>
"""

        with open(filename, "w", encoding="utf-8") as out:
            out.write(tei)

        print(f"OK TEI créé : {filename}")
