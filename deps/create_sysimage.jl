# Adapted from https://github.com/julia-vscode/julia-vscode/blob/1da85dc37b54723c1bc4b313d2c11a974c7656b4/scripts/tasks/task_compileenv.jl instead
import Pkg, Libdl, PackageCompiler

# crude CLI toggle. Either:
# julia ./deps/create_sysimage.jl   # defaults
# julia ./deps/create_sysimage.jl --only_package --no_precompile_tests   #change to only use the one package and not precompile tests, etc.
# julia ./deps/create_sysimage.jl --replace_default # replace the default sysimage.  Ony intended for batch environments without vscode/etc.

all_packages = !("--only_package" in ARGS)
precompile_tests = !("--no_precompile_tests" in ARGS)
replace_default = ("--replace_default" in ARGS)

project = dirname(@__DIR__)  # Must be one level deep below the project file
sysimage_path = joinpath(project, "JuliaSysimage.$(Libdl.dlext)")  # consistent naming with vscode
project_filename = isfile(joinpath(project, "JuliaProject.toml")) ? joinpath(project, "JuliaProject.toml") : joinpath(project, "Project.toml")
project_object = Pkg.API.read_project(project_filename)
packages = all_packages ? Symbol.(collect(keys(project_object.deps))) : Symbol(project_object.name)
precompile_execution_file = precompile_tests ? joinpath(project, "test/runtests.jl") : String[]

precompile_tests && @info "Using unit tests for precompile execution file."
@info "Precompiling packages: $packages: "
if replace_default
    @info "Now replacing the default sysimage with one for the environment '$project'"
    PackageCompiler.create_sysimage(packages; replace_default, project, precompile_execution_file)
else
    @info "Now building a custom sysimage for the environment '$project' to $sysimage_path"
    PackageCompiler.create_sysimage(packages; sysimage_path, project, precompile_execution_file)
end