<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:my="urn:local-functions"
    exclude-result-prefixes="tei my"
    version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:function name="my:label">
        <xsl:param name="value"/>
        <xsl:param name="type"/>
        
        <xsl:choose>
           <xsl:when test="$type = 'conjugaison'">
                <xsl:choose>
                    <xsl:when test="$value = 'indicatif_present'">indicatif présent</xsl:when>
                    <xsl:when test="$value = 'indicatif_imparfait'">indicatif imparfait</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$type = 'morphologie'">
                <xsl:choose>
                    <xsl:when test="$value = 'comparatif'">comparatif</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:when test="$type = 'syntaxe'">
                <xsl:choose>
                    <xsl:when test="$value = 'proposition_infinitive'">proposition infinitive</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
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
                        
                        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/alpheios-components@latest/dist/style/style-components.css"/>
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
                                
                                <div class="alpheios-enabled" lang="la">
                                    <xsl:apply-templates select=".//tei:ab[@type='orig']"/>
                                </div>
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
                        
                        <script type="text/javascript">
                            document.addEventListener("DOMContentLoaded", function(event) {
                              import ("https://cdn.jsdelivr.net/npm/alpheios-embedded@latest/dist/alpheios-embedded.js")
                                .then(alpheiosEmbed => {
                                  window.AlpheiosEmbed = alpheiosEmbed;
                                  alpheiosEmbed.importDependencies({ 
                                    mode: 'custom', 
                                    libs: { 
                                      components: { src: 'https://cdn.jsdelivr.net/npm/alpheios-components@latest/dist/alpheios-components.js' } 
                                    } 
                                  }).then(embedded => {
                                    embedded.activate();
                                  }).catch(e => {
                                    console.error(`Alpheios embedding failed: ${e}`)
                                  })
                                }).catch(e => {
                                  console.error(`Alpheios embedding failed: ${e}`)
                                })
                            });
                        </script>
                    </body>
                </html>
                
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
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
