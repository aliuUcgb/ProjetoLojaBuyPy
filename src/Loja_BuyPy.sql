DROP DATABASE IF EXISTS BuyPy;
CREATE DATABASE BuyPy
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
    
    
USE BuyPy;


CREATE TABLE Client1(
	id 					INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	firsname			VARCHAR(50) 	NOT NULL,
	surmane				VARCHAR(50)		NOT NULL,
	email 				VARCHAR(100)	NOT NULL,
	password_			CHAR(64)		NOT NULL,    -- SHA2-256 hex digest
	address				VARCHAR(150),	
	zip_code			VARCHAR(10),
	city				VARCHAR(50),
	country				VARCHAR(50)		NOT NULL DEFAULT 'Portugal',
	phone_number		VARCHAR(20),
	birthdate			DATE,
	last_login			DATETIME,
	status				ENUM('active' , 'inactive' , 'blocked')	NOT NULL DEFAULT 'active',
	CONSTRAINT uq_Client1_email UNIQUE(email)

)ENGINE=InnoDB;



CREATE TABLE Operator(
	id 					INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	firstname			VARCHAR(50)		NOT NULL,
	surname				VARCHAR(50)		NOT NULL,
	email				VARCHAR(100)	NOT NULL,
	password_			CHAR(64)		NOT NULL, -- SHA2-256 hex digest
	last_login			DATETIME,
	CONSTRAINT uq_operator_email UNIQUE (email)
)ENGINE=InnoDB;



CREATE TABLE Product(
	id 				VARCHAR(10) 	PRIMARY KEY,
	quality			INT 			NOT NULL,
	price			DECIMAL(10,2)	NOT NULL,
	vat				DECIMAL(5,2)	NOT NULL,
	vat_amount		DECIMAL(10,2)	NOT NULL,
	popularity_score TINYINT UNSIGNED,
	image_path		VARCHAR(255),
	active_			BOOLEAN			NOT NULL DEFAULT TRUE,
	inactive_reason	VARCHAR(255),
	CONSTRAINT chk_product_quality CHECK(quality >= 0),
	CONSTRAINT chk_product_price  CHECK(price > 0 ),
	CONSTRAINT chk_product_vat CHECK(vat BETWEEN 0 AND 100),
	CONSTRAINT chk_product_popularity CHECK(popularity_score IS NULL OR popularity_score BETWEEN 1 AND 5)
)ENGINE=InnoDB;


