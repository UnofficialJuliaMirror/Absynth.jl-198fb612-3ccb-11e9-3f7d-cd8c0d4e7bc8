using DataFrames
using ProgressMeter

const InvSet = Vector{Expr}

function report(polys::Vector{InvSet}; solvers=[Yices,Z3], timeout=2, maxsol=3, shapes=[full, upper, uni])
    prog = ProgressUnknown("Instances handled:")
    # prog = Progress(length(polys)*length(solvers)*maxsol*length(shapes))
    df = DataFrame(Solver = Type{<:NLSolver}[], Polys = Vector{Basic}[], Shape = MatrixShape[], Roots = Vector{Int}[], Loop = Union{Loop,NLStatus}[], ElapsedSolve = TimePeriod[])
    for solver in solvers
        for invset in polys
            for shape in shapes
                solutions = synth(invset, solver=solver, timeout=timeout, maxsol=maxsol, shape=shape)
                for s in solutions
                    push!(df, (solver, invset, shape, s.info.ctx.multi, s.result, s.elapsed))
                    next!(prog)
                end
            end
        end
    end
    finish!(prog)
    df
end

function rerun(df::DataFrame, row::Int; timeout=2, maxsol=1)
    r = df[row, :]
    solutions = synth(r.Polys, solver=r.Solver, timeout=timeout, maxsol=maxsol, shape=r.Shape)
    for s in solutions
        display(s)
    end
end