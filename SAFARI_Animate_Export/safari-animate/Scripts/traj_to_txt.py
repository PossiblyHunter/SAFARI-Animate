import os
import sys

def traj_to_txt(traj_file, txt_file=None):
    if txt_file is None:
        base_name = os.path.splitext(traj_file)[0]
        txt_file = f"{base_name}.txt"
    
    try:
        # Open the traj file for reading and txt file for writing
        with open(traj_file, 'r') as traj, open(txt_file, 'w') as txt: # Opens the traj file for reading and txt file for writing
            # Read the traj file line by line
            content = traj.read()
            # Write the content to the txt file
            txt.write(content)

            print(f"Successfully converted {traj_file} to {txt_file}.")
    
     # Possible errors when trying the operation
    except FileNotFoundError: 
        print(f"Error: File {traj_file} not found.")
    except PermissionError:
        print(f"Error: Permission denied for file {traj_file}. or write to {txt_file}.")
    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    if len(sys.argv) == 1:
        traj_file = "Ion.traj"
        txt_file = None
        print(f"No File specified. Uinsg default file {traj_file}")
    else:
        traj_file = sys.argv[1]
        txt_file = None

        if len(sys.argv) > 2:
            txt_file = sys.argv[2]
        
    traj_to_txt(traj_file, txt_file)