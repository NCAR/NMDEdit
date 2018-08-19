<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml" 
    xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:my="http://my-functions">

  <!-- ncarDialect_AllLevelsHTML.xsl ********************************************************************

        From a pathname to ISO 19115 metadata xml records, creates a report HTML file for totals 
        of metadata elements with horizontal bar graphs and color coded scores for each element. 

        This can be run separately on XML folders, or from the top WAF directory for all folders. 

        Uses XSLT 2.0 collection() function with Saxon 9 syntax to get the list of *.xml files to index

        Syntax for command:
            java net.sf.saxon.Transform -s:../WAFs/labs.xml -xsl:QScores/ncarDialect_AllLevels.xsl -o:out/Lab_scores/unidata_Level2Scores.xml WAF_BASE=../WAFs recordSetPath=unidata
            where labs.xml = 
                <collection stable="true">
                </collection>
   ****************************************************************************************************** -->
 	<xsl:output method="html" omit-xml-declaration="yes"/>
    <xsl:param name="WAF_BASE"/>
    <xsl:param name="recordSetPath"/>
    <xsl:param name="fileNamePattern" select="'*.xml'"/>
    <xsl:variable name="recordSetName" select="$recordSetPath"/>
    <xsl:param name="scoringDate" select="current-dateTime()"/>
	<xsl:variable name="rubricVersion" select="'1.35-ds'"/>

	<!-- *********************************************************************** -->
    <!--   get all XML files from a lab's WAF that have been downloaded to a     -->
    <!-- directory and the full path given as a parameter on the command line    -->
	<!-- *********************************************************************** -->
	<xsl:template match="/">
      <RecordSet recordSetName="{$recordSetName}" scoringDate="{$scoringDate}">
          <!-- get records from the file system path to the WAF -->
          <!--  for each *.xml file found in this directory...  -->
          <xsl:variable name="xmlFilesSelect">
            <xsl:choose>
              <xsl:when test="$WAF_BASE">
                <xsl:value-of select="concat($WAF_BASE, '/', $recordSetPath, '?select=', $fileNamePattern)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($recordSetPath, '?select=', $fileNamePattern)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:for-each select="collection(iri-to-uri($xmlFilesSelect))">
            <xsl:sort select="subsequence(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title,1,1)"/>
            <xsl:apply-templates>
              <xsl:with-param name="xmlFile" select="tokenize(document-uri(.), '/')[last()]"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
      </RecordSet>
    </xsl:template>
	<!-- *********************************************************************** -->

    <xsl:template match="gmd:MD_Metadata">
        <xsl:param name="xmlFile"/>
        <xsl:param name="position" select="'0'"/>
        <xsl:variable name="recordTitle" select="normalize-space(subsequence(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title,1,1))"/>
        <xsl:variable name="metadataDate" select="normalize-space(subsequence(/*/gmd:dateStamp/gco:Date | /*/gmd:dateStamp/gco:DateTime,1,1))"/>

    <!-- *************************************** -->
    <!--                 Level 1                 -->
    <!-- *************************************** -->

        <!-- File Identifier -->
		<xsl:variable name="fileIDExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fileIDCnt" select="count(//gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString)"/>

        <!-- Abstract -->
        <xsl:variable name="abstractExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="abstractCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)"/>

        <!-- Asset Type -->
        <xsl:variable name="assetTypeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:hierarchyLevel/gmd:MD_ScopeCode != '')">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="assetTypeCnt" select="count(//gmd:hierarchyLevel/gmd:MD_ScopeCode)"/>

        <!-- Author -->
        <xsl:variable name="authorExist">
            <xsl:choose> 
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'author'])">1</xsl:when> 
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="authorCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='author'])"/>

        <!-- Data Identification (if a dataset) -->
        <xsl:variable name="DataIdentificationExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Dataset Language -->  
        <xsl:variable name="datasetLanguageExist">
            <xsl:choose>
		        <xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode) != '' or normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString) != '' ">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="datasetLanguageCnt" select="count(normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode) != '' or normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString) != '')"/>

         <!-- Landing Page -->
        <xsl:variable name="landingPageExist">
            <xsl:choose>
                <xsl:when test="(//gmd:dataSetURI/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="landingPageCnt" select="count(//gmd:dataSetURI/gco:CharacterString)"/>        

        <!-- Metadata Contact -->
		<xsl:variable name="metadataContactExist">
			<xsl:choose>
				<xsl:when test="normalize-space(/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) != '' or normalize-space(/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString) != '' or  normalize-space(/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="metadataContactCnt" select="count(//gmd:MD_Metadata/gmd:contact)"/>

        <!-- Metadata Date -->
        <xsl:variable name="metadataDateStampCnt" select="count(normalize-space(subsequence(/*/gmd:dateStamp/gco:Date | /*/gmd:dateStamp/gco:DateTime,1,1)))"/>
 
        <!-- Metadata Standard Name -->
        <xsl:variable name="metadataStandardNameExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataStandardName/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="metadataStandardNameCnt" select="count(//gmd:metadataStandardName/gco:CharacterString)"/>

        <!-- Metadata Standard Version -->
        <xsl:variable name="metadataStandardVersionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataStandardVersion/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="metadataStandardVersionCnt" select="count(//gmd:metadataStandardVersion/gco:CharacterString)"/>

	    <!-- Other Constraints -->
        <xsl:variable name="otherConstraintsExist">
            <xsl:choose>
		        <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="otherConstraintsCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString)"/>

        <!-- Publication date --> 
        <xsl:variable name="publicationDateExist"> 
            <xsl:choose>  
                <xsl:when test="(//gmd:citation//gmd:CI_DateTypeCode[@codeListValue = 'publication'])">1</xsl:when>  
                <xsl:otherwise>0</xsl:otherwise> 
            </xsl:choose> 
        </xsl:variable> 
        <xsl:variable name="publicationDateCnt" select="count(//gmd:citation//gmd:CI_DateTypeCode[@codeListValue = 'publication'])"/> 
 
        <!-- Publisher -->
        <xsl:variable name="publisherExist">  
            <xsl:choose> 
                <xsl:when test="(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue = 'publisher'])">1</xsl:when> 
                <xsl:otherwise>0</xsl:otherwise> 
            </xsl:choose> 
		</xsl:variable>
        <xsl:variable name="publisherCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='publisher'])"/>
 
		<!-- Resource Contact (point of contact)  -->
		<xsl:variable name="resourceContactExist">
			<xsl:choose>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="resourceContactCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty)"/>

        <!-- Resource Type (DataCite) -->
        <xsl:variable name="resourceTypeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='Resource Type')">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceTypeCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='Resource Type')"/>

		<!-- Title -->
		<xsl:variable name="title" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		<xsl:variable name="titleCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString)"/>
		<xsl:variable name="titleExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <!-- Use Contraints -->
        <xsl:variable name="useConstraintsExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="useConstraintsCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString)"/>
        
    <!-- *************************************** -->
    <!--                Level 2                  -->
    <!-- *************************************** -->

		<!-- Citation Date -->
		<xsl:variable name="citationDateExist">
			<xsl:choose>
				<xsl:when test="(//gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date | //gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
        <xsl:variable name="citationDateCnt" select="count(//gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date | //gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime)"/>

        <!-- Credit -->
        <xsl:variable name="creditExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:credit/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="creditCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:credit/gco:CharacterString)"/>

        <!-- Custodian -->
        <xsl:variable name="custodianExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'custodian'])">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="custodianCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='custodian'])"/>

        <!-- Geographic Extent  --> 
        <xsl:variable name="datasetExtentExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="datasetExtentCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)"/>

        <xsl:variable name="datasetExtentDescriptionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="datasetExtentDescriptionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description/gco:CharacterString)"/>

        <xsl:variable name="startDateExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="startDateCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition)"/>

        <xsl:variable name="endDateExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="endDateCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition)"/>

		<!-- Keywords -->
		<xsl:variable name="keywordExist">
			<xsl:choose>
				<xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="keywordCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString)"/>

        <!-- Originator -->
        <xsl:variable name="originatorExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'originator'])">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="originatorCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='originator'])"/>

        <!-- Principal Investigator (Science Support Contact) -->
        <xsl:variable name="piExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'principalInvestigator'] or //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator')">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="piCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator'] and //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator')"/>

        <!-- Reference System -->
        <xsl:variable name="referenceSystemExist">
            <xsl:choose>
                <xsl:when test="normalize-space(//gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' or
normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' or
(normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:projection/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' and
normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:ellipsoid/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' and
normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:datum/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' )">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="referenceSystemCnt" select="count(gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem)"/>

        <!-- Resource Provider -->
        <xsl:variable name="resourceProviderExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'resourceProvider'])">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceProviderCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='resourceProvider'])"/>

        <!-- Spatial Representation Type -->
	<!--	<xsl:variable name="spatialRepresentationTypeCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType)"/>  -->
		<xsl:variable name="spatialRepresentationTypeCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/MD_SpatialRepresentationTypeCode[@codeListValue])"/>

		<xsl:variable name="spatialRepresentationTypeExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spatialRepresentationType_Group">
			<xsl:choose>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='grid'] and //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='vector'])">3</xsl:when>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='grid'])">2</xsl:when>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='vector'])">1</xsl:when>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='textTable'] or //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='tin'] or //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='stereoModel'] or
                        //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='video'])">0</xsl:when>
				<xsl:otherwise>
					<!-- if no spatialRepresentationTypeCode is defined, MD_SpatialRepresentation and MD_ContentInformation are studied -->
					<xsl:choose>
						<xsl:when test="(//gmd:spatialRepresentationInfo/gmd:MD_GridSpatialRepresentation/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer) and (//gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:topologyLevel/gmd:MD_TopologyLevelCode[@codeListValue]	or //gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:geometricObjects/gmd:MD_GeometricObjects/gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode[@codeListValue])">3</xsl:when>
						<xsl:when test="(//gmd:spatialRepresentationInfo/gmd:MD_GridSpatialRepresentation/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer)">2</xsl:when>
						<xsl:when test="(//gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:topologyLevel/gmd:MD_TopologyLevelCode[@codeListValue] or //gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:geometricObjects/gmd:MD_GeometricObjects/gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode[@codeListValue])">1</xsl:when>
						<xsl:when test="(//gmd:contentInfo/gmd:MD_CoverageDescription/gmd:attributeDescription/gco:RecordType or //gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType) and (//gmd:MD_FeatureCatalogueDescription/gmd:includedWithDataset/gco:Boolean)">3</xsl:when>
						<xsl:when test="(//gmd:contentInfo/gmd:MD_CoverageDescription/gmd:attributeDescription/gco:RecordType or //gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType)">2</xsl:when>
						<xsl:when test="(//gmd:MD_FeatureCatalogueDescription/gmd:includedWithDataset/gco:Boolean)">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spatialRepresentationType_GroupName">
			<xsl:choose>
				<xsl:when test="$spatialRepresentationType_Group='0'">textTable, tin, stereoModel, video or undefined</xsl:when>
				<xsl:when test="$spatialRepresentationType_Group='1'">vector</xsl:when>
				<xsl:when test="$spatialRepresentationType_Group='2'">grid</xsl:when>
				<xsl:when test="$spatialRepresentationType_Group='3'">grid and vector</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

        <!-- Spatial Resolution -->
        <xsl:variable name="spatialResolutionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="spatialResolutionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution)"/>

        <!-- Temporal Extent -->
        <xsl:variable name="temporalExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="temporalCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent)"/>

        <!-- Time Interval -->
        <xsl:variable name="temporalResolutionExist">
            <xsl:choose> 
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:timeInterval)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="temporalResolutionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:timeInterval)"/>

        <!-- Theme, aka GCMD keywords-->
		<xsl:variable name="themeKeywordExist">
			<xsl:choose>
				<xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme'])">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="themeKeywordCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme'])"/>

		<xsl:variable name="themeKeywordThesaurusExist">
			<xsl:choose>
				<xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme']/ancestor::node()/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="themeKeywordThesaurusCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme']/ancestor::node()/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString)"/>

		<!-- Topic Category -->
		<xsl:variable name="topicCategoryExist">
			<xsl:choose>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topicCategoryCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode)"/>

        <!-- Vertical Extent -->
        <xsl:variable name="verticalExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="verticalCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent)"/>

    <!-- *************************************** -->
    <!--                Level 3                  -->
    <!-- *************************************** -->

        <!-- Additional Information -->
        <xsl:variable name="additionalInformationExist">
            <xsl:choose>
                <xsl:when test="contains(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString, 'Documentation') or (//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="additionalInformationCnt" select="count((//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString) or starts-with(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:name/gco:CharacterString, 'Documentation'))"/>

        <!-- Alternate Identifier -->
        <xsl:variable name="alternateID" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString"/>
        <xsl:variable name="alternateIDExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="alternateIDCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString)"/>

        <!-- Asset Size -->
        <xsl:variable name="assetSizeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:transferSize)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="assetSizeCnt" select="count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:transferSize)"/>

        <!-- Author Identifier -->
        <xsl:variable name="authorIdentifierExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gmx:Anchor)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="authorIdentifierCnt" select="count(//gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gmx:Anchor)"/>

		<!-- Distributor -->
		<xsl:variable name="distributorContactExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) != '' or   
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString) != '' or 
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString) != '' or  
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:formatDistributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) != '' or  
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:formatDistributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString) != '' or  
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:formatDistributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString) != '' or 
//gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="distributorContactCnt">
			<xsl:choose>
				<xsl:when test="$distributorContactExist = 1 "><xsl:value-of select="count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty | //gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty)"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <!-- Distribution Format -->
        <xsl:variable name="distributionFormatExist">
            <xsl:choose>
                <xsl:when test="(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name/gco:CharacterString) != '' or (//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString) != '' or  (//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:operationName/gco:CharacterString) != '' ">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="distributionFormatCnt" select="count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name/gco:CharacterString) + count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString) + count(//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:operationName/gco:CharacterString)"/>

        <!-- Progress -->
        <xsl:variable name="progressExist">
            <xsl:choose>
                <xsl:when test="//gmd:MD_DataIdentification/gmd:status/gmd:MD_ProgressCode/@codeListValue">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="progressCnt" select="count(//gmd:MD_DataIdentification/gmd:status/gmd:MD_ProgressCode/@codeListValue)"/>

        <!-- Related Resource -->
        <xsl:variable name="relatedResourceExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:linkage)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:linkage)"/>

        <!-- Related Resource Description -->
        <xsl:variable name="relatedResourceDescriptionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:description/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceDescriptionCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:description/gco:CharacterString)"/>

        <!-- Related Resource Name -->
        <xsl:variable name="relatedResourceNameExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceNameCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString)"/>

        <!-- Related Resource Type -->
        <xsl:variable name="relatedResourceTypeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode/@codeListValue)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceTypeCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode/@codeListValue)"/>

        <!-- Resource Format -->
        <xsl:variable name="resourceFormatExist">
            <xsl:choose>
                <xsl:when test="(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceFormat/gmd:MD_Format/gmd:name/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceFormatCnt" select="count(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceFormat/gmd:MD_Format/gmd:name/gco:CharacterString)"/>

        <!-- Resource Version -->
        <xsl:variable name="resourceVersionExist">
            <xsl:choose>
                <xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:edition/gco:CharacterString) != '' ">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceVersionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:edition/gco:CharacterString)"/>

        <!-- Software Implementation Language -->
        <xsl:variable name="softwareImplementationLanguage">
            <xsl:choose>
                <xsl:when test="(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:environmentDescription/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="softwareImplementationLanguageCnt" select="count(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:environmentDescription/gco:CharacterString)"/>

        <!-- Levels Scores -->
        <xsl:variable name="level1Score" select="$abstractExist + $assetTypeExist + $authorExist + $DataIdentificationExist + $datasetLanguageExist + $fileIDExist + $landingPageExist + $metadataContactExist + $metadataDateStampCnt + $metadataStandardNameExist + $metadataStandardVersionExist + $otherConstraintsExist + $publicationDateExist + $publisherExist + $resourceContactExist + $resourceTypeExist + $titleExist + $useConstraintsExist"/>
        <xsl:variable name="level1Max">18</xsl:variable>
        <xsl:variable name="level1Total" select="$abstractCnt + $assetTypeCnt + $authorCnt + $DataIdentificationExist + $datasetLanguageCnt + $fileIDCnt + $landingPageCnt + $metadataContactCnt + $metadataDateStampCnt + $metadataStandardNameCnt + $metadataStandardVersionCnt + $otherConstraintsCnt + $publicationDateCnt + $publisherCnt + $resourceContactCnt + $resourceTypeCnt + $titleCnt + $useConstraintsCnt"/>

        <xsl:variable name="level2Score" select="$citationDateExist + $creditExist + $custodianExist + $datasetExtentExist + $datasetExtentDescriptionExist + $startDateExist + $endDateExist + $keywordExist + $originatorExist + $piExist + $referenceSystemExist + $resourceProviderExist + $spatialRepresentationTypeExist + $spatialResolutionExist + $temporalExist + $temporalResolutionExist + $themeKeywordExist + $themeKeywordThesaurusExist + $topicCategoryExist + $verticalExist"/>
        <xsl:variable name="level2Max">20</xsl:variable>
        <xsl:variable name="level2Total" select="$citationDateCnt + $creditCnt + $custodianCnt + $datasetExtentCnt + $datasetExtentDescriptionCnt + $startDateCnt + $endDateCnt + $keywordCnt + $originatorCnt + $piCnt + $referenceSystemCnt + $resourceProviderCnt + $spatialRepresentationTypeCnt + $spatialResolutionCnt + $temporalCnt + $temporalResolutionCnt + $themeKeywordCnt + $themeKeywordThesaurusCnt + $topicCategoryCnt + $verticalCnt"/>

        <xsl:variable name="level3Score" select="$additionalInformationExist + $alternateIDExist + $assetSizeExist + $authorIdentifierExist + $distributorContactExist + $distributionFormatExist + $progressExist + $relatedResourceExist + $relatedResourceDescriptionExist + $relatedResourceNameExist + $relatedResourceTypeExist + $resourceFormatExist + $resourceVersionExist + $softwareImplementationLanguage"/>
        <xsl:variable name="level3Max">14</xsl:variable>
        <xsl:variable name="level3Total" select="$additionalInformationCnt + $alternateIDCnt + $assetSizeCnt + $authorIdentifierCnt + $distributorContactCnt + $distributionFormatCnt + $progressCnt + $relatedResourceCnt + $relatedResourceDescriptionCnt + $relatedResourceNameCnt + $relatedResourceTypeCnt + $resourceFormatCnt + $resourceVersionCnt + $softwareImplementationLanguageCnt"/>

		<xsl:variable name="coreCnt" select="$fileIDExist + $titleExist + $topicCategoryExist + $metadataContactExist + $resourceContactExist + $metadataStandardNameExist + $metadataStandardVersionExist"/>
		<xsl:variable name="coreMax">7</xsl:variable>
		<xsl:variable name="coreTotal" select="$fileIDCnt + $titleCnt + $topicCategoryCnt + $metadataContactCnt + $resourceContactCnt + $metadataStandardNameCnt + $metadataStandardVersionCnt"/>
		<xsl:variable name="citationCnt" select="$citationDateExist + $authorExist + $publisherExist + $piExist + $custodianExist + $originatorExist + $resourceProviderExist + $creditExist"/>
		<xsl:variable name="citationMax">8</xsl:variable>
		<xsl:variable name="citationTotal" select="$citationDateCnt + $authorCnt + $publisherCnt + $piCnt + $custodianCnt + $originatorCnt + $resourceProviderCnt + $creditCnt"/>
        <xsl:variable name="distributionCnt" select="$distributorContactExist + $distributionFormatExist"/>
        <xsl:variable name="distributionMax">2</xsl:variable>
        <xsl:variable name="distributionTotal" select="$distributorContactCnt + $distributionFormatCnt"/>
        <xsl:variable name="referenceCnt" select="$referenceSystemExist + $spatialRepresentationTypeExist + $spatialResolutionExist"/>
		<xsl:variable name="referenceMax">3</xsl:variable>
        <xsl:variable name="referenceTotal" select="$referenceSystemCnt + $spatialRepresentationTypeCnt + $spatialResolutionCnt"/>
        <xsl:variable name="totalKeywordCnt" select="$keywordExist + $themeKeywordExist + $themeKeywordThesaurusExist"/>
        <xsl:variable name="keywordMax">3</xsl:variable>
        <xsl:variable name="keywordTotal" select="$keywordCnt + $themeKeywordCnt + $themeKeywordThesaurusCnt"/>
        <xsl:variable name="extentCnt" select="$datasetExtentExist + $datasetExtentDescriptionExist + $temporalExist + $startDateExist + $endDateExist + $verticalExist"/>
		<xsl:variable name="extentMax">6</xsl:variable>
        <xsl:variable name="extentTotal" select="$datasetExtentCnt + $datasetExtentDescriptionCnt + $temporalCnt + $startDateCnt + $endDateCnt + $verticalCnt"/>
		<xsl:variable name="spiralCnt" select="$coreCnt + $citationCnt + $distributionCnt + $referenceCnt + $totalKeywordCnt + $extentCnt"/>
		<xsl:variable name="spiralMax" select="$coreMax + $citationMax + $distributionMax + $referenceMax + $keywordMax + $extentMax"/>
		<xsl:variable name="spiralTotal" select="$coreTotal + $citationTotal + $distributionTotal + $referenceTotal + $keywordTotal + $extentTotal"/>
        <xsl:variable name="level1Cnt">15</xsl:variable>
        <xsl:variable name="level2Cnt" select="$spiralCnt - $distributionCnt"/>
        <xsl:variable name="level3Cnt" select="$distributionCnt"/>
        <xsl:variable name="levelsCnt" select="$level1Cnt + $level2Cnt + $level3Cnt"/>
        <xsl:variable name="levelsTotal" select="$level1Total + $level2Total + $level3Total"/>
        <xsl:variable name="levelsScore" select="$level1Score + $level2Score + $level3Score"/>
        <xsl:variable name="levelsMax" select="$level1Max + $level2Max + $level3Max"/>
		<!-- *************** -->

        <!-- Web page report -->
		<html>
			<head>
				<link href="base.css" type="text/css" rel="stylesheet"/>
				<link href="geo_main.css" type="text/css" rel="stylesheet"/>
				<link href="customXSL.css" type="text/css" rel="stylesheet"/>
			</head>
			<body>
				<h1> NCAR Dialect Completeness Report</h1>
				<h2> Title: <xsl:value-of select="$title"/></h2>
				<a name="Total Score"/>
			    <h2> Total Score: <xsl:value-of select="$levelsScore"/> concepts/out of a possible <xsl:value-of select="$levelsMax"/> </h2>
                <p>Summary of the results, by category of metadata. The columns show the % of the elements in that category that exist in the record. </p>

				<style type="text/css">
					table {
					    empty-cells:show;
					}
                    h3 {
                        text-align: right;
                        display: inline;
                    }
				</style>

				<table class="tableFullDescription" width="100%" border="1">
					<tr class="vrdr_container_odd">
						<th class="caption">Category</th>
						<th >None
						</th>
						<th>1-33% 
						</th>
						<th>34-66% 
						</th>
						<th>67-99% 
						</th>
						<th>All
						</th>
					</tr>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Total Score'"/>
						<xsl:with-param name="total" select="$levelsScore"/>
						<xsl:with-param name="max" select="$levelsMax"/>
					</xsl:call-template>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Citation'"/>
						<xsl:with-param name="total" select="$citationCnt"/>
						<xsl:with-param name="max" select="$citationMax"/>
					</xsl:call-template>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Reference'"/>
						<xsl:with-param name="total" select="$referenceCnt"/>
						<xsl:with-param name="max" select="$referenceMax"/>
					</xsl:call-template>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Extent'"/>
						<xsl:with-param name="total" select="$extentCnt"/>
						<xsl:with-param name="max" select="$extentMax"/>
					</xsl:call-template>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Keyword'"/>
						<xsl:with-param name="total" select="$keywordCnt"/>
						<xsl:with-param name="max" select="$keywordMax"/>
					</xsl:call-template>
				</table>
                <p>
				<!-- NCAR Dialect Score Table  -->
                <h3> Record: <xsl:value-of select="$xmlFile"/></h3>     (<xsl:value-of select="$spatialRepresentationType_GroupName"/>)
                </p>
				<table class="tableFullDescription" width="100%" border="1" cellpadding="2" cellspacing="2">
					<tr>
						<td align="center" bgcolor="#B8CCE4">
							<b>
								<font color="#173750">Tier1</font>
							</b>
						</td>
						<td align="center" bgcolor="#B8CCE4">
							<b>
								<font color="#173750">
									<xsl:value-of select="$level1Total"/>
								</font>
							</b>
						</td>
						<td align="center" bgcolor="#B8CCE4">
							<b>
								<font color="#17375D">Tier 2</font>
							</b>
						</td>
						<td align="center" bgcolor="#B8CCE4">
							<b>
								<font color="#17375D">
									<xsl:value-of select="$level2Total"/>
								</font>
							</b>
						</td>
						<td align="center" bgcolor="#B8CCE4">
							<b>
								<font color="#17375D">Tier 3</font>
							</b>
						</td>
						<td align="center" bgcolor="#B8CCE4">
							<b>
								<font color="#17375D">
									<xsl:value-of select="$level3Total"/>
								</font>
							</b>
						</td>
					</tr>
                    <!-- Score Details -->
                    <tr><td>Abstract</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$abstractCnt"/> </xsl:call-template><td>Citation Date</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$citationDateCnt"/> </xsl:call-template><td>Additional Information</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$additionalInformationCnt"/> </xsl:call-template></tr>
                    <tr><td>Asset Type</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$assetTypeCnt"/> </xsl:call-template><td>Credit</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$creditExist"/> </xsl:call-template><td>Alternate Identifier</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$alternateIDCnt"/> </xsl:call-template></tr>
                    <tr><td>Author</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$authorCnt"/> </xsl:call-template><td>Custodian</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$custodianCnt"/> </xsl:call-template><td>Asset Size</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$assetSizeCnt"/> </xsl:call-template></tr>
                    <tr><td>Data Identification</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$DataIdentificationExist"/> </xsl:call-template><td>Geographic Extent</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$datasetExtentCnt"/> </xsl:call-template><td>Author Identifier</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$authorIdentifierCnt"/> </xsl:call-template></tr>
                    <tr><td>Dataset Language</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$datasetLanguageCnt"/> </xsl:call-template><td>Geographic Description</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$datasetExtentDescriptionCnt"/> </xsl:call-template><td>Distributor</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$distributorContactCnt"/> </xsl:call-template></tr>
                    <tr><td>Landing Page</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$landingPageCnt"/> </xsl:call-template><td>Keywords</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$keywordCnt"/> </xsl:call-template><td>Distribution Format</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$distributionFormatCnt"/> </xsl:call-template></tr>
                    <tr><td>Metadata Contact</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$metadataContactCnt"/> </xsl:call-template><td>Originator</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$originatorCnt"/> </xsl:call-template><td>Progress</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$progressCnt"/> </xsl:call-template></tr>
                    <tr><td>Metadata Date</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$metadataDateStampCnt"/> </xsl:call-template><td>Principal Investigator</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$piCnt"/> </xsl:call-template><td>Related Resource</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$relatedResourceCnt"/> </xsl:call-template></tr>
                    <tr><td>Metadata Record Identifier</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$fileIDCnt"/> </xsl:call-template><td>Reference System</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$referenceSystemCnt"/> </xsl:call-template><td>Related Resource Description</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$relatedResourceDescriptionCnt"/> </xsl:call-template></tr>
                    <tr><td>Metadata Standard Name</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$metadataStandardNameCnt"/> </xsl:call-template><td>Resource Provider</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$resourceProviderCnt"/> </xsl:call-template><td>Related Resource Name</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$relatedResourceNameCnt"/> </xsl:call-template></tr>
                    <tr><td>Metadata Standard Version</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$metadataStandardVersionCnt"/> </xsl:call-template><td>Spatial Representation Type</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$spatialRepresentationTypeCnt"/> </xsl:call-template><td>Related Resource Type</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$relatedResourceTypeCnt"/> </xsl:call-template></tr>
                    <tr><td>Other Constraints</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$otherConstraintsCnt"/> </xsl:call-template><td>Spatial Resolution</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$spatialResolutionCnt"/> </xsl:call-template><td>Resource Format</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$resourceFormatCnt"/> </xsl:call-template></tr>
                    <tr><td>Publication date</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$publicationDateCnt"/> </xsl:call-template><td>Temporal Extent</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$temporalCnt"/> </xsl:call-template><td>Resource Version</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$resourceVersionCnt"/> </xsl:call-template></tr>
                    <tr><td>Publisher</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$publisherCnt"/> </xsl:call-template><td>Time Interval</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$temporalResolutionCnt"/> </xsl:call-template><td>Software Implementation Language</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$softwareImplementationLanguageCnt"/> </xsl:call-template></tr>
                    <tr><td>Resource Contact</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$resourceContactCnt"/> </xsl:call-template><td>Start Date</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$startDateCnt"/> </xsl:call-template> <td></td><td></td> </tr>
                    <tr><td>Resource Type (DataCite)</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$resourceTypeCnt"/> </xsl:call-template><td>End Date</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$endDateCnt"/> </xsl:call-template> <td></td><td></td> </tr>
                    <tr><td>Title</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$titleCnt"/> </xsl:call-template><td>Theme Keywords</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$themeKeywordCnt"/></xsl:call-template><td></td><td></td> </tr> 
                    <tr><td>Use Contraints</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$useConstraintsCnt"/> </xsl:call-template><td>Theme Keyword Thesaurus</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$themeKeywordThesaurusCnt"/> </xsl:call-template><td></td><td></td> </tr>
                    <tr><td></td><td></td><td>Topic Category</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$topicCategoryCnt"/> </xsl:call-template> <td></td><td></td> </tr>
                    <tr><td></td><td></td><td>Vertical Extent</td><xsl:call-template name="showScore"> <xsl:with-param name="score" select="$verticalCnt"/> </xsl:call-template> <td></td><td></td> </tr>
                </table>

				<h2> Score by Tiers: </h2>
				<table class="tableFullDescription" width="100%" border="1" cellpadding="2" cellspacing="2">
					<tr class="vrdr_container_odd">
						<th>Level</th>
						<th>None</th>
						<th>1-33%</th>
						<th>34-66%</th>
						<th>67-99%</th>
						<th>All</th>
					</tr>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Tier-1 Score'"/>
						<xsl:with-param name="total" select="$level1Score"/>
						<xsl:with-param name="max" select="$level1Max"/>
					</xsl:call-template>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Tier-2 Score'"/>
						<xsl:with-param name="total" select="$level2Score"/>
						<xsl:with-param name="max" select="$level2Max"/>
					</xsl:call-template>
					<xsl:call-template name="showColumn">
						<xsl:with-param name="name" select="'Tier-3 Score'"/>
						<xsl:with-param name="total" select="$level3Score"/>
						<xsl:with-param name="max" select="$level3Max"/>
					</xsl:call-template>
				</table>

				<a name="General Information"/>
				Version: <xsl:value-of select="$rubricVersion"/>
				<hr/>
				<br/>
			</body>
		</html>
	</xsl:template>

    <!-- ******************************************************************* -->

	<xsl:template name="showColumn">
		<xsl:param name="name"/>
		<xsl:param name="total"/>
		<xsl:param name="max"/>
		<xsl:variable name="column">
			<xsl:choose>
				<xsl:when test="$total=0">0</xsl:when>
				<xsl:when test="$total=$max">4</xsl:when>
				<xsl:when test="$total>$max">4</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor(number(number($total) * 3 div number($max)))+1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<th width="20%">
		<!--	<a href="#{$name}"> 
		-->			<xsl:value-of select="$name"/>
		<!--	</a> 
		-->	</th>
			<xsl:choose>
				<xsl:when test="$column=0">
					<td align="center" bgcolor="#0070C0"/>
					<td align="center" colspan="4"/>
				</xsl:when>
				<xsl:when test="$column=1">
					<td align="center" colspan="2" bgcolor="#0070C0"/>
					<td align="center" colspan="3"/>
				</xsl:when>
				<xsl:when test="$column=2">
					<td align="center" colspan="3" bgcolor="#0070C0"/>
					<td align="center" colspan="2"/>
				</xsl:when>
				<xsl:when test="$column=3">
					<td align="center" colspan="4" bgcolor="#0070C0"/>
					<td align="center"/>
				</xsl:when>
				<xsl:when test="$column=4">
					<td align="center" colspan="5" bgcolor="#0070C0"/>
				</xsl:when>
			</xsl:choose>
		</tr>
	</xsl:template>

	<xsl:template name="showColumnNotApplicable">
		<xsl:param name="name"/>
		<xsl:variable name="column">4</xsl:variable>
		<tr>
			<th width="20%">
				<a href="#{$name}">
					<xsl:value-of select="$name"/>
				</a>
			</th>
			<td align="center" colspan="5" bgcolor="#bababa"/>
		</tr>
	</xsl:template>

	<xsl:template name="showScore">
		<xsl:param name="score"/>
		<xsl:choose>
			<xsl:when test="$score=1">
				<td align="center" bgcolor="#a3e0a3">
					<xsl:value-of select="$score"/>
				</td>
			</xsl:when>
			<xsl:when test="$score=0">
				<td align="center" bgcolor="#ff99ad">
					<xsl:value-of select="$score"/>
				</td>
			</xsl:when>
            <xsl:when test="$score > 1">
                <td align="center" bgcolor="#b4e3f7">
                    <xsl:value-of select="$score"/>
                </td>
			</xsl:when>
			<!-- 99 means Not applicable -->
			<xsl:otherwise>
				<td align="center" bgcolor="#bababa">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="showScoreRowSpan">
		<xsl:param name="score"/>
		<xsl:param name="total"/>
		<xsl:param name="rowspan"/>
		<td align="center">
			<xsl:choose>
				<xsl:when test="$score > 0">
					<xsl:attribute name="bgcolor">#66CC66</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="bgcolor">#FF0033</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
			<xsl:value-of select="$score"/>
			<xsl:choose>
				<xsl:when test="$total > 0">/<xsl:value-of select="$total"/>
				</xsl:when>
			</xsl:choose>
		</td>
	</xsl:template>
</xsl:stylesheet>
