#!/bin/bash
#####################################################
# Applies NCAR-specific configurations to CatMDEdit
# updating thesauri and adding our Contacts list. 
# Run this after installing CatMDEdit 
#   updated for ver.5.2.0 
#####################################################
echo ""
echo "Enter the full path to the base CatMDEdit directory (e.g. /Users/dw/Applications/CatMDEdit):"
read catBase
if [ -d $catBase ] 
    then echo "directory $catBase exists"
else echo "the $catBase directory does not exist"; exit 1
fi
if [ -w $catBase ]
    then echo "and it is writable"
else echo "but it is not writable"
read -p "Press enter to continue, or CTRL-C to quit"
fi
echo "Files within the $catBase installation directory will be updated"
echo ""
cp -r "Expert Mode" "$catBase/template/genericEditor/gui/Expert Mode"
echo "copied Expert Mode directory to $catBase/template/genericEditor/gui/Expert Mode"
sleep 2
cp -r "NCAR Dialect" "$catBase/template/genericEditor/gui/NCAR Dialect"
echo "copied NCAR Dialect directory to $catBase/template/genericEditor/gui/NCAR Dialect"
sleep 2
cp -r "FAST" "$catBase/template/genericEditor/gui/FAST"
echo "copied FAST directory to $catBase/template/genericEditor/gui/FAST"
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
cp -f icons.properties $catBase  
echo "copied icons.properties to $catBase"
sleep 2
cp contact/*.rdf $catBase/repository/contact
echo "copied contact/*.rdf to $catBase/repository/contact"
sleep 2
cp -f CSDGM_FormatNameCode.dat $catBase/repository/thesaurus
echo "copied CSDGM_FormatNameCode.dat to $catBase/repository/thesaurus"
sleep 2
cp -f CSDGM_FormatNameCode.MD.DC_externo.xml $catBase/repository/thesaurus
echo "copied CSDGM_FormatNameCode.MD.DC_externo.xml to $catBase/repository/thesaurus"
sleep 2
cp "ResourceTypeNameCode.dat" $catBase/repository/thesaurus
echo "copied ResourceTypeNameCode.dat to $catBase/repository/thesaurus"
sleep 2
cp ResourceType.MD.DC.xml $catBase/repository/thesaurus
echo "copied ResourceType.MD.DC.xml to $catBase/repository/thesaurus"
sleep 2
cp -f nmdedit-5.2.0.jar "$catBase/lib"
echo "copied nmdedit-5.2.0.jar to $catBase/lib"
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
cp ncar_metatata_template___eng.xml "$catBase/repository/templates"
echo "copied ncar_metatata_template___eng.xml to $catBase/repository/templates"
sleep 2
cp FAST_Template.xml "$catBase/repository/templates"
echo "copied FAST_Template.xml to $catBase/repository/templates"
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
