using JuMP
using Clp
using DataFrames

#using Gurobi
m = Model(solver=ClpSolver())

# decision variables
S = ["x11","x12","x21","x22","x31","x32"]
#W = [1,2,1.2,3,2,3]
# non-negativity
@defVar(m, x[S] >= 0)
#@defVar(m, z >= 0)

@variable(m,z)
# read inputs
# myData = readtable("./fooddata.csv",header=true)

# add constraints
@constraint(m, x["x11"] + x["x21"] + x["x31"] <= z)
@constraint(m, x["x12"] + x["x22"] + x["x32"] <= z)
@constraint(m, x["x11"] + 2*x["x12"] == 15)
@constraint(m, 1.2*x["x21"] + 3*x["x22"] == 24)
@constraint(m, 2*x["x31"] + 3*x["x32"] == 18)

# Objective function:mimimize calories
@objective(m, Min,z)

# solve the optimization problem
solve(m)

# determine consumption amounts
println("variable values: ", getvalue(x))

# determine optimal cost of consumption
println("Objective value: ", getobjectivevalue(m))
