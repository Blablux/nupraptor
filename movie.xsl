<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:strip-space elements="*"/>
<xsl:template match="/">Titre;Année;Durée;Genre;Date d'ajout
<xsl:for-each select="videodb/movie">
  <xsl:sort select="dateadded" order="descending"/>
    <xsl:value-of select="title"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="year"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="runtime"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="genre"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="dateadded"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
