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

c = [30 50 64 46 19; 15 42 14 19 40; 59 25 30 66 60; 78 30 20 48 31; 27 53 62 11 27]
ct = transpose(c)
# Decision variables
@variable(m, y[i=1:5], Bin)
@variable(m, x[i=1:5,j=1:5], Bin)


# oBJECTIVE FUNCTION
@objective(m, Min, 40*sum{y[i],i=1:5} + sum(sum([ct[i,:].*x[i,:] for i in (1:5)])))

for i=1:5, j=1:5
  @constraint(m, x[i,j] <= y[i])
end

for j=1:5
  @constraint(m, sum{x[i,j],i=1:5} == 1)
end

# Solve the optimization problem
solve(m)

# Determine decision variables
println("variable values: ", getvalue(y))

#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
