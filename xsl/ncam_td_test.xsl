<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tdxf="http://teachersdomain.org/functions"
    version="2.0">
    
    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes"/>
    
    <xsl:variable name="afa_types">
        <i ref="Audio Description">audioDescription</i>
        <i ref="Caption">captions</i>
        <i ref="E-Book">e-book</i>
        <i ref="Sign Language">signLanguage</i>
        <i ref="High Contrast">highContrast</i>
        <i ref="Transcript">transcript</i>
        <i ref="Alt Text">alternativeText</i>
        <i ref="Long Description">longDescription</i>
        <i ref="Haptic">haptic</i>
    </xsl:variable>

    <xsl:function name="tdxf:afaType">
        <xsl:param name="t"/>
        <!-- 
            [Audio Description] audioDescription 
            [Caption] captions
            [E-Book]  e-book
            [Sign Language] signLanguage
            [High Contrast] highContrast
            [Transcript]  transcript
            [Alt Text]  alternativeText
            [Long Description]  longDescription
            [Haptic]  haptic
        -->
        <xsl:value-of select="$afa_types/i[@ref=$t]"/>
    </xsl:function>

    <xsl:template match="asset">
        
        <xsl:variable name="resource_code" select="../../@code"/>
        <xsl:variable name="resource_type" select="../../@media_type"/>
        <xsl:variable name="oer_level" select="@oer_level"/>
        <xsl:variable name="asset_code" select="@code"/>
        <xsl:variable name="record_id" select="concat($resource_code,'-',$asset_code)"/>
        
        <xsl:result-document href="../xml/output/{$record_id}.xml">
        
        <record xmlns="http://ns.nsdl.org/ncs/ncam_afa"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://ns.nsdl.org/ncs/ncam_afa http://ns.nsdl.org/ncs/ncam_afa/1.00/schemas/record.xsd">
            <general>
                <recordID><xsl:value-of select="$record_id"/></recordID>
                <recordDate>
                    <xsl:value-of select="substring(@date_created,1,10)"/>
                </recordDate>
                <url>
                    <xsl:value-of select="url"/>
                </url>
                <title>
                    <xsl:value-of select="asset_title"/>
                </title>
                <description>
                    <xsl:value-of select="../../resource_texts/annotation"/>
                </description>
                <xsl:for-each select="../../hierarchy_memberships/hierarchy_membership">
                    <subject>
                        <!-- Apply template to strip top levels of heirarchy -->
                        <xsl:value-of select="."/>
                    </subject>
                </xsl:for-each>
                <language>en-US</language>
                <xsl:choose>
                    <xsl:when test="mime_type">
                        <xsl:for-each select="mime_type">
                            <mimeType>
                                <xsl:value-of select="."/>
                            </mimeType>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <mimeType/>
                    </xsl:otherwise>
                </xsl:choose>
            </general>
            <educational>    
                
                <!-- Apply template to split numeric list into seperate tags-->
                <xsl:variable name="grade_band" select="../../grade_band"/>
                <xsl:variable name="pattern" select="',\s+'"/>
                <xsl:for-each select="tokenize($grade_band,$pattern)">
                    <educationLevel>Grade <xsl:value-of select="."/></educationLevel>
                </xsl:for-each>
                <!-- Can't find anything to key off of -->
                <audience>Learner</audience>
                <xsl:choose>
                    <xsl:when test="$resource_type = 'Video'">
                        <resourceType>Audio/Visual</resourceType>
                        <resourceType>Movie/Animation</resourceType>
                    </xsl:when>
                    <xsl:when test="$resource_type = 'Interactive'">
                        <resourceType>Instructional Material</resourceType>
                        <resourceType>Interactive Simulation</resourceType>
                    </xsl:when>
                    <xsl:otherwise>
                        <resourceType>Instructional Material</resourceType>
                        <resourceType>Tutorial</resourceType>                        
                    </xsl:otherwise>
                </xsl:choose>               
            </educational>
            <lifecycle>
                <publicationDate>
                    <xsl:value-of select="substring(@date_created,1,10)"/>
                </publicationDate>
                    <xsl:choose>
                        <xsl:when test="$oer_level = '1'">
                            <rights>Download</rights>
                            <rights>http://www.teachersdomain.org/oerlicense/1/</rights>
                        </xsl:when>
                        <xsl:when test="$oer_level = '2'">
                            <rights>Download and Share</rights>
                            <rights>http://www.teachersdomain.org/oerlicense/2/</rights>
                        </xsl:when>
                        <xsl:when test="$oer_level = '3'">
                            <rights>Download, Share, and Remix</rights>
                            <rights>http://www.teachersdomain.org/oerlicense/3/</rights>
                        </xsl:when>
                        <xsl:otherwise>
                            <rights>Viewed Online only</rights>
                            <rights>http://www.teachersdomain.org/terms_of_use.html</rights>
                        </xsl:otherwise>
                    </xsl:choose>
                <accessRights>Free access with registration</accessRights>
                                
                <xsl:for-each select="../../producers/producer">
                    <xsl:variable name="producer" select="./name"/>
                    <xsl:variable name="thumbnail" select="./logo"></xsl:variable>
                    <contributor role="Producer" thumbnail="{$thumbnail}" ><xsl:value-of select="$producer"/></contributor>
                </xsl:for-each>
                <xsl:for-each select="../../collection/developers/developer">
                    <xsl:variable name="developer" select="./name"/>
                    <xsl:variable name="thumbnail" select="./logo"></xsl:variable>
                    <contributor role="Developer" thumbnail="{$thumbnail}" ><xsl:value-of select="$developer"/></contributor>
                </xsl:for-each>
                <xsl:for-each select="../../collection/funders/funder">
                    <xsl:variable name="funder" select="./name"/>
                    <xsl:variable name="thumbnail" select="./logo"></xsl:variable>
                    <contributor role="Funder" thumbnail="{$thumbnail}" ><xsl:value-of select="$funder"/></contributor>
                </xsl:for-each>
            </lifecycle>
            <accessForAll>
                <xsl:for-each select="access_mode/@name">
                    <xsl:variable name="mode" select="."/>
                    <accessMode><xsl:value-of select="lower-case($mode)"/></accessMode>
                </xsl:for-each>
                <xsl:if test="./@relationship != 'Primary'">
                    <xsl:variable name="adapted_asset_code" select="is_adaptation_of/@code"/>
                    <xsl:variable name="asset_code" select="@code"></xsl:variable>
                    <xsl:for-each select="../../assets/asset">
                        <xsl:if test="./@code = $adapted_asset_code">
                            <xsl:variable name="adapted_asset_url" select="./url"></xsl:variable>
                            <isAdaptationOf><xsl:value-of select="$adapted_asset_url"/></isAdaptationOf>
                        </xsl:if>
                    </xsl:for-each>
                    
                </xsl:if>
                <xsl:for-each select="access_feature">
                    <xsl:variable name="adaptation_type" select="@name"></xsl:variable>
                    <adaptationType><xsl:value-of select="tdxf:afaType($adaptation_type)"/></adaptationType>
                </xsl:for-each>
            </accessForAll>
        </record>
    </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="text()" />
</xsl:stylesheet>