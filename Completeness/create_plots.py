#---------------------------------------------------
# This code will take CSV files and plot graphs
# representing EMDAC Metadata completeness scores
#
# Call the code from a directory with the following subdirectories:
# 	plots/ --> .png files of the completeness plots
# 		   will end up here
# 	lab_scores/ --> this should contain the .csv files
# 			with the scores FOR EACH ARCHIVE_IDENT
# 			titled *lab name*-Scores.csv
#
# Enter the lab name as an argument when calling the script
# using the same capitalization as found in the Scores.csv file
#
#
#---------------------------------------------------

import sys
import csv
import matplotlib.pyplot as plt
import numpy as np
import collections
#from datetime import date

if(len(sys.argv)==1):
	print('Please enter the lab for which you want to calculate metadata completenesss.')
	sys.exit()
else:
	lab_name = sys.argv[1]

def createTotals():
    totals = collections.OrderedDict.fromkeys(['metadataRecordID', 'ISO assetType', 'metadataContact', 'metadataDate', 'landingPage', 'title', 'publicationDate', 'author', 'publisher', 'abstract', 'resourceSupportContact', 'DataCite resourceType', 'legalConstraints', 'accessConstraints', 'resourceLanguage', '| Tier 2 |', 'otherResponsibleParty/Custodian', 'otherResponsibleParty/Originator', 'otherResponsibleParty/ResourceProvider', 'credit', 'citationDate', 'scienceSupportContact/PI', 'keywords (tags)', 'keywords (GCMD )', 'keywordVocabulary', 'referenceSystem', 'spatialRepresentation', 'spatialResolution', 'ISO topicCategory', 'datasetExtent (Geolocation)', 'datasetExtentDescription', 'temporalCoverage', 'startDate', 'endDate', 'temporalResolution', 'verticalExtent', '| Tier 3 |', 'relatedLinkIdentifier', 'relatedLinkName', 'relatedLinkType', 'relatedlinkDescription', 'alternateIdentifier', 'resourceVersion', 'progress', 'resourceFormat', 'softwareImplementationLanguage', 'additionalInformation', 'distributor', 'distributionFormat', 'assetSize', 'authorIdentifier', '| from Templates |', 'dataIdentification', 'metadataStandardName', 'metadataStandardVersion'], 0)
    return totals

print('Reading in totals for metadata values from ', lab_name)    
with open('lab_scores/'+lab_name+'-Scores.csv', mode='r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    totals = createTotals()
    next(csv_reader)
    #print ("Length : %d" % len (totals))
    for row in csv_reader:
        del row['archive ident']
        del row['Total Score']
        #print ("Length : %d" % len (row))
        for key in row:
            row[key] = int(row[key])
            totals[key] += row[key]
            
# Create two lists from the totals dictionary to be used for plotting
labels = list(totals.keys())
values = list(totals.values())

# Reverse orders of lists for horizontal bar chart
#labels.reverse()
#values.reverse()

print('Creating completeness graph')
# Create a figure
fig = plt.figure(figsize=(20,8))

# Create a list of colors to distinguish between tiers
#colors = ['navy' for i in range(labels.index('| Tier 2 |'))]
#for j in range(labels.index('| Tier 3 |') - labels.index('| Tier 2 |')):
#    colors.append('blue')
#for k in range(labels.index('| from Templates |') - labels.index('| Tier 3 |')):
#    colors.append('royalblue')
#for z in range(len(labels) - labels.index('| from Templates |')):
#    colors.append('lightgray')

# All bars uniform except tier dividers
colors = ['steelblue' for i in range(len(labels))]
colors[labels.index('| Tier 2 |')] = 'lightgray'
colors[labels.index('| Tier 3 |')] = 'lightgray'
colors[labels.index('| from Templates |')] = 'lightgray'

# Change values at tier dividers
values[labels.index('| Tier 2 |')] = max(values)
values[labels.index('| Tier 3 |')] = max(values)
values[labels.index('| from Templates |')] = max(values)

# Retrieve date information to display on plot
#today = date.today()

# Plot metadata type as x-axis and number of datasets containing such as y-axis
index = np.arange(len(labels))
scale_index = [3*i for i in index]
plt.bar(scale_index, values, color=colors, width=2, align='center')
plt.xlabel('NCAR Dialect', fontsize=15)
plt.ylabel('Number of metadata files with element', fontsize=15)
plt.xticks(scale_index, labels, fontsize=11, rotation=45, ha='right')
plt.title(lab_name.upper()+' Completeness Score', fontsize=20)
plt.subplots_adjust(bottom=0.4, top=0.9)
fig.savefig('plots/'+lab_name+'.png')

print('Plot saved in the plots directory with the name '+ lab_name+ '.png')
