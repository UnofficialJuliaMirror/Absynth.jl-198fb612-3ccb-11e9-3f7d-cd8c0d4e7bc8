module Absynth

using MacroTools
using Combinatorics
using LinearAlgebra
using SymEngine
using SymPy

include("nlsat.jl")

using Absynth.NLSat

const Yices = YicesSolver
const Z3 = Z3Solver

export YicesSolver, Z3Solver, Yices, Z3

include("constraints.jl")
include("synthesizer.jl")
include("show.jl")

export synth

# ------------------------------------------------------------------------------

# atoms(f, ex) = MacroTools.postwalk(x -> x isa Symbol && Base.isidentifier(x) ? f(x) : x, ex)
# function free_symbols(ex::Expr)
#     ls = Symbol[]
#     atoms(x -> (push!(ls, x); x), ex)
#     Base.unique(ls)
# end

end # module