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

m = Model()

# Decision variables
@variable(m, x[i=1:9,j=1:9,k=1:9], Bin) # equals to 1 if we put number in the ith row and jth column and 0 otherwise
# @variable(m, a[i=1:9,j=1:9,k=1:9], Bin) # initialization

# initialization
for (i,j,k) in [(1,1,5),(1,2,3),(1,5,7),(2,1,6),(2,4,1),(2,5,9),(2,6,5),
        (3,2,9),(3,3,8),(3,8,6),(4,1,8),(4,5,6),
        (4,9,3),(5,1,4),(5,4,8),(5,6,3),(5,9,1),(6,1,7),(6,5,2),(6,9,6),(7,2,6),(7,7,2),(7,8,8),
        (8,4,4),(8,5,1),(8,6,9),(8,9,5),(9,5,8),(9,8,7),(9,9,9)]
        @constraint(m,x[i,j,k] == 1)
end

for i = 1:9, j = 1:9  # Each row and each column
    # Sum across all the possible digits
    # One and only one of the digits can be in this cell,
    # so the sum must be equal to one
    @constraint(m, sum{x[i,j,k],k=1:9} == 1)
end

for ind = 1:9  # Each row, OR each column
    for k = 1:9  # Each digit
        # Sum across columns (j) - row constraint
        @constraint(m, sum{x[ind,j,k],j=1:9} == 1)
        # Sum across rows (i) - column constraint
        @constraint(m, sum{x[i,ind,k],i=1:9} == 1)
    end
end

for i = 1:3:7, j = 1:3:7, k = 1:9
    # i is the top left row, j is the top left column
    # We'll sum from i to i+2, e.g. i=4, r=4, 5, 6
    @constraint(m, sum{x[r,c,k], r=i:i+2, c=j:j+2} == 1)
end

# No Objective Function needed as this is a feasibility problem

# Solve the optimization problem
solve(m)

# Determine decision variables
# Extract the values of x
x_val = getvalue(x)
# Create a matrix to store the solution
sol = zeros(Int,9,9)  # 9x9 matrix of integers
for i in 1:9, j in 1:9, k in 1:9
    # Integer programs are solved as a series of linear programs
    # so the values might not be precisely 0 and 1. We can just
    # round them to the nearest integer to make it easier
    if x_val[i,j,k] == 1
        sol[i,j] = k
    end
end
# Display the solution
println(sol)
