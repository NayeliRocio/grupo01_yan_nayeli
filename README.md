# MANUAL PARA IMPLEMENTAR LA BASE DE DATOS SQL SERVER EN CODESPACE

# 1. Ejecutar SQL Server en Docker
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=DockerPass123" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest

#2. Conectar con la extensión SQL Server (MSSQL)
   Servidor: localhost,1433
   Usuario: sa
    Contraseña: DockerPass123

#3. Crear base de datos principal
sqlcmd -S localhost -U sa -P DockerPass123
CREATE DATABASE db_SalesClothes;
USE db_SalesClothes;

#4. Crear tablas
CREATE TABLE client (
    id int PRIMARY KEY,
    type_document char(3),
    number_document char(15),
    names varchar(60),
    last_name varchar(90),
    email varchar(80),
    cell_phone char(9),
    birthdate date,
    active bit
);

CREATE TABLE seller (
    id int PRIMARY KEY,
    type_document char(3),
    number_document char(15),
    names varchar(60),
    last_name varchar(90),
    salary decimal(8,2),
    cell_phone char(9),
    email varchar(80),
    active bit
);

CREATE TABLE clothes (
    id int PRIMARY KEY,
    descriptions varchar(60),
    brand varchar(60),
    amount int,
    size varchar(10),
    price decimal(8,2),
    active bit
);

CREATE TABLE sale (
    id int PRIMARY KEY,
    date_time datetime,
    seller_id int,
    client_id int,
    active bit
);

CREATE TABLE sale_detail (
    id int PRIMARY KEY,
    sale_id int,
    clothes_id int,
    amount int
);

#5. Crear relaciones entre tablas
ALTER TABLE sale
ADD CONSTRAINT FK_sale_client FOREIGN KEY (client_id)
REFERENCES client(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE sale
ADD CONSTRAINT FK_sale_seller FOREIGN KEY (seller_id)
REFERENCES seller(id);

ALTER TABLE sale_detail
ADD CONSTRAINT FK_sale_detail_sale FOREIGN KEY (sale_id)
REFERENCES sale(id);

ALTER TABLE sale_detail
ADD CONSTRAINT FK_sale_detail_clothes FOREIGN KEY (clothes_id)
REFERENCES clothes(id);

#6. Verificar relaciones
SELECT
    fk.name AS Constraint,
    OBJECT_NAME(fk.parent_object_id) AS Tabla,
    COL_NAME(fk.parent_object_id, fkc.parent_column_id) AS Columna_FK,
    OBJECT_NAME(fk.referenced_object_id) AS Tabla_Base,
    COL_NAME(fk.referenced_object_id, fkc.referenced_column_id) AS Columna_PK
FROM
    sys.foreign_keys AS fk
INNER JOIN
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id;

#7. Conectar con Docker Compose
Crear archivo docker-compose.yml con:
-------------------------------------------------
services:
mssql:
image: mcr.microsoft.com/mssql/server:2022-latest
container_name: mssql_salesclothes
environment:
ACCEPT_EULA: "Y"
MSSQL_SA_PASSWORD: "DockerPass123"
ports:
- "1434:1433"
volumes:
- ./db/init.sql:/init.sql
command: >
 /bin/bash -c "
/opt/mssql/bin/sqlservr &
sleep 20s &&
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P DockerPass123 -i /init.sql &&
wait
"
-------------------------------------------------
