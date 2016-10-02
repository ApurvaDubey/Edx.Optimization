# Airlines optimize their ticket sales in order to maximize their revenue.
# This is called the airline network revenue management problem. In this problem,
# we are trying to decide how many tickets for each origin-destination (O-D) pair to sell at each price level.
# The goal is to maximize revenue, and we cannot sell more tickets than there is demand for,
# or space on the planes for.

using JuMP
using Cbc
using Clp
# using DataFrames

m = Model(solver=CbcSolver())

# Inputs
Price = [428 190 642 224 512 190]
Demand = [80 120 75 100 60 110]

# Decision variables
@variable(m, x[i=1:6] >= 0, Int) # refers to the number of tickets to sell for each O-D pair and fare class

# set objective to minimize cost
@objective(m, Max,sum{Price[i]*x[i],i=1:6})

# demand constraint
for i=1:6
  @constraint(m,x[i] <= Demand[i])
end

# capacity constraint
@constraint(m, sum{x[i],i=1:4} <= 166)
@constraint(m, sum{x[i],i=3:6} <= 166)

# Solve the optimization problem
solve(m)

# Determine decision variables
#Determine consumption amounts
println("variable values: ", getValue(x))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
