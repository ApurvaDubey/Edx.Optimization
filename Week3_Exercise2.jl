# The local post office requires full-time employees to meet demands that vary from day to day.
# The number of full-time employees required on each day is given in Table 1.
# Each full-time employee must work five consecutive days and then receive two days off.
# For example, an employee who works Monday to Friday must be off on Saturday and Sunday.
# This schedule for employees repeats every week. We want to formulate an integer program that the
# post office can use to minimize the number of full-time employees who must be hired.

using JuMP
using Cbc
using Clp

m = Model(solver=CbcSolver())

# Decision variables
# Let DecisionVar[1] be the number of full-time employees who work Monday to Friday
@variable(m, DecisionVar[1:7] >= 0, Int)

# comstraints
c1 = sum([DecisionVar[i] for i in (1:1)]) + sum([DecisionVar[i] for i in (4:7)])
c2 = sum([DecisionVar[i] for i in (1:2)]) + sum([DecisionVar[i] for i in (5:7)])
c3 = sum([DecisionVar[i] for i in (1:3)]) + sum([DecisionVar[i] for i in (6:7)])
c4 = sum([DecisionVar[i] for i in (1:4)]) + sum([DecisionVar[i] for i in (7:7)])
c5 = sum([DecisionVar[i] for i in (1:4)]) + sum([DecisionVar[i] for i in (5:5)])
c6 = sum([DecisionVar[i] for i in (2:5)]) + sum([DecisionVar[i] for i in (6:6)])
c7 = sum([DecisionVar[i] for i in (3:6)]) + sum([DecisionVar[i] for i in (7:7)])

@constraint(m, c1 >= 17)
@constraint(m, c2 >= 13)
@constraint(m, c3 >= 15)
@constraint(m, c4 >= 19)
@constraint(m, c5 >= 14)
@constraint(m, c6 >= 16)
@constraint(m, c7 >= 11)

# Minimize
@objective(m, Min, sum([DecisionVar[i] for i in 1:7]))

#Solve the optimization problem
solve(m)
#Determine consumption amounts
println("variable values: ", getValue(DecisionVar))
#Determine optimal cost of consumption
println("Objective value: ", getObjectiveValue(m))
