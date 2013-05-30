# Settings for compiling and linking against Global Arrays
ga.dir = /Users/jturney/Install/ga
ga.include_dirs := ${ga.dir}/include
ga.libraries := ga armci ${scalapack.libraries}
ga.library_dirs := ${ga.dir}/lib ${scalapack.library_dirs}
