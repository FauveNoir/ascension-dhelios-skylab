#!/bin/zsh
#
SCRIPT_PATH=$(dirname "$(realpath "$0")")
OUTPUTDIR=output
INPUTFILE="$1"
BASENAME=${$(basename ${INPUTFILE})%.pdf}

OUTPUTNAME="${1%.pdf}"
OUTPUTFULLNAME="${OUTPUTDIR}/${BASENAME}-CAHIER.pdf"
NUMBEROFFOLIOPERBOOKLET=7 # The number of paper used for each booklet


TOTALNUMBEROFPAGES=$(exiftool $INPUTFILE | grep "Page Count" | sed "s/Page Count  *: //")
(( GIVENINTERIORNUMBEROFPAGES=$TOTALNUMBEROFPAGES-4 )) # The remaining page number after cover extraction
(( ORPHANPAGES=$GIVENINTERIORNUMBEROFPAGES%4 )) # PAges restées orpheniles sans folio
(( BLANKPAGESTOAD=4-$ORPHANPAGES )) # Pages restées orpheniles sans folio

if [[ $BLANKPAGESTOAD = 4 ]] ; then
	BLANKPAGESTOAD=0
fi

(( INTERIORNUMBEROFPAGES=$GIVENINTERIORNUMBEROFPAGES+$BLANKPAGESTOAD )) # The remaining page number after cover extraction

(( FOLIA=$INTERIORNUMBEROFPAGES/4 )) # Nombre minimal de folia 


(( NUMBEROFBOOKLET=$FOLIA/$NUMBEROFFOLIOPERBOOKLET ))
(( NUMBEROFPAGESPERBOOKLET=$NUMBEROFFOLIOPERBOOKLET*4 ))
(( HAFPAGENUMBEROFPAGESPERBOOKLET=$NUMBEROFPAGESPERBOOKLET/2 )) # Usefull to leave the booklet loop 
EXTRACTCOVER=true
NUMBERINGPAGES=false
FACETOFACE=false
MARKBOOKLETATTACHMENT=true



# TODO
# Numérotation des pages en boléen
# Extraction de la couverture en option



print "Nombre de pages intérieures : $INTERIORNUMBEROFPAGES"
print "Nombre de pages orfelines   : $ORPHANPAGES"
print "Nombre de pages à ajouter   : $BLANKPAGESTOAD"
print "Nombre de folia             : $FOLIA"
print "Nombre de cahiers           : $NUMBEROFBOOKLET"
print "Nombre de page par cahier   : $NUMBEROFPAGESPERBOOKLET"

# Fonctions agissants sur les pdfs
function normalizeNumber() {
	# Ajoute des zéros non significatifs de telle sorte que tous les nombres soient constitués de trois chiffres
	normalized=$(printf '%03d\n' $1)
	echo $normalized
}

function makebookletfilename() {
	bookletPageNormalized=$(normalizeNumber $1)
	bookletPageName="/tmp/booklet-$bookletPageNormalized.pdf"
	echo $bookletPageName
}

function makebookletpage() {
	# Prépare le recto de chaque folio
	bookletPageNormalized=$(normalizeNumber $3)
	bookletfilename=$(makebookletfilename $3)
	pageleft=$(normalizeNumber $2)
	pageright=$(normalizeNumber $1)
	echo "Traitmeent des pages $pageleft et $pageright ; Page $bookletPageNormalized du livret"
	pdfjam --quiet /tmp/page_{$pageleft,$pageright}.pdf  --nup 2x1 --landscape --outfile $bookletfilename
}

function makereversedbookletpage() {
	# Prépare le verso de chaque folio
	bookletPageNormalized=$(normalizeNumber $3)
	bookletfilename=$(makebookletfilename $3)
	pageleft=$(normalizeNumber $1)
	pageright=$(normalizeNumber $2)
	echo "Traitmeent des pages $pageleft et $pageright ; Page $bookletPageNormalized du livret"
	if $FACETOFACE; then 
		pdfjam --quiet /tmp/page_{$pageleft,$pageright}.pdf  --nup 2x1 --landscape --outfile $bookletfilename
	else
		pdfjam --quiet /tmp/page_{$pageright,$pageleft}.pdf  --nup 2x1 --landscape --angle 180 --outfile $bookletfilename
	fi 
}


# Fonction de distribution des pages
function getLastPageOfCurrentBooklet()
{
	# Trouve le numéro de la dernière page d’un cahier
	(( LASTPAGE=$1+$NUMBEROFPAGESPERBOOKLET ))
	if [ $LASTPAGE -le $INTERIORNUMBEROFPAGES ] ; then
		echo $LASTPAGE
	else
		echo $INTERIORNUMBEROFPAGES
	fi
}

function getMiddlePageOfBooklet()
{
	(( MIDDLEPAGE=($1+$2)/2 ))
	echo $MIDDLEPAGE
}

function getRelativeMiddlePageOfBooklet()
{
	# Trouve le numéro relatif de la page médiane d’un cahier.
	# Est surtout utile pour l’itération du dernier cahier pour lequel le nombre de flia est différent des autres cahiers.
	(( MIDDLEPAGE=($2-$1)/2 ))
	echo $MIDDLEPAGE
}


# Procéssus

echo "########################################################################"
echo " Préparation de l’imposition "
echo "########################################################################"

