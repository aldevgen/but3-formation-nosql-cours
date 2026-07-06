# Nom du dossier de sortie
OUTPUT_DIR = build

# Nom du fichier principal (sans extension)
MAIN = main

# Créer le dossier de sortie s'il n'existe pas
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Nettoyer les fichiers auxiliaires
clean:
	rm -f $(OUTPUT_DIR)/*.aux $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.blg $(OUTPUT_DIR)/*.out $(OUTPUT_DIR)/*.bbl $(OUTPUT_DIR)/*.nav $(OUTPUT_DIR)/*.snm $(OUTPUT_DIR)/*.vrb
	rm -rf $(OUTPUT_DIR)/_minted/
	rm -f $(OUTPUT_DIR)/*.synctex.gz


# Générer un PDF à partir d'un fichier .tex
%.pdf: %.tex | $(OUTPUT_DIR)
	@rm -f $(OUTPUT_DIR)/$@.pdf 2> /dev/null || true
	@echo '----------------------------------------------------------------------------'
	@echo '------------------------- PDF LaTeX running pass 1 -------------------------'
	@echo '----------------------------------------------------------------------------'
	pdflatex -interaction=batchmode -shell-escape -output-directory=$(OUTPUT_DIR) $< -o $@ 2>&1 | tee errors.err
	# pdflatex -shell-escape -output-directory=$(OUTPUT_DIR) $< -o $@ 2>&1 | tee errors.err
	@echo '----------------------------------------------------------------------------'
	@echo '------------------------- PDF LaTeX running pass 2 -------------------------'
	@echo '----------------------------------------------------------------------------'
	pdflatex -interaction=batchmode -shell-escape -output-directory=$(OUTPUT_DIR) $< -o $@ 2>&1 | tee errors.err
	# pdflatex -shell-escape -output-directory=$(OUTPUT_DIR) $< -o $@ 2>&1 | tee errors.err
	@echo '----------------------------------------------------------------------------'
	@echo '------------------------- PDF LaTeX run finished --------------------------'
	@echo '----------------------------------------------------------------------------'

open:
	#open -a "Adobe Acrobat" $(OUTPUT_DIR)/$(MAIN).pdf
	open -a "Preview" $(OUTPUT_DIR)/$(MAIN).pdf
all:
	make $(MAIN).pdf
	make clean
	make open
