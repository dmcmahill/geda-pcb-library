# -*- Makefile -*-
#

.PHONY: all
all: components

AWK         ?= awk
PREFIX      ?= ${HOME}/share/gEDA/symbols

# source directory
SRC_DIR     ?= .

# in the build tree
SYMBOLS_DIR =  symbols

# symbol templates
#SYM_SRCS    != ls ${SRC_DIR}/symbol_templates/*.sym.in
SYM_SRCS    = $(shell, ls ${SRC_DIR}/symbol_templates/*.sym.in)

.PHONY: install
install: all
	@echo "Installing custom libraries"
	test -d "${PREFIX}" || mkdir -m0755 -p "${PREFIX}"
	@for f in ${SYMBOLS_DIR}/* ; do \
		fb=`basename "$$f"` ; \
		echo "Install $$fb to ${PREFIX}/" ; \
		if test -f "${PREFIX}/$$fb" ; then rm -f "${PREFIX}/$$fb" ; fi ; \
		cp "$$f" "${PREFIX}/$$fb" ; \
		chmod 644 "${PREFIX}/$$fb" ; \
	done

.PHONY: components
components: components-stamp
components-stamp: scripts/make_syms.awk components.dat ${SYM_SRCS}
	test -d "${SYMBOLS_DIR}" || mkdir "${SYMBOLS_DIR}"
	rm -f "${SYMBOLS_DIR}"/*
	${AWK} -f "${SRC_DIR}/scripts/make_syms.awk" "${SRC_DIR}/components.dat"
	touch $@

.PHONY: resistor
resistor:
	echo "resistors"

.PHONY: clean
clean:
	rm -f gschem.log gattrib.log *~
	rm -f components-stamp
	rm -f out/*
	rm -f symbols/*

REL_DIR=	dan-syms-v0.1

.PHONY: release
release: components
	echo "Creating release:  ${REL_DIR}"
	if test -d ${REL_DIR}  ; then rm -fr ${REL_DIR} ; fi
	mkdir ${REL_DIR}
	cp symbols/*.sym ${REL_DIR}
	tar -zcvf ${REL_DIR}.tar.gz ${REL_DIR}


########################################################################
#
# debug targets
#
########################################################################

##
## Usage:
##   make show-var VARNAME=FOO
##

.PHONY: show-var
show-var:
	@echo '${VARNAME} = ${${VARNAME}}'

