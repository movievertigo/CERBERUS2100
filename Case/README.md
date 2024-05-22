# Cerberus 2100 Case

To secure the PCB to the case you will need five M2.5x6mm bolts and nuts.

The case was designed in OpenSCAD and positions, sizes and tolerances can be tweaked easily in there if necessary.

## SCAD tweaks

* The sizes and positions of the various holes are defined at the top of the file and should be fairly self explanatory.

* Longer than 6mm M2.5 bolts can be used if you increase "UnderBoardGap" in the SCAD file to compensate.

* By default the design has a large gap for the CAT programmer to attach on the right hand side of the board.  If you don't use this and wish to remove the hole, you can set EnableCAT to zero

* Currently the lid fits quite snugly to the case.  If you want a looser fit, you can tweak LidRunnerExpansion and LidRunnerTopExpansion.
