# A school wants to illuminate six corridors, labeled A, B, C, D, E and F. The corridors
# are portrayed in Figure 1. Each corridor can be illuminated by placing lights at one or
# both ends of the corridor, which we label as intersections 1 to 5. The luminosity required
# for each corridor is given in Table 1. For example, the luminosity in Corridor A is required
# to be 250. This requirement should be interpreted as meaning that the sum of the
# luminosities of bulbs at Intersections 1 and 2 must be at least 250. Remember that one cannot
# place bulbs at an intersection unless one first puts in a lighting fixture.

# The cost of placing the light fixtures is $450 per corner. (There is no cost if there is
# no light fixture in a corner.) The cost of the bulbs is $2 per luminosity unit.
# The maximum luminosity that can be placed in any light fixture is 300 units. The number of
# units of luminosity is permitted to be fractional. As an illustration, to create a luminosity
# of 60.5 at a corner with a light fixture requires an expense of $121 in bulbs plus an expense of
# $450 for putting in the light fixture.

using JuMP
using Cbc
using Clp
# using DataFrames

m = Model(solver=CbcSolver())

# Decision variables
@variable(m, DecisionVarY[i=1:5], Bin) # if we place a light fixture in intersection
@variable(m, DecisionVarX[i=1:5]) # luminosity units of light bulb(s) in intersection

# Read compatibility scores
# CompScore = readtable("./compatibility_score_debug_integers.csv",header=false)

# Add constraints
for i = 1:5
  @constraint(m, DecisionVarX[i] <= 300*DecisionVarY[i])
end

# Initial constraints
@constraint(m, DecisionVarX[1] + DecisionVarX[2] >= 250)
@constraint(m, DecisionVarX[1] + DecisionVarX[3] >= 300)
@constraint(m, DecisionVarX[2] + DecisionVarX[3] >= 150)
@constraint(m, DecisionVarX[2] + DecisionVarX[4] >= 200)
@constraint(m, DecisionVarX[3] + DecisionVarX[5] >= 350)
@constraint(m, DecisionVarX[4] + DecisionVarX[5] >= 180)

# Additional constraints
@variable(m, w, Bin)
@variable(m, z[1:5], Bin)

@constraint(m, sum{z[i],i=1:5} >= 3)

@constraint(m, DecisionVarX[1] >= 300*w)
@constraint(m, DecisionVarX[4] >= 300*(1-w))

for i = 1:5
  @constraint(m, DecisionVarX[i] <= 150 + 150*(1-z[i]))
end

@constraint(m, 0.6*DecisionVarX[1] - 0.4*DecisionVarX[3] <= 0)

# Minimize cost
@objective(m,Min, sum{450*DecisionVarY[i],i=1:5}+sum{2*DecisionVarX[i],i=1:5})

# Solve the optimization problem
solve(m)
# Determine decision variables
println("variable values: ", getValue(DecisionVarY))
println("variable values: ", getValue(DecisionVarX))
# Determine objective function
println("Objective value: ", getObjectiveValue(m))
