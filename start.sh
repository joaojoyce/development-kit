env=${PWD##*/}
path="./devenvironment-${env}"
pathtoproject=${PWD#/Users/*/}



echo $path

if [ ! -d $path ]; then
	echo "Cloning dev environment";
	git clone https://github.com/joaojoyce/laradock $path
	cp $path/env-example $path/.env
	echo "APPLICATION=/mnt/${pathtoproject}" >> $path/.env
	echo "DEV_PATH_FROM_CONTAINER=/mnt/${pathtoproject}/$path" >> $path/.env
	echo "NGINX_SITES_PATH=/mnt/${pathtoproject}/$path/nginx/sites/" >> $path/.env
	echo "NGINX_HOST_LOG_PATH=/mnt/${pathtoproject}/$path/logs/nginx/" >> $path/.env
	#	rm -rf .git
fi

if [ ! -f ./.env  ] && [ -f ./.env.example ]; then
    echo "Copying .env variables";
    cp .env.example .env
fi

for port in $(seq 8000 9000); do
    echo -n "Testing port $port: "
    portopen=$(nc -z localhost $port; echo $?)
    if [ $portopen -eq 1 ]; then
        echo "Open"
        newport=$port;
        break;
    else
        echo "Closed"
    fi
done

echo "HTTP_PORT=${newport}" >> $path/.env


echo "Starting server and database!"
cd $path
docker-compose up -d nginx postgres-postgis
cd ..

if [ -f ./.env  ]; then

    #RUN COMPOSER!!!
    cd $path;
    docker-compose exec workspace bash -c "composer install";
    cd ..;

    while true; do
        read -p "Do you wish to refresh the database?" yn
        case $yn in
            [Yy]* )
                cd $path;
                docker-compose exec workspace bash -c "php artisan migrate:refresh";
                docker-compose exec workspace bash -c "php artisan db:seed";
                cd ..;
                break;;
            [Nn]* )
                break;;
            * )
                echo "Please answer yes or no.";;
        esac
    done

fi

open http://localhost:$newport
