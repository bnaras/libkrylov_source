#!/usr/bin/env python3

import numpy
import json
import matplotlib.pyplot as plt
import csv
import itertools

with open("real_dp_1a_exact_vals.json", "r") as json_file:
  eigen = json.load(json_file)

print(type(eigen["real(kind_float)array"]["array"][1]["val"][1]))

eigen_file = open('varcosine_eigenval.csv', 'w')

for i in eigen["real(kind_float)array"]["array"]:
    x = i["val"][0]
    y = i["val"][1]
    export_data = [x, y]
    w = csv.writer(eigen_file, delimiter='\t')
    w.writerow(export_data)

eigen_file.close()

with open("real_dp_1a_prob.json", "r") as json_file:
  diag = json.load(json_file)

print(type(diag["type(base)array"]["array"]))

diag_file = open('cayleydiag_val.csv', 'w')

for j in diag["type(base)array"]["array"]:
    r = j["val"][0]
    if j["val"][0] == j["val"][1]:
        d = j["val"][2]
        print(type(d))
        export_data = [r, d]
        w = csv.writer(diag_file, delimiter='\t')
        w.writerow(export_data)

diag_file.close()