CREATE TABLE Book(
	product_id				VARCHAR(10)		PRIMARY key,
	isbn13					CHAR(13)		NOT NULL,
	title					VARCHAR(200)	NOT NULL,
	genre					VARCHAR(100)	NOT NULL,
	publication_date		DATE,
	CONSTRAINT uq_book_isbn13 UNIQUE(isbn13),
	CONSTRAINT	fk_book_product FOREIGN KEY (product_id)
		REFERENCES Product(id) on DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE Author(
	id 				INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	authorname		VARCHAR(100)	NOT NULL,
	fullname		VARCHAR(150),
	birthdate		DATE
)ENGINE=InnoDB;


CREATE TABLE BookAuthor(
	book_id			VARCHAR(10)		NOT NULL,
	author_id		INT UNSIGNED 	NOT NULL,
	PRIMARY KEY (book_id, author_id),
	CONSTRAINT fk_bookauthor_book FOREIGN KEY (book_id)
		REFERENCES Book(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_bookautor_author  FOREIGN KEY (author_id)
		REFERENCES Author(id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE Eletronic(
	product_id 		VARCHAR(10)		PRIMARY KEY,
	serial_number	VARCHAR(50)		NOT NULL,
	brand			VARCHAR(100)	NOT NULL,
	model			VARCHAR(100)	NOT NULL,
	spec_tec		VARCHAR(255),
	type_			VARCHAR(50),
	CONSTRAINT uq_electronic_serial UNIQUE (serial_number),
	CONSTRAINT fk_electronic_product FOREIGN KEY (product_id)
		REFERENCES Product (id) on DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE Recommendation(
	id 						INT UNSIGNED 	AUTO_INCREMENT PRIMARY KEY,
	client_id				INT UNSIGNED 	NOT NULL,
	product_id				VARCHAR(10)		NOT NULL,
	reason 					VARCHAR(255)	NOT NULL,
	start_date				DATE			NOT NULL DEFAULT (CURRENT_DATE),
	CONSTRAINT  fk_recommendation_client FOREIGN KEY (client_id)
		REFERENCES client1(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_recommendatioin_product FOREIGN KEY (product_id)
		REFERENCES Product(id) ON DELETE CASCADE ON UPDATE CASCADE

)ENGINE=InnoDB;


cREATE TABLE Orders(
	id 					INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	client1_id			INT UNSIGNED 	NOT NULL,
	date_time			DATETIME		NOT NULL DEFAULT CURRENT_TIMESTAMP,
	delivery_method		ENUM('regular', 'urgent') NOT NULL DEFAULT 'regular',
	status				ENUM('open', 'processing', 'pendig', 'close', 'cancelled') NOT NULL DEFAULT 'open',
	payment_card_number	VARCHAR(20),
	payment_card_name	VARCHAR(100),
	payment_card_expiration	DATE,
	CONSTRAINT fk_orders_client1 FOREIGN KEY (client1_id)
		REFERENCES Client1(id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE Orderd_Product(
order_id		INT UNSIGNED 	NOT NULL,
product_id		VARCHAR(10)		NOT NULL,
quality			INT 			NOT NULL,
price			DECIMAL			NOT NULL,
PRIMARY KEY (order_id, product_id),
CONSTRAINT fk_orderedproduct_order FOREIGN KEY (order_id)
	REFERENCES Orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_orderedproduct_product FOREIGN KEY (product_id)
	REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_orderedproduct_quality CHECK (quality > 0),
CONSTRAINT chk_orderedproduct_price CHECK (price > 0)

)ENGINE=InnoDB;


ALTER TABLE Client1
	ADD CONSTRAINT chk_client_email_format
		CHECK(email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
	ADD CONSTRAINT chk_clint_phone_format
		CHECK (phone_number IS NULL OR phone_number REGEXP '^[0-9]{6,}$');
        
ALTER TABLE Operator
	ADD CONSTRAINT chk_operator_email_format
		CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');


ALTER TABLE Book
	ADD CONSTRAINT chk_book_isbn13_format
		CHECK (isbn13 REGEXP '^[0-9]{13}$');


ALTER TABLE Product
	ADD CONSTRAINT chk_product_active_reason
		CHECK ( (active_ = TRUE AND inactive_reason IS NULL)
             OR (active_ = FALSE) );
             
DELIMITER $$

CREATE TRIGGER trg_client_before_insert
BEFORE INSERT ON Client1
FOR EACH ROW
BEGIN
	IF NEW.password_ NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula,
1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
    
    IF NEW.phone_number IS NOT NULL AND NEW.phone_number NOT REGEXP '^[0-9]{6,}$' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Número de telefone inválido: apenas dígitos, mínimo 6.';
    END IF;
    SET NEW.password_ = SHA2(NEW.password_,256);
    END$$
    
    
CREATE TRIGGER trg_client_before_update
BEFORE UPDATE ON Client1
FOR EACH ROW
BEGIN 
	IF NEW.password_ <> OLD.password_ THEN
		IF NEW.password_ NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula,
1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
        SET NEW.password_ = SHA2(NEW.password_, 256);
	END IF;
    IF NEW.phone_number IS NOT NULL AND NEW.phone_number NOT REGEXP '^[0-9]{6,}$' THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula,
1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
END$$



CREATE TRIGGER trg_operator_before_insert
BEFORE INSERT ON Operator
FOR EACH ROW
BEGIN
    IF NEW.password_ NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula, 1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
    END IF;
    SET NEW.password_ = SHA2(NEW.password_, 256);
END$$
 
CREATE TRIGGER trg_operator_before_update
BEFORE UPDATE ON Operator
FOR EACH ROW
BEGIN
    IF NEW.password_ <> OLD.password_ THEN
        IF NEW.password_ NOT REGEXP '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!$%?]).{6,}$' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Password inválida: mínimo 6 caracteres, 1 minúscula, 1 maiúscula, 1 dígito e 1 símbolo entre ! $ ? %';
        END IF;
        SET NEW.password_ = SHA2(NEW.password_, 256);
    END IF;
END$$			

CREATE TRIGGER trg_product_before_insert
BEFORE INSERT ON Product
FOR EACH ROW
BEGIN
	SET NEW.vat_amount = ROUND(NEW.price * NEW.vat / 100,2);
END$$

CREATE TRIGGER trg_product_before_update
BEFORE UPDATE ON Product
FOR EACH ROW
BEGIN
	SET NEW.vat_amount = ROUND(NEW.price * NEW.vat / 100,2);
END$$


CREATE TRIGGER trg_book_before_insert
BEFORE INSERT ON Book
FOR EACH ROW
BEGIN
	DECLARE v_sum INT DEFAULT 0;
    DECLARE v_i INT DEFAULT 1;
    DECLARE v_digit INT;
    DECLARE V_check INT;
    
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

CREATE PROCEDURE ProductByType(IN p_type VARCHAR(20))
BEGIN
	SELECT p.id AS codigo,
           p.price AS preco,
           p.popularity_score AS pontuacao,
           (SELECT COUNT(*) FROM Recommendation r WHERE r.product_id = p.id) AS recomendacao,
           p.active AS estado_ativo,
           p.image_path AS imagem,
           'livro' AS tipo
    FROM Product p
    JOIN Book b ON b.product_id = p.id
    WHERE p_type IS NULL OR LOWER(p_type) = 'livro'
    UNION ALL

	SELECT p.id AS codigo,
		   p.price AS preco,
           p.popularity_score AS pontuacao,
           (SELECT COUNT(*) FROM REcomendation r WHERE r.product_id = p.id) AS recomendacao,
           p.active AS estado_ativo,
           p.image_path AS imagem,
           'eletronico' AS tipo
   FROM Product p
   JOIN Electronic e ON e.product_id = p.id
   WHERE p_type IS NULL OR LOWER(p_type) = 'eletronico';
END$$

CREATE PROCEDURE DailyOrders(IN p_date DATE)
BEGIN
	SELECT o.*
    FROM Orders o
    WHERE DATE(o.date_time) = p_date;
END$$

CREATE PROCEDURE AnnualOrders(IN p_client_id INT UNSIGNED, IN p_year INT)
BEGIN
	SELECT o.*
    FROM Orders o
    WHERE o.client_id = p_client_id
      AND YEAR(o.date_time) = p_year;
END$$
	


    






 
        
		





