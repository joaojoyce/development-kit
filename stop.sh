
env=${PWD##*/} 
path="./devenvironment-${env}"

if [[ -d $path ]]; then
	cd $path
	docker-compose stop
	docker-compose down
fi

