# Adapted from https://github.com/julia-vscode/julia-vscode/blob/1da85dc37b54723c1bc4b313d2c11a974c7656b4/scripts/tasks/task_compileenv.jl instead
using Pkg, Libdl, PackageCompiler, HMCExamples

#project = dirname(@__DIR__)  # Must be one level deep below the project file
sysimage_path = joinpath(pkgdir(HMCExamples), "JuliaSysimage.$(Libdl.dlext)")  # consistent naming with vscode
precompile_execution_file = joinpath(pkgdir(HMCExamples), "test", "runtests.jl")

@info "Using unit tests for precompile execution file."
@info "Now building a custom sysimage for the environment to $sysimage_path"
PackageCompiler.create_sysimage(; sysimage_path, precompile_execution_file)
