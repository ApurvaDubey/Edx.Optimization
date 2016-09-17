using JuMP
using Clp
using DataFrames

#using Gurobi
m = Model(solver=ClpSolver())

# decision variables
S = ["f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"]
# non-negativity
@defVar(m, x[S] >= 0)

# read inputs
myData = readtable("./fooddata.csv",header=true)


# add constraints
@addConstraint(m,
myData[1,:Fat]*x["f1"] + myData[2,:Fat]*x["f2"] + myData[3,:Fat]*x["f3"] + myData[4,:Fat]*x["f4"] + myData[5,:Fat]*x["f5"] +
myData[6,:Fat]*x["f6"] + myData[7,:Fat]*x["f7"] + myData[8,:Fat]*x["f8"] + myData[9,:Fat]*x["f9"] + myData[10,:Fat]*x["f10"]
>= 50)

@addConstraint(m,
myData[1,:Carbohydrate]*x["f1"] + myData[2,:Carbohydrate]*x["f2"] + myData[3,:Carbohydrate]*x["f3"] + myData[4,:Carbohydrate]*x["f4"] + myData[5,:Carbohydrate]*x["f5"] +
myData[6,:Carbohydrate]*x["f6"] + myData[7,:Carbohydrate]*x["f7"] + myData[8,:Carbohydrate]*x["f8"] + myData[9,:Carbohydrate]*x["f9"] + myData[10,:Carbohydrate]*x["f10"]
>= 300)

@addConstraint(m,
myData[1,:Protein]*x["f1"] + myData[2,:Protein]*x["f2"] + myData[3,:Protein]*x["f3"] + myData[4,:Protein]*x["f4"] + myData[5,:Protein]*x["f5"] +
myData[6,:Protein]*x["f6"] + myData[7,:Protein]*x["f7"] + myData[8,:Protein]*x["f8"] + myData[9,:Protein]*x["f9"] + myData[10,:Protein]*x["f10"]
>= 60)

@addConstraint(m,
myData[1,:Saturated_Fat ]*x["f1"] + myData[2,:Saturated_Fat ]*x["f2"] + myData[3,:Saturated_Fat ]*x["f3"] + myData[4,:Saturated_Fat ]*x["f4"] + myData[5,:Saturated_Fat ]*x["f5"] +
myData[6,:Saturated_Fat ]*x["f6"] + myData[7,:Saturated_Fat ]*x["f7"] + myData[8,:Saturated_Fat ]*x["f8"] + myData[9,:Saturated_Fat ]*x["f9"] + myData[10,:Saturated_Fat ]*x["f10"]
<= 20)


# Objective function:mimimize calories
@setObjective(m, Min,
myData[1,:Calories]*x["f1"] + myData[2,:Calories]*x["f2"] + myData[3,:Calories]*x["f3"] + myData[4,:Calories]*x["f4"] + myData[5,:Calories]*x["f5"] +
myData[6,:Calories]*x["f6"] + myData[7,:Calories]*x["f7"] + myData[8,:Calories]*x["f8"] + myData[9,:Calories]*x["f9"] + myData[10,:Calories]*x["f10"]
)


# solve the optimization problem
solve(m)

# determine consumption amounts
println("variable values: ", getValue(x))

# determine optimal cost of consumption
println("Objetive value: ", getObjectiveValue(m))
