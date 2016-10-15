
using JuMP
using Cbc
using Clp
using NLopt
# using DataFrames

m = Model(solver=NLoptSolver(algorithm=:LD_MMA))

# Decision variables
@variable(m, x[i=1:2] >= 0)

# oBJECTIVE FUNCTION
@NLobjective(m, Min, 100( (x[2] - (0.5+x[1])^2)^2 + (1-x[1])^2))

# Solve the optimization problem
solve(m)

# Determine decision variables
println("variable values: ", getvalue(x))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
