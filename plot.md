# plot.py
> A python script to visualize all models found to a flatland problem.

![image](images/Figure_1.png)

## Description
This script takes **2 input arguments**.
1. path to encoding .lp file
2. path to environment .lp file

Clingo then solves the logic programs. This script processes all
generated models, creates a heatmap of train positions, and visualizes
them using Matplotlib. You can use the **optional argument** -n/--models to
set the maximum number of models to be calculated.

> [!IMPORTANT] required facts
> This script only works when your encoding generates train position
> facts of the following format:    
> ~~~ 
> pos(Train_ID, (Y, X), Time).
> ~~~

## Example Usage
    python plot.py asp/encoding.lp envs/lp/env.lp -n 1000
