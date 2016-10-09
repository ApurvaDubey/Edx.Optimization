# Airlines optimize their ticket sales in order to maximize their revenue.
# This is called the airline network revenue management problem. In this problem,
# we are trying to decide how many tickets for each origin-destination (O-D) pair to sell at each price level.
# The goal is to maximize revenue, and we cannot sell more tickets than there is demand for,
# or space on the planes for.

using JuMP
using Cbc
using Clp
# using DataFrames

m = Model(solver=ClpSolver())

# Decision variables
@variable(m, x[i=1:3] >= 0)

# set objective to minimize cost
@objective(m, Max,5x[1] + 4.5x[2] + 6x[3])

# capacity constraint
@constraint(m, 6x[1] + 5x[2] + 8x[3] == 60)
@constraint(m, 10x[1] + 20x[2] + 10x[3] == 150)
@constraint(m, x[1] <= 80)

# Solve the optimization problem
solve(m)

# Determine decision variables
#Determine consumption amounts
println("variable values: ", getvalue(x))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
