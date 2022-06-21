# geda-pcb-library
Library of components for gEDA

# Overview
One of the challenges with maitaining an effective PCB design flow is
library management.  An environment where all the schematic symbols
and PCB footprints already exist is much faster than one where new symbols
and footprints need to be added for each design.

This project creates a collection of "heavy" symbols for gschem.  A
"heavy" symbol is one which has already been associated with an exact
part number and a footprint.  The basic idea is to start with manually
created symbols and the fairly large footprint library available in the
pcb package.  Then a simple database file takes a part number and maps
the generic symbol pinout to the required footprint pinout to create
symbols for use in design.


# NO WARRANTY
The author is not able to make any claims of accuracy or suitability for
a particular use and in no circumstance will be held liable for failed
boards.  You should *always* vet your libraries.  I've seen cases of
libraries supplied with even high end commercial tools have fatal mistakes.
Those mistakes include, but have not been limited to: incorrect pitch on
a surface mount QFP/TQFP package, incorrect drill size on leaded parts, incorrect
pad size on surface mount parts, incorrect pin out on some package types.
While I have tried my best it is not possible to have a complete guarantee.

# Bipolar Junction Transistor Example
Bipolar junciton transistors (BJT) provide a more concrete example for the library flow.
A standard bipolar transistor symbol has 3 terminals; emitter, base, and collector.
There are two flavors, NPN and PNP.  This only takes two manually drawn symbols.
There are many many different transistor types, 2N3904, 2N2222, MMBT3904, 2N5179, to
name a few.  Each of these may be in a different package with each package having
a different mapping between logical pin (emitter, base, collector) and footprint
pin (1, 2, 3).

The following is an excerpt from the ASCII mapping file.  Please refer to comments
in that file for the most up to date description of the fields.  For the purposes
of illustration here, the first field is the component that we will be generating.
The next field specifies a symbol template.  The next field is used for parts
that have a value (resistance, zener voltage, etc).  Next is the footprint name.
Finally is the pin mapping between the symbol template and the footprint.


```
MMBT3904LG      |npn.sym.in || SOT23 | 3,1,2 ||           | On Semiconductor
MMBT5179        |npn.sym.in || SOT23 | 3,1,2 ||           | Fairchild
MPS5179         |npn.sym.in || TO92  | 3,2,1 ||           | Fairchild
```

# Other Use Cases
- Standard resistor families
- Zener diode familes
- ICs that may be offered in multiple package options.  Sometimes the
different package options have a different pin count and pinout.  This
lets us easily pick the one we want for our design and have some confidence
that the pins are correct for the selected package.

# Tool Links

