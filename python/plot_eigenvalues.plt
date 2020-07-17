#! /usr/bin/gnuplot
set terminal png size 1640,980 font "Times-New-Roman,30"
set output "output_eigenvalues.png"
set key right font ",25"

set boxwidth 1.2

set xlabel "Eigenvalue Position" font ",30"

set ylabel 'Eigenvalue' font ",30" offset 2, 0

set ytics  nomirror font ",30"

set xrange [0:500]
set yrange [0:1000]

plot 'outfile.csv' u 1:2 w i lw 2 lt 2 t "Sparsitiy of eigenvalues" axis x1y1,\

pause -1
