
using JuMP
using Cbc
using Clp
using NLopt
using Ipopt
# using DataFrames

# m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
m = Model(solver=IpoptSolver())

# Decision variables
@variable(m, 1 <= x[i=1:4] <= 5)

# oBJECTIVE FUNCTION
@NLobjective(m, Min, x[1]*x[4]*(x[1]+x[2]+x[3])+x[3])

@NLconstraint(m, x[1]*x[2]*x[3]*x[4] >= 25)
@NLconstraint(m, 39.5 <= (x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2) <= 40.5)

# Solve the optimization problem
solve(m)

# Determine decision variables
println("variable values: ", getvalue(x))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
