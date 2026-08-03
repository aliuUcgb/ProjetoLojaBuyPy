
INSERT INTO `Client` (firstname, surname, email, `password`, address, zip_code, city, country, phone_number, birthdate, last_login, `status`) VALUES
('Jose',     'Mendes',    'mendesjose@gmail.com',    'Benfica15%', 'Av.Almirante Reis',   '2696-221', 'Lisboa',    'Portugal', '912345455', '1993-07-12', '2026-08-01 10:00:00', 'active'),
('Luciana',   'Costa',    'lucianacosta@gmail.com',  'Amor12%b',  'Av. da Liberdade 21',  '1562-021', 'Lisboa',    'Portugal', '913236789', '1987-05-22', '2026-05-02 12:30:00', 'active'),
('Mamadu',   'Djalo',   'mamadudjalo@gmail.com', 'Lisboa$10%',  'Rua General Gançalos',    '4010-101', 'Porto',     'Portugal', '914567872', '1998-10-05', '2026-05-05 14:15:00', 'active'),
('Iuri',   'Fonseca',  'iurifonseca@hotmail.com','fonseca7%z',  'Rua dos Combatentes',         '3051-200', 'Coimbra',   'Portugal', '920678952', '1993-08-20', '2026-07-28 08:00:00', 'inactive'),
('Elsa',    'Fernades',    'elsafernandes@gmail.com',   'Fernandes2026%', 'Travessa das Maravilhas',     '2005-310', 'Leiria',  'Portugal', '913789412', '1989-01-25', '2026-04-10 18:45:00', 'active'),
('Maria',  'Mendes de Carvalho',    'mariamendes@hotmail.com', 'Carvalho20%', 'Parque das Nações',       '4710-410', 'Lisboa',     'Portugal', '920890025', '1997-09-09', '2026-03-11 12:30:00', 'active'),
('Gabriela','Nunes',    'gabrielanumes1@ehotmail.com','Nunesi8?e', 'Rua da Alcantra',          '8032-510', 'Lisboa',      'Portugal', '918901369', '1998-04-17', '2026-06-30 15:20:00', 'blocked'),
('Mariama',    'Baldé', 'baldemariama@gmail.com','Mariama3%bl',  'Rua das Forças Armadas',         '3501-600', 'Viseu',     'Portugal', '913012350', '1995-12-30', '2026-07-20 07:10:00', 'active'),
('Nuno',    'Cardoso',      'nuno.cardoso@gmail.com',     'Cardoso25§',  'Praca Sá Gomes',      '2600-100', 'Viseu', 'Portugal', '912123458', '1998-06-06', '2026-07-24 22:00:00', 'active'),
('Joao',    'Nunes',   'joao.nunes@hotmail.com',  'Joao25%$',  'Rua da Camara 30',         '2700-800', 'Amadora',   'Portugal', '911234569', '1990-03-14', '2026-05-14 14:35:00', 'active');


INSERT INTO Operator (firstname, surname, email, `password`, last_login) VALUES
('Maitana', 'Oliveira', 'maitanaoliveira@buypy.pt', 'Maita1!op', '2026-07-15 08:00:00'),
('Ivandro',  'Cardoso',  'ivandrocardoso@buypy.pt',   'Cardoso9$op',  '2026-07-16 08:30:00'),
('Rute',  'Almeida',  'rutealmeida@buypy.pt',   'Almeida5?op',  '2026-07-17 09:00:00');
 
INSERT INTO Author (authorname, fullname, birthdate) VALUES
('C. de Camºoes', 'Luis Vaz de Camºoes',           '1579-06-10'),
('F. Pessoa',   'Fernando Antonio Nogueira Pessoa','1888-06-13'),
('E. Queiros',  'Jose Maria de Eca de Queiros',   '1845-11-25'),
('A. Lobo',  'António Lobo Antunes',              '1942-09-01'),
('A. Bessa-Luís', 'Agustina Bessa-Luís',          '1922-10-15'),
('J. Rodrigues',  'José Rodrigues Dos Santos',    '1964-04-01'),
('L. Jorge', 'Lídia Jorge',                		  '1946-06-18');

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