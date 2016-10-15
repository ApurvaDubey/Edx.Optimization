
using JuMP
using Cbc
using Clp
using NLopt
using Ipopt
# using DataFrames

#m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
m = Model(solver=IpoptSolver())

# Decision variables
@variable(m, x[i=1:3] >= 0)

coeff = [10 11 12;21 22 23; 21 22 -23;19 34 -32]

# oBJECTIVE FUNCTION
@NLobjective(m, Max, (2x[1] + 3x[2] + 4x[3])^2)

@NLconstraint(m, sum{x[i] * coeff[1,i],i=1:3} <= 60)
@NLconstraint(m, sum{x[i] * coeff[2,i],i=1:3} <= 150)
@NLconstraint(m, sum{x[i] * coeff[3,i],i=1:3} >= 110)
@NLconstraint(m, sum{x[i] * coeff[4,i],i=1:3} == 180)

# Solve the optimization problem
solve(m)

# Determine decision variables
println("variable values: ", getvalue(x))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
