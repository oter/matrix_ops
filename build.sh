# Cyclon 2 DE2 Board
# Vertex 4 ? ICAP interface

cd $1
PROJECT_DIR="modules/matrix/matrix_mult_matrix/"
PROJECT_NAME=$(basename $PROJECT_DIR)
PROJECT_PATH=$PROJECT_DIR
killall gtkwave 2>/dev/null
cd $PROJECT_PATH
project_files=$(find  -type f -name "*.v" | tr '\n' ' ')
mkdir -p output
iverilog -o output/$PROJECT_NAME $project_files
if [ $? != 0 ];
then
	exit 1;
fi
cd output
vvp $PROJECT_NAME
gtkwave $(find -type f -name "*.vcd")