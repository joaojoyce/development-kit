
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

echo "Starting server and database!"
cd $path
docker-compose up -d nginx postgres-postgis mysql
cd ..

if [ -f ./.env  ]; then
    echo "Found Laravel project";
    while true; do
        read -p "Do you wish to run composer install?" yn
        case $yn in
            [Yy]* )
                cd $path;
                docker-compose exec workspace bash -c "composer install";
                cd ..;
                break;;
            [Nn]* )
                break;;
            * )
                echo "Please answer yes or no.";;
        esac
    done

    while true; do
        read -p "Do you wish to refresh the database?" yn
        case $yn in
            [Yy]* )
                cd $path;
                docker-compose exec workspace bash -c "php artisan migrate";
                cd ..;
                break;;
            [Nn]* )
                break;;
            * )
                echo "Please answer yes or no.";;
        esac
    done


fi

