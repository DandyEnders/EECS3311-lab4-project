mkdir -p /tmp/EECS3311/project
ec -c_compile -project_path /tmp/EECS3311/project -config simodyssey2/simodyssey2.ecf

cd ./simodyssey2/regression-testing/
bash ./regression_test.bash
cd ../../
