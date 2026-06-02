<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:my="urn:local-functions"
    exclude-result-prefixes="tei my"
    version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- ===================================================== -->
    <!-- FONCTION DE TRANSFORMATION DES VALEURS @ana -->
    <!-- ===================================================== -->
    <xsl:function name="my:label">
        <xsl:param name="value"/>
        <xsl:param name="type"/>
        
        <xsl:choose>

            <xsl:when test="$type = 'conjugaison'">
                <xsl:choose>
                    <xsl:when test="$value = 'indicatif_present'">indicatif présent</xsl:when>
                    <xsl:when test="$value = 'indicatif_imparfait'">indicatif imparfait</xsl:when>
                    <xsl:when test="$value = 'indicatif_parfait'">indicatif parfait</xsl:when>
                    <xsl:when test="$value = 'indicatif_plus_que_parfait'">indicatif plus-que-parfait</xsl:when>
                    <xsl:when test="$value = 'indicatif_aoriste'">indicatif aoriste</xsl:when>
                    <xsl:when test="$value = 'indicatif_futur'">indicatif futur</xsl:when>
                    <xsl:when test="$value = 'indicatif_futur_anterieur'">indicatif futur antérieur</xsl:when>

                    <xsl:when test="$value = 'subjonctif_present'">subjonctif présent</xsl:when>
                    <xsl:when test="$value = 'subjonctif_imparfait'">subjonctif imparfait</xsl:when>
                    <xsl:when test="$value = 'subjonctif_parfait'">subjonctif parfait</xsl:when>
                    <xsl:when test="$value = 'subjonctif_plus_que_parfait'">subjonctif plus-que-parfait</xsl:when>

                    <xsl:when test="$value = 'imperatif_present'">impératif présent</xsl:when>

                    <xsl:when test="$value = 'infinitif_present'">infinitif présent</xsl:when>
                    <xsl:when test="$value = 'infinitif_present_actif'">infinitif présent actif</xsl:when>
                    <xsl:when test="$value = 'infinitif_present_passif'">infinitif présent passif</xsl:when>
                    <xsl:when test="$value = 'infinitif_parfait'">infinitif parfait</xsl:when>
                    <xsl:when test="$value = 'infinitif_parfait_passif'">infinitif parfait passif</xsl:when>
                    <xsl:when test="$value = 'infinitif_futur'">infinitif futur</xsl:when>

                    <xsl:when test="$value = 'participe_present'">participe présent</xsl:when>
                    <xsl:when test="$value = 'participe_parfait'">participe parfait</xsl:when>
                    <xsl:when test="$value = 'participe_futur'">participe futur</xsl:when>
                    <xsl:when test="$value = 'participe_substantive'">participe substantivé</xsl:when>

                    <xsl:when test="$value = 'adjectif_verbal'">adjectif verbal</xsl:when>
                    <xsl:when test="$value = 'gerondif'">gérondif</xsl:when>

                    <xsl:when test="$value = 'deponent'">déponent</xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$type = 'morphologie'">
                <xsl:choose>
                    <xsl:when test="$value = 'comparatif'">comparatif</xsl:when>
                    <xsl:when test="$value = 'comparatif_adverbe'">comparatif de l'adverbe</xsl:when>
                    <xsl:when test="$value = 'superlatif'">superlatif</xsl:when>

                    <xsl:when test="$value = 'ipse'">ipse, a, um</xsl:when>
                    <xsl:when test="$value = 'is'">is, ea, id</xsl:when>
                    <xsl:when test="$value = 'ille'">ille, illa, illud</xsl:when>
                    <xsl:when test="$value = 'hic'">hic, haec, hoc</xsl:when>
                    <xsl:when test="$value = 'idem'">idem, eadem, idem</xsl:when>

                    <xsl:when test="$value = 'qui'">qui, quae, quod</xsl:when>
                    <xsl:when test="$value = 'quis'">quis, quae, quid</xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$type = 'syntaxe'">
                <xsl:choose>
                    <xsl:when test="$value = 'proposition_infinitive'">proposition infinitive</xsl:when>
                    <xsl:when test="$value = 'proposition_relative_indicatif'">proposition relative (indicatif)</xsl:when>
                    <xsl:when test="$value = 'proposition_relative_subjonctif'">proposition relative (subjonctif)</xsl:when>
                    <xsl:when test="$value = 'relatif_liaison'">relatif de liaison</xsl:when>

                    <xsl:when test="$value = 'completive_ut_subjonctif'">complétive ut + subjonctif</xsl:when>
                    <xsl:when test="$value = 'completive_ne_subjonctif'">complétive ne + subjonctif</xsl:when>

                    <xsl:when test="$value = 'interrogative_directe'">interrogative directe</xsl:when>
                    <xsl:when test="$value = 'interrogative_indirecte'">interrogative indirecte</xsl:when>
                    <xsl:when test="$value = 'exclamative'">exclamative</xsl:when>

                    <xsl:when test="$value = 'discours_indirect'">discours indirect</xsl:when>

                    <xsl:when test="$value = 'circonstancielle_temps_indicatif'">circonstancielle de temps (indicatif)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_causale_indicatif'">circonstancielle causale (indicatif)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_concessive_indicatif'">circonstancielle concessive (indicatif)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_lieu_qua'">circonstancielle de lieu (qua)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_lieu_ubi'">circonstancielle de lieu (ubi)</xsl:when>

                    <xsl:when test="$value = 'circonstancielle_finale_subjonctif'">circonstancielle finale (subjonctif)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_consecutive_subjonctif'">circonstancielle consécutive (subjonctif)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_causale_subjonctif'">circonstancielle causale (subjonctif)</xsl:when>
                    <xsl:when test="$value = 'circonstancielle_concessive_subjonctif'">circonstancielle concessive (subjonctif)</xsl:when>

                    <xsl:when test="$value = 'comparative_indicatif'">comparative (indicatif)</xsl:when>
                    <xsl:when test="$value = 'complement_comparatif'">complément du comparatif</xsl:when>
                    <xsl:when test="$value = 'quo_comparatif_ut'">quo + comparatif = ut</xsl:when>

                    <xsl:when test="$value = 'cum_indicatif'">cum + indicatif</xsl:when>
                    <xsl:when test="$value = 'cum_subjonctif'">cum + subjonctif</xsl:when>
                    <xsl:when test="$value = 'tum_cum'">tum … cum</xsl:when>
                    <xsl:when test="$value = 'quod_subjonctif'">quod + subjonctif</xsl:when>
                    <xsl:when test="$value = 'ut_indicatif'">ut + indicatif</xsl:when>

                    <xsl:when test="$value = 'passif_personnel_infinitif'">passif personnel + infinitif</xsl:when>
                    <xsl:when test="$value = 'tournure_esse_datif'">tournure esse + datif</xsl:when>
                    <xsl:when test="$value = 'attribut_cod'">attribut du COD</xsl:when>
                    <xsl:when test="$value = 'accusatif_exclamatif'">accusatif exclamatif</xsl:when>
                    <xsl:when test="$value = 'ablatif_absolu'">ablatif absolu</xsl:when>
                    <xsl:when test="$value = 'omission_esse'">omission du verbe esse</xsl:when>

                    <xsl:when test="$value = 'adjectif_verbal_epithete'">adjectif verbal épithète</xsl:when>
                    <xsl:when test="$value = 'adjectif_verbal_attribut'">adjectif verbal attribut</xsl:when>

                    <xsl:when test="$value = 'subjonctif_principale'">subjonctif en principale</xsl:when>

                    <xsl:when test="$value = 'systeme_hypothetique_reel'">système hypothétique (réel)</xsl:when>
                    <xsl:when test="$value = 'systeme_hypothetique_eventuel'">système hypothétique (éventuel)</xsl:when>
                    <xsl:when test="$value = 'systeme_hypothetique_irreel_present'">système hypothétique (irréel du présent)</xsl:when>
                    <xsl:when test="$value = 'systeme_hypothetique_irreel_passe'">système hypothétique (irréel du passé)</xsl:when>
                </xsl:choose>
            </xsl:when>

            <!-- ============ GENRE ============ -->
            <xsl:when test="$type = 'genre'">
                <xsl:choose>
                    <xsl:when test="$value = 'comedie'">comédie</xsl:when>
                    <xsl:when test="$value = 'didactique'">didactique</xsl:when>
                    <xsl:when test="$value = 'discours'">discours</xsl:when>
                    <xsl:when test="$value = 'elegie'">élégie</xsl:when>
                    <xsl:when test="$value = 'epigramme'">épigramme</xsl:when>
                    <xsl:when test="$value = 'epistolaire'">épistolaire</xsl:when>
                    <xsl:when test="$value = 'epopee'">épopée</xsl:when>
                    <xsl:when test="$value = 'fable'">fable</xsl:when>
                    <xsl:when test="$value = 'histoire'">histoire</xsl:when>
                    <xsl:when test="$value = 'philosophie'">philosophie</xsl:when>
                    <xsl:when test="$value = 'roman'">roman</xsl:when>
                    <xsl:when test="$value = 'satire'">satire</xsl:when>
                    <xsl:when test="$value = 'theatre'">théâtre</xsl:when>
                    <xsl:when test="$value = 'tragedie'">tragédie</xsl:when>
                    <xsl:when test="$value = 'litterature_technique'">littérature technique</xsl:when>
                    <xsl:when test="$value = 'compilation'">compilation</xsl:when>
                    <xsl:when test="$value = 'lyrique'">lyrique</xsl:when>
                    <xsl:when test="$value = 'epyllion'">épyllion</xsl:when>
                </xsl:choose>
            </xsl:when>

            <!-- ============ THEMES ============ -->
            <xsl:when test="$type = 'themes'">
                <xsl:choose>
                    <xsl:when test="$value = 'amitie'">amitié</xsl:when>
                    <xsl:when test="$value = 'amour'">amour</xsl:when>
                    <xsl:when test="$value = 'education'">éducation</xsl:when>
                    <xsl:when test="$value = 'eloge'">éloge</xsl:when>
                    <xsl:when test="$value = 'famille'">famille</xsl:when>
                    <xsl:when test="$value = 'guerre'">guerre</xsl:when>
                    <xsl:when test="$value = 'litterature'">littérature</xsl:when>
                    <xsl:when test="$value = 'mort'">mort</xsl:when>
                    <xsl:when test="$value = 'nature'">nature</xsl:when>
                    <xsl:when test="$value = 'philosophie'">philosophie</xsl:when>
                    <xsl:when test="$value = 'politique'">politique</xsl:when>
                    <xsl:when test="$value = 'religions'">religions</xsl:when>
                    <xsl:when test="$value = 'societe'">société</xsl:when>
                    <xsl:when test="$value = 'alterite'">altérité</xsl:when>
                    <xsl:when test="$value = 'argent'">argent</xsl:when>
                    <xsl:when test="$value = 'violence'">violence</xsl:when>
                    <xsl:when test="$value = 'quotidien'">quotidien</xsl:when>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="$type = 'programme'">
    <xsl:choose>
        <xsl:when test="$value = 'de_la_legende_du_mythe_a_l_histoire'">De la légende/du mythe à l'histoire</xsl:when>
        <xsl:when test="$value = 'vie_privee_et_vie_publique'">Vie privée et vie publique</xsl:when>
        <xsl:when test="$value = 'le_monde_mediterraneen'">Le monde méditerranéen</xsl:when>
        <xsl:when test="$value = 'l_empire_romain'">L'empire romain</xsl:when>
        <xsl:when test="$value = 'de_la_republique_au_principat'">De la république au principat</xsl:when>
        <xsl:when test="$value = 'vie_familiale_sociale_et_intellectuelle'">Vie familiale, sociale et intellectuelle</xsl:when>
        <xsl:when test="$value = 'la_grece_dans_son_unite_et_sa_diversite'">La Grèce dans son unité et sa diversité</xsl:when>
        <xsl:when test="$value = 'l_homme_et_l_animal'">L'Homme et l'animal</xsl:when>
        <xsl:when test="$value = 'l_homme_et_le_divin'">L'Homme et le divin</xsl:when>
        <xsl:when test="$value = 'soi_meme_et_l_autre'">Soi-même et l'autre</xsl:when>
        <xsl:when test="$value = 'vivre_dans_la_cite'">Vivre dans la cité</xsl:when>
        <xsl:when test="$value = 'les_dieux_dans_la_cite'">Les dieux dans la cité</xsl:when>
        <xsl:when test="$value = 'masculin_feminin'">Masculin, Féminin</xsl:when>
        <xsl:when test="$value = 'mediterranee_voyager_explorer_decouvrir'">Méditerranée : voyager, explorer, découvrir</xsl:when>
        <xsl:when test="$value = 'mediterranee_conflit_influences_et_echanges'">Méditerranée : conflit, influences et échanges</xsl:when>
        <xsl:when test="$value = 'lecons_de_sagesse_antique'">Leçons de sagesse antique</xsl:when>
        <xsl:when test="$value = 'comprendre_le_monde'">Comprendre le monde</xsl:when>
        <xsl:when test="$value = 'inventer_creer_fabriquer_produire'">Inventer, créer, fabriquer, produire</xsl:when>
        <xsl:when test="$value = 'mediterranee_presence_des_mondes_antiques'">Méditerranée : présence des mondes antiques</xsl:when>
        <xsl:when test="$value = 'la_cite_entre_realites_et_utopies'">La cité entre réalités et utopies</xsl:when>
        <xsl:when test="$value = 'justice_des_dieux_justice_des_hommes'">Justice des dieux, justice des hommes</xsl:when>
        <xsl:when test="$value = 'amour_amours'">Amour, amours</xsl:when>
        <xsl:when test="$value = 'l_homme_le_monde_le_destin'">L'homme, le monde, le destin</xsl:when>
        <xsl:when test="$value = 'croire_savoir_douter'">Croire, savoir, douter</xsl:when>
    </xsl:choose>
</xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- ===================================================== -->
    <!-- TEMPLATE PRINCIPAL -->
    <!-- ===================================================== -->
    <xsl:template match="/">
        
        <xsl:for-each select="collection('../tei?select=*.xml')">
            
            <xsl:variable name="lang"
                select=".//tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language/@ident"/>
            
            <xsl:variable name="fichier-name"
                select="normalize-space(.//tei:title[@type = 'fichier'])"/>
            
            <xsl:variable name="output-filename" select="replace($fichier-name, '\.xml$', '.html')"/>
            
            <xsl:result-document
                href="../data/{$output-filename}"
                method="html"
                encoding="UTF-8">
                
                <html lang="fr">
                    <head>
                        <meta charset="UTF-8"/>
                        <title>
                                <xsl:value-of select=".//tei:titleStmt/tei:title"/>
                        </title>
                        <link rel="stylesheet" type="text/css" href="../css/style_texte.css"/>
                    </head>
                    
                    <body>
                        <div class="texte"
                            data-langue="{$lang}"
                            data-type="{.//tei:term[@type='prose/poésie']/@subtype}"
                            data-niveau="{.//tei:term[@type='niveau']/@n}"
                            data-genre="{.//tei:term[@type='genre']/@ana}"
                            data-themes="{.//tei:term[@type='themes']/@ana}"
                            data-programme="{.//tei:term[@type='programme']/@ana}"
                            data-conjugaison="{.//tei:term[@type='conjugaison']/@ana}"
                            data-morphologie="{.//tei:term[@type='morphologie']/@ana}"
                            data-syntaxe="{.//tei:term[@type='syntaxe']/@ana}">
                            
                            <div class="badge niveau">
                                <xsl:text>Niveau </xsl:text>
                                <xsl:value-of select=".//tei:term[@type='niveau']/@n"/>
                            </div>
                            
                            <div class="badge type">
                                <xsl:choose>
                                    <xsl:when test=".//tei:term[@type='prose/poésie' and @subtype='prose']">Prose</xsl:when>
                                    <xsl:when test=".//tei:term[@type='prose/poésie' and @subtype='poesie']">Poésie</xsl:when>
                                </xsl:choose>
                            </div>
                            
                            <p class="notice">
                                <strong>
                                    <xsl:value-of select=".//tei:author"/>,
                                    <xsl:value-of select=".//tei:sourceDesc//tei:title[@type='oeuvre']"/>,
                                    <xsl:value-of select=".//tei:biblScope"/> :
                                    "<xsl:value-of select=".//tei:titleStmt/tei:title"/>"
                                </strong>
                            </p>
                            
                            <p>
                                <strong>Original (<xsl:value-of select=".//tei:term[@type='mots']/@n"/> mots environ ; 
                                <xsl:if test="normalize-space(.//tei:name[@role='editeur']) != ''"> ; éd. <xsl:value-of select=".//tei:name[@role='editeur']"/></xsl:if>) :</strong><br/>
                                <xsl:apply-templates select=".//tei:ab[@type='orig']"/>
                            </p>
                            
                            <p>
                                <strong>
                                    Français (trad.
                                    <xsl:value-of select=".//tei:name[@role='traducteur']"/>)
                                    :
                                </strong><br/>
                                <xsl:apply-templates select=".//tei:ab[@type='trad']"/>
                            </p>
                            
                            <p class="keywords grammaire">
                                <strong>Mots-clés : </strong>
                                <xsl:for-each select=".//tei:term[@ana]">
                                    <xsl:variable name="type" select="@type"/>
                                    <xsl:variable name="tokens" select="tokenize(@ana, '\s+')"/>
                                    <xsl:for-each select="$tokens">
                                        <xsl:value-of select="my:label(., $type)"/>
                                        <xsl:if test="position() != last()"> ; </xsl:if>
                                    </xsl:for-each>
                                    <xsl:if test="position() != last()"> ; </xsl:if>
                                </xsl:for-each>
                            </p>

                            <xsl:if test="normalize-space(.//tei:profileDesc/tei:abstract[@ana='utilisation_pedagogique']/tei:p) != ''">
                            <p class="pedagogy">
                            <strong>Utilisation pédagogique : </strong>
                            <xsl:value-of select=".//tei:profileDesc/tei:abstract[@ana='utilisation_pedagogique']/tei:p"/>
                            </p>
                            </xsl:if>
                            
                            <p><strong>Contribution : </strong>
                            <xsl:value-of select=".//tei:name[@role='contributeur']"/></p>
                            
                        </div>
                    </body>
                </html>
                
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- ===================================================== -->
    <!-- TEMPLATES DE CONTENU -->
    <!-- ===================================================== -->
    <xsl:template match="tei:ab[@type='orig']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:ab[@type='trad']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
</xsl:stylesheet>
