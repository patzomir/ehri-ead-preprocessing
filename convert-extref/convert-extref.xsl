<?xml version='1.0'?>
<!--
//*****************************************************************************
// Pre-process EAD files to convert <extref href="url"> to MarkDown.
//
// Distributed under the GNU General Public Licence
//*****************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions"
  version="2.0">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
  <xsl:output encoding="UTF-8"/>


  <xsl:template match="/">
      
        <xsl:apply-templates />
      
  </xsl:template>
  
  <!-- Add provenance describing the changes -->
  <xsl:template match="eadheader/revisiondesc">
      <revisiondesc>
          <xsl:call-template name="add-change" />
          <xsl:apply-templates />
      </revisiondesc>
  </xsl:template>
  
  <xsl:template match="eadheader[not(revisiondesc)]">
      <eadheader><xsl:copy-of select="@*"/>
      <xsl:apply-templates />
      <revisiondesc>
          <xsl:call-template name="add-change" />
      </revisiondesc>
      </eadheader>
  </xsl:template>
  
  <xsl:template name="add-change">
    <xsl:variable name="convertdate" select="fn:current-dateTime()" />
    <change>
      <date><xsl:attribute name="normal" select="format-dateTime($convertdate, '[Y0001]-[M01]-[D01]')" /><xsl:value-of select="format-dateTime($convertdate, '[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]')" /></date>
      <item>If there were any, EAD element extref inside accessrestrict elements have been converted to their Markdown equivalents by EHRI's preprocessing tool. 
      For example: &lt;extref href="http://example.com"&gt;some text&lt;/extref&gt; becomes [some text](http://example.com).</item>
    </change>
  </xsl:template>
  
  <xsl:template match="accessrestrict/p/extref[@href]">
      <xsl:value-of select="concat('[', normalize-space(.), ']', '(', ./@href, ')')" />
  </xsl:template>
  
  <xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
