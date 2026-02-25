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
        <xsl:when test="$value = 'comparatif_adverbe'">comparatif de l’adverbe</xsl:when>
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
                    </head>
                    
                    <body>
                        <div class="texte"
                            data-langue="{$lang}"
                            data-type="{.//tei:term[@type='prose/poésie']/@subtype}"
                            data-niveau="{.//tei:term[@type='niveau']/@n}"
                            data-conjugaison="{.//tei:term[@type='conjugaison']/@ana}"
                            data-morphologie="{.//tei:term[@type='morphologie']/@ana}"
                            data-syntaxe="{.//tei:term[@type='syntaxe']/@ana}">
                            
                            <div class="badge niveau">
                                <xsl:text>Niveau </xsl:text>
                                <xsl:value-of select=".//tei:term[@type='niveau']/@n"/>
                            </div>
                            
                            <div class="badge type">
                                <xsl:choose>
                                    <xsl:when test=".//tei:term[@type='prose/poésie' and @subtype= 'prose']">Prose</xsl:when>
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
                                <strong>Texte latin (<xsl:value-of select=".//tei:term[@type='mots']/@n"/> mots environ) :</strong><br/>
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
                                <strong>Grammaire : </strong>
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
