using JuMP
using Clp
using DataFrames

#using Gurobi
m = Model(solver=ClpSolver())

# decision variables
S = ["f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"]
# non-negativity
@defVar(m, x[S] >= 0)

# read inputs
myData = readtable("./fooddata.csv",header=true)

# add constraints
@addConstraint(m, sum([myData[i,:Fat]*x[s] for (i,s) in enumerate(S)]) >= 50)
@addConstraint(m, sum([myData[i,:Carbohydrate]*x[s] for (i,s) in enumerate(S)]) >= 300)
@addConstraint(m, sum([myData[i,:Protein]*x[s] for (i,s) in enumerate(S)]) >= 60)
@addConstraint(m, c4, sum([myData[i,:Saturated_Fat]*x[s] for (i,s) in enumerate(S)]) <= 20)

# Objective function:mimimize calories
@setObjective(m, Min,sum([myData[i,:Calories]*x[s] for (i,s) in enumerate(S)]))

# solve the optimization problem
solve(m)

# determine consumption amounts
println("variable values: ", getValue(x))

# determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
