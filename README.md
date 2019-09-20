# Template: template-basic

This template provides a boilerplate repository for developing non-ROS software
in Duckietown.

**NOTE:** If you want to develop software that uses ROS, check out
[this template](https://github.com/duckietown/template-ros).


## How to use it

### 1. Fork this repository

Use the fork button in the top-right corner of the github page to fork this template repository.


### 2. Create a new repository

Create a new repository on github.com while
specifying the newly forked template repository as
a template for your new repository.


### 3. Define dependencies

List the dependencies in the files `dependencies-apt.txt` and
`dependencies-py.txt` (apt packages and pip packages respectively).


### 4. Place your code

Place your code in the directory `/code` of
your new repository.

**NOTE:** Do not use absolute paths in your code, the code you place under `/code` will be copied to a different location later.


### 5. Setup the launchfile

Change the file `launch.sh` in your repository to
launch your code. Use the provided variable `CODE_DIR`
to identify the place where your code will be placed.
