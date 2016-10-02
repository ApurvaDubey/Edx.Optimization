# Factory F produces three different products with a single machine. The factory starts
# operations at 9 AM every morning and ends operations at 5 PM. (Each day has 480 minutes of work.)
# The machine is configured differently for the three products.
# To configure the machine to start producing product requires a set-up time (see Table 1).
# If, for example, the machine were producing product 2,
# and we would like to switch production to product 1, we would require 45 minutes of set-up time.
# At the beginning of each day, the machine has to be configured (requires set-up time) regardless of
# what the last item produced was on the previous day.

# The time horizon for this problem is four days. At the end of each day, the factory must meet
# the demand for each product given in Table 1. If there are items remaining after meeting demand,
# these items are stored in inventory at a cost of per unit for product (see Table 1).

# Using the original given values, consider that it is possible to have a Super Production (SP)
# day in which there are an extra 2 hours in the day. The extra two hours costs $50 because
# of increased labor costs. The factory can have up to two SP days out of four, but the two
# days cannot be consecutive. Formulate the modified machine scheduling problems as a mixed
# integer linear program. Let for t = 1, 2, 3, 4 be the extra decision variables. means that
# day is a super production day; , otherwise.


using JuMP
using Cbc
using Clp
# using DataFrames

m = Model(solver=CbcSolver())

# Inputs
SetUpTime = [45 60 100]
Price = [50 70 120]
ProductionRate = [5 4 2]
InventoryCost = [18 15 25]
DailyDemand = [400 600 200 800; 240 440 100 660; 80 120 40 100]

# Decision variables
@variable(m, 480 >= x[i=1:3,t=1:4] >= 0) # denotes the time the machine spends on day t producing item i
@variable(m, y[i=1:3,t=1:4] >= 0) # number of units of item i produced on day t
@variable(m, z[i=1:3,t=1:4], Bin) # if we set up the machine to produce item i in day t
@variable(m, s[i=1:3,t=0:4] >= 0) # amount of product i that is stored in inventory from the end of day t
@variable(m, u[i=1:4], Bin) # amount of product i that is stored in inventory from the end of day t

# set objective to minimize cost
@objective(m, Max,sum{Price[i]*y[i,t] - InventoryCost[i]*s[i,t],i=1:3,t=1:4} - sum{50*u[t],t=1:4})

# SP day can be at max two in four days
@constraint(m, sum{u[t],t=1:4} <= 2)

# SP days cannot be consecutive
for t=1:3
  @constraint(m, u[t]+u[t+1]<=1)
end

# Production: quantity that can be produced in a day
for i=1:3, t=1:4
  @constraint(m, y[i,t] == ProductionRate[i]*x[i,t])
end

# Include set-up time to production
for t=1:4
  @constraint(m, sum{x[i,t]+ SetUpTime[i]*z[i,t],i=1:3}  <= 480 + 120*u[t])
end

# Production should happen if the machine has been set up (z)
for i=1:3, t=1:4
  @constraint(m, x[i,t] <= z[i,t]*600)
end

# Inventory constraints, 0 inventory at the beginning and at the end
for i=1:3
  @constraint(m,s[i,4] == 0)
  @constraint(m,s[i,0] == 0)
end

# Products filed to inventory
for i=1:3, t=1:4
  @constraint(m,  s[i,t] == s[i,t-1] + y[i,t] - DailyDemand[i,t])
end

# Demand constraints
for i=1:3, t=1:4
  @constraint(m, y[i,t] + s[i,t-1] >= DailyDemand[i,t])
end

# Solve the optimization problem
solve(m)

# Determine decision variables
println("X variable values: \n", round(getValue(x),0))
println("Y variable values: \n", round(getValue(y),0))
println("Z variable values: \n", round(getValue(z),0))
println("S variable values: \n", getValue(s))
println("U variable values: \n", round(getValue(u),0))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
