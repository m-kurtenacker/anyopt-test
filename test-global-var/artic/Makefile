.PHONY: all
all: ref test test-artic

.PHONY: clean
clean:
	rm -rf ref test test-artic *.ll *.thorin.json

RUNTIME_OPT := \
${THORIN_RUNTIME_PATH}/artic/intrinsics_amdgpu.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_cpu.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_hls.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_nvvm.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_opencl.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_thorin.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_cuda.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_math.impala \
${THORIN_RUNTIME_PATH}/artic/intrinsics_rv.impala

RUNTIME := \
${THORIN_RUNTIME_PATH}/artic/runtime.impala

.PRECIOUS: %.thorin.json
%.thorin.json: %.art
	artic --emit-json $^ $(RUNTIME)

.PRECIOUS: %.ll
%.ll: %.art
	artic --emit-llvm $^ $(RUNTIME)

ref: import.ll exports.ll
	clang -o ref -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime $^

test: import.thorin.json exports.thorin.json
	anyopt --emit-llvm -o test $^
	clang -o test -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime test.ll

test-artic: import.art exports.art
	artic --emit-llvm -o test-artic $^ $(RUNTIME)
	clang -o test-artic -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime test-artic.ll
