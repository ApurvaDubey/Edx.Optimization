# In the facility location problem, the goal is to optimally place facilities so
# as to minimize transportation costs from the facilities to the customers.
# In practice, one rarely knows the demand of customers with a high degree of accuracy.
# In addition, the transportation costs themselves may vary with time and are subject to uncertainty.
# In this version of the facility location problem, we assume that all data is known.

# In the first part of this problem, the goal is to locate one or more facilities out
# of five possible sites, which we designated as and . The cost of selecting a facility is $40.
# Coincidentally, there are also five customers that need to be serviced. We refer to them as .
# The delivery cost from each possible facility site to each of the five customers is known.
# The cost of satisfying (all of) the demand of Customer from site .
# (Note that the first index is for the site and the second is for the customer.)
# The delivery cost from all possible sites to all customers are given in Table 1 below.


using JuMP
using Cbc
using Clp
using NLopt
using Ipopt
# using DataFrames

#m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
#m = Model(solver=IpoptSolver())

m = Model(solver=CbcSolver())

# Parameters

##########################################
del_cost = zeros(5,5,5) # initialize delivery cost

del_cost[:,:,1]=[32  7 60 43 54;12 14 15 52 31;42 50 48 18 61;22 20 45 43 29;19 47 11 16 53] # delivery cost under scenario 1
del_cost[:,:,2]=[10 12 26 19 21;22 46 17 20  9;61 67 17 20 19;31 59 10 71 40;13 48 26 54 19] # delivery cost under scenario 2
del_cost[:,:,3]=[33 41 10 12 11;16 18 16 33 30;57 32 50 54 39;37 18 47 35 39;48 49 54 67 74] # delivery cost under scenario 3
del_cost[:,:,4]=[19 55 15 26 45; 2 54 17 45 25;52 50 36 34 37;13 34 33 26 50;54 70 36 20 37] # delivery cost under scenario 4
del_cost[:,:,5]=[24 27 57 39 30;56 14 23 13 64;16 22 79 11 23;62 12 39 64 18;30 15 62 31 41] # delivery cost under scenario 5

prob = [0.1, 0.15, 0.25, 0.2, 0.25] # probability of scenario realization
##########################################

# Decision variables
@variable(m, y[i=1:5], Bin)
@variable(m, x[i=1:5,j=1:5,k=1:5], Bin)


# oBJECTIVE FUNCTION
@objective(m, Min, 40*sum{y[i],i=1:5} +
sum(sum( [(del_cost[i,:,k].*x[i,:,k])*prob[k] for i in (1:5), k in (1:5)] )))

for i=1:5, j=1:5, k=1:5
  @constraint(m, x[i,j,k] <= y[i])
end

for j=1:5, k=1:5
  @constraint(m, sum{x[i,j,k],i=1:5} == 1)
end

# Solve the optimization problem
solve(m)

# Determine decision variables
println("variable values: ", getvalue(x))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
