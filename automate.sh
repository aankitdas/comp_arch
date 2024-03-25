#!/bin/bash
### 456.hmmer ###

export GEM5_DIR=/home/010/a/ax/axd220192/gem5_proj/gem5/
export BENCHMARKDIRECTORY=/home/010/a/ax/axd220192/gem5_proj/gem5/benchmark/Project1_SPEC/456.hmmer
export BENCHMARK=/home/010/a/ax/axd220192/gem5_proj/gem5/benchmark/Project1_SPEC/456.hmmer/src/benchmark
export ARGUMENT=/home/010/a/ax/axd220192/gem5_proj/gem5/benchmark/Project1_SPEC/456.hmmer/data/bombesin.hmm

### 458.sjeng ###

# export GEM5_DIR=/home/010/a/ax/axd220192/gem5_proj/gem5/
# export BENCHMARKDIRECTORY=/home/010/a/ax/axd220192/gem5_proj/gem5/benchmark/Project1_SPEC/458.sjeng
# export BENCHMARK=/home/010/a/ax/axd220192/gem5_proj/gem5/benchmark/Project1_SPEC/458.sjeng/src/benchmark
# export ARGUMENT=/home/010/a/ax/axd220192/gem5_proj/gem5/benchmark/Project1_SPEC/458.sjeng/data/test.txt


# Define the paths to the BaseSimpleCPU.py and BranchPredictor.py files
baseSimpleCPUPath="/home/010/a/ax/axd220192/gem5_proj/gem5/src/cpu/simple/BaseSimpleCPU.py"
branchPredictorPath="/home/010/a/ax/axd220192/gem5_proj/gem5/src/cpu/pred/BranchPredictor.py"
branchPredictorbakPath="/home/010/a/ax/axd220192/gem5_proj/gem5/src/cpu/pred/BranchPredictorbak.py"

# Create a backup of the original BranchPredictor.py
cp "$branchPredictorPath" "$branchPredictorbakPath"

# Create a results directory
mkdir -p "$BENCHMARKDIRECTORY/results/"
 
# Define the branch predictors and their respective parameter combinations
# predictors=("LocalBP()" "TournamentBP()" "BiModeBP()")
predictor="BiModeBP()"
 
BTBEntries=(2048 4096)
localPredictorSize=(1024 2048)
globalPredictorSize=(2048 8192)
choicePredictorSize=(2048 8192)
 
# Replace the line in BaseSimpleCPU.py with the selected predictor
#    branchPred = Param.BranchPredictor(LocalBP(), "Branch Predictor")
sed -i "s/branchPred = Param.BranchPredictor(.*)/branchPred = Param.BranchPredictor(${predictor}, \"Branch Predictor\")/" "$baseSimpleCPUPath"
 
if [ "$predictor" = "LocalBP()" ]; then
  BTBEntries=(2048 4096)
  localPredictorSize=(1024 2048)
  # Iterate over each combination of parameters
  for btb in "${BTBEntries[@]}"; do
    for local in "${localPredictorSize[@]}"; do
      # Modify the parameters in BranchPredictor.py based on the selected predictor
      sed -i "s/BTBEntries = Param.Unsigned(.*)/BTBEntries = Param.Unsigned(${btb}, \"Number of BTB entries\")/" "$branchPredictorPath"
      sed -i "s/localPredictorSize = Param.Unsigned(.*)/localPredictorSize = Param.Unsigned(${local}, \"Size of local predictor\")/" "$branchPredictorPath"
      # Build the output directory based on the parameters
      OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/results/$predictor/BTBEntries=$btb-localPredictorSize=$local"
      # compile gem5 #
      scons $GEM5_DIR/build/X86/gem5.opt
      # Run gem5 simulation
      time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 5000000 --cpu-type=timing --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
    done
  done
elif [ "$predictor" = "TournamentBP()" ]; then
  BTBEntries=(2048 4096)
  localPredictorSize=(1024 2048)
  globalPredictorSize=(4096 8192)
  choicePredictorSize=(4096 8192)
  # Iterate over each combination of parameters
  for btb in "${BTBEntries[@]}"; do
    for local in "${localPredictorSize[@]}"; do
      for global in "${globalPredictorSize[@]}"; do
        for choice in "${choicePredictorSize[@]}"; do
          # Modify the parameters in BranchPredictor.py based on the selected predictor
          sed -i "s/BTBEntries = Param.Unsigned(.*)/BTBEntries = Param.Unsigned($btb, \"Number of BTB entries\")/" "$branchPredictorPath"
          sed -i "s/localPredictorSize = Param.Unsigned(.*)/localPredictorSize = Param.Unsigned($local, \"Size of local predictor\")/" "$branchPredictorPath"
          sed -i "s/globalPredictorSize = Param.Unsigned(.*)/globalPredictorSize = Param.Unsigned($global, \"Size of global predictor\")/" "$branchPredictorPath"
          sed -i "s/choicePredictorSize = Param.Unsigned(.*)/choicePredictorSize = Param.Unsigned($choice, \"Size of choice predictor\")/" "$branchPredictorPath"
 
          # Build the output directory based on the parameters
          OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/results/$predictor/BTBEntries=$btb-localPredictorSize=$local-globalPredictorSize=$global-choicePredictorSize=$choice"
          # compile gem5 #
          scons $GEM5_DIR/build/X86/gem5.opt
          # Run gem5 simulation
          time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 5000000 --cpu-type=timing --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
        done
      done
    done
  done
elif [ "$predictor" = "BiModeBP()" ]; then
  BTBEntries=(2048 4096)
  globalPredictorSize=(2048 8192)
  choicePredictorSize=(2048 8192)
  # Iterate over each combination of parameters
  for btb in "${BTBEntries[@]}"; do
    for global in "${globalPredictorSize[@]}"; do
      for choice in "${choicePredictorSize[@]}"; do
          # Modify the parameters in BranchPredictor.py based on the selected predictor
          # globalPredictorSize = Param.Unsigned(8192, "Size of global predictor")
          sed -i "s/BTBEntries = Param.Unsigned(.*)/BTBEntries = Param.Unsigned($btb, \"Number of BTB entries\")/" "$branchPredictorPath"
          sed -i "s/globalPredictorSize = Param.Unsigned(.*)/globalPredictorSize = Param.Unsigned($global, \"Size of global predictor\")/" "$branchPredictorPath"
          sed -i "s/choicePredictorSize = Param.Unsigned(.*)/choicePredictorSize = Param.Unsigned($choice, \"Size of choice predictor\")/" "$branchPredictorPath"
 
          # Build the output directory based on the parameters
          OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/results/$predictor/BTBEntries=$btb-globalPredictorSize=$global-choicePredictorSize=$choice"
          # compile gem5 #
          scons $GEM5_DIR/build/X86/gem5.opt
          # Run gem5 simulation
          time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 5000000 --cpu-type=timing --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
      done
    done
  done
fi