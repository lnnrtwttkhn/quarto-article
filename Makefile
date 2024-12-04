IMAGES_URL=https://cloud.uni-hamburg.de/s/MsqQbgRkswr2aFj/download
IMAGES_ARCHIVE=images.zip
IMAGES_DIR=images/
TARGET_WORD := quarto-article
REPLACEMENT_WORD := test-word
FILES := ./_quarto.yml ./_variables.yml ./plausible.html ./README.md

.PHONY: preview
preview:
	quarto preview

.PHONY: render
render: clean images
	quarto render index.qmd

.PHONY: pdf
pdf: clean images
	quarto render --profile pdf

.PHONY: deploy
deploy: clean images
	quarto publish gh-pages

.PHONY: images
images:
	wget $(IMAGES_URL) -O $(IMAGES_ARCHIVE)
	unzip -j -o $(IMAGES_ARCHIVE) -d $(IMAGES_DIR)
	rm -f $(IMAGES_ARCHIVE)

.PHONY: clean
clean:
	rm -rf _site $(IMAGES_DIR)*
	
.PHONY: replace
replace:
	@for file in $(FILES); do \
		sed -i '' "s/$(TARGET_WORD)/$(REPLACEMENT_WORD)/g" "$$file"; \
	done
	@find . -type f -name "*$(TARGET_WORD)*" | while read -r file; do \
		new_name=$$(echo "$$file" | sed "s/$(TARGET_WORD)/$(REPLACEMENT_WORD)/g"); \
		git mv "$$file" "$$new_name"; \
	done