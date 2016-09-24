# This problem and the following are optional. If you are interested in using Julia and JuMP in practice,
# we encourage you to try it out. This exercise and the following one are similar to PART D and PART D II.
# Instead of solving a problem using a 3 x 3 matrix, this problem includes a 1000 x 1000 matrix.
# If you solve the problem, you can honestly say that you have solved a million variable integer program.

# Till now, eHarmony has 33 million members. Spreadsheet optimization is too cumbersome to use for
# day-to-day operations. Instead they need to rely on "modeling languages." In this part, we are going
# to use Julia/JuMP to solve a large-scale matching problem for eHarmony. In the material of problem set 3,
# you will find a csv (comma-separated values) file compatibility_score_integers.csv, which represents
# compatibility score among 1000 men and 1000 women. The numbers in "compatibility_score.csv"
# constitutes a 1000 x 1000 matrix, where each row corresponds to a man, each column corresponds to a woman.
# Your task here is to solve this 1000 x 1000 matching problem based on the integer programming formulation
# in PART G using Julia/JuMP. The "readcsv" function in Julia will be helpful. We also provide a smaller
# data set 20 x 20 compatibility_score_debug_integers.csv in the problem set materials.
# You may debug your model with this smaller data set first before try the 1000 x 1000 version.
# Any bug in the 1000 x 1000 version could possibly take an absurdly long time to fix.
# (If you have correctly solved the 1000 x 1000 instance of this problem, then you have solved your
# first linear (integer) program with 1 million variables.)

using JuMP
using Cbc
using Clp
using DataFrames

m = Model(solver=CbcSolver())

# Decision variables
@variable(m, DecisionVar[i=1:1000, j=1:1000], Bin)

# Read compatibility scores
# CompScore = readtable("./compatibility_score_debug_integers.csv",header=false)
CompScore = readtable("./compatibility_score_integers.csv",header=false)

# Add constraints
for i = 1:1000
  @constraint(m, sum{DecisionVar[i,k],k=1:1000} == 1) # each boy gets a girl
  @constraint(m, sum{DecisionVar[k,i],k=1:1000} == 1) # each girl gets a boy
end

# Maximize overall utility
@objective(m,Max, sum{DecisionVar[x,y]*CompScore[x,y],x=1:1000,y=1:1000})

# Solve the optimization problem
solve(m)
# Determine decision variables
println("variable values: ", getValue(DecisionVar))
# Determine objective function
println("Objective value: ", getObjectiveValue(m))
