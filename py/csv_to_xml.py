import csv
import os
import re
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
    "morphologie": {
        "comparatif": "Comparatif",
        "is": "is, ea, id"
    },
    "syntaxe": {
        "relative": "Proposition relative",
        "infinitive": "Proposition infinitive",
        "ablatif_absolu": "Ablatif absolu",
        "omission_esse": "Omission du verbe esse"
    }
}

# =========================
# 2. Fonctions utilitaires
# =========================

import unicodedata

def slug(text):
    if not text:
        return "inconnu"
    
    # 1. Traitement spécifique des références : remplacer le point par un tiret bas
    # On le fait avant la normalisation pour ne pas interférer avec d'autres points éventuels
    text = text.replace('.', '_')
    
    # 2. Remplacer les apostrophes par des tirets bas (ex: l'aurore -> l_aurore)
    text = text.replace("'", "_")
    
    # 3. Supprimer les accents (é->e, à->a, û->u, etc.)
    # La normalisation NFD décompose "é" en "e" + "accent"
    text = unicodedata.normalize('NFD', text)
    # On garde tout sauf les "accents" (catégorie 'Mn')
    text = "".join([c for c in text if unicodedata.category(c) != 'Mn'])
    
    # 4. Nettoyage final
    text = text.lower()
    # On remplace tout ce qui n'est pas alphanumérique (espaces, parenthèses) par un seul _
    text = re.sub(r"[^\w]+", "_", text)
    
    # On nettoie les doubles underscores potentiels (ex: __) et les bords
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

# =========================
# 3. Lecture CSV → TEI
# =========================

with open(CSV_FILE, newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)

    for i, row in enumerate(reader, start=1):

        auteur = row.get("Auteur", "")
        oeuvre = row.get("Oeuvre", "")
        ref = row.get("Référence", "")
        langue_code = langue(row.get("Langue", ""))

        filename = os.path.join(
            OUTPUT_DIR,
            f"{slug(langue_code)}_{slug(auteur)}_{slug(oeuvre)}_{slug(ref)}.xml"
        )

        title_fichier = (
            f"{slug(langue_code)}_{slug(auteur)}_{slug(oeuvre)}_{slug(ref)}.xml"
        )

        ana_conj = build_ana(row.get("Conj"), "conjugaison")
        ana_morph = build_ana(row.get("Morphologie"), "morphologie")
        ana_syn = build_ana(row.get("Syntaxe"), "syntaxe")

        tei = f'''<?xml version="1.0" encoding="UTF-8"?>
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
            <term type="mots" n="{row.get('Nombre de mots','')}"/>
            <term type="niveau" n="{row.get('Niveau','')}"/>
            <term type="coupe" subtype="{'oui' if row.get('Coupes') == 'TRUE' else 'non'}"/>

            {f'<term type="conjugaison" ana="{ana_conj}"/>' if ana_conj else ''}
            {f'<term type="morphologie" ana="{ana_morph}"/>' if ana_morph else ''}
            {f'<term type="syntaxe" ana="{ana_syn}"/>' if ana_syn else ''}
          </bibl>
        </listBibl>
      </sourceDesc>
    </fileDesc>

    <profileDesc>
      <langUsage>
        <language ident="{langue_code}"/>
      </langUsage>
    </profileDesc>
  </teiHeader>

  <text>
    <body>
      <ab type="orig" xml:id="texte_{i}">
        {xml_safe(row.get('Texte latin/grec'))}
      </ab>

      <ab type="trad" corresp="#texte_{i}">
        {xml_safe(row.get('Traduction'))}
      </ab>
    </body>
  </text>
</TEI>
'''

        with open(filename, "w", encoding="utf-8") as out:
            out.write(tei)

        print(f"✔ TEI créé : {filename}")




