#!/bin/zsh

SCRIPTPATH=$(dirname "$(realpath "$0")")
OUTPUTDIR=output
INPUTFILE="$1"
BASENAME=${$(basename ${INPUTFILE})%.pdf}

OUTPUTNAME="${1%.pdf}"
OUTPUTFULLNAME="${OUTPUTDIR}/${BASENAME}"

#########################
COVERSUFIX="COUVERTURE"
INTERIORSUFIX="CONTREPLAT"
A3SIMPLESUFIX="A3"
A3PLUSSUFIX="A3plus"

#########################
OUTPUTDIR=output

INPUTFILE="$1"
echo NOM: $INPUTFILE
OUTPUTNAME=${1%.pdf}
INCLUDEBACK=true # Inclue le contreplat
# Valeur de l'espace blanc de la trache (en centimètres)
espace_blanc_cm=1

echo "Extraction du corps"
pdftk $INPUTFILE cat 1 r1 output /tmp/tmp-onlycoverpages.pdf
if $INCLUDEBACK ; then
	echo "Extraction du contreplat"
	pdftk $INPUTFILE cat 2 r2 output /tmp/tmp-onlycoverpages-internal.pdf
fi

echo "Éclatement des pages"
pdftk /tmp/tmp-onlycoverpages.pdf burst output /tmp/coverpage_%03d.pdf
if $INCLUDEBACK ; then
	echo "Éclatement des pages de contreplat"
	pdftk /tmp/tmp-onlycoverpages-internal.pdf burst output /tmp/coverpage-internal_%03d.pdf
fi

echo "Fusion des pages"

# Nom des fichiers PDF A4
fileA="/tmp/coverpage_002.pdf"
fileB="/tmp/coverpage_001.pdf"


# Conversion de centimètres en points (1 cm = 28.3465 points)
espace_blanc_pt=$(echo "scale=5; $espace_blanc_cm * 28.3465" | bc)
largeur_concatenee=$(echo "$espace_blanc_pt + 1190.551" | bc)

# Calcul des dimensions du papier A4 avec l'espace blanc
papersize_with_margin="{841.890pt,${largeur_concatenee}pt}"

# Calcul de l'offset pour le deuxième fichier PDF



echo "Includeback NON pris en compte"
# Fichier de sortie
pdfjam --outfile "${OUTPUTDIR}/${BASENAME}-${COVERSUFIX}-${A3SIMPLESUFIX}".pdf --nup '2x1' --papersize "$papersize_with_margin" --landscape --delta '1cm 0cm' --frame 'false' -- /tmp/coverpage_002.pdf - /tmp/coverpage_001.pdf -
xelatex -output-directory="${OUTPUTDIR}" -jobname="${BASENAME}-${COVERSUFIX}-${A3PLUSSUFIX}"  "\\documentclass[landscape,border=0mm]{article}\\usepackage[paperwidth=483mm,paperheight=329mm,margin=0mm]{geometry}\\usepackage{pdfpages}\\pagestyle{empty} \\begin{document}\\null\\vfill\\null\\hfill\\includegraphics{${OUTPUTDIR}/${BASENAME}-${COVERSUFIX}-${A3SIMPLESUFIX}}\\end{document}"

if $INCLUDEBACK ; then
	echo "Includeback pris en compte"
	pdfjam --quiet /tmp/coverpage-internal_{001,002}.pdf  --nup 2x1 --landscape --outfile /tmp/unifiedcover-2.pdf

	# Nom des fichiers PDF A4
	fileA="/tmp/coverpage-internal_001.pdf"
	fileB="/tmp/coverpage-internal_002.pdf"

	# Conversion de centimètres en points (1 cm = 28.3465 points)
	espace_blanc_pt=$(echo "scale=5; $espace_blanc_cm * 28.3465" | bc)
	largeur_concatenee=$(echo "$espace_blanc_pt + 1190.551" | bc)

	# Calcul des dimensions du papier A4 avec l'espace blanc
	papersize_with_margin="{841.890pt,${largeur_concatenee}pt}"

	# Calcul de l'offset pour le deuxième fichier PDF

	# Fichier de sortie
	pdfjam --outfile "${OUTPUTDIR}/${BASENAME}-${INTERIORSUFIX}-${A3SIMPLESUFIX}".pdf  --nup '2x1' --papersize "$papersize_with_margin" --landscape --delta '1cm 0cm' --frame 'false' -- $fileA $fileB
	xelatex -output-directory="${OUTPUTDIR}" -jobname="${BASENAME}-${INTERIORSUFIX}-${A3PLUSSUFIX}"  "\\documentclass[landscape,border=0mm]{article}\\usepackage[paperwidth=483mm,paperheight=329mm,margin=0mm]{geometry}\\usepackage{pdfpages}\\pagestyle{empty} \\begin{document}\\null\\vfill\\includegraphics{${OUTPUTDIR}/${BASENAME}-${INTERIORSUFIX}-${A3SIMPLESUFIX}.pdf}\\end{document}"

#	pdftk A=${OUTPUTDIR}/ascension-dhelios-skylab-COUVERTURE-IMPOSE-A3plus.pdf B=${OUTPUTDIR}/ascension-dhelios-skylab-COUVERTUREINTERNE-IMPOSE-A3plus.pdf cat A B output ${OUTPUTDIR}/ascension-dhelios-skylab-COUVERTURE-IMPOSE-A3plus.tmp.pdf

#	mv ${OUTPUTDIR}/ascension-dhelios-skylab-COUVERTURE-IMPOSE-A3plus.tmp.pdf ${OUTPUTDIR}/ascension-dhelios-skylab-COUVERTURE-IMPOSE-A3plus.pdf
fi
