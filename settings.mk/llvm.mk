ifndef llvm.llvm_config
	llvm.llvm_config := llvm_config
endif
llvm.include_dirs := `${llvm.llvm_config} --cxxflags`
llvm.libraries := `${llvm.llvm_config} --ldflags --libs`
