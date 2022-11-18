.PHONY: all
all: full.out ref.out

.PHONY: clean
clean:
	rm -f *.ll *.thorin.json *.out

RUNTIME_OPT := \
${THORIN_RUNTIME_PATH}/artic/intrinsics_amdgpu.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_cpu.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_cuda.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_hls.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_nvvm.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_opencl.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_rv.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics.impala

RUNTIME := \
${THORIN_RUNTIME_PATH}/artic/intrinsics_thorin.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_math.impala \
${THORIN_RUNTIME_PATH}/artic/runtime.impala

.PRECIOUS: %.thorin.json
%.thorin.json: %.art
	artic --emit-json $^ $(RUNTIME)

.PRECIOUS: %.ll
%.ll: %.thorin.json
	anyopt $^

full.out: full.ll
	clang -o full.out -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime full.ll

ref.out: full.art
	artic --emit-llvm -o full-ref $^ $(RUNTIME)
	clang -o ref.out -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime full-ref.ll
