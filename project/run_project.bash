if [ $1 = "eclean" ]
then
	bash run_eclean.bash
fi


mkdir -p /tmp/EECS3311/project
echo "Use /tmp/EECS3311/project as compile directory."

cd ./simodyssey2
estudio simodyssey2.ecf &

cd ../
