
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

# Define cache levels, size, associativity, block size
cache_levels=("l2cache")
 
L1_instruction_cahce_size=("1kB" "2kB" "4kB" "8kB" "16kB" "32kB" "64kB" "128kB")
L1_data_cahce_size=("1kB" "2kB" "4kB" "8kB" "16kB" "32kB" "64kB" "128kB")
L2_cache_size=("1MB" "2MB" "4MB" "8MB" "16MB" "32MB" "64MB" "128MB")
 
L1_instruction_cahce_associativity=(1 2 4 8)
L1_data_cahce_associativity=(1 2 4 8)
L2_cahce_associativity=(1 2 4 8)
 
block_size=("8" "16" "32" "64" "128" "256" "512")
 
### example ###
# cache_levels=("l2cache")
 
# L1_instruction_cahce_size=("128kB")
# L1_data_cahce_size=("128kB")
# L2_cache_size=("1MB")
 
# L1_instruction_cahce_associativity=(2)
# L1_data_cahce_associativity=(2)
# L2_cahce_associativity=(1)
 
# block_size=("64")
 

# Create a results directory
mkdir -p "$BENCHMARKDIRECTORY/cache_results/"
 
 
cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")
 
# Iterate over each combination of parameters
for CACHELINE_SIZE in "${block_size[@]}"; do
 
  OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
  mkdir -p $OUTPUT_DIRECTORY
  time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
  # Read the values from the log file
  dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  # Calculate CPI using the formula
  cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
 
  # Print CPI to a new file
  echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
done

cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")

for L1I_SIZE in "${L1_instruction_cahce_size[@]}"; do
 
 
  OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
  mkdir -p $OUTPUT_DIRECTORY
  time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
  # Read the values from the log file
  dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  # Calculate CPI using the formula
  cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
  
  # Print CPI to a new file
  echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
done
 
cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")
for L1D_SIZE in "${L1_data_cahce_size[@]}"; do
 
  OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
  mkdir -p $OUTPUT_DIRECTORY
  time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
  # Read the values from the log file
  dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  # Calculate CPI using the formula
  cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
 
  # Print CPI to a new file
  echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
done  
 
cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")
for L1I_ASSOC in "${L1_instruction_cahce_associativity[@]}"; do
 
  OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
  mkdir -p $OUTPUT_DIRECTORY
  time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
  # Read the values from the log file
  dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  # Calculate CPI using the formula
  cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
 
  # Print CPI to a new file
  echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
done
 
cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")
for L1D_ASSOC in "${L1_data_cahce_associativity[@]}"; do
 
    OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
    mkdir -p $OUTPUT_DIRECTORY
    time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
    # Read the values from the log file
    dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
    icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
    l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
    # Calculate CPI using the formula
    cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
 
    # Print CPI to a new file
    echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
  done
 
cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")
for L2_ASSOC in "${L2_cahce_associativity[@]}"; do
 
  OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
  mkdir -p $OUTPUT_DIRECTORY
  time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
  # Read the values from the log file
  dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  # Calculate CPI using the formula
  cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
 
  # Print CPI to a new file
  echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
done
 
cache_level=("l2cache")
L1I_SIZE=("128kB")
L1D_SIZE=("128kB")
L1I_ASSOC=(2)
L1D_ASSOC=(2)
L2_SIZE=("1MB")
L2_ASSOC=(1)
CACHELINE_SIZE=("64")
for L2_SIZE in "${L2_cache_size[@]}"; do
 
  OUTPUT_DIRECTORY="$BENCHMARKDIRECTORY/cache_results/cache_level=$cache_level-cacheline_size=$CACHELINE_SIZE-l1I_size=$L1I_SIZE-l1d_size=$L1D_SIZE-l2_size=$L2_SIZE-l1i_assoc=$L1I_ASSOC-l1d_assoc=$L1D_ASSOC-L2_assoc=$L2_ASSOC"
  mkdir -p $OUTPUT_DIRECTORY
  time $GEM5_DIR/build/X86/gem5.opt -d "$OUTPUT_DIRECTORY" $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 50000000 --cpu-type=timing --caches --$cache_level --l1d_size=$L1D_SIZE --l1i_size=$L1I_SIZE --l2_size=$L2_SIZE --l1d_assoc=$L1D_ASSOC --l1i_assoc=$L1I_ASSOC --l2_assoc=$L2_ASSOC --cacheline_size=$CACHELINE_SIZE > $OUTPUT_DIRECTORY/time.log
  # Read the values from the log file
  dcache_miss_rate=$(grep "system.cpu.dcache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  icache_miss_rate=$(grep "system.cpu.icache.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  l2_miss_rate=$(grep "system.l2.overall_misses::total" "$OUTPUT_DIRECTORY/stats.txt" | awk '{print $2}')
  # Calculate CPI using the formula
  cpi=$(echo "scale=10; 1 + (($dcache_miss_rate + $icache_miss_rate) * 6 + $l2_miss_rate * 50)/50000000" | bc)
 
  # Print CPI to a new file
  echo "CPI: $cpi" > $OUTPUT_DIRECTORY/cpi_result.txt
done