# Sudoku is a popular number puzzle. The goal is to place the digits in [1,9] on a
# nine-by-nine grid, with some of the digits already filled in, where [1,9] denotes the
# set of integers from 1 to 9. Your solution must satisfy the following four rules:
#
#     Rule 1. Each cell contains an integer in [1,9].
#     Rule 2. Each row must contain each of the integers in [1,9].
#     Rule 3. Each column must contain each of the integers in [1,9].
#     Rule 4. Each of the nine 3x3 squares with bold outlines must contain each of the integers in [1,9]

using JuMP
using Cbc
using Clp
# using DataFrames

m = Model(solver=CbcSolver())

# Inputs
oppCost =
           [ 75 150 225 75 ;
             357 255 153 306;
             84 105 126 105 ]

# Decision variables
@variable(m, x[i=1:3,j=1:4], Bin) # 1 if region i sends its checks to lockbox j
@variable(m, y[i=1:3], Bin) #  1 if lockbox j is opened and 0 if it is not

# set objective to minimize cost
@objective(m, Min,sum{150*y[i],i=1:3} + sum{oppCost[i,j]*x[i,j],i=1:3,j=1:4})

for i=1:3, j=1:3
  @constraint(m,x[i,j] <= y[j])
end

for i=1:3
  @constraint(m,sum{x[i,j],j=1:4} == 1)
end

# Solve the optimization problem
solve(m)

# Determine decision variables
#Determine consumption amounts
println("variable values: ", getValue(y))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
