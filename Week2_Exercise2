using JuMP
using Clp
#using Gurobi
m = Model(solver=ClpSolver())

#Food available
S = ["f1","f2"]
#Non-negativity
@defVar(m, x[S] >= 0)

#Nutrient1
@addConstraint(m, 4*x["f1"] + 6*x["f2"] >= 30)
#Nutrient2
@addConstraint(m, 6*x["f1"] + 2*x["f2"] >= 20)
#Nutrient3
@addConstraint(m, 1*x["f1"] + 2*x["f2"] >= 12)

#Minimize cost
@setObjective(m, Min, 2*x["f1"] + 3*x["f2"])

#Solve the optimization problem
solve(m)
#Determine consumption amounts
println("variable values: ", getValue(x))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
