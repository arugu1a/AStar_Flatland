import clingo
import argparse
import numpy as np
import re
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from matplotlib.colors import ListedColormap
import math

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('encoding_filename', help='encoding as a .lp file')
    parser.add_argument('environment_filename', help='environment as a .lp file')
    parser.add_argument('-n', '--models', type=int, default=0, help='maximum number of models to be computed')
    return(parser.parse_args())

def get_dimensions(environment_filename):
    pattern = re.compile(r'cell\(\(\s*(\d+)\s*,\s*(\d+)\s*\),')
    with open(environment_filename, 'r') as file:
        for line in reversed(file.readlines()):  # Read lines from the end
            line = line.strip()
            if line:  # Ignore empty lines
                match = pattern.search(line)
                if match:
                    max_y, max_x = map(int, match.groups())
                    return max_y + 1, max_x + 1  # Convert to matrix size
    return 0, 0  # No valid cell fact found

def plot_matriceXs(matrices, environment_filename):
    # Plot all matrices next to each other
    num_plots = len(matrices)
    fig, axes = plt.subplots(1, num_plots, figsize=(num_plots * 5, 5))

    # If there's only one matrix, axes will be a single object, so we make it iterable
    if num_plots == 1:
        axes = [axes]

    image_filepath = environment_filename.replace("lp", "png")
    bg_img = mpimg.imread(image_filepath)
    cmap = plt.cm.viridis.copy()

    # Create a colormap and set alpha to 0 for the zero values
    colors = cmap(np.linspace(0, 1, cmap.N))  # Get colors from the colormap
    colors[:, -1] = np.linspace(0, 1, cmap.N)  # Linear alpha from 0 (transparent) to 1 (opaque)
    colors[0, -1] = 0  # Set alpha of the zero values to fully transparent

    # Create a custom colormap with modified alpha values
    custom_cmap = ListedColormap(colors)

    # Plot each matrix
    for i, (train_id, matrix) in enumerate(matrices.items()):
        axes[i].imshow(bg_img, cmap=cmap, vmin=0.01, extent=[0, matrix.shape[1], matrix.shape[0], 0])
        axes[i].matshow(matrix, cmap=custom_cmap, vmin=0.01, interpolation='nearest')  # Use the custom colormap for transparency
        axes[i].set_title(f'Train {train_id}')
        axes[i].axis('off')  # Hide axis ticks

    plt.tight_layout()
    plt.show()

def plot_matrices(matrices, environment_filename):
    num_plots = len(matrices)
    
    # Determine a roughly square grid layout
    cols = math.ceil(math.sqrt(num_plots))
    rows = math.ceil(num_plots / cols)

    fig, axes = plt.subplots(rows, cols, figsize=(cols * 5, rows * 5))
    axes = np.array(axes).reshape(rows, cols)  # Ensure axes is a 2D array

    image_filepath = environment_filename.replace("lp", "png")

    # Try to load the image, but continue if it fails
    try:
        bg_img = mpimg.imread(image_filepath)
    except FileNotFoundError:
        print("\nThere is no environment image in the envs/png folder.")
        bg_img = None

    # Create a colormap and set alpha to 0 for the zero values
    cmap = plt.cm.inferno_r.copy()
    colors = cmap(np.linspace(0, 1, cmap.N))
    colors[:, -1] = np.linspace(0, 1, cmap.N)
    colors[0, -1] = 0  # Transparent for zero values
    custom_cmap = ListedColormap(colors)

    # Plot each matrix
    for ax, (train_id, matrix) in zip(axes.flatten(), matrices.items()):
        if bg_img is not None:
            ax.imshow(bg_img, cmap=cmap, vmin=0.01, extent=[0, matrix.shape[1], matrix.shape[0], 0])
        ax.matshow(matrix, cmap=custom_cmap, vmin=0.01, interpolation='nearest')
        ax.set_title(f'Train {train_id}', y=0.95, pad=20)
        ax.axis('off')

    # Hide unused subplots if any
    for i in range(num_plots, rows * cols):
        fig.delaxes(axes.flatten()[i])

    plt.tight_layout()
    plt.show()


def main():
    args = get_args()
    rows, cols = get_dimensions(args.environment_filename)
    matrix = np.zeros((rows, cols), dtype=int)
    ctl = clingo.Control()
    ctl.load(args.encoding_filename)
    ctl.load(args.environment_filename)
    print('\rgrounding...', end='')
    ctl.ground([("base", [])])
    ctl.configuration.solve.models = args.models
    matrices = {}
    number_models_processed = 0
    with ctl.solve(yield_=True) as handle:
        result = handle.get()  # Get the solving result
        if not result.satisfiable:  # Correct way to check UNSATISFIABLE
            print("\nClingo returned UNSATISFIABLE. No solutions found.")
            return  
        for model in handle:
            # Extract pos(ID, (Y, X), time) facts from each model
            for atom in model.symbols(atoms=True):
                if atom.name == "pos" and len(atom.arguments) == 3:  # Ensure it's a pos fact
                    train_id = atom.arguments[0]  # ID of the train
                    y, x = atom.arguments[1].arguments  # Y, X coordinates
                    y, x = y.number, x.number  # Convert Symbols to integers
                    # Initialize the matrix for the train if not already initialized
                    if train_id not in matrices:
                        matrices[train_id] = np.zeros((rows, cols), dtype=int)

                    # Increment the corresponding matrix entry for this entity's position
                    matrices[train_id][int(y), int(x)] += 1
            number_models_processed += 1
            print(f"\rmodels processed: {number_models_processed}", end='')
    plot_matrices(matrices, args.environment_filename)

if __name__ == "__main__":
    main()