#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy
import json

with open("real_dp_1a_exact_vals.json", "r") as json_file:
  data = json.load(json_file)
  #y = float(data["real(kind_float)array"]["array"][0]["val"][0])
  #print(y)

#for each in data["real(kind_float)array"]["array"]:
 #   print(each["val"][0], float(each["val"][1]))
  
i = 0
x = list()
y = list()

while i <501:
    for i in data["real(kind_float)array"]["array"]:
        x.append(i["val"][0]);
        y.append(i["val"][1]);
        plt.stem(["val"][0], ["val"][1], use_line_collection=True)
        i+ = 1;
        plt.show()


