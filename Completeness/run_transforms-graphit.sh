#!/bin/tcsh

foreach i (acom cgd cisl eol hao library mmm opensky ral rda unidata)
    java net.sf.saxon.Transform -s:WAFs/labs.xml -xsl:LevelsScores/ncarDialectScoresTXT.xsl -o:../xsl/out/Lab_scores/LevelsScores/$i-Scores.csv WAF_BASE=../WAFs recordSetPath=$i --suppressXsltNamespaceCheck:on
    echo "processed $i"
end
