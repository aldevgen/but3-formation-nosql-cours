# Nom du dossier de sortie
OUTPUT_DIR = build

# Nom du fichier principal (sans extension)
MAIN = main

LATEX = pdflatex -interaction=batchmode -shell-escape -output-directory=$(OUTPUT_DIR)
# debug
#LATEX = pdflatex -shell-escape -output-directory=$(OUTPUT_DIR)

.PHONY: slides notes handout clean open all

# Compiler main.tex en deux passes sous le nom $(1).pdf, avec \coursmode = $(2)
define compile
	@rm -f $(OUTPUT_DIR)/$(1).pdf 2> /dev/null || true
	@echo '----------------------------------------------------------------------------'
	@echo '------------------------- PDF LaTeX running pass 1 -------------------------'
	@echo '----------------------------------------------------------------------------'
	$(LATEX) -jobname=$(1) "\def\coursmode{$(2)}\input{$(MAIN)}" 2>&1 | tee errors.err
	@echo '----------------------------------------------------------------------------'
	@echo '------------------------- PDF LaTeX running pass 2 -------------------------'
	@echo '----------------------------------------------------------------------------'
	$(LATEX) -jobname=$(1) "\def\coursmode{$(2)}\input{$(MAIN)}" 2>&1 | tee errors.err
	@echo '----------------------------------------------------------------------------'
	@echo '------------------------- PDF LaTeX run finished --------------------------'
	@echo '----------------------------------------------------------------------------'
endef

# Slides de présentation : build/slides.pdf
slides: | $(OUTPUT_DIR)
	$(call compile,slides,0)

# Slides avec les notes (3 slides par page A4) : build/notes.pdf
notes: | $(OUTPUT_DIR)
	$(call compile,notes,1)

# Support pour les étudiant·es (sans animations ni notes) : build/handout.pdf
handout: | $(OUTPUT_DIR)
	$(call compile,handout,2)

# Créer le dossier de sortie s'il n'existe pas
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Nettoyer les fichiers auxiliaires
clean:
	rm -f $(OUTPUT_DIR)/*.aux $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.blg $(OUTPUT_DIR)/*.out $(OUTPUT_DIR)/*.bbl $(OUTPUT_DIR)/*.nav $(OUTPUT_DIR)/*.snm $(OUTPUT_DIR)/*.vrb
	rm -rf $(OUTPUT_DIR)/_minted/
	rm -f $(OUTPUT_DIR)/*.synctex.gz

open:
	#open -a "Adobe Acrobat" $(OUTPUT_DIR)/slides.pdf
	open -a "Preview" $(OUTPUT_DIR)/slides.pdf

all:
	make slides
	make notes
	make handout
	make clean
	make open
