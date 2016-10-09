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

resources =
[10 15 10 10 20;
1 2 2 1 1;
3 1 6 6 3;
2 4 2 5 3]

resourceConstraint = [130 13 45 23]

profit = [51 102 66 66 89]

# Decision variables
@variable(m, x[i=1:5] >= 0)


# set objective to minimize cost
@objective(m, Max,sum{x[j]*profit[j], j=1:5})

# capacity constraint
for indx=1:4
  @constraint(m, sum{x[j]*resources[indx,j], j=1:5} <= resourceConstraint[indx])
end

@constraint(m, x[3] >= x[4])


# Solve the optimization problem
solve(m)

# Determine decision variables
#Determine consumption amounts
println("variable values: ", getvalue(x))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
