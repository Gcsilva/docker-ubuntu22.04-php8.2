# Mega image -> Ubuntu 22.04 / PHP 8.2 / Composer / SQL Server Driver

## In this image, you'll find these features available:

- **Ubuntu 22.04**
- **PHP 8.2**
- **Composer**
- **ODBC Driver 18** 
    - install_ODBC_Driver.sh
    - (https://learn.microsoft.com/it-it/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15&tabs=ubuntu18-install%2Calpine17-install%2Cdebian8-install%2Credhat7-13-install%2Crhel7-offline#ubuntu18)
- **PHP Driver for SQL Server (sqlsrv)**

## Repository files
- **Dockerfile** - _The file responsible for generating images_
- **docker-compose.yml** - _Sample for how you can use this image using in the docker-compose and raise a new application_
- **install_ODBC_Driver.sh** - _Script to install ODBC Driver on the Ubuntu 22.04_
- **docker-compose_test_image.yml** - _This file is helpful if you download this project from GitHub and try to test the image_

## Composer Update
To run composer update and install dependencies of your project, you can either:
-  To attach to the container and run `composer update` into the /var/www/html directory.

Or 
- Adding to `docker-composer.yml` through execute commands.

I hope that image can be helpful to many people. 

Thank you for your attention.
