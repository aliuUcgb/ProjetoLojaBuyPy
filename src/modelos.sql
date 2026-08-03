DROP DATABASE IF EXISTS BuyPy;
CREATE DATABASE BuyPy
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
    
    
USE BuyPy;

DROP TABLE IF EXISTS `Client`;
CREATE TABLE `Client`(
	id 					INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	firstname			VARCHAR(50) 	NOT NULL,
	surname				VARCHAR(50)		NOT NULL,
	email 				VARCHAR(100)	NOT NULL,
	`password`			CHAR(64)		NOT NULL,    -- SHA2-256 hex digest
	address				VARCHAR(150),	
	zip_code			VARCHAR(10),
	city				VARCHAR(50),
	country				VARCHAR(50)		NOT NULL DEFAULT 'Portugal',
	phone_number		VARCHAR(20),
	birthdate			DATE,
	last_login			DATETIME,
	`status`				ENUM('active' , 'inactive' , 'blocked')	NOT NULL DEFAULT 'active',
	CONSTRAINT uq_Client_email UNIQUE(email)

)ENGINE=InnoDB;


DROP TABLE IF EXISTS Operator;
CREATE TABLE Operator(
	id 					INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	firstname			VARCHAR(50)		NOT NULL,
	surname				VARCHAR(50)		NOT NULL,
	email				VARCHAR(100)	NOT NULL,
	`password`			CHAR(64)		NOT NULL, -- SHA2-256 hex digest
	last_login			DATETIME,
	CONSTRAINT uq_operator_email UNIQUE (email)
)ENGINE=InnoDB;


DROP TABLE IF EXISTS Product;
CREATE TABLE Product(
	id 				VARCHAR(10) 	PRIMARY KEY,
	quantity			INT 			NOT NULL,
	price			DECIMAL(10,2)	NOT NULL,
	vat				DECIMAL(5,2)	NOT NULL,
	vat_amount		DECIMAL(10,2)	NOT NULL,
	popularity_score TINYINT UNSIGNED,
	product_image		VARCHAR(255),
	`active`			BOOLEAN			NOT NULL DEFAULT TRUE,
	inactive_reason	VARCHAR(255),
	CONSTRAINT chk_product_quantity CHECK(quantity >= 0),
	CONSTRAINT chk_product_price  CHECK(price > 0 ),
	CONSTRAINT chk_product_vat CHECK(vat BETWEEN 0 AND 100),
	CONSTRAINT chk_product_popularity CHECK(popularity_score IS NULL OR popularity_score BETWEEN 1 AND 5)
)ENGINE=InnoDB;

