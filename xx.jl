using JuMP
using Clp
#using Gurobi
m = Model(solver=ClpSolver())

#Food available
S = ["brownies","ice cream","cola","cheese cake"]
#Non-negativity
@defVar(m, x[S] >= 0)
#Minimum calories
@addConstraint(m, 400x["brownies"] + 200x["ice cream"] + 250x["cola"] + 500x["cheese cake"] >= 500)
#At least 6 grams of chocolate
@addConstraint(m, 3x["brownies"] + 2x["ice cream"] >= 6)
#At least 10 grams of sugar
@addConstraint(m, 2x["brownies"] + 2x["ice cream"] + 4x["cola"] + 4x["cheese cake"] >= 10)
#At least 8 grams of fat
@addConstraint(m, 2x["brownies"] + 4x["ice cream"] + 1x["cola"] + 5x["cheese cake"] >= 8)
#Minimize cost of consumption
@setObjective(m, Min, 0.5x["brownies"] + 0.2x["ice cream"] + 0.3x["cola"] + 0.8x["cheese cake"])
#Solve the optimization problem
solve(m)
#Determine consumption amounts
println("variable values: ", getValue(x))
#Determine optimal cost of consumption
println("Objetive value: ", getObjectiveValue(m))
