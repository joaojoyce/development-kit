
env=${PWD##*/}
path="./devenvironment-${env}"

echo $path

if [ ! -d $path ]; then
	echo "Cloning dev environment";
	git clone https://github.com/joaojoyce/laradock $path
	cp $path/env-example $path/.env
	echo "POSTGRES_DB=${env}" >> $path/.env
	echo "MYSQL_DATABASE=${env}" >> $path/.env
#	rm -rf .git
fi

if [ ! -f ./.env  ] && [ -f ./.env.example ]; then
    echo "Copying .env variables";
    cp .env.example .env
fi

#cd laradock-lojascomhistoria
#docker-compose up -d nginx postgres-postgis
#docker-compose exec workspace bash -c "composer install"
#docker-compose exec workspace bash -c "php artisan migrate"
#cd ..