DROP TABLE IF EXISTS Book;
CREATE TABLE Book(
	product_id				VARCHAR(10)		PRIMARY key,
	isbn13					CHAR(13)		NOT NULL,
	title					VARCHAR(200)	NOT NULL,
	genre					VARCHAR(100)	NOT NULL,
    publisher				VARCHAR(150)	NOT NULL,
	publication_date		DATE,
	CONSTRAINT uq_book_isbn13 UNIQUE(isbn13),
	CONSTRAINT	fk_book_product FOREIGN KEY (product_id)
		REFERENCES Product(id) on DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

DROP TABLE IF EXISTS Author;
CREATE TABLE Author(
	id 				INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	authorname		VARCHAR(100)	NOT NULL,
	fullname		VARCHAR(150),
	birthdate		DATE
)ENGINE=InnoDB;

DROP TABLE IF EXISTS BookAuthor;
CREATE TABLE BookAuthor(
	book_id			VARCHAR(10)		NOT NULL,
	author_id		INT UNSIGNED 	NOT NULL,
	PRIMARY KEY (book_id, author_id),
	CONSTRAINT fk_bookauthor_book FOREIGN KEY (book_id)
		REFERENCES Book(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_bookauthor_author  FOREIGN KEY (author_id)
		REFERENCES Author(id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;
DROP TABLE IF EXISTS Electronic;
CREATE TABLE Electronic(
	product_id 		VARCHAR(10)		PRIMARY KEY,
	serial_number	VARCHAR(50)		NOT NULL,
	brand			VARCHAR(100)	NOT NULL,
	model			VARCHAR(100)	NOT NULL,
	spec_tec		VARCHAR(255),
	`type`			VARCHAR(50),
	CONSTRAINT uq_electronic_serial UNIQUE (serial_number),
	CONSTRAINT fk_electronic_product FOREIGN KEY (product_id)
		REFERENCES Product (id) on DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

DROP TABLE IF EXISTS Recommendation;
CREATE TABLE Recommendation(
	id 						INT UNSIGNED 	AUTO_INCREMENT PRIMARY KEY,
	client_id				INT UNSIGNED 	NOT NULL,
	product_id				VARCHAR(10)		NOT NULL,
	reason 					VARCHAR(255)	NOT NULL,
	start_date				DATE			NOT NULL DEFAULT (CURRENT_DATE),
	CONSTRAINT  fk_recommendation_client FOREIGN KEY (client_id)
		REFERENCES `Client`(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_recommendation_product FOREIGN KEY (product_id)
		REFERENCES Product(id) ON DELETE CASCADE ON UPDATE CASCADE

)ENGINE=InnoDB;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	id 					INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	client_id			INT UNSIGNED 	NOT NULL,
	date_time			DATETIME		NOT NULL DEFAULT CURRENT_TIMESTAMP,
	delivery_method		ENUM('regular', 'urgent') NOT NULL DEFAULT 'regular',
	`status`				ENUM('open', 'processing', 'pending', 'closed', 'cancelled') NOT NULL DEFAULT 'open',
	payment_card_number	VARCHAR(20),
	payment_card_name	VARCHAR(100),
	payment_card_expiration	DATE,
	CONSTRAINT fk_orders_client FOREIGN KEY (client_id)
		REFERENCES `Client`(id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

DROP TABLE IF EXISTS Ordered_Product;
CREATE TABLE Ordered_Product(
order_id		INT UNSIGNED 	NOT NULL,
product_id		VARCHAR(10)		NOT NULL,
quantity			INT 			NOT NULL,
price			DECIMAL(10,2)		NOT NULL,
PRIMARY KEY (order_id, product_id),
CONSTRAINT fk_orderedproduct_order FOREIGN KEY (order_id)
	REFERENCES Orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_orderedproduct_product FOREIGN KEY (product_id)
	REFERENCES Product(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_orderedproduct_quantity CHECK (quantity > 0),
CONSTRAINT chk_orderedproduct_price CHECK (price > 0)

)ENGINE=InnoDB;


ALTER TABLE `Client`
	ADD CONSTRAINT chk_client_email_format
		CHECK(email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
	ADD CONSTRAINT chk_cleint_phone_format
		CHECK (phone_number IS NULL OR phone_number REGEXP '^[0-9]{6,}$');
        
ALTER TABLE Operator
	ADD CONSTRAINT chk_operator_email_format
		CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');


ALTER TABLE Book
	ADD CONSTRAINT chk_book_isbn13_format
		CHECK (isbn13 REGEXP '^[0-9]{13}$');


ALTER TABLE Product
	ADD CONSTRAINT chk_product_active_reason
		CHECK ( (`active` = TRUE AND inactive_reason IS NULL)
             OR (`active`= FALSE) );
             
         
DELIMITER $$

DROP TRIGGER IF EXISTS trg_client_before_insert$$

CREATE TRIGGER trg_client_before_insert
BEFORE INSERT ON `Client`
FOR EACH ROW
BEGIN
	IF NEW.`password` NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula,
1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
    
    IF NEW.phone_number IS NOT NULL AND NEW.phone_number NOT REGEXP '^[0-9]{6,}$' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Número de telefone inválido: apenas dígitos, mínimo 6.';
    END IF;
    SET NEW.`password`= SHA2(NEW.`password`,256);
    END$$
    
DROP TRIGGER IF EXISTS trg_client_before_update$$

CREATE TRIGGER trg_client_before_update
BEFORE UPDATE ON `Client`
FOR EACH ROW
BEGIN 
	IF NEW.`password` <> OLD.`password`THEN
		IF NEW.`password` NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula,
1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
        SET NEW.`password` = SHA2(NEW.`password`, 256);
	END IF;
    IF NEW.phone_number IS NOT NULL AND NEW.phone_number NOT REGEXP '^[0-9]{6,}$' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula,
1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_operator_before_insert$$

CREATE TRIGGER trg_operator_before_insert
BEFORE INSERT ON Operator
FOR EACH ROW
BEGIN
    IF NEW.`password` NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula, 1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
    SET NEW.`password` = SHA2(NEW.`password`, 256);
END$$


 DROP TRIGGER IF EXISTS trg_operator_before_update$$
 
CREATE TRIGGER trg_operator_before_update
BEFORE UPDATE ON Operator
FOR EACH ROW
BEGIN
    IF NEW.`password` <> OLD.`password` THEN
        IF NEW.`password` NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula, 1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
        END IF;
        SET NEW.`password`= SHA2(NEW.`password`, 256);
    END IF;
END$$			

DROP TRIGGER IF EXISTS trg_product_before_insert$$

CREATE TRIGGER trg_product_before_insert
BEFORE INSERT ON Product
FOR EACH ROW
BEGIN
	SET NEW.vat_amount = ROUND(NEW.price * NEW.vat / 100,2);
END$$
DROP TRIGGER IF EXISTS trg_product_before_update$$
CREATE TRIGGER trg_product_before_update
BEFORE UPDATE ON Product
FOR EACH ROW
BEGIN
	SET NEW.vat_amount = ROUND(NEW.price * NEW.vat / 100,2);
END$$

DROP TRIGGER IF EXISTS trg_book_before_insert$$

CREATE TRIGGER trg_book_before_insert
BEFORE INSERT ON Book
FOR EACH ROW
BEGIN
	DECLARE v_sum INT DEFAULT 0;
    DECLARE v_i INT DEFAULT 1;
    DECLARE v_digit INT;
    DECLARE v_check INT;
    
     IF NEW.isbn13 NOT REGEXP '^[0-9]{13}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ISBN-13 inválido: deve ter 13 dígitos numéricos.';
    END IF;
    while v_i <= 12 DO
		SET v_digit = CAST(SUBSTRING(NEW.isbn13, v_i, 1) AS UNSIGNED);
        IF v_i % 2 = 1 THEN
			SET v_sum = v_sum + v_digit;
		ELSE 
			 SET v_sum = v_sum + (v_digit * 3);
        END IF;
        SET v_i = v_i + 1;
    END WHILE;
    
    SET v_check = (10 - (v_sum % 10)) % 10;
	IF v_check <> CAST(SUBSTRING(NEW.isbn13, 13, 1) AS UNSIGNED) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ISBN-13 inválido: dígito de controlo incorreto.';
    END IF;
END$$
DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS ProductByType$$

CREATE PROCEDURE ProductByType(IN p_type VARCHAR(20))
BEGIN
	SELECT p.id AS codigo,
           p.price AS preco,
           p.popularity_score AS pontuacao,
           (SELECT COUNT(*) FROM Recommendation r WHERE r.product_id = p.id) AS recomendacao,
           p.active AS estado_ativo,
           p.product_image AS imagem,
           'livro' AS tipo
    FROM Product p
    JOIN Book b ON b.product_id = p.id
    WHERE p_type IS NULL OR LOWER(p_type) = 'livro'
    UNION ALL

	SELECT p.id AS codigo,
		   p.price AS preco,
           p.popularity_score AS pontuacao,
           (SELECT COUNT(*) FROM Recommendation r WHERE r.product_id = p.id) AS recomendacao,
           p.active AS estado_ativo,
           p.product_image AS imagem,
           'eletronico' AS tipo
   FROM Product p
   JOIN Electronic e ON e.product_id = p.id
   WHERE p_type IS NULL OR LOWER(p_type) = 'eletronico';
END$$

DROP PROCEDURE IF EXISTS DailyOrders$$

CREATE PROCEDURE DailyOrders(IN p_date DATE)
BEGIN
    SELECT o.*
    FROM Orders o
    WHERE DATE(o.date_time) = p_date;
END$$

DROP PROCEDURE IF EXISTS AnnualOrders$$

CREATE PROCEDURE AnnualOrders(IN p_client_id INT UNSIGNED, IN p_year INT)
BEGIN
    SELECT o.*
    FROM Orders o
    WHERE o.client_id = p_client_id
      AND YEAR(o.date_time) = p_year;
END$$

DROP PROCEDURE IF EXISTS CreateOrder$$

CREATE PROCEDURE CreateOrder (
    IN  p_client_id       INT UNSIGNED,
    IN  p_delivery_method ENUM('regular','urgent'),
    IN  p_card_number     VARCHAR(20),
    IN  p_card_name       VARCHAR(100),
    IN  p_expiration_date DATE,
    OUT p_order_id        INT UNSIGNED
)
BEGIN
    INSERT INTO Orders (client_id, delivery_method, `status`, payment_card_number, payment_card_name, payment_card_expiration)
    VALUES (p_client_id, p_delivery_method, 'open', p_card_number, p_card_name, p_expiration_date);
 
    SET p_order_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS GetOrderTotal$$
CREATE PROCEDURE GetOrderTotal (IN p_order_id INT UNSIGNED)
BEGIN
    SELECT
        p_order_id AS order_id,
        ROUND(SUM(op.price * op.quantity), 2) AS subtotal,
        ROUND(SUM(op.price * op.quantity * pr.vat / 100), 2) AS iva,
        ROUND(SUM(op.price * op.quantity) + SUM(op.price * op.quantity * pr.vat / 100), 2) AS total
    FROM Ordered_Product op
    JOIN Product pr ON pr.id = op.product_id
    WHERE op.order_id = p_order_id;
END$$

DROP PROCEDURE IF EXISTS AddProductToOrder$$

CREATE PROCEDURE AddProductToOrder (
    IN p_order_id   INT UNSIGNED,
    IN p_product_id VARCHAR(10),
    IN p_quantity   INT
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(10,2);
 
    SELECT quantity, price INTO v_stock, v_price
    FROM Product
    WHERE id = p_product_id
    FOR UPDATE;
 
    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto inexistente.';
    END IF;
 
    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para este produto.';
    END IF;
 
    INSERT INTO Ordered_Product (order_id, product_id, quantity, price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price)
    ON DUPLICATE KEY UPDATE quantity = quantity + p_quantity;
 
    UPDATE Product
    SET quantity = quantity - p_quantity
    WHERE id = p_product_id;
END$$
DROP PROCEDURE IF EXISTS AddBook$$
CREATE PROCEDURE AddBook (
    IN p_product_id       VARCHAR(10),
    IN p_quantity         INT,
    IN p_price            DECIMAL(10,2),
    IN p_vat              DECIMAL(5,2),
    IN p_popularity_score TINYINT,
    IN p_product_image    VARCHAR(255),
    IN p_isbn13           CHAR(13),
    IN p_title            VARCHAR(200),
    IN p_genre            VARCHAR(100),
    IN p_publisher        VARCHAR(150),
    IN p_publication_date DATE,
    IN p_author_id        INT UNSIGNED,   -- NULL se for criar autor novo
    IN p_author_name      VARCHAR(100),
    IN p_author_fullname  VARCHAR(150),
    IN p_author_birthdate DATE
)
BEGIN
    DECLARE v_author_id INT UNSIGNED;
 
    INSERT INTO Product (id, quantity, price, vat, popularity_score, product_image, `active`)
    VALUES (p_product_id, p_quantity, p_price, p_vat, p_popularity_score, p_product_image, TRUE);
 
    INSERT INTO Book (product_id, isbn13, title, genre, publisher, publication_date)
    VALUES (p_product_id, p_isbn13, p_title, p_genre, p_publisher, p_publication_date);
 
    IF p_author_id IS NULL THEN
        INSERT INTO Author (authorname, fullname, birthdate)
        VALUES (p_author_name, p_author_fullname, p_author_birthdate);
        SET v_author_id = LAST_INSERT_ID();
    ELSE
        SET v_author_id = p_author_id;
    END IF;
 
    INSERT INTO BookAuthor (book_id, author_id) VALUES (p_product_id, v_author_id);
END$$
DROP PROCEDURE IF EXISTS AddBookAuthor$$
CREATE PROCEDURE AddBookAuthor (
    IN p_book_id   VARCHAR(10),
    IN p_author_id INT UNSIGNED
)
BEGIN
    INSERT INTO BookAuthor (book_id, author_id) VALUES (p_book_id, p_author_id);
END$$
 DROP PROCEDURE IF EXISTS AddElec$$
CREATE PROCEDURE AddElec (
    IN p_product_id       VARCHAR(10),
    IN p_quantity         INT,
    IN p_price            DECIMAL(10,2),
    IN p_vat              DECIMAL(5,2),
    IN p_popularity_score TINYINT,
    IN p_product_image    VARCHAR(255),
    IN p_serial_number    VARCHAR(50),
    IN p_brand            VARCHAR(100),
    IN p_model            VARCHAR(100),
    IN p_spec_tec         VARCHAR(255),
    IN p_type             VARCHAR(50)
)
BEGIN
    INSERT INTO Product (id, quantity, price, vat, popularity_score, product_image, `active`)
    VALUES (p_product_id, p_quantity, p_price, p_vat, p_popularity_score, p_product_image, TRUE);
 
    INSERT INTO Electronic (product_id, serial_number, brand, model, spec_tec, `type`)
    VALUES (p_product_id, p_serial_number, p_brand, p_model, p_spec_tec, p_type);
END$$

DELIMITER ;

DROP VIEW IF EXISTS vw_product_catalog;

CREATE OR REPLACE VIEW vw_product_catalog AS
SELECT p.id, 'livro' AS type, b.title AS name, p.price, p.vat_amount,
	   p.quantity, p.popularity_score, p.`active`, p.product_image
FROM Product p
JOIN Book b ON b.product_id = p.id
UNION ALL
SELECT p.id,  'eletronico' AS type, CONCAT(e.brand, ' ' , e.model) AS name, p.price, p.vat_amount,
	   p.quantity, p.popularity_score, p.`active`, p.product_image
FROM Product p
JOIN Electronic e ON e.product_id = p.id;

DROP VIEW IF EXISTS vw_active_clients;

CREATE OR REPLACE VIEW vw_active_clients AS 
SELECT id, firstname, surname, email, city, country, last_login
FROM `Client`
WHERE status = 'active';


DROP VIEW IF EXISTS vw_order_summary;

CREATE OR REPLACE VIEW vw_order_summary AS
SELECT o.id AS order_id,
	   o.client_id,
       o.date_time,
       o.status,
       o.delivery_method,
	   ROUND(SUM(op.price * op.quantity), 2) AS subtotal,
       ROUND(SUM(op.price * op.quantity * pr.vat / 100), 2) AS iva,
       ROUND(SUM(op.price * op.quantity) * 1 + SUM(op.price * op.quantity * pr.vat / 100), 2) AS total
FROM Orders o
JOIN Ordered_Product op ON op.order_id = o.id
JOIN Product pr ON pr.id = op.product_id
GROUP BY o.id, o.client_id, o.date_time, o.`status`, o.delivery_method;

DROP VIEW IF EXISTS vw_recommendations;
CREATE OR REPLACE VIEW vw_recommendations As 
SELECT r.id, r.client_id, c.firstname, c.surname, r.product_id,
	   COALESCE(b.title,  CONCAT(e.brand, ' ', e.model)) AS product_name,
       r.reason, r.start_date
FROM Recommendation r
JOIN `Client`c ON c.id = r.client_id
LEFT JOIN Book b ON b.product_id = r.product_id
LEFT JOIN Electronic e ON e.product_id = r.product_id;

DROP USER IF EXISTS 'WEB_CLIENT'@'%';
CREATE USER 'WEB_CLIENT'@'%' IDENTIFIED BY 'Lmxy20#a';
GRANT SELECT ON BuyPy.* TO 'WEB_CLIENT'@'%';
GRANT INSERT, UPDATE ON BuyPy.`Client` TO 'WEB_CLIENT'@'%';
GRANT INSERT, UPDATE, DELETE ON BuyPy.Orders TO 'WEB_CLIENT'@'%';
GRANT INSERT, UPDATE, DELETE ON BuyPy.Ordered_Product TO 'WEB_CLIENT'@'%';
GRANT UPDATE (quantity) ON BuyPy.Product TO 'WEB_CLIENT'@'%';
GRANT EXECUTE ON PROCEDURE BuyPy.CreateOrder TO 'WEB_CLIENT'@'%';
GRANT EXECUTE ON PROCEDURE BuyPy.GetOrderTotal TO 'WEB_CLIENT'@'%';
GRANT EXECUTE ON PROCEDURE BuyPy.AddProductToOrder TO 'WEB_CLIENT'@'%';

DROP USER IF EXISTS 'BUYDB_OPERATOR'@'%';
CREATE USER 'BUYDB_OPERATOR'@'%' IDENTIFIED BY 'Lmxy20#a';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON BuyPy.* TO 'BUYDB_OPERATOR'@'%';

DROP USER IF EXISTS 'BUYDB_ADMIN'@'%';
CREATE USER 'BUYDB_ADMIN'@'%' IDENTIFIED BY 'Lmxy20#a';
GRANT ALL PRIVILEGES ON BuyPy.* TO 'BUYDB_ADMIN'@'%' WITH GRANT OPTION ;

FLUSH PRIVILEGES;

INSERT INTO `Client` (firstname, surname, email, `password`, address, zip_code, city, country, phone_number, birthdate, last_login, `status`) VALUES
('Ana',     'Silva',    'ana.silva@example.com',    'Passw0rd!', 'Rua das Flores 10',    '1000-001', 'Lisboa',    'Portugal', '912345678', '1990-05-12', '2026-07-01 10:00:00', 'active'),
('Bruno',   'Costa',    'bruno.costa@example.com',  'Bruno1$x',  'Av. da Liberdade 20',  '1250-096', 'Lisboa',    'Portugal', '913456789', '1988-03-22', '2026-07-02 09:30:00', 'active'),
('Carla',   'Mendes',   'carla.mendes@example.com', 'Carla9?q',  'Rua Nova 5',           '4000-100', 'Porto',     'Portugal', '914567890', '1995-11-02', '2026-07-05 14:15:00', 'active'),
('Diogo',   'Fonseca',  'diogo.fonseca@example.com','Diogo7%z',  'Rua do Sol 8',         '3000-200', 'Coimbra',   'Portugal', '915678901', '1992-07-19', '2026-06-28 08:00:00', 'inactive'),
('Elsa',    'Ramos',    'elsa.ramos@example.com',   'Elsa2024!', 'Travessa Verde 3',     '2000-300', 'Santarem',  'Portugal', '916789012', '1985-01-30', '2026-07-10 17:45:00', 'active'),
('Filipe',  'Neves',    'filipe.neves@example.com', 'Filipe5$w', 'Rua Central 12',       '4700-400', 'Braga',     'Portugal', '917890123', '1998-09-09', '2026-07-11 12:00:00', 'active'),
('Gabriela','Pinto',    'gabriela.pinto@example.com','Gabri8?e', 'Rua Alta 21',          '8000-500', 'Faro',      'Portugal', '918901234', '1993-04-17', '2026-06-30 19:20:00', 'blocked'),
('Hugo',    'Teixeira', 'hugo.teixeira@example.com','Hugo3%rt',  'Rua Baixa 14',         '3500-600', 'Viseu',     'Portugal', '919012345', '1991-12-24', '2026-07-12 07:10:00', 'active'),
('Ines',    'Vaz',      'ines.vaz@example.com',     'Ines6$mn',  'Praca Central 2',      '2500-700', 'Caldas da Rainha', 'Portugal', '910123456', '1996-06-06', '2026-07-13 21:00:00', 'active'),
('Joao',    'Barros',   'joao.barros@example.com',  'Joao4?kp',  'Rua Longa 30',         '2700-800', 'Amadora',   'Portugal', '911234567', '1989-02-14', '2026-07-14 11:35:00', 'active');


INSERT INTO Operator (firstname, surname, email, `password`, last_login) VALUES
('Marta', 'Oliveira', 'marta.oliveira@buypy.pt', 'Marta1!op', '2026-07-15 08:00:00'),
('Nuno',  'Cardoso',  'nuno.cardoso@buypy.pt',   'Nuno9$op',  '2026-07-15 08:30:00'),
('Rita',  'Antunes',  'rita.antunes@buypy.pt',   'Rita5?op',  '2026-07-15 09:00:00');
 
INSERT INTO Author (authorname, fullname, birthdate) VALUES
('J. Saramago', 'Jose de Sousa Saramago',         '1922-11-16'),
('F. Pessoa',   'Fernando Antonio Nogueira Pessoa','1888-06-13'),
('E. Queiros',  'Jose Maria de Eca de Queiros',   '1845-11-25'),
('P. Marques',  'Pedro Marques',                  '1980-08-19'),
('L. Ferreira', 'Luisa Ferreira',                 '1970-01-10'),
('R. Castro',   'Rui Castro',                     '1965-05-05'),
('T. Nogueira', 'Tiago Nogueira',                 '1990-10-30');

CALL AddBook('LIV001', 15, 14.90, 6,  5, '/img/liv001.jpg', '9789720000019', 'Memorial do Convento',   'Romance',  'Editorial Caminho',  '1982-01-01', 1, NULL, NULL, NULL);
CALL AddBook('LIV002', 10, 12.50, 6,  4, '/img/liv002.jpg', '9789720000026', 'Mensagem',               'Poesia',   'Atica',              '1934-01-01', 2, NULL, NULL, NULL);
CALL AddBook('LIV003', 8,  11.00, 6,  4, '/img/liv003.jpg', '9789720000033', 'Os Maias',               'Romance',  'Livros do Brasil',   '1888-01-01', 3, NULL, NULL, NULL);
CALL AddBook('LIV004', 20, 9.90,  6,  3, '/img/liv004.jpg', '9789720000040', 'Contos de Verao',        'Contos',   'Porto Editora',      '2015-06-15', NULL, 'S. Aguiar',  'Sofia Aguiar',  '1975-03-01');
CALL AddBook('LIV005', 12, 16.75, 6,  3, '/img/liv005.jpg', '9789720000057', 'Estruturas de Dados',    'Tecnico',  'FCA',                '2019-02-20', 4, NULL, NULL, NULL);
CALL AddBook('LIV006', 6,  22.00, 6,  4, '/img/liv006.jpg', '9789720000064', 'Redes de Computadores',  'Tecnico',  'FCA',                '2020-09-10', 5, NULL, NULL, NULL);
CALL AddBook('LIV007', 9,  8.50,  6,  2, '/img/liv007.jpg', '9789720000071', 'Poemas Escolhidos',      'Poesia',   'Assirio & Alvim',    '2005-03-03', 6, NULL, NULL, NULL);
CALL AddBook('LIV008', 5,  19.90, 6,  5, '/img/liv008.jpg', '9789720000088', 'Historia de Portugal',   'Historia', 'Circulo de Leitores','2011-11-11', 7, NULL, NULL, NULL);
CALL AddBook('LIV009', 14, 13.30, 6,  3, '/img/liv009.jpg', '9789720000095', 'Cozinha Tradicional',    'Culinaria','Marcador',           '2018-04-04', NULL, 'C. Almeida', 'Catarina Almeida', '1983-04-22');
CALL AddBook('LIV010', 7,  17.40, 6,  4, '/img/liv010.jpg', '9789720000101', 'Algoritmos Essenciais',  'Tecnico',  'FCA',                '2021-07-07', NULL, 'M. Santos',  'Miguel Santos',   '1978-12-12');

CALL AddBookAuthor('LIV003', 2);
CALL AddBookAuthor('LIV008', 6);


CALL AddElec('ELE001', 25, 199.99, 23, 5, '/img/ele001.jpg', 'SN-0001', 'TechSound',  'BT-100',    'Bluetooth 5.2, 20h autonomia', 'auscultadores');
CALL AddElec('ELE002', 15, 349.00, 23, 4, '/img/ele002.jpg', 'SN-0002', 'PixelView',  'M24-Pro',   '24 polegadas, 144Hz',          'monitor');
CALL AddElec('ELE003', 30, 29.90,  23, 3, '/img/ele003.jpg', 'SN-0003', 'KeyMaster',  'K-Slim',    'Mecanico, RGB',                'teclado');
CALL AddElec('ELE004', 40, 19.90,  23, 3, '/img/ele004.jpg', 'SN-0004', 'ClickPro',   'M-Wireless','Sem fios, 2.4GHz',             'rato');
CALL AddElec('ELE005', 10, 899.00, 23, 5, '/img/ele005.jpg', 'SN-0005', 'CompuTech',  'UltraBook14','16GB RAM, 512GB SSD',         'portatil');
CALL AddElec('ELE006', 18, 79.90,  23, 4, '/img/ele006.jpg', 'SN-0006', 'SoundBox',   'Boom-2',    'Coluna portatil, 12h',         'coluna');
CALL AddElec('ELE007', 22, 129.00, 23, 3, '/img/ele007.jpg', 'SN-0007', 'CamOne',     'Web-HD',    'Webcam 1080p',                 'webcam');
CALL AddElec('ELE008', 12, 249.00, 23, 4, '/img/ele008.jpg', 'SN-0008', 'PowerCharge','Bank-20000','Powerbank 20000mAh',           'acessorio');
CALL AddElec('ELE009', 9,  599.00, 23, 5, '/img/ele009.jpg', 'SN-0009', 'TabTech',    'Tab-10',    '10 polegadas, 128GB',          'tablet');
CALL AddElec('ELE010', 16, 449.00, 23, 3, '/img/ele010.jpg', 'SN-0010', 'PrintFast',  'InkJet-300','Multifuncoes, WiFi',           'impressora');

CALL CreateOrder(1,  'regular', '4111111111111111', 'Ana Silva',     '2027-05-01', @o1);
CALL CreateOrder(2,  'urgent',  '4111111111111112', 'Bruno Costa',   '2027-06-01', @o2);
CALL CreateOrder(3,  'regular', '4111111111111113', 'Carla Mendes',  '2027-07-01', @o3);
CALL CreateOrder(5,  'regular', '4111111111111114', 'Elsa Ramos',    '2027-08-01', @o4);
CALL CreateOrder(6,  'urgent',  '4111111111111115', 'Filipe Neves',  '2027-09-01', @o5);
CALL CreateOrder(8,  'regular', '4111111111111116', 'Hugo Teixeira', '2027-10-01', @o6);
CALL CreateOrder(9,  'regular', '4111111111111117', 'Ines Vaz',      '2027-11-01', @o7);
CALL CreateOrder(10, 'urgent',  '4111111111111118', 'Joao Barros',   '2027-12-01', @o8);
CALL CreateOrder(1,  'regular', '4111111111111111', 'Ana Silva',     '2027-05-01', @o9);
CALL CreateOrder(2,  'regular', '4111111111111112', 'Bruno Costa',   '2027-06-01', @o10);
CALL CreateOrder(3,  'urgent',  '4111111111111113', 'Carla Mendes',  '2027-07-01', @o11);
CALL CreateOrder(5,  'regular', '4111111111111114', 'Elsa Ramos',    '2027-08-01', @o12);
CALL CreateOrder(6,  'regular', '4111111111111115', 'Filipe Neves',  '2027-09-01', @o13);
CALL CreateOrder(8,  'urgent',  '4111111111111116', 'Hugo Teixeira', '2027-10-01', @o14);
CALL CreateOrder(9,  'regular', '4111111111111117', 'Ines Vaz',      '2027-11-01', @o15);
CALL CreateOrder(10, 'regular', '4111111111111118', 'Joao Barros',   '2027-12-01', @o16);
CALL CreateOrder(1,  'urgent',  '4111111111111111', 'Ana Silva',     '2027-05-01', @o17);
CALL CreateOrder(2,  'regular', '4111111111111112', 'Bruno Costa',   '2027-06-01', @o18);
CALL CreateOrder(3,  'regular', '4111111111111113', 'Carla Mendes',  '2027-07-01', @o19);
CALL CreateOrder(5,  'urgent',  '4111111111111114', 'Elsa Ramos',    '2027-08-01', @o20);

CALL AddProductToOrder(@o1,  'LIV001', 1);
CALL AddProductToOrder(@o1,  'ELE003', 2);
CALL AddProductToOrder(@o2,  'LIV002', 1);
CALL AddProductToOrder(@o2,  'ELE001', 1);
CALL AddProductToOrder(@o3,  'LIV003', 2);
CALL AddProductToOrder(@o4,  'ELE005', 1);
CALL AddProductToOrder(@o4,  'LIV005', 1);
CALL AddProductToOrder(@o5,  'ELE002', 1);
CALL AddProductToOrder(@o6,  'LIV006', 1);
CALL AddProductToOrder(@o6,  'ELE004', 2);
CALL AddProductToOrder(@o7,  'LIV007', 3);
CALL AddProductToOrder(@o8,  'ELE008', 1);
CALL AddProductToOrder(@o9,  'LIV008', 1);
CALL AddProductToOrder(@o9,  'ELE006', 1);
CALL AddProductToOrder(@o10, 'LIV009', 2);
CALL AddProductToOrder(@o11, 'ELE007', 1);
CALL AddProductToOrder(@o12, 'LIV010', 1);
CALL AddProductToOrder(@o12, 'ELE009', 1);
CALL AddProductToOrder(@o13, 'LIV001', 1);
CALL AddProductToOrder(@o14, 'ELE010', 1);
CALL AddProductToOrder(@o15, 'LIV002', 1);
CALL AddProductToOrder(@o15, 'ELE003', 1);
CALL AddProductToOrder(@o16, 'LIV004', 2);
CALL AddProductToOrder(@o17, 'ELE001', 1);
CALL AddProductToOrder(@o18, 'LIV006', 1);
CALL AddProductToOrder(@o18, 'ELE002', 1);
CALL AddProductToOrder(@o19, 'LIV007', 1);
CALL AddProductToOrder(@o20, 'ELE004', 1);
CALL AddProductToOrder(@o20, 'LIV009', 1);
CALL AddProductToOrder(@o3,  'ELE005', 1);

INSERT INTO Recommendation (client_id, product_id, reason, start_date) VALUES
(1,  'LIV002', 'Baseado em compras anteriores', '2026-06-01'),
(1,  'ELE003', 'Clientes que compraram itens semelhantes', '2026-06-02'),
(2,  'LIV004', 'Novo lancamento no genero favorito', '2026-06-03'),
(3,  'ELE005', 'Popular entre clientes semelhantes', '2026-06-04'),
(5,  'LIV006', 'Baseado no historico de navegacao', '2026-06-05'),
(6,  'ELE002', 'Complementa a ultima compra', '2026-06-06'),
(8,  'LIV008', 'Tendencia da semana', '2026-06-07'),
(9,  'ELE007', 'Baseado em compras anteriores', '2026-06-08'),
(10, 'LIV010', 'Novo lancamento tecnico', '2026-06-09'),
(1,  'ELE006', 'Popular na sua cidade', '2026-06-10'),
(2,  'LIV003', 'Classico recomendado', '2026-06-11'),
(3,  'ELE008', 'Acessorio util para compras anteriores', '2026-06-12'),
(5,  'LIV009', 'Baseado nos seus interesses', '2026-06-13'),
(6,  'ELE009', 'Alternativa popular', '2026-06-14'),
(8,  'LIV001', 'Best-seller do mes', '2026-06-15'),
(9,  'ELE010', 'Baseado no historico de navegacao', '2026-06-16'),
(10, 'LIV005', 'Recomendado por clientes semelhantes', '2026-06-17'),
(1,  'LIV007', 'Complementa a ultima compra', '2026-06-18'),
(2,  'ELE001', 'Tendencia da semana', '2026-06-19'),
(3,  'LIV006', 'Baseado em compras anteriores', '2026-06-20');

SELECT 'Clientes' AS tabela, COUNT(*) AS total FROM `Client`
UNION ALL SELECT 'Operadores', COUNT(*) FROM Operator
UNION ALL SELECT 'Livros', COUNT(*) FROM Book
UNION ALL SELECT 'Eletronicos', COUNT(*) FROM Electronic
UNION ALL SELECT 'Autores', COUNT(*) FROM Author
UNION ALL SELECT 'BookAuthor', COUNT(*) FROM BookAuthor
UNION ALL SELECT 'Encomendas', COUNT(*) FROM Orders
UNION ALL SELECT 'Ordered_Product', COUNT(*) FROM Ordered_Product
UNION ALL SELECT 'Recomendacoes', COUNT(*) FROM Recommendation;

 
        
		





