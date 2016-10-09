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
@variable(m, 5000 >= R >= 1000)
@variable(m, 6000 >= G >= 1000)

# set objective to minimize cost
@objective(m, Max,10*R + 3*G)

# capacity constraint
@constraint(m, R+G <= 8000)

# Solve the optimization problem
solve(m)

# Determine decision variables
#Determine consumption amounts
println("variable values: ", getValue(R))
println("variable values: ", getValue(G))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
