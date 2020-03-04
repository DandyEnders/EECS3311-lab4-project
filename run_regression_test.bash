mkdir -p /tmp/EECS3311/lab4
ec -c_compile -project_path /tmp/EECS3311/lab4 -config simodyssey1/simodyssey1.ecf

cd ./simodyssey1/regression-testing/
bash ./regression_test.bash
cd ../../
