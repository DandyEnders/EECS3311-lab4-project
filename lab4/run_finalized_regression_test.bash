mkdir -p /tmp/EECS3311/lab4
ec -c_compile -finalize -project_path /tmp/EECS3311/lab4 -config simodyssey1/simodyssey1.ecf

cd ./simodyssey1/regression-testing/
bash ./regression_test_finalize_test.bash
cd ../../
