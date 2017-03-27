#!/bin/bash
#####################################################
# Applies NCAR-specific configurations to CatMDEdit
# updating thesauri and adding our Contacts list. 
# Run this after installing CatMDEdit 
#####################################################
echo ""
echo "Enter the full path to the base CatMDEdit directory (e.g. /Users/dw/Applications/CatMDEdit):"
read catBase
echo "We will be updating files within the $catBase installation directory"
echo ""
read -p "Press enter to continue"
cp -r "Expert Mode" "$catBase/template/genericEditor/gui/Expert Mode"
echo "copied Expert Mode directory to $catBase/template/genericEditor/gui/Expert Mode"
sleep 2
cp -r "NCAR Dialect" "$catBase/template/genericEditor/gui/NCAR Dialect"
echo "copied NCAR Dialect directory to $catBase/template/genericEditor/gui/NCAR Dialect"
sleep 2
cp -f iso19115.xml $catBase/repository/standards
echo "copied iso19115.xml to $catBase/repository/standards"
sleep 2
cp Default.theme $catBase
echo "copied Default.theme to $catBase"
sleep 2
cp -f internat.properties $catBase
echo "copied internat.properties to $catBase"
sleep 2
cp -f splash_Cat_5.0_NMDEdit.jpg $catBase/imagen/generalIcons
echo "copied  splash_Cat_5.0_NMDEdit.jpg to $catBase/imagen/generalIcons"
sleep 2
cp contact/*.rdf $catBase/repository/contact
echo "copied contact/*.rdf to $catBase/repository/contact"
sleep 2
# cp -f CSDGM_FormatNameCode.dat $catBase/repository/thesaurus
# echo "copied CSDGM_FormatNameCode.dat to $catBase/repository/thesaurus"
# sleep 2
# cp -f CSDGM_FormatNameCode.MD.DC_externo.xml $catBase/repository/thesaurus
# echo "copied  CSDGM_FormatNameCode.MD.DC_externo.xml to $catBase/repository/thesaurus"
# sleep 2
cp "ResourceType.dat" $catBase/repository/thesaurus
echo "copied ResourceType.dat to $catBase/repository/thesaurus"
sleep 2
cp md_ResourceTypeCode_en.xml $catBase/repository/thesaurus
echo "copied md_ResourceTypeCode_en.xml to $catBase/repository/thesaurus"
sleep 2
cp -f catmdedit-5.1.jar "$catBase/lib"
echo "copied catmdedit-5.1.jar to $catBase/lib"
sleep 2
cp NMDEdit.launch "$catBase"
echo "copied NMDEdit.launch to $catBase"
sleep 2
cp NMDEdit.properties "$catBase"
echo "copied NMDEdit.properties to $catBase"
sleep 2
cp about.html "$catBase/doc/about"
echo "copied about.html to $catBase/doc/about"
sleep 2
cp ncar_highres_transparent.png "$catBase/doc/about/about_files"
echo "copied ncar_highres_transparent.png to $catBase/doc/about/about_files"
sleep 2
cp startup.sh "$catBase"
chmod 754 "$catBase/CatMDEdit.sh" "$catBase/startup.sh"
echo "created startup.sh script to start NMDEdit"
echo "set permissions on CatMDEdit.sh and startup.sh"
sleep 2
echo "NMDEdit is now ready to use"
cd "$catBase"
echo "To start, type ./startup.sh in the terminal window" 
sleep 2
#echo "done"
echo ""
