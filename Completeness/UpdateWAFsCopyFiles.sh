#!/bin/tcsh
#-------------------------------------------------
# UpdateWAFsCopyFiles.sh
#
# Updates local copy of GitHub prod WAFs
# Deletes all files in the target directory,
# then copies all XML files in each lab's WAF 
# to processing directory for completeness 
# checks. Creation and modification dates 
# are preserved. Reports total files in each
# lab's WAF.
#
# run this script from the local prod WAF repo 
#  ~/DMG/DSET_prod_WAFs on eol-elk
# 
#   July 27, 2018
#   Feb 28, Sept 27, Jan 24, June 9, July 27, Oct 1 
#   July 19, 2021
#   Sept 9, changed name of Unidata WAF to UCP
#   -ds
#-------------------------------------------------

#---------------------------------
# pull the latest 
#---------------------------------
cd /Users/stott/DMG/DSET_prod_WAFs

foreach i (dash*prod)
    echo "updating $i"
    cd $i
    git pull
    cd ..
end
echo "currently in the "
pwd
echo "directory"
echo ""

#---------------------------------
# copy repo files for processing
#---------------------------------

echo "will next copy files to the processing directory for completeness"

#--------------------------
# ACOM HAO Library MMM RAL 
#--------------------------
foreach i (acom hao library mmm ral)
    echo "deleting old files in $i processing directory"
    rm /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/$i/*.xml
    echo "copying $i files"
    cp -pf dash-$i-prod/*.xml /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/$i/
    echo ""
end

# add files from Datacite for ral
cp -pf dash-ral-prod/Datacite/*.xml /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/ral

#---------------------------------
# CGD
#---------------------------------

echo "deleting old files in cgd directory"
rm /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cgd/*.xml
echo "copying cgd files"
cp -pf dash-cgd-prod/*.xml /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cgd

# fold subdirectory files into main WAF for completeness counting
echo "copying cgd/cesm_expdb files"
cp -pf dash-cgd-prod/cesm_expdb/*.xml /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cgd
echo ""

#---------------------------------
# CISL
#---------------------------------

cd dash-cisl-prod
echo "deleting old files in cisl processing directory"
rm /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cisl/*.xml

echo "deleting file with a non UTF-8 char that breaks the script"
rm NA_CORDEX_Dataset.xml
echo "deleting file with two point-of-contacts that breaks the script"
rm NA_CORDEX_Dataset.xml

echo "copying cisl files"
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cisl
end

# fold subdirectory files into main WAF for completeness counting
cd dash-repo-prod
echo "deleting file with two point-of-contacts that breaks the script"
rm fuel_moisture_content-1613d171-3a51-4aa1-a503-ecb2218ee1fc.xml
echo "copying cisl/dash-repo-prod files"
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cisl
end

cd ../Datacite
echo "copying cisl/Datacite files"
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/cisl
end
echo ""

#---------------------------------
# EOL
#---------------------------------

cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/eol
echo "deleting old files in eol processing directory"
foreach i (*.xml)
    rm $i
end

cd /Users/stott/DMG/DSET_prod_WAFs/dash-eol-prod/EOL-Datasets
echo "copying EOL files"
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/eol
end

# fold toga_coare subdirectory files into main WAF for completeness counting
echo "copying EOL/toga_coare files"
cd toga_coare
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/eol
end

echo "copying Datacite files"
cd ../../Datacite
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/eol
end
echo ""

#---------------------------------
# Opensky
#---------------------------------

cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/opensky
echo "deleting old files in opensky processing directory"
foreach i (*.xml)
    rm $i
end

echo "copying opensky files"
cd /Users/stott/DMG/DSET_prod_WAFs/dash-opensky-prod/opensky
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/opensky
end
echo ""

#---------------------------------
# RDA
#---------------------------------

cd /Users/stott/DMG/DSET_prod_WAFs
echo "deleting old files in rda processing directory"
rm /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/rda/*.xml
echo "copying rda files"
cp dash-rda-prod/RDA-Datasets/*.xml  /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/rda
echo ""

#---------------------------------
# UCP (Unidata and COSMIC)
#---------------------------------

cd /Users/stott/DMG/DSET_prod_WAFs
echo "deleting old files in ucp processing directory"
rm /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/ucp/*.xml
echo "copying UCP files"
cp dash-ucp-prod/Unidata/*.xml  /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/ucp
echo "copying COSMIC files"
cp dash-ucp-prod/COSMIC/*.xml  /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/ucp
echo ""

#---------------------------------
# count files in each lab's WAF
#---------------------------------

cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs
echo "Files in each lab's WAF"
foreach i (acom cgd cisl eol hao library mmm opensky ral rda ucp)
    echo $i
    ls -1 /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/$i | wc -l
end
echo ""

#---------------------------------
# combine all files for allInOne
#---------------------------------

cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/allInOne
echo "deleting old files in allInOne directory"
foreach i (*.xml)
    rm "$i"
end

cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs
echo "copy all labs' data to make one allInOne record"
foreach i (acom cgd cisl hao library mmm ral rda ucp)
    echo "copy $i files to allInOne"
    cp $i/*.xml /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/allInOne/
end

echo "copy eol files to allInOne"
cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/eol
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/allInOne
end

echo "copy opensky files to allInOne"
cd /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/opensky
foreach i (*.xml)
    cp -pf $i /Users/stott/DMG/DSET/Completeness/XSLT/WAFs/allInOne
end

cd /Users/stott/DMG/DSET_prod_WAFs

