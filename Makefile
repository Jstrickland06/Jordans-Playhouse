# Makefile for Jordans Olive Garden menu solution

SCRIPT = myMenuScript.sh
INPUT  = olive_raw.txt
OUTPUT = my_output.csv
README = README.md
PACKAGE = menu_solution.zip

help:
	@echo "Jordan Strickland"
	@echo "To build the deployment package: make build"
	@echo "To deploy the package (git commit): make deploy"

build: $(SCRIPT) $(INPUT) $(OUTPUT) $(README)
	zip -r $(PACKAGE) $(SCRIPT) $(INPUT) $(OUTPUT) $(README)

deploy: build
	git add $(PACKAGE)
	git commit -m "Build and deploy Olive Garden menu solution package"
