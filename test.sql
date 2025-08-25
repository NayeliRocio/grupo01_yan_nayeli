SELECT @@version;

CREATE DATABASE db_SalesClothes;

USE db_SalesClothes;

USE master;

CREATE TABLE client (
    id int,
    type_document char(3),
    number_document char(15),
    names varchar(60),
    last_name varchar(90),
    email varchar(80),
    cell_phone char(9),
    birthdate date,
    activate BIT 
    CONSTRAINT client_pk PRIMARY KEY (id)
);

EXEC sp_columns @table_name = 'client';

SELECT * FROM INFORMATION_SCHEMA.TABLES;

DROP TABLE client;

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
GO
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
GO
CREATE TABLE clothes (
    id int PRIMARY KEY,
    descriptions varchar(60),
    brand varchar(60),
    amount int,
    size varchar(10),
    price decimal(8,2),
    active bit
);
GO

CREATE TABLE sale (
    id int PRIMARY KEY,
    date_time datetime,
    seller_id int,
    client_id int,
    active bit
);
GO
CREATE TABLE sale_detail (
    id int PRIMARY KEY,
    sale_id int,
    clothes_id int,
    amount int
);
GO


ALTER TABLE sale
    ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
    REFERENCES client (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
GO

ALTER TABLE sale
ADD CONSTRAINT FK_sale_seller FOREIGN KEY (seller_id) REFERENCES seller(id);
GO

ALTER TABLE sale
ADD CONSTRAINT FK_sale_client FOREIGN KEY (client_id) REFERENCES client(id);
GO

ALTER TABLE sale_detail
ADD CONSTRAINT FK_sale_detail_sale FOREIGN KEY (sale_id) REFERENCES sale(id);
GO

ALTER TABLE sale_detail
ADD CONSTRAINT FK_sale_detail_clothes FOREIGN KEY (clothes_id) REFERENCES clothes(id);
GO

SELECT
    fk.name AS [Constraint],
    OBJECT_NAME(fk.parent_object_id) AS [Tabela],
    COL_NAME(fk.parent_object_id, fkc.parent_column_id) AS [Coluna FK],
    OBJECT_NAME(fk.referenced_object_id) AS [Tabela base],
    COL_NAME(fk.referenced_object_id, fkc.referenced_column_id) AS [Coluna PK]
FROM
    sys.foreign_keys AS fk
INNER JOIN
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id;
GO