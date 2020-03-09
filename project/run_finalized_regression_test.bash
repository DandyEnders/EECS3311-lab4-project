mkdir -p /tmp/EECS3311/project
ec -c_compile -finalize -project_path /tmp/EECS3311/project -config simodyssey2/simodyssey2.ecf

cd ./simodyssey2/regression-testing/
bash ./regression_test_finalize_test.bash
cd ../../
