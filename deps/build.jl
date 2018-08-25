## It seems I need to write this file myself
## The code is mainly inspired by
##   - Source of BinDeps.jl
##   - https://github.com/JuliaOpt/NLopt.jl/blob/master/src/NLopt.jl
##

# get the current path
currentFilePath = @__FILE__()
currentDirPath = dirname(currentFilePath)

# function to mkdir lib dir
function mklibdir()
    usrdir = joinpath(currentDirPath, "usr");
    
    if isdir(usrdir) == false
        mkdir(usrdir);
    end

    libdir = joinpath(usrdir, "lib");
    if isdir(libdir) == false
        mkdir(libdir);
    end
end

# run make file
function runmake()
    usrdir = joinpath(currentDirPath, "usr", "lib");
    run(`make OUTPUTDIR=$(usrdir)`)
end

# write the "deps.jl" file
function writeDeps()
    libpath = joinpath(currentDirPath, "usr", "lib", "liblbfgsbf.so")
    outputfile = open(joinpath(currentDirPath, "deps.jl"), "w");
    write( outputfile, "if VERSION >= v\"0.7.0-DEV.3382\"\nimport Libdl\nend\nmacro checked_lib(libname, path)\n    (Libdl.dlopen_e(path) == C_NULL) && error(\"Unable to load \\n\\n\$libname (\$path)\n\nPlease re-run Pkg.build(package), and restart Julia.\")\n    quote const \$(esc(libname)) = \$path end\nend\n@checked_lib liblbfgsbf \"$(libpath)\"\n")
    close(outputfile)
end

mklibdir()
runmake()
writeDeps()
