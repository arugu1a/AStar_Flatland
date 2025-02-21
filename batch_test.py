import os
import subprocess
import sys
import csv
import re
from multiprocessing import Pool

NUM_CORES = 10  # Adjust based on your CPU
CSV_OUTPUT = "comparison_results.csv"

def parse_clingo_output(output):
    """Extract solving time, and other statistics from Clingo output."""
    time = "N/A"
    time_solving = "N/A"
    satisfiable = "unknown"
    #grounding_lines = "N/A"

    # Regex patterns
    sat_pattern             = re.compile(r"(SATISFIABLE|UNSATISFIABLE|OPTIMUM FOUND)")
    time_pattern            = re.compile(r"Time\s+:\s+([\d.]+)s")  # Time: 0.125s
    solving_time_pattern    = re.compile(r"Solving:\s+([\d.]+)s")


    # Search in output text
    match_sat           = sat_pattern.search(output)
    match_time          = time_pattern.search(output)
    match_time_solving  = solving_time_pattern.search(output)


    if match_sat:
        satisfiable = match_sat.group(1)
    if match_time:
        time = match_time.group(1)
    if match_time_solving:
        time_solving = match_time_solving.group(1)

    return satisfiable, time, time_solving


def process_instance(args):
    encoding_path, instance_path, output_folder = args
    #
    os.makedirs(output_folder, exist_ok=True)
    # Extract the base name of the problem instance to use as the output file name
    instance_name = os.path.basename(instance_path)
    output_path = os.path.join(output_folder, f"{instance_name}.txt")
    
    # Construct and run the clingo command
    command = ["clingo-dl", encoding_path, instance_path]
    try:
        result = subprocess.run(command,capture_output=True, text=True)
        with open(output_path, "w") as output_file:
            output_file.write(result.stdout)
        print(f"Processed {instance_path}, output saved to {output_path}")
        # extracting for csv data
        satisfiable, time, time_solving = parse_clingo_output(result.stdout)
        return [instance_name, satisfiable, time, time_solving]
    except subprocess.CalledProcessError as e:
        raise RuntimeError("command '{}' return with error (code {}): {}".format(e.cmd, e.returncode, e.output))


if __name__ == "__main__":

    # Example usage:
    # python batch_test.py encoding1.lp instance_folder -o output_folder
    
    if len(sys.argv) < 3:
        print("Usage: python batch_test.py <encoding_path> <instance1> <instance2> ... -o <output_folder>")
        sys.exit(1)
    encoding_path = sys.argv[1]
    instances_folder  = sys.argv[2]
    output_folder = sys.argv[3]

    instances = [os.path.join(root, file) for root, _, files in os.walk(instances_folder) for file in files if file.endswith(".lp")]

    #for instance_path in problem_instances:
    #    results = process_instance(encoding_path, instance_path, output_folder)

    # Prepare argument pairs (encoding, instance)
    task_list = [(encoding_path, instance,output_folder) for instance in instances]

    # Run batch processing in parallel
    with Pool(NUM_CORES) as pool:
        results = pool.map(process_instance, task_list)

    #time, satisfiable, grounding_lines = parse_clingo_output(result.stdout)

    # Save results to CSV
    csv_file = os.path.join(output_folder, CSV_OUTPUT)
    with open(csv_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Instance", "Satisfiability", "Time (s)"])
        writer.writerows(results)