if $EXTRACTCOVER ; then
	echo "Extraction de la couverture"
	pdftk $INPUTFILE cat 3-r3 output /tmp/tmp-onlybooklet.pdf

	if (( $ORPHANPAGES > 0 )); then
		echo "Ajout des pages manquantes au miltiple de 4"
		PDFJAMSUFFIX=""
		for ((i=0; i<$BLANKPAGESTOAD; i++)); do
			PDFJAMSUFFIX="${PDFJAMSUFFIX},{}"
		done

		echo "$i pages blanches ajoutées."
		BOOKLETLASTPAGE=$(exiftool /tmp/tmp-onlybooklet.pdf | grep "Page Count" | sed "s/Page Count  *: //")
		pdfjam --quiet  --outfile /tmp/tmp-onlybooklet.pdf /tmp/tmp-onlybooklet.pdf "-$BOOKLETLASTPAGE$PDFJAMSUFFIX"
	fi

	if $NUMBERINGPAGES ; then
		echo "Numérotation des pages"
		pdftk /tmp/tmp-onlybooklet.pdf multistamp numbers.pdf output /tmp/tmp-onlybooklet-numbered.pdf
		cp /tmp/tmp-onlybooklet-numbered.pdf /tmp/tmp-onlybooklet.pdf
	fi

	echo "Éclatement des pages"
	pdftk /tmp/tmp-onlybooklet.pdf burst output /tmp/page_%03d.pdf
else
	echo "Pas d’extraction de couverture"
	cp $INPUTFILE /tmp/tmp-onlybooklet.pdf
fi

page=0
FIRSTBOOKLETPAGE=0
BOOKLETNUMBER=1
BOOKLETPAGENUMBER=1
while [ $page -lt $INTERIORNUMBEROFPAGES ] ; do
	# Booklet loop initialisation
	LASTPAGEOFCURRENTBOOKLET=$(getLastPageOfCurrentBooklet $page)
	MIDDLEPAGE=$(getRelativeMiddlePageOfBooklet $page $LASTPAGEOFCURRENTBOOKLET)
	firstbookletpagefilename=$(makebookletfilename $BOOKLETPAGENUMBER)
	echo "------------------------------------------------------------------------"
	echo "Cahier $BOOKLETNUMBER"
	echo "Dernière page du feuillet : $LASTPAGEOFCURRENTBOOKLET"
	echo "Page centrale : $MIDDLEPAGE"
	echo "Page du feuillet : $BOOKLETCURSOR"
	echo "Nom du fichier de folio : $firstbookletpagefilename"

	# Entering Folio
	BOOKLETCURSOR=0
	while [ $BOOKLETCURSOR -lt $MIDDLEPAGE ] ; do
		# Initializing variables for each iteration
		(( first=$page+1+$BOOKLETCURSOR ))
		(( second=$page+2+$BOOKLETCURSOR ))
		(( last=$LASTPAGEOFCURRENTBOOKLET-$BOOKLETCURSOR ))
		(( penultimate=$last-1 ))

		#   Folio repartition:
		#
		#   Recto                   Verso
		#   +--------+--------+     +--------+--------+
		#   |        |        |     |        |        |
		#   |        |        |     |        |        |
		#   | last   | first  |     | second | penul- |
		#   |        |        |     |        | timate |
		#   |        |        |     |        |        |
		#   |        |        |     |        |        |
		#   +--------+--------+     +--------+--------+
		#        │        ╰─────────────╯        │
		#        │                               │
		#        ╰───────────────────────────────╯



		# Process on pdf files.
		echo "$BOOKLETCURSOR	$first $last	$BOOKLETPAGENUMBER"
		makebookletpage $first $last	$BOOKLETPAGENUMBER

		# Add attach points
		if [[ $BOOKLETCURSOR = 0 ]]; then
			echo "!!! PREMIÈRE PAGE DU FEUILLET !!!"
			pdftk $firstbookletpagefilename background ${SCRIPT_PATH}/pointsdagraffe.pdf output $firstbookletpagefilename-marked
			mv $firstbookletpagefilename-marked $firstbookletpagefilename
		fi

		(( BOOKLETPAGENUMBER=$BOOKLETPAGENUMBER+1 ))
		echo "	$second $penultimate	$BOOKLETPAGENUMBER"
		makereversedbookletpage $second $penultimate	$BOOKLETPAGENUMBER

		# End of folio iteration
		(( BOOKLETPAGENUMBER=$BOOKLETPAGENUMBER+1 ))
		(( BOOKLETCURSOR=$BOOKLETCURSOR+2 ))
	done

	# End of booklet iteration
	(( page=$LASTPAGEOFCURRENTBOOKLET ))
	(( BOOKLETNUMBER=$BOOKLETNUMBER+1 ))
done

(( BOOKLETPAGENUMBER=$BOOKLETPAGENUMBER-1 )) # Annulate the last supernumerary incrementation to feet the real number of total iteration
echo "Concaténation finale des pages du livret"

# Concatenate all the folia in a final linear PDF
echo " Préfinal"
pdftk /tmp/booklet-{001..$BOOKLETPAGENUMBER}.pdf cat output ${OUTPUTDIR}/${BASENAME}-prefinal.pdf
echo " Ultime"
pdftk A=${OUTPUTDIR}/${BASENAME}-prefinal.pdf shuffle AoddWest AevenEast output ${OUTPUTFULLNAME}

# Nétoyage des fichiers temporaires
#rm -v -- ${OUTPUTNAME}-prefinal.pdf
echo "Nétoyage des fichiers temporaires"
rm -v -- ${OUTPUTDIR}/${BASENAME}-prefinal.pdf

