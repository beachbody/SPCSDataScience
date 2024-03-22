#!/bin/bash

# Initialize variables
repository_url=""
warehouse=""
image_name=""

# Function to print usage
usage() {
    echo "Usage: $0 -r <repository_url> -w <warehouse> -i <image_name>"
    echo "  -r repository_url: The image repository URL."
    echo "  -w warehouse: The warehouse the modeling app can use."
    echo "  -i image_name: The image name the modeling app will use."
    echo "Arguments are optional; missing values will be prompted."
}

# Parse command-line options
while getopts ":r:w:i:" opt; do
  case $opt in
    r)
      repository_url="$OPTARG"
      ;;
    w)
      warehouse="$OPTARG"
      ;;
    i)
      image_name="$OPTARG"
      ;;
    \?)
      echo "Invalid option -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

# Prompt for missing arguments
if [ -z "$repository_url" ]; then
    read -p "Enter the image repository URL: " repository_url
else
    echo "Repository URL: $repository_url"
fi

if [ -z "$warehouse" ]; then
    read -p "Enter the warehouse the modeling app can use: " warehouse
else
    echo "Warehouse: $warehouse"
fi

if [ -z "$image_name" ]; then
    read -p "Enter the image name the modeling app will use: " image_name
else
    echo "Image Name: $image_name"
fi

# Determine the absolute path to the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

# Paths to the template files and their target locations
makefile_template="$SCRIPT_DIR/Makefile.template"
modeling_file_template="$SCRIPT_DIR/modeling.yaml.template"
makefile_target="$PROJECT_ROOT_DIR/Makefile"
modeling_file_target="$PROJECT_ROOT_DIR/modeling.yaml"

# Copy templates to target locations if they do not exist
if [ ! -f "$makefile_target" ]; then
    cp "$makefile_template" "$makefile_target"
    echo "Makefile created from template."
fi

if [ ! -f "$modeling_file_target" ]; then
    cp "$modeling_file_template" "$modeling_file_target"
    echo "modeling.yaml created from template."
fi

# Check if the operating system is macOS and set the sed -i option accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS, use -i '' directly within the command to avoid file naming issues
    for file in "$makefile_target" "$modeling_file_target"; do
        sed -i '' "s|<<repository_url>>|$repository_url|g" "$file"
        sed -i '' "s|<<warehouse_name>>|$warehouse|g" "$file"
        sed -i '' "s|<<image_name>>|$image_name|g" "$file"
    done
else
    # For other systems like Linux, use -i with no additional argument
    for file in "$makefile_target" "$modeling_file_target"; do
        sed -i "s|<<repository_url>>|$repository_url|g" "$file"
        sed -i "s|<<warehouse_name>>|$warehouse|g" "$file"
        sed -i "s|<<image_name>>|$image_name|g" "$file"
    done
fi


echo "Placeholder values have been replaced in Makefile and modeling.yaml."
