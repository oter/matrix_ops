PROJECT_NAME=$(basename $1)
PROJECT_PATH=$1
MODULES_DIR=modules

killall gtkwave 2>/dev/null

cd $PROJECT_PATH
project_files="$MODULES_DIR/matrix/matrix_mult_matrix/matrix_mult_matrix.v $MODULES_DIR/matrix/matrix_mult_vector/matrix_mult_vector.v"
mkdir -p output
iverilog -o output/$PROJECT_NAME $project_files
if [ $? != 0 ];
then
	exit 1;
fi
cd output
vvp $PROJECT_NAME
gtkwave $(find -type f -name "*.vcd")