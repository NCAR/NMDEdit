#!/bin/bash
#####################################################
# Applies NCAR-specific configurations to CatMDEdit
# updating thesauri and adding our Contacts list. 
# Run this after installing CatMDEdit 
#   updated for ver.5.2.0 
*   added thesaurus changes - Jun 1, 2017
#####################################################
echo ""
echo "Enter the full path to the base CatMDEdit directory (e.g. /Users/jsmith/NMDEdit):"
read catBase
if [ -d "$catBase" ] 
    then echo "directory $catBase exists"
else echo "the $catBase directory does not exist"; exit 1
fi
if [ -w "$catBase" ]
    then echo "and it is writable"
else echo "but it is not writable"
read -p "Press enter to continue, or CTRL-C to quit"
fi
echo "Files within the $catBase installation directory will be updated"
echo ""
###########################
# add our dialects
###########################
cp -r "Expert Mode" "$catBase/template/genericEditor/gui/Expert Mode"
echo "copied Expert Mode directory to $catBase/template/genericEditor/gui/Expert Mode"
sleep 1
cp -r "NCAR Dialect" "$catBase/template/genericEditor/gui/NCAR Dialect"
echo "copied NCAR Dialect directory to $catBase/template/genericEditor/gui/NCAR Dialect"
sleep 1
cp -r "FAST" "$catBase/template/genericEditor/gui/FAST"
echo "copied FAST directory to $catBase/template/genericEditor/gui/FAST"
sleep 1
cp FAST_Template.xml "$catBase/repository/templates"
echo "copied FAST_Template.xml to $catBase/repository/templates"
sleep 1
cp -f iso19115.xml "$catBase/repository/standards"
echo "copied iso19115.xml to $catBase/repository/standards"
# sleep 1
cp -f nmdedit-5.2.0.jar "$catBase/lib"
echo "copied nmdedit-5.2.0.jar to $catBase/lib"
# sleep 1
cp Default.theme "$catBase"
echo "copied Default.theme to $catBase"
# sleep 1
cp -f internat.properties "$catBase"
echo "copied internat.properties to $catBase"
# sleep 1
cp -f splash_Cat_5.0_NMDEdit.jpg "$catBase/imagen/generalIcons"
echo "copied  splash_Cat_5.0_NMDEdit.jpg to $catBase/imagen/generalIcons"
# sleep 1
cp -f icons.properties "$catBase"  
echo "copied icons.properties to $catBase"
# sleep 1
cp NMDEdit.launch "$catBase"
echo "copied NMDEdit.launch to $catBase"
# sleep 1
cp NMDEdit.properties "$catBase"
echo "copied NMDEdit.properties to $catBase"
# sleep 1
cp about.html "$catBase/doc/about"
echo "copied about.html to $catBase/doc/about"
# sleep 1
cp ncar_highres_transparent.png "$catBase/doc/about/about_files"
echo "copied ncar_highres_transparent.png to $catBase/doc/about/about_files"
# sleep 1
cp ncar_metatata_template___eng.xml "$catBase/repository/templates"
echo "copied ncar_metatata_template___eng.xml to $catBase/repository/templates"
# sleep 1
###########################
# add sample XML files 
###########################
rm "$catBase/repository/metadata/*.xml"
cp sample_XML/*.xml "$catBase/repository/metadata"
###########################
# add our NCAR contacts
###########################
cp contact/*.rdf "$catBase/repository/contact"
echo "copied contact/*.rdf to $catBase/repository/contact"
sleep 1
#######################################################
# fix up thesaurus directory
#  add Resource Type and update CSDGM with new formats
#######################################################
cp -f CSDGM_FormatNameCode.dat "$catBase/repository/thesaurus"
echo "copied CSDGM_FormatNameCode.dat to $catBase/repository/thesaurus"
sleep 1
cp -f CSDGM_FormatNameCode.MD.DC_externo.xml "$catBase/repository/thesaurus"
echo "copied CSDGM_FormatNameCode.MD.DC_externo.xml to $catBase/repository/thesaurus"
sleep 1
cp "Resource Type.dat" "$catBase/repository/thesaurus"
echo "copied Resource Type.dat to $catBase/repository/thesaurus"
sleep 1
cp "md_Resource Type_en.xml" "$catBase/repository/thesaurus"
echo "copied md_Resource Type_en.xml to $catBase/repository/thesaurus"
sleep 1
###########################
# delete unneeded thesauri
###########################
rm "$catBase/repository/thesaurus/ADLFTT.dat"
rm "$catBase/repository/thesaurus/ADLFTT.MD.DC.xml"
rm "$catBase/repository/thesaurus/AGROVOC.dat"
rm "$catBase/repository/thesaurus/AGROVOC.MD.DC.xml"
rm "$catBase/repository/thesaurus/CEODiscipline.dat"
rm "$catBase/repository/thesaurus/CEODisicpline.MD.DC.xml"
rm "$catBase/repository/thesaurus/CEOLocation.dat"
rm "$catBase/repository/thesaurus/CEOLocation.MD.DC.xml"
rm "$catBase/repository/thesaurus/DroughtVocabulary.dat"
rm "$catBase/repository/thesaurus/DroughtVocabulary.MD.DC.xml"
rm "$catBase/repository/thesaurus/EuropeanTerritorialUnits.dat"
rm "$catBase/repository/thesaurus/EuropeanTerritorialUnits.MD.DC.xml"
rm "$catBase/repository/thesaurus/EUROVOC.dat"
rm "$catBase/repository/thesaurus/EUROVOC.MD.DC.xml"
rm "$catBase/repository/thesaurus/GCMD.dat"
rm "$catBase/repository/thesaurus/GCMD.MD.DC.xml"
rm "$catBase/repository/thesaurus/GEMET.dat"
rm "$catBase/repository/thesaurus/GEMET.MD.DC.xml"
rm "$catBase/repository/thesaurus/INSPIRE_SpatialDataServicesClassification.dat"
rm "$catBase/repository/thesaurus/INSPIRE_SpatialDataServicesClassification.MD.DC.xml"
rm "$catBase/repository/thesaurus/INSPIRE_SpatialThemes.dat"
rm "$catBase/repository/thesaurus/INSPIRE_SpatialThemes.MD.DC.xml"
rm "$catBase/repository/thesaurus/ISO3166.dat"
rm "$catBase/repository/thesaurus/ISO3166.MD.DC.xml"
rm "$catBase/repository/thesaurus/MARC21_Keywords.MD.DC_externo.xml"
rm "$catBase/repository/thesaurus/MARC21_SubjectHeadings.dat"
rm "$catBase/repository/thesaurus/MARC21_SubjectHeadings.MD.DC_externo.xml"
rm "$catBase/repository/thesaurus/SBA_EuroGEOSS.MD.DC.xml"
rm "$catBase/repository/thesaurus/SBA.dat"
rm "$catBase/repository/thesaurus/UNESCO.dat"
rm "$catBase/repository/thesaurus/UNESCO.MD.DC.xml"
rm "$catBase/repository/thesaurus/URBISOC_MD.DC.xml"
rm "$catBase/repository/thesaurus/URBISOC.dat"
rm "$catBase/repository/thesaurus/WebServicesSpecification.MD.DC.xml"
###################################################################################
# These files should be updated with latest versions to remove the Spanish titles
###################################################################################
cp MARC21_Keywords.MD.DC_externo.xml "$catBase/repository/thesaurus"
cp WebServicesSpecification.MD.DC.xml "$catBase/repository/thesaurus"
####################################################################################
cp startup.sh "$catBase"
rm "$catBase/CatMDEdit.sh"
chmod 754 "$catBase/startup.sh"
echo "created startup.sh script to start NMDEdit"
echo "and set permissions on startup.sh"
sleep 2
cd "$catBase"
echo "NMDEdit is now ready to use"
echo "To start, type ./startup.sh in the terminal window in the installation directory" 
echo "  or create a shortcut on  your desktop to $catBase/startup.sh" 
#echo "done"
echo ""
