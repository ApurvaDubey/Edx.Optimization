# A combinatorial auction is an auction in which participants can place bids on sets of items,
# instead of placing bids on individual items. A combinatorial auction is useful in many situations.
# For example, consider the problem of an airline company buying takeoff and landing slots at an airport:
# clearly, the value of a single slot may be small if the slot is taken by itself,
# but the value may be much larger if several slots can be bought at the same time,
# allowing the company to setup flight routes according to the desired timetable.
# Thus, the airport wants to sell its available slots to airline companies maximizing its own profit
# (i.e. the total value at which the slots are sold), allowing airlines to bid on sets of items and
# choosing the most profitable combination of bids among the received ones. Many other examples exist.
# In this problem, we study a simple formulation for a combinatorial auction.

using JuMP
using Cbc
using Clp
using DataFrames

m = Model(solver=CbcSolver())

BidValue = [15,20,32,14,18,28,31,25,5,34]
ItemAvail = [1,2,3,2,1,2,2,2,1,2]
Bids = readtable("./bids.txt",header=true)
#println(vecdot(Bids[1:10,1],BidValue))

# Decision variables
@variable(m, AcceptBid[1:length(ItemAvail)], Bin)

# Intermediate variable
@variable(m, i, Int)

# Add constraints
for i = 1:length(ItemAvail)
  @constraint(m, vecdot(Bids[1:length(ItemAvail),i],AcceptBid) <= ItemAvail[i])
end

# Maximize
@objective(m, Max, sum([AcceptBid[i]*BidValue[i] for i in 1:length(ItemAvail)]))

#Solve the optimization problem
solve(m)
#Determine consumption amounts
println("variable values: ", getValue(AcceptBid))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
