# Adapted from https://github.com/julia-vscode/julia-vscode/blob/1da85dc37b54723c1bc4b313d2c11a974c7656b4/scripts/tasks/task_compileenv.jl instead
using Libdl, PackageCompiler, HMCExamples

sysimage_path = joinpath(pkgdir(HMCExamples), "JuliaSysimage.$(Libdl.dlext)")  # consistent naming with vscode
precompile_execution_file = joinpath(pkgdir(HMCExamples), "test", "runtests.jl")
sysimage_build_args = `--threads auto`

@info "Using unit tests for custom sysimage for the environment to $sysimage_path"
PackageCompiler.create_sysimage(; sysimage_path, precompile_execution_file, sysimage_build_args)
