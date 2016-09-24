# eHarmony is an online dating site focused on long term relationships.
# It takes a scientific approach to love and marriage. About nearly 4% of US marriages in 2012 are a result of eHarmony.
# The company has generated over $1 billion in cumulative revenue from 2000, the year it was founded.
# Unlike other online dating websites, eHarmony does not have users browse others' profiles.
# Instead, eHarmony computes a compatibility score between two people and uses optimization algorithms
# to determine their users' best matches. In this problem, we are going to see how eHamony uses
# integer programming to find good matches. The compatibility scores in the table below indicates
# how compatible a match is. A higher number indicates that the compatibility is greater.

using JuMP
using Cbc
using Clp

m = Model(solver=CbcSolver())

x = ["x11","x12","x13","x21","x22","x23","x31","x32","x33"]
CompScore = [1,3,5,4,2,2,1,5,3]

#@variable(m, DecisionVar[x], Bin)
@variable(m, 0 <= DecisionVar[x] <= 1)

# each boy gets a girl
@constraint(m, sum([DecisionVar[x[i]] for i in (1,2,3)])  == 1)
@constraint(m, sum([DecisionVar[x[i]] for i in (4,5,6)])  == 1)
@constraint(m, sum([DecisionVar[x[i]] for i in (7,8,9)])  == 1)

# each girl gets a boy
@constraint(m, sum([DecisionVar[x[i]] for i in (1,4,7)])  == 1)
@constraint(m, sum([DecisionVar[x[i]] for i in (2,5,8)])  == 1)
@constraint(m, sum([DecisionVar[x[i]] for i in (3,6,9)])  == 1)

# additional constraint
@constraint(m, DecisionVar["x13"] <= DecisionVar["x22"])
@constraint(m, DecisionVar["x33"] <= DecisionVar["x22"])

# Maximize utility
@objective(m, Max, sum([DecisionVar[x]*CompScore[i]  for (i,x) in enumerate(x)]))

# Solve the optimization problem
solve(m)
# Determine decision variables
println("variable values: ", getValue(DecisionVar))
# Determine optimal happiness
println("Objective value: ", getObjectiveValue(m))
